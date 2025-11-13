import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:isar/isar.dart';
import 'package:isar_notion_sync_starter/data/models/highlight.dart';
import 'package:isar_notion_sync_starter/data/models/reading_prefs.dart';
import 'package:isar_notion_sync_starter/data/models/sentence.dart';
import 'package:isar_notion_sync_starter/main.dart';
import 'package:isar_notion_sync_starter/sync/notion_pull_service.dart';
import 'package:isar_notion_sync_starter/sync/notion_push_service.dart';
import 'package:isar_notion_sync_starter/sync/sync_scheduler_impl.dart';

/// 单词学习页：支持阅读、句级操作、文本高亮与样式自定义。
class LearningPage extends StatefulWidget {
  const LearningPage({super.key});

  @override
  State<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  bool _loading = true;
  bool _syncingRemote = false;
  Isar? _isar;
  List<Sentence> _sentences = const [];
  Map<int, List<Highlight>> _highlightMap = const {};
  ReadingPrefs _prefs = ReadingPrefs();
  NotionPushService? _pushService;
  SyncSchedulerImpl? _scheduler;

  StreamSubscription<List<Sentence>>? _sentenceSub;
  StreamSubscription<List<Highlight>>? _highlightSub;

  bool _selectionMode = false;
  int? _selectionSentenceId;
  TextSelection _selection =
      const TextSelection(baseOffset: -1, extentOffset: -1);
  String? _pendingNote;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await isarService.init();
    _isar = isarService.isar;
    final isar = _isar!;
    _scheduler = SyncSchedulerImpl(isar);
    _pushService = NotionPushService(isar, scheduler: _scheduler);
    var prefs = await isar.readingPrefs.get(1);
    if (prefs == null) {
      prefs = ReadingPrefs();
      await isar.writeTxn(() async {
        await isar.readingPrefs.put(prefs!);
      });
    }
    _prefs = prefs;

    _sentenceSub = isar.sentences
        .where()
        .anyId()
        .watch(fireImmediately: true)
        .listen((items) {
      final list = items.where((e) => e.deletedAt == null).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      setState(() {
        _sentences = list;
        _loading = false;
      });
    });

    _highlightSub = isar.highlights
        .where()
        .anyId()
        .watch(fireImmediately: true)
        .listen((items) {
      final map = <int, List<Highlight>>{};
      for (final h in items.where((e) => e.deletedAt == null)) {
        map.putIfAbsent(h.sentenceLocalId, () => []).add(h);
      }
      for (final list in map.values) {
        list.sort((a, b) => a.start.compareTo(b.start));
      }
      setState(() => _highlightMap = map);
    });

