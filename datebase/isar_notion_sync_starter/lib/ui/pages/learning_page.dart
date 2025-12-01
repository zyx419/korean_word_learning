import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'package:isar_notion_sync_starter/data/models/highlight.dart';
import 'package:isar_notion_sync_starter/data/models/reading_prefs.dart';
import 'package:isar_notion_sync_starter/data/models/sentence.dart';
import 'package:isar_notion_sync_starter/main.dart';
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
  bool _bulkSelectMode = false;
  final Set<int> _selectedSentenceIds = {};
  FamiliarState? _filterState;
  late final ScrollController _scrollController;
  bool _scrollRestored = false;
  double _lastScrollOffset = 0;
  DateTime? _lastPrefsPersistedAt;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScrollChanged);
    _init();
  }

  Future<void> _init() async {
    await isarService.init();
    _isar = isarService.isar;
    final isar = _isar!;
    await ensureGlobalSchedulerStarted();
    final scheduler = globalSyncScheduler;
    _scheduler = scheduler;
    _pushService = NotionPushService(isar, scheduler: scheduler);
    var prefs = await isar.readingPrefs.get(1);
    if (prefs == null) {
      prefs = ReadingPrefs();
      await isar.writeTxn(() async {
        await isar.readingPrefs.put(prefs!);
      });
    }
    prefs.ensureExternalKey();
    _prefs = prefs;
    _filterState = prefs.filterState;
    _lastScrollOffset = _getOffsetForFilter(_prefs, _filterState);

    _sentenceSub = isar.sentences
        .where()
        .anyId()
        .watch(fireImmediately: true)
        .listen((items) {
      final list =
          _sortByCreatedDesc(items.where((e) => e.deletedAt == null).toList());
      setState(() {
        _sentences = list;
        _loading = false;
      });
      _maybeRestoreScroll();
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
  }

  @override
  void dispose() {
    _sentenceSub?.cancel();
    _highlightSub?.cancel();
    _persistScrollOffset();
    _scrollController.removeListener(_onScrollChanged);
    _scrollController.dispose();
    super.dispose();
  }

  ReadingThemeColors get _themeColors =>
      _readingThemes[_prefs.theme] ?? _readingThemes['light']!;

  @override
  Widget build(BuildContext context) {
    final allVisibleSelected = _areAllVisibleSelected();
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
            if (_bulkSelectMode)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Center(
                    child: Text('已选 ${_selectedSentenceIds.length}',
                        style: Theme.of(context).textTheme.bodyMedium)),
              ),
            IconButton(
              tooltip: _bulkSelectMode ? '退出批量' : '批量选择',
              icon: Icon(
                  _bulkSelectMode ? Icons.close : Icons.check_box_outlined),
              onPressed: _toggleBulkSelectMode,
            ),
            if (_filterState != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Center(
                  child: Text(
                    _filterLabel(_filterState),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            if (_bulkSelectMode)
              IconButton(
                tooltip: allVisibleSelected ? '取消全选' : '全选当前列表',
                icon: Icon(
                    allVisibleSelected ? Icons.check_box : Icons.select_all),
                onPressed: _toggleSelectAllVisible,
              ),
            PopupMenuButton<FamiliarState?>(
              tooltip: '筛选熟练度',
              icon: Icon(
                Icons.filter_list,
                color: _filterState == null
                    ? null
                    : Theme.of(context).colorScheme.primary,
              ),
              onSelected: _onFilterChanged,
              itemBuilder: (context) => [
                CheckedPopupMenuItem(
                  value: null,
                  checked: _filterState == null,
                  child: const Text('全部熟练度'),
                ),
                ...FamiliarState.values.map(
                  (state) => CheckedPopupMenuItem(
                    value: state,
                    checked: _filterState == state,
                    child: Text(state.name),
                  ),
                ),
              ],
            ),
            if (_bulkSelectMode) ...[
              IconButton(
                tooltip: '标熟',
                onPressed: () =>
                    _applyBulkSentenceAction(_SentenceAction.markFamiliar),
                icon: const Icon(Icons.thumb_up_alt_outlined),
              ),
              IconButton(
                tooltip: '标不熟',
                onPressed: () =>
                    _applyBulkSentenceAction(_SentenceAction.markUnfamiliar),
                icon: const Icon(Icons.warning_amber_outlined),
              ),
              IconButton(
                tooltip: '标一般',
                onPressed: () =>
                    _applyBulkSentenceAction(_SentenceAction.markNeutral),
                icon: const Icon(Icons.circle_outlined),
              ),
              IconButton(
                tooltip: '批量删除',
                onPressed: () =>
                    _applyBulkSentenceAction(_SentenceAction.delete),
                icon: const Icon(Icons.delete_outline),
              ),
            ] else ...[
              PopupMenuButton<String>(
                tooltip: '页面设置',
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  switch (value) {
                    case 'import':
                      _showImportDialog();
                      break;
                    case 'style':
                      _showStylePanel(context);
                      break;
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'import', child: Text('导入句子')),
                  PopupMenuItem(value: 'style', child: Text('阅读样式')),
                ],
              ),
            ],
          ],
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : LayoutBuilder(
                builder: (context, constraints) {
                  final maxWidth = constraints.maxWidth;
                  const centerBreakpoint = 768.0;
                  final contentMaxWidth =
                      maxWidth >= centerBreakpoint ? 760.0 : double.infinity;
                  final sentenceArea = _buildSentenceArea(isWideLayout: false);
                  Widget mainContent = sentenceArea;
                  if (contentMaxWidth.isFinite) {
                    mainContent = Align(
                      alignment: Alignment.topCenter,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: contentMaxWidth),
                        child: sentenceArea,
                      ),
                    );
                  }
                  return mainContent;
                },
              ),
      ),
    );
  }

  Widget _buildSentenceArea({required bool isWideLayout}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTabletWidth = screenWidth >= 900;
    final swipeThreshold = isTabletWidth ? 0.15 : 0.25;
    final items = _filterSentences(_sentences);
    final Widget content;
    if (items.isEmpty) {
      content = const _EmptyState();
    } else {
      content = ListView.separated(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(
          horizontal: isWideLayout ? 24 : 16,
          vertical: 16,
        ),
        itemCount: items.length,
        separatorBuilder: (_, __) =>
            SizedBox(height: _prefs.paragraphSpacing.toDouble()),
        itemBuilder: (context, index) {
          final sentence = items[index];
          final highlights = _highlightMap[sentence.id] ?? const [];
          return Dismissible(
            key: ValueKey(sentence.id),
            dragStartBehavior: DragStartBehavior.down,
            dismissThresholds: {
              DismissDirection.startToEnd: swipeThreshold,
              DismissDirection.endToStart: swipeThreshold,
            },
            direction: _bulkSelectMode
                ? DismissDirection.none
                : DismissDirection.horizontal,
            confirmDismiss: (direction) {
              if (_bulkSelectMode) return Future.value(false);
              if (direction == DismissDirection.endToStart) {
                return _handleSwipeFamiliar(sentence);
              } else if (direction == DismissDirection.startToEnd) {
                return _confirmSwipeDelete(sentence);
              }
              return Future.value(false);
            },
            background: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              color: Colors.red.withValues(alpha: 0.2),
              child: const Row(
                children: [
                  Icon(Icons.delete_outline, color: Colors.red),
                  SizedBox(width: 8),
                  Text('删除句子'),
                ],
              ),
            ),
            secondaryBackground: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('提升熟练度'),
                  SizedBox(width: 8),
                  Icon(Icons.trending_up),
                ],
              ),
            ),
            child: _SentenceBlock(
              sentence: sentence,
              highlights: highlights,
              prefs: _prefs,
              selectionMode:
                  _selectionMode && _selectionSentenceId == sentence.id,
              bulkSelectMode: _bulkSelectMode,
              bulkSelected: _selectedSentenceIds.contains(sentence.id),
              onBulkSelectChanged: (selected) =>
                  _toggleBulkSelection(sentence.id, selected),
              onSelectionChanged: (selection, cause) =>
                  _handleSelection(sentence.id, selection, cause),
              onHighlightTap: _editHighlight,
              onAction: (action) => _handleSentenceAction(sentence, action),
            ),
          );
        },
      );
    }

    return Stack(
      children: [
        content,
        if (_selectionMode && items.isNotEmpty) _buildSelectionPalette(),
      ],
    );
  }

  List<Sentence> _sortByCreatedDesc(List<Sentence> source) {
    final sorted = List<Sentence>.from(source);
    sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted;
  }

  String _filterLabel(FamiliarState? state) {
    switch (state) {
      case FamiliarState.familiar:
        return '熟练';
      case FamiliarState.unfamiliar:
        return '不熟';
      case FamiliarState.neutral:
        return '一般';
      default:
        return '全部';
    }
  }

  List<Sentence> _filterSentences(List<Sentence> source) {
    if (_filterState == null) return source;
    final filtered =
        source.where((s) => s.familiarState == _filterState).toList();
    return _sortByCreatedDesc(filtered);
  }

  void _handleSelection(
      int sentenceId, TextSelection selection, SelectionChangedCause? cause) {
    final reason = cause ?? SelectionChangedCause.tap;
    if (reason == SelectionChangedCause.tap && !_selectionMode) return;
    final isLongPress = reason == SelectionChangedCause.longPress;
    if (isLongPress || _selectionMode) {
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
                Row(
                  children: [
                    Text('颜色与备注',
                        style: Theme.of(context).textTheme.titleSmall),
                    const Spacer(),
                    TextButton(
                        onPressed: _exitSelectionMode, child: const Text('取消')),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: _commitSelectionDraft,
                      child: const Text('完成'),
                    ),
                  ],
                ),
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

  Sentence? _findSentenceById(int id) {
    for (final sentence in _sentences) {
      if (sentence.id == id) return sentence;
    }
    return null;
  }

  String? _clipSentenceText(String text, Highlight highlight) {
    if (text.isEmpty) return null;
    final start = highlight.start.clamp(0, text.length);
    final end = highlight.end.clamp(start, text.length);
    if (start >= end) return null;
    return text.substring(start, end);
  }

  Future<String?> _resolveHighlightText(Highlight highlight) async {
    final localSentence = _findSentenceById(highlight.sentenceLocalId);
    if (localSentence != null) {
      return _clipSentenceText(localSentence.text, highlight);
    }
    final isar = _isar;
    if (isar == null) return null;
    final remoteSentence = await isar.sentences.get(highlight.sentenceLocalId);
    if (remoteSentence == null) return null;
    return _clipSentenceText(remoteSentence.text, highlight);
  }

  Future<void> _copyHighlightText(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    final preview = text.length > 30 ? '${text.substring(0, 30)}…' : text;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('已复制：$preview')),
    );
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
    final copyableText = await _resolveHighlightText(highlight);
    if (!mounted) return;
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
                  OutlinedButton.icon(
                    onPressed: (copyableText == null || copyableText.isEmpty)
                        ? null
                        : () => _copyHighlightText(copyableText),
                    icon: const Icon(Icons.copy_outlined),
                    label: const Text('复制所选文本'),
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
        await _updateSentenceFamiliar(sentence, FamiliarState.familiar);
        return;
      case _SentenceAction.markUnfamiliar:
        await _updateSentenceFamiliar(sentence, FamiliarState.unfamiliar);
        return;
      case _SentenceAction.markNeutral:
        await _updateSentenceFamiliar(sentence, FamiliarState.neutral);
        return;
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
        await _deleteSentence(sentence);
        await _reloadSentences();
        return;
    }
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

  void _showSyncError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  double _getOffsetForFilter(ReadingPrefs prefs, FamiliarState? filter) {
    double value() {
      switch (filter) {
        case FamiliarState.familiar:
          return prefs.scrollOffsetFamiliar;
        case FamiliarState.unfamiliar:
          return prefs.scrollOffsetUnfamiliar;
        case FamiliarState.neutral:
          return prefs.scrollOffsetNeutral;
        default:
          return prefs.scrollOffsetAll;
      }
    }

    final v = value();
    return v.isFinite ? v : 0;
  }

  void _setOffsetForFilter(
      ReadingPrefs prefs, FamiliarState? filter, double offset) {
    if (!offset.isFinite || offset < 0) {
      offset = 0.0;
    }
    final clamped = offset;
    switch (filter) {
      case FamiliarState.familiar:
        prefs.scrollOffsetFamiliar = clamped;
        break;
      case FamiliarState.unfamiliar:
        prefs.scrollOffsetUnfamiliar = clamped;
        break;
      case FamiliarState.neutral:
        prefs.scrollOffsetNeutral = clamped;
        break;
      default:
        prefs.scrollOffsetAll = clamped;
        break;
    }
  }

  Future<void> _onFilterChanged(FamiliarState? state) async {
    final currentOffset =
        _scrollController.hasClients ? _scrollController.offset : _lastScrollOffset;
    _setOffsetForFilter(_prefs, _filterState, currentOffset);
    setState(() {
      _filterState = state;
      _prefs.filterState = state;
      _lastScrollOffset = _getOffsetForFilter(_prefs, state);
      _scrollRestored = false;
    });
    await _persistPrefs();
    _maybeRestoreScroll();
  }

  Future<void> _persistPrefs() async {
    final isar = _isar;
    if (isar == null) return;
    _prefs
      ..ensureExternalKey()
      ..updatedAtLocal = DateTime.now();
    await isar.writeTxn(() async {
      await isar.readingPrefs.put(_prefs);
    });
    await _enqueuePrefsSync();
  }

  Future<void> _enqueuePrefsSync() async {
    final scheduler = _scheduler;
    if (scheduler == null) return;
    await scheduler.enqueue(
      entityType: 'prefs',
      op: _prefs.notionPageId == null ? 'create' : 'update',
      entityLocalKey: _prefs.externalKey,
      remoteId: _prefs.notionPageId,
      payload: {
        'externalKey': _prefs.externalKey,
      },
      status: 'pending',
    );
    unawaited(scheduler.runOnce());
  }

  void _onScrollChanged() {
    final offset = _scrollController.offset;
    _lastScrollOffset = offset;
    _setOffsetForFilter(_prefs, _filterState, offset);
    final now = DateTime.now();
    if (_lastPrefsPersistedAt == null ||
        now.difference(_lastPrefsPersistedAt!) >= const Duration(seconds: 2)) {
      _lastPrefsPersistedAt = now;
      unawaited(_persistPrefs());
    }
  }

  void _toggleBulkSelectMode() {
    setState(() {
      if (_bulkSelectMode) {
        _selectedSentenceIds.clear();
      }
      _bulkSelectMode = !_bulkSelectMode;
    });
  }

  void _toggleBulkSelection(int sentenceId, bool selected) {
    setState(() {
      if (selected) {
        _selectedSentenceIds.add(sentenceId);
      } else {
        _selectedSentenceIds.remove(sentenceId);
      }
    });
  }

  bool _areAllVisibleSelected() {
    final visible = _filterSentences(_sentences);
    if (visible.isEmpty) return false;
    return visible.every((s) => _selectedSentenceIds.contains(s.id));
  }

  void _toggleSelectAllVisible() {
    if (!_bulkSelectMode) return;
    final visible = _filterSentences(_sentences);
    if (visible.isEmpty) return;
    final fullySelected =
        visible.every((s) => _selectedSentenceIds.contains(s.id));
    setState(() {
      if (fullySelected) {
        for (final s in visible) {
          _selectedSentenceIds.remove(s.id);
        }
      } else {
        for (final s in visible) {
          _selectedSentenceIds.add(s.id);
        }
      }
    });
  }

  Future<void> _enqueueSentenceSync(Sentence sentence, {String? op}) async {
    final scheduler = _scheduler;
    if (scheduler == null) return;
    sentence.ensureExternalKey();
    await scheduler.enqueue(
      entityType: 'sentence',
      op: op ?? (sentence.notionPageId == null ? 'create' : 'update'),
      entityLocalKey: sentence.externalKey ?? '${sentence.id}',
      remoteId: sentence.notionPageId,
      payload: {
        'externalKey': sentence.externalKey,
        'text': sentence.text,
      },
      status: 'pending',
    );
    unawaited(scheduler.runOnce());
  }

  Future<void> _enqueueHighlightDeletion(Highlight highlight) async {
    final scheduler = _scheduler;
    if (scheduler == null) return;
    await scheduler.enqueue(
      entityType: 'highlight',
      op: 'delete',
      entityLocalKey: '${highlight.id}',
      remoteId: highlight.notionPageId,
      payload: {
        'externalKey': highlight.externalKey,
        'sentenceExternalKey': highlight.sentenceExternalKey,
      },
    );
    unawaited(scheduler.runOnce());
  }

  Future<void> _showImportDialog() async {
    final controller = TextEditingController();
    FamiliarState selected = FamiliarState.unfamiliar;
    final result = await showDialog<_ImportPayload>(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text('导入句子'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  maxLines: 8,
                  decoration: const InputDecoration(
                    hintText: '每行一个句子；空行或仅符号会被忽略',
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButton<FamiliarState>(
                  value: selected,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => selected = value);
                    }
                  },
                  items: FamiliarState.values
                      .map((state) => DropdownMenuItem(
                          value: state, child: Text(state.name)))
                      .toList(),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('取消'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(
                    context, _ImportPayload(controller.text.trim(), selected)),
                child: const Text('导入'),
              ),
            ],
          );
        });
      },
    );
    if (result == null || result.content.isEmpty) return;
    await _importSentences(result.content,
        defaultState: result.defaultFamiliar);
  }

  Future<void> _importSentences(String raw,
      {FamiliarState defaultState = FamiliarState.unfamiliar}) async {
    final isar = _isar;
    if (isar == null) return;
    // 用字符/数字判断句子是否有实际内容
    final RegExp meaningful = RegExp(r'[\p{Letter}\p{Number}]', unicode: true);
    // 按行拆分，并在循环里完成去重与结构化解析
    final lines = raw.split(RegExp(r'\r?\n'));
    final seenTexts = <String>{};
    final sentences = <Sentence>[];
    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;
      final structured = _parseStructuredSentenceLine(trimmed, defaultState);
      if (structured != null) {
        sentences.add(structured);
        continue;
      }
      // 非结构化行，仅包含符号则跳过
      if (!meaningful.hasMatch(trimmed)) continue;
      final key = trimmed.toLowerCase();
      // 忽略重复句子
      if (!seenTexts.add(key)) continue;
      final sentence = Sentence()
        ..text = trimmed
        ..createdAt = DateTime.now()
        ..familiarState = defaultState
        ..updatedAtLocal = DateTime.now();
      sentence.ensureExternalKey();
      sentences.add(sentence);
    }
    // 再次过滤无意义内容（结构化解析可能带来空文本）
    sentences.removeWhere((s) => !meaningful.hasMatch(s.text));
    if (sentences.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('没有可导入的有效句子')),
        );
      }
      return;
    }
    // 写入本地库，确保 id 回填
    await isar.writeTxn(() async {
      for (final sentence in sentences) {
        final id = await isar.sentences.put(sentence);
        sentence.id = id;
      }
    });
    await _reloadSentences();
    // 将新增句子推入同步队列
    for (final sentence in sentences) {
      await _enqueueSentenceSync(sentence, op: 'create');
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('已导入 ${sentences.length} 条句子')));
  }

  Future<void> _applyBulkSentenceAction(_SentenceAction action) async {
    if (!_bulkSelectMode || _selectedSentenceIds.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('请先选择句子')));
      return;
    }
    if (action == _SentenceAction.delete) {
      final confirmed = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('批量删除'),
              content:
                  Text('确认删除选中的 ${_selectedSentenceIds.length} 条句子吗？此操作不可撤销。'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('取消')),
                FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: FilledButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('删除'),
                ),
              ],
            ),
          ) ??
          false;
      if (!confirmed) return;
    }
    final isar = _isar;
    if (isar == null) return;
    final ids = List<int>.from(_selectedSentenceIds);
    final toUpsert = <Sentence>[];
    final toDelete = <Sentence>[];
    await isar.writeTxn(() async {
      for (final id in ids) {
        final sentence = await isar.sentences.get(id);
        if (sentence == null) continue;
        switch (action) {
          case _SentenceAction.markFamiliar:
            sentence.familiarState = FamiliarState.familiar;
            sentence.updatedAtLocal = DateTime.now();
            await isar.sentences.put(sentence);
            toUpsert.add(sentence);
            break;
          case _SentenceAction.markUnfamiliar:
            sentence.familiarState = FamiliarState.unfamiliar;
            sentence.updatedAtLocal = DateTime.now();
            await isar.sentences.put(sentence);
            toUpsert.add(sentence);
            break;
          case _SentenceAction.markNeutral:
            sentence.familiarState = FamiliarState.neutral;
            sentence.updatedAtLocal = DateTime.now();
            await isar.sentences.put(sentence);
            toUpsert.add(sentence);
            break;
          case _SentenceAction.delete:
            toDelete.add(sentence);
            break;
        }
      }
    });
    for (final sentence in toUpsert) {
      await _enqueueSentenceSync(sentence);
    }
    for (final sentence in toDelete) {
      await _deleteSentence(sentence);
    }
    await _reloadSentences();
    setState(() {
      _selectedSentenceIds.clear();
      _bulkSelectMode = false;
    });
  }

  Sentence? _parseStructuredSentenceLine(
      String line, FamiliarState defaultState) {
    final fields = _splitCsvLine(line);
    if (fields.length < 5) return null;
    final headerCheck = fields.map((f) => f.trim().toLowerCase()).toList();
    if (headerCheck[0] == 'title' && headerCheck[1] == 'created') {
      return null;
    }
    final text = fields[0].trim();
    if (text.isEmpty) return null;
    final createdRaw = fields[1].trim();
    final externalKey = fields[2].trim();
    final extra = fields[3].trim();
    final familiarRaw = fields[4].trim();
    final sentence = Sentence()
      ..text = text
      ..createdAt = _parseCreatedAt(createdRaw) ?? DateTime.now()
      ..familiarState =
          familiarRaw.isEmpty ? defaultState : _parseFamiliar(familiarRaw)
      ..extra = extra.isEmpty ? null : extra
      ..updatedAtLocal = DateTime.now();
    if (externalKey.isNotEmpty) {
      sentence.externalKey = externalKey;
    }
    sentence.ensureExternalKey();
    return sentence;
  }

  DateTime? _parseCreatedAt(String raw) {
    if (raw.isEmpty) return null;
    try {
      return DateTime.parse(raw).toLocal();
    } catch (_) {}
    final regex = RegExp(
        r'^(\d{4})年(\d{1,2})月(\d{1,2})日\s+(\d{1,2}):(\d{2})\s*\((?:GMT|UTC)([+-]\d+)\)$');
    final match = regex.firstMatch(raw);
    if (match != null) {
      final year = int.parse(match.group(1)!);
      final month = int.parse(match.group(2)!);
      final day = int.parse(match.group(3)!);
      final hour = int.parse(match.group(4)!);
      final minute = int.parse(match.group(5)!);
      final offsetHours = int.tryParse(match.group(6)!);
      var utc = DateTime.utc(year, month, day, hour, minute);
      if (offsetHours != null) {
        utc = utc.subtract(Duration(hours: offsetHours));
      }
      return utc.toLocal();
    }
    return null;
  }

  FamiliarState _parseFamiliar(String raw) {
    final value = raw.trim().toLowerCase();
    return FamiliarState.values.firstWhere(
      (e) => e.name.toLowerCase() == value,
      orElse: () => FamiliarState.neutral,
    );
  }

  List<String> _splitCsvLine(String line) {
    final result = <String>[];
    var buffer = StringBuffer();
    var inQuotes = false;
    for (var i = 0; i < line.length; i++) {
      final char = line[i];
      if (char == '"') {
        if (inQuotes && i + 1 < line.length && line[i + 1] == '"') {
          buffer.write('"');
          i++;
        } else {
          inQuotes = !inQuotes;
        }
        continue;
      }
      if (char == ',' && !inQuotes) {
        result.add(buffer.toString());
        buffer = StringBuffer();
      } else {
        buffer.write(char);
      }
    }
    result.add(buffer.toString());
    return result;
  }

  Future<void> _reloadSentences() async {
    final isar = _isar;
    if (isar == null) return;
    final items = await isar.sentences.where().anyId().findAll();
    final list =
        _sortByCreatedDesc(items.where((e) => e.deletedAt == null).toList());
    if (!mounted) return;
    setState(() => _sentences = list);
  }

  void _maybeRestoreScroll() {
    if (_scrollRestored) return;
    if (!_scrollController.hasClients) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _maybeRestoreScroll());
      return;
    }
    final max = _scrollController.position.maxScrollExtent;
    final offset = _getOffsetForFilter(_prefs, _filterState);
    final target = offset.clamp(0, max).toDouble();
    _lastScrollOffset = target;
    _scrollController.jumpTo(target);
    _scrollRestored = true;
  }

  Future<void> _persistScrollOffset() async {
    final isar = _isar;
    if (isar == null) return;
    _setOffsetForFilter(_prefs, _filterState, _lastScrollOffset);
    await _persistPrefs();
  }

  Future<bool> _handleSwipeFamiliar(Sentence sentence) async {
    final next = _nextFamiliarState(sentence.familiarState);
    if (next == sentence.familiarState) return false;
    await _updateSentenceFamiliar(sentence, next);
    return false;
  }

  Future<bool> _confirmSwipeDelete(Sentence sentence) async {
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
    if (confirmed) {
      await _deleteSentence(sentence);
      await _reloadSentences();
    }
    return false;
  }

  Future<void> _updateSentenceFamiliar(Sentence sentence, FamiliarState state,
      {bool reload = true}) async {
    final isar = _isar;
    if (isar == null) return;
    sentence.familiarState = state;
    sentence.updatedAtLocal = DateTime.now();
    await isar.writeTxn(() async {
      await isar.sentences.put(sentence);
    });
    await _enqueueSentenceSync(sentence);
    if (reload) {
      await _reloadSentences();
    }
  }

  Future<void> _deleteSentence(Sentence sentence) async {
    final isar = _isar;
    if (isar == null) return;
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
    await _enqueueSentenceSync(sentence, op: 'delete');
    for (final h in relatedHighlights) {
      await _enqueueHighlightDeletion(h);
    }
  }

  FamiliarState _nextFamiliarState(FamiliarState current) {
    switch (current) {
      case FamiliarState.unfamiliar:
        return FamiliarState.neutral;
      case FamiliarState.neutral:
        return FamiliarState.familiar;
      case FamiliarState.familiar:
        return FamiliarState.familiar;
    }
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
    _setOffsetForFilter(prefs, _filterState, _lastScrollOffset);
    prefs.ensureExternalKey();
    prefs
      ..filterState = _filterState
      ..scrollOffsetAll = _prefs.scrollOffsetAll
      ..scrollOffsetFamiliar = _prefs.scrollOffsetFamiliar
      ..scrollOffsetUnfamiliar = _prefs.scrollOffsetUnfamiliar
      ..scrollOffsetNeutral = _prefs.scrollOffsetNeutral
      ..notionPageId = _prefs.notionPageId
      ..externalKey = _prefs.externalKey
      ..updatedAtLocal = DateTime.now();
    setState(() => _prefs = prefs);
    await _persistPrefs();
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
    required this.bulkSelectMode,
    required this.bulkSelected,
    required this.onBulkSelectChanged,
  });

  final Sentence sentence;
  final List<Highlight> highlights;
  final ReadingPrefs prefs;
  final bool selectionMode;
  final bool bulkSelectMode;
  final bool bulkSelected;
  final void Function(TextSelection, SelectionChangedCause?) onSelectionChanged;
  final ValueChanged<Highlight> onHighlightTap;
  final ValueChanged<_SentenceAction> onAction;
  final ValueChanged<bool> onBulkSelectChanged;

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
                if (widget.bulkSelectMode)
                  Checkbox(
                    value: widget.bulkSelected,
                    onChanged: (val) =>
                        widget.onBulkSelectChanged(val ?? false),
                  ),
                const SizedBox(width: 8),
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
        DateTime? tapDownTime;
        final recognizer = TapGestureRecognizer()
          // Treat short tap as “edit highlight”; let long-press fall through to selection.
          ..onTapDown = (_) {
            tapDownTime = DateTime.now();
          }
          ..onTapCancel = () {
            tapDownTime = null;
          }
          ..onTapUp = (_) {
            final down = tapDownTime;
            tapDownTime = null;
            if (down == null) return;
            final elapsed = DateTime.now().difference(down);
            if (elapsed < kLongPressTimeout) {
              widget.onHighlightTap(h);
            }
          };
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

class _ImportPayload {
  _ImportPayload(this.content, this.defaultFamiliar);
  final String content;
  final FamiliarState defaultFamiliar;
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
      ..notionPageId = source.notionPageId
      ..externalKey = source.externalKey
      ..filterState = source.filterState
      ..scrollOffsetAll = source.scrollOffsetAll
      ..scrollOffsetFamiliar = source.scrollOffsetFamiliar
      ..scrollOffsetUnfamiliar = source.scrollOffsetUnfamiliar
      ..scrollOffsetNeutral = source.scrollOffsetNeutral
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
