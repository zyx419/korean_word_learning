import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isar_notion_sync_starter/data/local/secure_token_storage.dart';
import 'package:isar_notion_sync_starter/data/models/notion_auth.dart';
import 'package:isar_notion_sync_starter/data/models/notion_binding.dart';
import 'package:isar_notion_sync_starter/data/remote/notion_api.dart';
import 'package:isar_notion_sync_starter/main.dart';
import 'package:isar_notion_sync_starter/sync/notion_pull_service.dart';

// Optional defaults injected via --dart-define at run time.
// Example:
// flutter run --dart-define=NOTION_TOKEN=secret_... \
//             --dart-define=DB_SENTENCES_URL=https://... \
//             --dart-define=DB_HIGHLIGHTS_URL=https://... \
//             --dart-define=DB_PREFS_URL=https://...
const String kDefaultToken = String.fromEnvironment('NOTION_TOKEN', defaultValue: '');
const String kDefaultDb1 = String.fromEnvironment('DB_SENTENCES_URL', defaultValue: '');
const String kDefaultDb2 = String.fromEnvironment('DB_HIGHLIGHTS_URL', defaultValue: '');
const String kDefaultDb3 = String.fromEnvironment('DB_PREFS_URL', defaultValue: '');

const JsonEncoder _prettyJsonEncoder = JsonEncoder.withIndent('  ');

class SettingsConfig {
  SettingsConfig({
    required this.token,
    required this.dbSentences,
    required this.dbHighlights,
    required this.dbPrefs,
  });

  final String token;
  final String dbSentences;
  final String dbHighlights;
  final String dbPrefs;

  bool get isEmpty =>
      token.trim().isEmpty &&
      dbSentences.trim().isEmpty &&
      dbHighlights.trim().isEmpty &&
      dbPrefs.trim().isEmpty;

  Map<String, dynamic> toJson() => {
        'token': token,
        'dbSentences': dbSentences,
        'dbHighlights': dbHighlights,
        'dbPrefs': dbPrefs,
      };

  factory SettingsConfig.fromJson(Map<String, dynamic> json) {
    return SettingsConfig(
      token: (json['token'] ?? '').toString(),
      dbSentences: (json['dbSentences'] ?? '').toString(),
      dbHighlights: (json['dbHighlights'] ?? '').toString(),
      dbPrefs: (json['dbPrefs'] ?? '').toString(),
    );
  }

  factory SettingsConfig.fromControllers(
    TextEditingController tokenCtl,
    TextEditingController sentencesCtl,
    TextEditingController highlightsCtl,
    TextEditingController prefsCtl,
  ) {
    return SettingsConfig(
      token: tokenCtl.text.trim(),
      dbSentences: sentencesCtl.text.trim(),
      dbHighlights: highlightsCtl.text.trim(),
      dbPrefs: prefsCtl.text.trim(),
    );
  }

  void applyToControllers(
    TextEditingController tokenCtl,
    TextEditingController sentencesCtl,
    TextEditingController highlightsCtl,
    TextEditingController prefsCtl,
  ) {
    tokenCtl.text = token;
    sentencesCtl.text = dbSentences;
    highlightsCtl.text = dbHighlights;
    prefsCtl.text = dbPrefs;
  }
}