    unawaited(_refreshFromNotion());
  }

  Future<void> _refreshFromNotion() async {
    final isar = _isar;
    if (isar == null || _syncingRemote || !mounted) return;
    setState(() => _syncingRemote = true);
    try {
      await NotionPullService(isar).pullAll();
    } finally {
      if (mounted) {
        setState(() => _syncingRemote = false);
      }
    }
  }

  @override
  void dispose() {
    _sentenceSub?.cancel();
    _highlightSub?.cancel();
    super.dispose();
  }

  ReadingThemeColors get _themeColors =>
      _readingThemes[_prefs.theme] ?? _readingThemes['light']!;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final readingTheme = theme.copyWith(
      scaffoldBackgroundColor: _themeColors.background,
      textTheme: theme.textTheme.apply(
        bodyColor: _themeColors.foreground,
        displayColor: _themeColors.foreground,
      ),
      colorScheme: theme.colorScheme.copyWith(surface: _themeColors.background),
    );

    return Theme(
      data: readingTheme,
      child: Scaffold(
        backgroundColor: _themeColors.background,
        appBar: AppBar(
          title: const Text('单词学习'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              tooltip: '阅读样式',
              icon: const Icon(Icons.tune),
              onPressed: () => _showStylePanel(context),
            ),
          ],
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : LayoutBuilder(
                builder: (context, constraints) {
                  final showSidePanel = constraints.maxWidth >= 1024;
                  final sentenceArea = _buildSentenceArea();
                  if (!showSidePanel) return sentenceArea;
                  return Row(
                    children: [
                      Expanded(flex: 6, child: sentenceArea),
                      const SizedBox(width: 24),
                      SizedBox(
                        width: 360,
                        child: Card(
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: ReadingStylePanel(
                              prefs: _prefs,
                              onUpdate: _updatePrefs,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                  );
                },
              ),
      ),
    );
  }

  Widget _buildSentenceArea() {
    final Widget content;
    if (_sentences.isEmpty) {
      content = const _EmptyState();
    } else {
      content = ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _sentences.length,
        separatorBuilder: (_, __) =>
            SizedBox(height: _prefs.paragraphSpacing.toDouble()),
        itemBuilder: (context, index) {
          final sentence = _sentences[index];
          final highlights = _highlightMap[sentence.id] ?? const [];
          return _SentenceBlock(
            sentence: sentence,
            highlights: highlights,
            prefs: _prefs,
            selectionMode:
                _selectionMode && _selectionSentenceId == sentence.id,
            onSelectionChanged: (selection, cause) =>
                _handleSelection(sentence.id, selection, cause),
            onHighlightTap: _editHighlight,
            onAction: (action) => _handleSentenceAction(sentence, action),
          );
        },
      );
    }

    return Stack(
      children: [
        content,
        if (_selectionMode && _sentences.isNotEmpty)
          _SelectionBanner(
              onCancel: _exitSelectionMode, onDone: _commitSelectionDraft),
        if (_selectionMode && _sentences.isNotEmpty) _buildSelectionPalette(),
        if (_syncingRemote)
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: SizedBox(
                height: 2,
                child: LinearProgressIndicator(),
              ),
            ),
          ),
      ],
    );
  }

  void _handleSelection(
      int sentenceId, TextSelection selection, SelectionChangedCause? cause) {
    final reason = cause ?? SelectionChangedCause.tap;
    if (reason == SelectionChangedCause.tap && !_selectionMode) return;
    if (reason == SelectionChangedCause.longPress || _selectionMode) {
      if (!_selectionMode) {
        setState(() {
          _selectionMode = true;
          _pendingNote = null;
        });
      }
      setState(() {
        _selectionSentenceId = sentenceId;
        _selection = selection;
      });
    }
  }

  Widget _buildSelectionPalette() {
    final validSelection =
        !_selection.isCollapsed && _selectionSentenceId != null;
    if (!validSelection) return const SizedBox.shrink();
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('颜色与备注', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  children: _highlightColors.entries
                      .map(
                        (entry) => _ColorDot(
                          label: entry.key,
                          color: entry.value.display,
                          onTap: () => _createHighlight(entry.key),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => _composeNote(),
                  icon: const Icon(Icons.edit_note_outlined),
                  label: Text(_pendingNote == null
                      ? '添加备注'
                      : '备注：${_pendingNote!.isEmpty ? '（空）' : _pendingNote}'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _composeNote() async {
    final controller = TextEditingController(text: _pendingNote ?? '');
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('备注'),
          content: TextField(
            controller: controller,
            maxLines: 4,
            decoration: const InputDecoration(hintText: '输入此高亮的备注'),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('取消')),
            TextButton(
                onPressed: () => Navigator.pop(context, controller.text.trim()),
                child: const Text('保存')),
          ],
        );
      },
    );
    if (result == null) return;
    setState(() => _pendingNote = result.isEmpty ? null : result);
  }

  Future<void> _createHighlight(String color) async {
    final isar = _isar;
    if (isar == null) return;
    final sentenceId = _selectionSentenceId;
    if (sentenceId == null || _selection.isCollapsed) return;
    final sentence = await isar.sentences.get(sentenceId);
    if (sentence == null) return;
    Highlight? createdHighlight;
    await isar.writeTxn(() async {
      sentence
        ..ensureExternalKey()
        ..updatedAtLocal = DateTime.now();
      await isar.sentences.put(sentence);
      final highlight = Highlight()
        ..sentenceLocalId = sentenceId
        ..sentenceExternalKey = sentence.externalKey
        ..sentenceNotionPageId = sentence.notionPageId
        ..ensureExternalKey()
        ..start = _selection.start
        ..end = _selection.end
        ..color = color
        ..note = _pendingNote
        ..updatedAtLocal = DateTime.now();
      final newId = await isar.highlights.put(highlight);
      highlight.id = newId;
      createdHighlight = highlight;
    });
    _exitSelectionMode();
    if (createdHighlight != null) {
      unawaited(_pushHighlightUpdate(createdHighlight!));
    }
  }

  void _exitSelectionMode() {
    setState(() {
      _selectionMode = false;
      _selectionSentenceId = null;
      _selection = const TextSelection(baseOffset: -1, extentOffset: -1);
      _pendingNote = null;
    });
  }

  void _commitSelectionDraft() {
    if (_selectionSentenceId == null || _selection.isCollapsed) {
      _exitSelectionMode();
    } else {
      _composeNote();
    }
  }

  Future<void> _editHighlight(Highlight highlight) async {
    final controller = TextEditingController(text: highlight.note ?? '');
    String selectedColor = highlight.color;
    final result = await showModalBottomSheet<_HighlightEditResult>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('颜色与备注', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    children: _highlightColors.entries
                        .map(
                          (entry) => ChoiceChip(
                            label: Text(entry.key),
                            selected: selectedColor == entry.key,
                            onSelected: (_) =>
                                setModalState(() => selectedColor = entry.key),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(labelText: '备注'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.pop(
                            context, _HighlightEditResult(delete: true)),
                        style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red),
                        child: const Text('删除高亮'),
                      ),
                      const Spacer(),
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('取消')),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: () {
                          Navigator.pop(
                            context,
                            _HighlightEditResult(
                              color: selectedColor,
                              note: controller.text.trim(),
                            ),
                          );
                        },
                        child: const Text('保存'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
    if (result == null) return;
    final isar = _isar;
    if (isar == null) return;
    if (result.delete) {
      await isar.writeTxn(() async {
        final now = DateTime.now();
        highlight.deletedAt = now;
        highlight.updatedAtLocal = now;
        highlight.ensureExternalKey();
        await isar.highlights.put(highlight);
      });
      unawaited(_pushHighlightDeletion(highlight));
    } else {
      await isar.writeTxn(() async {
        highlight.color = result.color ?? highlight.color;
        highlight.note = result.note;
        highlight.updatedAtLocal = DateTime.now();
        highlight.ensureExternalKey();
        await isar.highlights.put(highlight);
      });
      unawaited(_pushHighlightUpdate(highlight));
    }
  }

  Future<void> _handleSentenceAction(
      Sentence sentence, _SentenceAction action) async {
    final isar = _isar;
    if (isar == null) return;
    switch (action) {
      case _SentenceAction.markFamiliar:
        sentence.familiarState = FamiliarState.familiar;
        break;
      case _SentenceAction.markUnfamiliar:
        sentence.familiarState = FamiliarState.unfamiliar;
        break;
      case _SentenceAction.markNeutral:
        sentence.familiarState = FamiliarState.neutral;
        break;
      case _SentenceAction.delete:
        final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('删除句子'),
                content: const Text('确认删除此句子？此操作不可撤销。'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('取消')),
                  FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: FilledButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('确认删除'),
                  ),
                ],
              ),
            ) ??
            false;
        if (!confirmed) return;
        final relatedHighlights = await isar.highlights
            .filter()
            .sentenceLocalIdEqualTo(sentence.id)
            .findAll();
        await isar.writeTxn(() async {
          final now = DateTime.now();
          sentence.deletedAt = now;
          sentence.updatedAtLocal = now;
          await isar.sentences.put(sentence);
          for (final h in relatedHighlights) {
            h.deletedAt = now;
            h.updatedAtLocal = now;
            h.ensureExternalKey();
            await isar.highlights.put(h);
          }
        });
        unawaited(_pushSentenceDeletion(sentence));
        for (final h in relatedHighlights) {
          unawaited(_pushHighlightDeletion(h));
        }
        return;
    }
    sentence.updatedAtLocal = DateTime.now();
    await isar.writeTxn(() async {
      await isar.sentences.put(sentence);
    });
  }

  Future<void> _pushHighlightUpdate(Highlight highlight) async {
    final service = _pushService;
    if (service == null) return;
    final result = await service.upsertHighlight(highlight);
    if (!result.ok && result.message != null) {
      _showSyncError(result.message!);
    }
  }

  Future<void> _pushHighlightDeletion(Highlight highlight) async {
    final service = _pushService;
    if (service == null) return;
    final result = await service.deleteHighlight(highlight);
    if (!result.ok && result.message != null) {
      _showSyncError(result.message!);
    }
  }

  Future<void> _pushSentenceDeletion(Sentence sentence) async {
    final service = _pushService;
    if (service == null) return;
    final result = await service.deleteSentence(sentence);
    if (!result.ok && result.message != null) {
      _showSyncError(result.message!);
    }
  }

  void _showSyncError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _showStylePanel(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom + 24,
            left: 16,
            right: 16,
            top: 8,
          ),
          child: ReadingStylePanel(
            prefs: _prefs,
            onUpdate: _updatePrefs,
          ),
        );
      },
    );
  }

  Future<void> _updatePrefs(ReadingPrefs prefs) async {
    final isar = _isar;
    if (isar == null) return;
    await isar.writeTxn(() async {
      await isar.readingPrefs.put(prefs);
    });
    setState(() => _prefs = prefs);
  }
}

