import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:isar_notion_sync_starter/data/models/sync_queue_item.dart';
import 'package:isar_notion_sync_starter/main.dart';
import 'package:isar_notion_sync_starter/sync/sync_scheduler_impl.dart';

class SyncQueuePage extends StatefulWidget {
  const SyncQueuePage({super.key, this.itemsStream});

  /// Optional injected stream for tests/demos so we don't rely on Isar runtime.
  final Stream<List<SyncQueueItem>>? itemsStream;

  @override
  State<SyncQueuePage> createState() => _SyncQueuePageState();
}

class _SyncQueuePageState extends State<SyncQueuePage> {
  late final SyncSchedulerImpl _scheduler;
  Stream<List<SyncQueueItem>>? _stream;
  bool _inited = false;

  // UI filters
  String _status = 'all';
  String _entity = 'all'; // sentence|highlight|pref
  String _keyword = '';
  String _sort = 'updated_desc'; // updated_desc|priority_desc|created_desc

  final _searchCtl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.itemsStream != null) {
      _stream = widget.itemsStream;
      _inited = true;
    } else {
      _init();
    }
  }

  Future<void> _init() async {
    await isarService.init();
    _scheduler = SyncSchedulerImpl(isarService.isar);
    _buildStream();
    setState(() => _inited = true);
  }

  void _buildStream() {
    if (widget.itemsStream != null) {
      _stream = widget.itemsStream;
      return;
    }

    final isar = isarService.isar;
    _stream = isar.syncQueueItems.where().anyId().watch(fireImmediately: true);
  }

  @override
  void dispose() {
    _searchCtl.dispose();
    super.dispose();
  }

  Future<void> _runOnce() async {
    await _scheduler.runOnce();
    if (mounted) _snack('已触发一次同步');
  }

  Future<void> _retryItem(SyncQueueItem item) async {
    final isar = isarService.isar;
    await isar.writeTxn(() async {
      item.status = 'pending';
      item.updatedAt = DateTime.now();
      await isar.syncQueueItems.put(item);
    });
  }

  Future<void> _cancelItem(SyncQueueItem item) async {
    final isar = isarService.isar;
    await isar.writeTxn(() async {
      item.status = 'canceled';
      item.updatedAt = DateTime.now();
      await isar.syncQueueItems.put(item);
    });
  }

  Future<void> _deleteItem(SyncQueueItem item) async {
    final isar = isarService.isar;
    await isar.writeTxn(() async {
      await isar.syncQueueItems.delete(item.id);
    });
  }

  Future<void> _retryFailed() async {
    final isar = isarService.isar;
    final failed = await isar.syncQueueItems.filter().statusEqualTo('failed').findAll();
    await isar.writeTxn(() async {
      for (final it in failed) {
        it.status = 'pending';
        it.updatedAt = DateTime.now();
        await isar.syncQueueItems.put(it);
      }
    });
  }

  Future<void> _cancelPending() async {
    final isar = isarService.isar;
    final pending = await isar.syncQueueItems.filter().statusEqualTo('pending').findAll();
    await isar.writeTxn(() async {
      for (final it in pending) {
        it.status = 'canceled';
        it.updatedAt = DateTime.now();
        await isar.syncQueueItems.put(it);
      }
    });
  }

  Future<void> _clearSuccess() async {
    final isar = isarService.isar;
    final success = await isar.syncQueueItems.filter().statusEqualTo('success').findAll();
    await isar.writeTxn(() async {
      for (final it in success) {
        await isar.syncQueueItems.delete(it.id);
      }
    });
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('同步队列'),
        actions: [
          IconButton(
            tooltip: '运行一次',
            onPressed: (_inited && widget.itemsStream == null) ? _runOnce : null,
            icon: const Icon(Icons.play_circle_outline),
          ),
          if (widget.itemsStream == null)
            PopupMenuButton<String>(
              tooltip: '批量操作',
              onSelected: (v) async {
                switch (v) {
                  case 'retry_failed':
                    await _retryFailed();
                    _snack('已重试所有失败任务');
                    break;
                  case 'cancel_pending':
                    await _cancelPending();
                    _snack('已取消所有待处理任务');
                    break;
                  case 'clear_success':
                    await _clearSuccess();
                    _snack('已清理成功任务');
                    break;
                }
              },
              itemBuilder: (ctx) => const [
                PopupMenuItem(value: 'retry_failed', child: Text('重试失败全部')),
                PopupMenuItem(value: 'cancel_pending', child: Text('取消待处理全部')),
                PopupMenuItem(value: 'clear_success', child: Text('清理成功记录')),
              ],
            ),
        ],
      ),
      body: !_inited
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  _buildFilters(context),
                  const SizedBox(height: 8),
                  Expanded(
                    child: StreamBuilder<List<SyncQueueItem>>(
                      stream: _stream,
                      builder: (context, snap) {
                        final items = _applyFilters(snap.data ?? const <SyncQueueItem>[]);
                        return Column(
                          children: [
                            _SummaryBar(items: items),
                            const SizedBox(height: 8),
                            Expanded(
                              child: items.isEmpty
                                  ? const _EmptyState()
                                  : _buildList(items),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildFilters(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 第1排：搜索 + 排序
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchCtl,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: '搜索 queueId / 本地键 / 远端ID',
                  isDense: true,
                  border: const OutlineInputBorder(),
                  suffixIcon: _keyword.isEmpty
                      ? null
                      : IconButton(
                          onPressed: () {
                            _searchCtl.clear();
                            setState(() => _keyword = '');
                          },
                          icon: const Icon(Icons.clear),
                        ),
                ),
                onChanged: (v) => setState(() => _keyword = v),
              ),
            ),
            const SizedBox(width: 8),
            DropdownButton<String>(
              value: _sort,
              items: const [
                DropdownMenuItem(value: 'updated_desc', child: Text('按更新时间')),
                DropdownMenuItem(value: 'priority_desc', child: Text('按优先级')),
                DropdownMenuItem(value: 'created_desc', child: Text('按创建时间')),
              ],
              onChanged: (v) => setState(() => _sort = v ?? 'updated_desc'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // 第2排：状态筛选（独立一排）
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final s in const [
                'all', 'pending', 'syncing', 'success', 'failed', 'canceled', 'skipped'
              ])
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(_statusLabel(s)),
                    selected: _status == s,
                    onSelected: (_) => setState(() => _status = s),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        // 第3排：类型筛选（独立一排）
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final e in const ['all', 'sentence', 'highlight', 'pref'])
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(_entityLabel(e)),
                    selected: _entity == e,
                    onSelected: (_) => setState(() => _entity = e),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
  List<SyncQueueItem> _applyFilters(List<SyncQueueItem> items) {
    Iterable<SyncQueueItem> it = items;
    if (_status != 'all') {
      it = it.where((e) => e.status == _status);
    }
    if (_entity != 'all') {
      it = it.where((e) => e.entityType == _entity);
    }
    final kw = _keyword.trim();
    if (kw.isNotEmpty) {
      it = it.where((e) =>
          e.queueId.contains(kw) ||
          e.entityLocalKey.contains(kw) ||
          (e.entityNotionPageId ?? '').contains(kw));
    }
    final list = it.toList();
    list.sort(_compareItems);
    return list;
  }

  int _compareItems(SyncQueueItem a, SyncQueueItem b) {
    switch (_sort) {
      case 'priority_desc':
        final cmp = b.priority.compareTo(a.priority);
        if (cmp != 0) return cmp;
        return b.updatedAt.compareTo(a.updatedAt);
      case 'created_desc':
        return b.createdAt.compareTo(a.createdAt);
      case 'updated_desc':
      default:
        return b.updatedAt.compareTo(a.updatedAt);
    }
  }

  Widget _buildList(List<SyncQueueItem> items) {
    final list = ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, i) {
        return _ItemTile(
          item: items[i],
          onRetry: () => _retryItem(items[i]),
          onCancel: () => _cancelItem(items[i]),
          onDelete: () => _deleteItem(items[i]),
        );
      },
    );
    if (widget.itemsStream != null) {
      return list;
    }
    return RefreshIndicator(onRefresh: () async => _runOnce(), child: list);
  }
}

class _SummaryBar extends StatelessWidget {
  const _SummaryBar({required this.items});
  final List<SyncQueueItem> items;

  int _count(String s) => s == 'all' ? items.length : items.where((e) => e.status == s).length;

  @override
  Widget build(BuildContext context) {
    final chips = <Widget>[
      _pill('全部', _count('all'), Colors.grey),
      _pill('待处理', _count('pending'), _statusColor('pending')),
      _pill('进行中', _count('syncing'), _statusColor('syncing')),
      _pill('成功', _count('success'), _statusColor('success')),
      _pill('失败', _count('failed'), _statusColor('failed')),
      _pill('已取消', _count('canceled'), _statusColor('canceled')),
      _pill('跳过', _count('skipped'), _statusColor('skipped')),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: [for (final c in chips) Padding(padding: const EdgeInsets.only(right: 8), child: c)]),
    );
  }

  Widget _pill(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text('$label $count'),
        ],
      ),
    );
  }
}