/// App settings to configure Notion connectivity.
///
/// Java-to-Dart mental model:
/// - `StatefulWidget` ~ a View with mutable UI state
/// - `State<T>` ~ the controller holding fields and lifecycle (init/dispose)
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  /// Controllers work like Java Swing/TextField models: they hold current
  /// input value and notify the field.
  final _tokenCtl = TextEditingController();
  // 1=Sentences, 2=Highlights, 3=Prefs
  final _dbSentencesCtl = TextEditingController();
  final _dbHighlightsCtl = TextEditingController();
  final _dbPrefsCtl = TextEditingController();
  bool _loading = false;
  bool _fileBusy = false;
  String _statusText = '';
  DateTime? _testedAt;
  DateTime? _lastSyncedAt;
  String? _db1Name;
  String? _db2Name;
  String? _db3Name;

  @override
  void initState() {
    super.initState();
    _load();
  }

  /// Load previously saved token/binding from local Isar database.
  Future<void> _load() async {
    // Ensure the Isar instance is opened before CRUD.
    await isarService.init();
    final isar = isarService.isar;
    
    // 从安全存储读取 Token
    final token = await secureTokenStorage.getToken();
    if (token != null && token.isNotEmpty) {
      _tokenCtl.text = token;
    }
    
    // 读取其他认证状态信息（非敏感数据仍存在 Isar 中）
    final auth = await isar.notionAuths.get(1);
    if (auth != null) {
      _statusText = auth.status;
      _testedAt = auth.testedAt;
      _lastSyncedAt = auth.lastSyncedAt;
    }
    
    final b1 = await isar.notionDatabaseBindings.get(1);
    final b2 = await isar.notionDatabaseBindings.get(2);
    final b3 = await isar.notionDatabaseBindings.get(3);
    if (b1 != null) {
      _dbSentencesCtl.text = b1.rawUrl.isNotEmpty ? b1.rawUrl : b1.databaseId;
      _db1Name = b1.databaseName.isNotEmpty ? b1.databaseName : null;
    }
    if (b2 != null) {
      _dbHighlightsCtl.text = b2.rawUrl.isNotEmpty ? b2.rawUrl : b2.databaseId;
      _db2Name = b2.databaseName.isNotEmpty ? b2.databaseName : null;
    }
    if (b3 != null) {
      _dbPrefsCtl.text = b3.rawUrl.isNotEmpty ? b3.rawUrl : b3.databaseId;
      _db3Name = b3.databaseName.isNotEmpty ? b3.databaseName : null;
    }
    // Prefill from --dart-define only when local store is empty.
    if (_tokenCtl.text.isEmpty && kDefaultToken.isNotEmpty) {
      _tokenCtl.text = kDefaultToken;
    }
    if (_dbSentencesCtl.text.isEmpty && kDefaultDb1.isNotEmpty) {
      _dbSentencesCtl.text = kDefaultDb1;
    }
    if (_dbHighlightsCtl.text.isEmpty && kDefaultDb2.isNotEmpty) {
      _dbHighlightsCtl.text = kDefaultDb2;
    }
    if (_dbPrefsCtl.text.isEmpty && kDefaultDb3.isNotEmpty) {
      _dbPrefsCtl.text = kDefaultDb3;
    }
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _tokenCtl.dispose();
    _dbSentencesCtl.dispose();
    _dbHighlightsCtl.dispose();
    _dbPrefsCtl.dispose();
    super.dispose();
  }

  /// Accepts either a Notion database URL or a raw 32-char ID.
  /// Normalizes to 32 hex chars without dashes.
  static String _extractDatabaseId(String input) {
    final urlMatch = RegExp(r"[0-9a-fA-F]{32}")
        .firstMatch(input.replaceAll('-', ''));
    if (urlMatch != null) {
      return urlMatch.group(0)!.toLowerCase();
    }
    throw const FormatException('无法从输入中解析 Notion Database ID');
  }

  /// Persist token and any non-empty database bindings locally without contacting Notion.
  Future<void> _saveOnly({bool showToast = true}) async {
    final token = _tokenCtl.text.trim();
    if (token.isEmpty &&
        _dbSentencesCtl.text.trim().isEmpty &&
        _dbHighlightsCtl.text.trim().isEmpty &&
        _dbPrefsCtl.text.trim().isEmpty) {
      _snack('请填写至少一项配置');
      return;
    }

    // 保存 Token 到安全存储
    if (token.isNotEmpty) {
      await secureTokenStorage.saveToken(token);
    } else {
      await secureTokenStorage.deleteToken();
    }

    await isarService.init();
    final isar = isarService.isar;

    Future<void> saveBinding(int id, TextEditingController ctl) async {
      final raw = ctl.text.trim();
      if (raw.isEmpty) return;
      final dbId = _extractDatabaseId(raw);
      await isar.writeTxn(() async {
        final b = await isar.notionDatabaseBindings.get(id) ?? (NotionDatabaseBinding()..id = id);
        b.rawUrl = raw;
        b.databaseId = dbId;
        await isar.notionDatabaseBindings.put(b);
      });
    }

    try {
      await saveBinding(1, _dbSentencesCtl);
      await saveBinding(2, _dbHighlightsCtl);
      await saveBinding(3, _dbPrefsCtl);
      if (showToast) {
        _snack('已保存');
      }
    } catch (e) {
      _snack('保存失败：$e');
    }
  }

  /// Persist and then perform a safe connectivity check against Notion.
  /// It uses GET /databases/{id}, so it won't create or mutate any data.
  Future<void> _saveAndTest() async {
    if (_loading) return;
    setState(() => _loading = true);
    try {
      final token = _tokenCtl.text.trim();
      if (token.isEmpty) {
        _snack('请填写 Token');
        return;
      }

      // 1) Save token to secure storage first
      await secureTokenStorage.saveToken(token);

      await isarService.init();
      final isar = isarService.isar;

      // 2) Update auth status (non-sensitive data in Isar)
      await isar.writeTxn(() async {
        final auth = await isar.notionAuths.get(1) ?? NotionAuth();
        auth.status = 'testing';
        auth.errorMessage = null;
        await isar.notionAuths.put(auth);
      });

      // 3) Connectivity check via Notion API (safe GET to databases/{id}).
      final api = NotionApi(token);
      Future<void> saveAndTestOne(int id, TextEditingController ctl, void Function(String?) setName) async {
        final raw = ctl.text.trim();
        if (raw.isEmpty) return;
        final dbId = _extractDatabaseId(raw);
        await isar.writeTxn(() async {
          final b = await isar.notionDatabaseBindings.get(id) ?? (NotionDatabaseBinding()..id = id);
          b.rawUrl = raw;
          b.databaseId = dbId;
          await isar.notionDatabaseBindings.put(b);
        });
        final meta = await api.getDatabase(dbId);
        final name = (meta['title'] is List && meta['title'].isNotEmpty)
            ? (meta['title'][0]['plain_text'] as String? ?? '')
            : (meta['title']?.toString() ?? '');
        await isar.writeTxn(() async {
          final b = await isar.notionDatabaseBindings.get(id) ?? (NotionDatabaseBinding()..id = id);
          b.databaseName = name;
          await isar.notionDatabaseBindings.put(b);
        });
        setName(name.isEmpty ? null : name);
      }

      await saveAndTestOne(1, _dbSentencesCtl, (v) => _db1Name = v);
      await saveAndTestOne(2, _dbHighlightsCtl, (v) => _db2Name = v);
      await saveAndTestOne(3, _dbPrefsCtl, (v) => _db3Name = v);

      // 4) Mark overall success and time
      await isar.writeTxn(() async {
        final auth = await isar.notionAuths.get(1) ?? NotionAuth();
        auth.status = 'success';
        auth.testedAt = DateTime.now();
        await isar.notionAuths.put(auth);
      });

      setState(() {
        _statusText = 'success';
        _testedAt = DateTime.now();
      });
      _snack('连接成功');
    } catch (e) {
      // Any thrown HttpException/format error marks the status as error.
      await isarService.init();
      final isar = isarService.isar;
      await isar.writeTxn(() async {
        final auth = await isar.notionAuths.get(1) ?? NotionAuth();
        auth.status = 'error';
        auth.testedAt = DateTime.now();
        auth.errorMessage = '$e';
        await isar.notionAuths.put(auth);
      });
      setState(() {
        _statusText = 'error';
        _testedAt = DateTime.now();
      });
      _snack('连接失败：$e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _triggerManualSync() async {
    if (_loading) return;
    setState(() => _loading = true);
    try {
      final token = await secureTokenStorage.getToken();
      if (token == null || token.isEmpty) {
        _snack('请先保存 Notion Token 和数据库 ID');
        return;
      }
      await isarService.init();
      final isar = isarService.isar;
      await NotionPullService(isar).pullAll();
      final refreshed = await isar.notionAuths.get(1);
      setState(() => _lastSyncedAt = refreshed?.lastSyncedAt);
      _snack('已触发一次同步');
    } catch (e) {
      _snack('同步失败：$e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _exportConfig() async {
    if (_fileBusy) return;
    setState(() => _fileBusy = true);
    try {
      final config = SettingsConfig.fromControllers(_tokenCtl, _dbSentencesCtl, _dbHighlightsCtl, _dbPrefsCtl);
      if (config.isEmpty) {
        _snack('暂无可导出的配置');
        return;
      }
      final fileName = 'notion_config_${_fileTimestamp()}.json';
      final jsonPayload = _prettyJsonEncoder.convert(config.toJson());
      final bytes = Uint8List.fromList(utf8.encode(jsonPayload));
      try {
        final savedPath = await FilePicker.platform.saveFile(
          dialogTitle: '导出配置',
          fileName: fileName,
          type: FileType.custom,
          allowedExtensions: const ['json'],
          bytes: bytes,
        );
        if (savedPath == null) {
          _snack('已取消导出');
        } else {
          _snack('已导出：$savedPath');
        }
      } on UnimplementedError {
        final fallbackPath = await _manualSaveConfig(fileName, bytes);
        if (fallbackPath == null) {
          _snack('已取消导出');
        } else {
          _snack('已导出至：$fallbackPath');
        }
      }
    } catch (e) {
      _snack('导出失败：$e');
    } finally {
      if (mounted) setState(() => _fileBusy = false);
    }
  }

  Future<void> _importConfig() async {
    if (_fileBusy) return;
    setState(() => _fileBusy = true);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['json'],
        withData: true,
      );
      if (result == null || result.files.isEmpty) {
        _snack('已取消导入');
        return;
      }
      final file = result.files.first;
      String? content;
      if (file.bytes != null) {
        content = utf8.decode(file.bytes!);
      } else if (!kIsWeb && file.path != null) {
        content = await File(file.path!).readAsString();
      }
      if (content == null) {
        _snack('无法读取所选文件');
        return;
      }
      final decoded = jsonDecode(content);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('JSON 结构无效');
      }
      final config = SettingsConfig.fromJson(decoded);
      config.applyToControllers(_tokenCtl, _dbSentencesCtl, _dbHighlightsCtl, _dbPrefsCtl);
      _db1Name = _db2Name = _db3Name = null;
      await _saveOnly(showToast: false);
      if (mounted) setState(() {});
      _snack('导入成功并已保存');
    } catch (e) {
      _snack('导入失败：$e');
    } finally {
      if (mounted) setState(() => _fileBusy = false);
    }
  }

  Future<String?> _manualSaveConfig(String fileName, Uint8List bytes) async {
    if (kIsWeb) return null;
    final directory = await FilePicker.platform.getDirectoryPath(dialogTitle: '选择保存文件夹');
    if (directory == null) return null;
    final path = _joinPath(directory, fileName);
    final file = File(path);
    await file.writeAsBytes(bytes);
    return path;
  }

  String _joinPath(String directory, String fileName) {
    final separator = Platform.pathSeparator;
    if (directory.endsWith(separator)) {
      return '$directory$fileName';
    }
    return '$directory$separator$fileName';
  }

  String _fileTimestamp() {
    return DateTime.now().toIso8601String().replaceAll(':', '-');
  }

  String _formatLastSync() {
    if (_lastSyncedAt == null) return '未同步';
    final local = _lastSyncedAt!.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${local.year}-${two(local.month)}-${two(local.day)} '
        '${two(local.hour)}:${two(local.minute)}';
  }

  /// Small helper to surface messages as SnackBars.
  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final caption = Theme.of(context).textTheme.bodySmall;
    final buttonsDisabled = _loading || _fileBusy;
    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Notion Token', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              TextField(
                controller: _tokenCtl,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'secret_***',
                ),
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
              ),
              const SizedBox(height: 16),
              Text('DB_Sentences（URL 或 32位ID）', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              TextField(
                controller: _dbSentencesCtl,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'https://www.notion.so/... 或 32位ID',
                  helperText: _db1Name == null ? null : '已识别：$_db1Name',
                ),
              ),
              const SizedBox(height: 12),
              Text('DB_Highlights（URL 或 32位ID）', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              TextField(
                controller: _dbHighlightsCtl,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'https://www.notion.so/... 或 32位ID',
                  helperText: _db2Name == null ? null : '已识别：$_db2Name',
                ),
              ),
              const SizedBox(height: 12),
              Text('DB_Prefs（URL 或 32位ID，可选）', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              TextField(
                controller: _dbPrefsCtl,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'https://www.notion.so/... 或 32位ID',
                  helperText: _db3Name == null ? null : '已识别：$_db3Name',
                ),
              ),
              const SizedBox(height: 8),
              if (_statusText.isNotEmpty)
                Text('上次结果：$_statusText${_testedAt != null ? ' @ ${_testedAt!.toLocal()}' : ''}', style: caption),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: buttonsDisabled ? null : _triggerManualSync,
                      icon: const Icon(Icons.sync),
                      label: const Text('手动同步 Notion'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('上次同步：${_formatLastSync()}', style: caption),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: buttonsDisabled ? null : _saveOnly,
                      child: const Text('仅保存'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: buttonsDisabled ? null : _saveAndTest,
                      child: _loading
                          ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Text('保存并测试（全部）'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: buttonsDisabled ? null : _exportConfig,
                      child: _fileBusy
                          ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Text('导出 JSON'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: buttonsDisabled ? null : _importConfig,
                      child: _fileBusy
                          ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Text('导入 JSON'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