class _SentenceBlock extends StatefulWidget {
  const _SentenceBlock({
    required this.sentence,
    required this.highlights,
    required this.prefs,
    required this.onSelectionChanged,
    required this.onHighlightTap,
    required this.onAction,
    required this.selectionMode,
  });

  final Sentence sentence;
  final List<Highlight> highlights;
  final ReadingPrefs prefs;
  final bool selectionMode;
  final void Function(TextSelection, SelectionChangedCause?) onSelectionChanged;
  final ValueChanged<Highlight> onHighlightTap;
  final ValueChanged<_SentenceAction> onAction;

  @override
  State<_SentenceBlock> createState() => _SentenceBlockState();
}

class _SentenceBlockState extends State<_SentenceBlock> {
  final List<TapGestureRecognizer> _recognizers = [];

  @override
  void dispose() {
    for (final r in _recognizers) {
      r.dispose();
    }
    super.dispose();
  }

  void _resetRecognizers() {
    for (final r in _recognizers) {
      r.dispose();
    }
    _recognizers.clear();
  }

  @override
  Widget build(BuildContext context) {
    final baseStyle = Theme.of(context).textTheme.bodyLarge!.copyWith(
          fontSize: widget.prefs.fontSize.toDouble(),
          height: widget.prefs.lineHeight,
        );
    final spans =
        _buildSpans(widget.sentence.text, widget.highlights, baseStyle);

    return Card(
      elevation: widget.selectionMode ? 4 : 0,
      color: widget.selectionMode
          ? Theme.of(context)
              .colorScheme
              .secondaryContainer
              .withValues(alpha: 0.3)
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _LeadActionsButton(
                  familiarState: widget.sentence.familiarState,
                  onSelected: widget.onAction,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SelectableText.rich(
                    TextSpan(children: spans),
                    onSelectionChanged: widget.onSelectionChanged,
                    selectionControls: materialTextSelectionControls,
                    enableInteractiveSelection: true,
                  ),
                ),
              ],
            ),
            if (widget.highlights.any((e) => (e.note ?? '').isNotEmpty)) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  for (final h in widget.highlights)
                    if ((h.note ?? '').isNotEmpty)
                      GestureDetector(
                        onTap: () => widget.onHighlightTap(h),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: (_highlightColors[h.color]?.display ??
                                    Colors.blue)
                                .withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(h.note!,
                              style: Theme.of(context).textTheme.bodySmall),
                        ),
                      ),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }

  List<InlineSpan> _buildSpans(
      String text, List<Highlight> highlights, TextStyle baseStyle) {
    _resetRecognizers();
    if (text.isEmpty) {
      return [
        TextSpan(text: '（空句子）', style: baseStyle.copyWith(color: Colors.grey))
      ];
    }
    final spans = <InlineSpan>[];
    int cursor = 0;
    final sorted = [...highlights]..sort((a, b) => a.start.compareTo(b.start));
    for (final h in sorted) {
      final start = h.start.clamp(0, text.length);
      final end = h.end.clamp(start, text.length);
      if (start > cursor) {
        spans.add(
            TextSpan(text: text.substring(cursor, start), style: baseStyle));
      }
      if (end > start) {
        final color = _highlightColors[h.color] ?? _highlightColors['yellow']!;
        final recognizer = TapGestureRecognizer()
          ..onTap = () => widget.onHighlightTap(h);
        _recognizers.add(recognizer);
        spans.add(TextSpan(
          text: text.substring(start, end),
          style: baseStyle.copyWith(
            backgroundColor: color.background,
          ),
          recognizer: recognizer,
        ));
      }
      cursor = end;
    }
    if (cursor < text.length) {
      spans.add(TextSpan(text: text.substring(cursor), style: baseStyle));
    }
    return spans;
  }
}