class _ItemTile extends StatefulWidget {
  const _ItemTile({required this.item, required this.onRetry, required this.onCancel, required this.onDelete});
  final SyncQueueItem item;
  final VoidCallback onRetry;
  final VoidCallback onCancel;
  final VoidCallback onDelete;

  @override
  State<_ItemTile> createState() => _ItemTileState();
}

class _ItemTileState extends State<_ItemTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final it = widget.item;
    final color = _statusColor(it.status);
    final subtitle = [
      '#${it.queueId}',
      '优先级 ${it.priority}',
      '尝试 ${it.attempt}/${it.maxAttempt}',
      _fmtTime(it.updatedAt),
    ].join(' · ');

    return InkWell(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 10, height: 10, margin: const EdgeInsets.only(top: 6, right: 8), decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${_entityLabel(it.entityType)} ${_opLabel(it.op)} · ${it.entityLocalKey}',
                          style: Theme.of(context).textTheme.titleSmall),
                      const SizedBox(height: 2),
                      Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
                Wrap(spacing: 4, children: [
                  _statusChip(it.status),
                  IconButton(tooltip: '重试', onPressed: it.status == 'failed' ? widget.onRetry : null, icon: const Icon(Icons.refresh)),
                  IconButton(tooltip: '取消', onPressed: it.status == 'pending' ? widget.onCancel : null, icon: const Icon(Icons.cancel_outlined)),
                  IconButton(tooltip: '删除', onPressed: widget.onDelete, icon: const Icon(Icons.delete_outline)),
                ]),
              ],
            ),
            if (_expanded) ...[
              const SizedBox(height: 8),
              _kv('远端ID', it.entityNotionPageId ?? '-'),
              _kv('状态', '${_statusLabel(it.status)}  尝试 ${it.attempt}/${it.maxAttempt}'),
              if (it.lastErrorMessage != null && it.lastErrorMessage!.isNotEmpty)
                _kv('错误', '${it.lastErrorCode ?? 'ERROR'}: ${it.lastErrorMessage}'),
              _kv('载荷', _prettyJson(it.payload)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _kv(String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 64, child: Text(k, style: Theme.of(context).textTheme.bodySmall)),
          const SizedBox(width: 8),
          Expanded(child: Text(v, style: Theme.of(context).textTheme.bodySmall)),
        ],
      ),
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
          Icon(Icons.task_alt_outlined, size: 40, color: Theme.of(context).disabledColor),
          const SizedBox(height: 8),
          Text('暂无任务', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          Text('下拉刷新或返回重试', style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

// Helpers
Color _statusColor(String status) {
  switch (status) {
    case 'pending':
      return Colors.orange;
    case 'syncing':
      return Colors.blue;
    case 'success':
      return Colors.green;
    case 'failed':
      return Colors.red;
    case 'canceled':
      return Colors.grey;
    case 'skipped':
      return Colors.purple;
    default:
      return Colors.grey;
  }
}

String _statusLabel(String s) {
  switch (s) {
    case 'all':
      return '全部';
    case 'pending':
      return '待处理';
    case 'syncing':
      return '进行中';
    case 'success':
      return '成功';
    case 'failed':
      return '失败';
    case 'canceled':
      return '已取消';
    case 'skipped':
      return '跳过';
    default:
      return s;
  }
}

String _entityLabel(String e) {
  switch (e) {
    case 'all':
      return '全部类型';
    case 'sentence':
      return '句子';
    case 'highlight':
      return '高亮';
    case 'pref':
      return '偏好';
    default:
      return e;
  }
}

String _opLabel(String op) {
  switch (op) {
    case 'create':
      return '创建';
    case 'update':
      return '更新';
    case 'delete':
      return '删除';
    default:
      return op;
  }
}

Widget _statusChip(String status) {
  return Chip(
    padding: EdgeInsets.zero,
    visualDensity: VisualDensity.compact,
    label: Text(_statusLabel(status)),
    backgroundColor: _statusColor(status).withOpacity(0.12),
    side: BorderSide(color: _statusColor(status).withOpacity(0.4)),
  );
}

String _fmtTime(DateTime dt) {
  final d = dt.toLocal();
  final two = (int n) => n.toString().padLeft(2, '0');
  return '${d.year}-${two(d.month)}-${two(d.day)} ${two(d.hour)}:${two(d.minute)}:${two(d.second)}';
}

String _prettyJson(String raw) {
  try {
    final map = jsonDecode(raw);
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(map);
  } catch (_) {
    return raw;
  }
}