class _LeadActionsButton extends StatelessWidget {
  const _LeadActionsButton(
      {required this.familiarState, required this.onSelected});
  final FamiliarState familiarState;
  final ValueChanged<_SentenceAction> onSelected;

  Color _stateColor(BuildContext context) {
    switch (familiarState) {
      case FamiliarState.familiar:
        return Colors.green;
      case FamiliarState.unfamiliar:
        return Colors.orange;
      case FamiliarState.neutral:
        return Theme.of(context).colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_SentenceAction>(
      tooltip: '句子操作菜单',
      onSelected: onSelected,
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: _SentenceAction.markFamiliar,
          child: Text('标熟句子'),
        ),
        PopupMenuItem(
          value: _SentenceAction.markUnfamiliar,
          child: Text('标为不熟'),
        ),
        PopupMenuItem(
          value: _SentenceAction.markNeutral,
          child: Text('恢复一般'),
        ),
        PopupMenuDivider(),
        PopupMenuItem(
          value: _SentenceAction.delete,
          child: Text('删除句子'),
        ),
      ],
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: _stateColor(context)),
        ),
        child: Icon(Icons.more_vert, color: _stateColor(context)),
      ),
    );
  }
}

class _SelectionBanner extends StatelessWidget {
  const _SelectionBanner({required this.onCancel, required this.onDone});
  final VoidCallback onCancel;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Material(
        color: Theme.of(context).colorScheme.secondaryContainer,
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              const Icon(Icons.edit, size: 18),
              const SizedBox(width: 8),
              const Text('选择模式'),
              const Spacer(),
              TextButton(onPressed: onCancel, child: const Text('取消')),
              const SizedBox(width: 8),
              FilledButton(onPressed: onDone, child: const Text('完成')),
            ],
          ),
        ),
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot(
      {required this.label, required this.color, required this.onTap});
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.6),
              shape: BoxShape.circle,
              border: Border.all(color: color.withValues(alpha: 0.9), width: 2),
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }
}

class ReadingStylePanel extends StatefulWidget {
  const ReadingStylePanel(
      {super.key, required this.prefs, required this.onUpdate});
  final ReadingPrefs prefs;
  final ValueChanged<ReadingPrefs> onUpdate;

  @override
  State<ReadingStylePanel> createState() => _ReadingStylePanelState();
}

class _ReadingStylePanelState extends State<ReadingStylePanel> {
  late ReadingPrefs _editing;

  @override
  void initState() {
    super.initState();
    _editing = _clone(widget.prefs);
  }

  @override
  void didUpdateWidget(covariant ReadingStylePanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.prefs != oldWidget.prefs) {
      _editing = _clone(widget.prefs);
    }
  }

  ReadingPrefs _clone(ReadingPrefs source) {
    return ReadingPrefs()
      ..id = source.id
      ..theme = source.theme
      ..fontSize = source.fontSize
      ..lineHeight = source.lineHeight
      ..paragraphSpacing = source.paragraphSpacing
      ..updatedAtLocal = source.updatedAtLocal;
  }

  void _persist() {
    _editing.updatedAtLocal = DateTime.now();
    widget.onUpdate(_editing);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('阅读样式', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        Text('背景', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: _readingThemes.entries
              .map(
                (entry) => ChoiceChip(
                  label: Text(entry.key.toUpperCase()),
                  selected: _editing.theme == entry.key,
                  onSelected: (_) {
                    setState(() => _editing.theme = entry.key);
                    _persist();
                  },
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 16),
        _SliderTile(
          label: '字号',
          value: _editing.fontSize.toDouble(),
          min: 14,
          max: 22,
          step: 1,
          unitBuilder: (v) => v.toStringAsFixed(0),
          onChanged: (value) {
            setState(() => _editing.fontSize = value.round());
            _persist();
          },
        ),
        _SliderTile(
          label: '行距',
          value: _editing.lineHeight,
          min: 1.4,
          max: 2.0,
          step: 0.1,
          unitBuilder: (v) => v.toStringAsFixed(1),
          onChanged: (value) {
            setState(() =>
                _editing.lineHeight = double.parse(value.toStringAsFixed(1)));
            _persist();
          },
        ),
        _SliderTile(
          label: '段距',
          value: _editing.paragraphSpacing.toDouble(),
          min: 4,
          max: 16,
          step: 2,
          unitBuilder: (v) => v.toStringAsFixed(0),
          onChanged: (value) {
            setState(() => _editing.paragraphSpacing = value.round());
            _persist();
          },
        ),
      ],
    );
  }
}

class _SliderTile extends StatelessWidget {
  const _SliderTile({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.step,
    required this.unitBuilder,
    required this.onChanged,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final double step;
  final String Function(double) unitBuilder;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text(unitBuilder(value)),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: ((max - min) / step).round(),
          label: unitBuilder(value),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.menu_book_outlined,
              size: 48, color: Theme.of(context).disabledColor),
          const SizedBox(height: 12),
          Text('暂无句子', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text('请先从 Notion 同步或在应用内创建。',
              style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

enum _SentenceAction { markFamiliar, markUnfamiliar, markNeutral, delete }

class _HighlightEditResult {
  _HighlightEditResult({this.color, this.note, this.delete = false});
  final String? color;
  final String? note;
  final bool delete;
}

class ReadingThemeColors {
  const ReadingThemeColors(
      {required this.background, required this.foreground});
  final Color background;
  final Color foreground;
}

class HighlightVisual {
  const HighlightVisual({required this.background, required this.display});
  final Color background;
  final Color display;
}

const Map<String, HighlightVisual> _highlightColors = {
  'yellow': HighlightVisual(
      background: Color(0x66FFF59D), display: Color(0xFFFFF59D)),
  'pink': HighlightVisual(
      background: Color(0x66F8BBD0), display: Color(0xFFF8BBD0)),
  'blue': HighlightVisual(
      background: Color(0x6681D4FA), display: Color(0xFF81D4FA)),
  'green': HighlightVisual(
      background: Color(0x66A5D6A7), display: Color(0xFFA5D6A7)),
};

const Map<String, ReadingThemeColors> _readingThemes = {
  'light': ReadingThemeColors(
      background: Color(0xFFFFFFFF), foreground: Color(0xFF111111)),
  'sepia': ReadingThemeColors(
      background: Color(0xFFF5F0E6), foreground: Color(0xFF3A2F24)),
  'dark': ReadingThemeColors(
      background: Color(0xFF121212), foreground: Color(0xFFF5F5F5)),
};
