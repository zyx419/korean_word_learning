import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:isar_notion_sync_starter/data/adapters/notion_mappers.dart';
import 'package:isar_notion_sync_starter/data/local/secure_token_storage.dart';
import 'package:isar_notion_sync_starter/data/models/highlight.dart';
import 'package:isar_notion_sync_starter/data/models/notion_auth.dart';
import 'package:isar_notion_sync_starter/data/models/notion_binding.dart';
import 'package:isar_notion_sync_starter/data/models/reading_prefs.dart';
import 'package:isar_notion_sync_starter/data/models/sentence.dart';
import 'package:isar_notion_sync_starter/data/remote/notion_api.dart';
import 'package:isar_notion_sync_starter/utils/app_logger.dart';

/// Background puller that fetches the latest Notion data on app start.
class NotionPullService {
  NotionPullService(this._isar);
  final Isar _isar;
  final AppLogger _logger = AppLogger.instance;

  /// Pull sentences/highlights/prefs from Notion and upsert into Isar.
  Future<void> pullAll() async {
    _logger.info('Starting Notion pull');
    final token = await secureTokenStorage.getToken();
    if (token == null || token.isEmpty) {
      _logger.warn('Notion token not configured. Skipping pull.');
      return;
    }

    final bindings = await _isar.notionDatabaseBindings.getAll([1, 2, 3]);
    final sentencesDb = bindings[0];
    final highlightsDb = bindings[1];
    final prefsDb = bindings[2];
    if ((sentencesDb?.databaseId.isEmpty ?? true) &&
        (highlightsDb?.databaseId.isEmpty ?? true) &&
        (prefsDb?.databaseId.isEmpty ?? true)) {
      _logger.warn('No Notion database IDs configured. Skipping pull.');
      return;
    }

    final startedAt = DateTime.now();
    _logger.debug(
        'Using databases: sentences=${sentencesDb?.databaseId}, highlights=${highlightsDb?.databaseId}, prefs=${prefsDb?.databaseId}');

    final api = NotionApi(token);
    try {
      if (sentencesDb != null && sentencesDb.databaseId.isNotEmpty) {
        _logger.info('Syncing sentences from ${sentencesDb.databaseId}');
        await _syncSentences(api, sentencesDb.databaseId);
      }
      if (highlightsDb != null && highlightsDb.databaseId.isNotEmpty) {
        _logger.info('Syncing highlights from ${highlightsDb.databaseId}');
        await _syncHighlights(api, highlightsDb.databaseId);
      }
      if (prefsDb != null && prefsDb.databaseId.isNotEmpty) {
        _logger.info('Syncing reading preferences from ${prefsDb.databaseId}');
        await _syncPrefs(api, prefsDb.databaseId);
      }
      _logger.info('Notion pull completed');
    } catch (e, st) {
      _logger.error('Notion pull error', error: e, stackTrace: st);
      if (kDebugMode) {
        debugPrint('Notion pull error: $e');
        debugPrint('$st');
      }
    }
    await _markLastSynced(startedAt);
  }

  Future<void> _markLastSynced(DateTime time) async {
    await _isar.writeTxn(() async {
      final auth = await _isar.notionAuths.get(1) ?? NotionAuth();
      auth.lastSyncedAt = time;
      await _isar.notionAuths.put(auth);
    });
  }

  Future<void> _syncSentences(NotionApi api, String databaseId) async {
    final pages = await api.queryDatabase(databaseId);
    _logger.info('Fetched ${pages.length} sentence pages from Notion');
    if (pages.isEmpty) return;
    await _isar.writeTxn(() async {
      for (final page in pages) {
        final remote = Sentence.fromNotion(page);
        final remoteId = remote.notionPageId;
        if (remoteId == null) {
          _logger.warn('Skipped sentence with null Notion page id');
          continue;
        }
        remote.updatedAtLocal = DateTime.now();
        final existing = await _isar.sentences
            .filter()
            .notionPageIdEqualTo(remoteId, caseSensitive: false)
            .findFirst();
        if (existing == null) {
          await _isar.sentences.put(remote);
          _logger.info('Inserted sentence $remoteId text="${remote.text}"');
        } else if (_remoteWins(
          remoteUpdated: remote.updatedAtRemote,
          localUpdated: existing.updatedAtLocal,
          remoteCreated: remote.createdAt,
          localCreated: existing.createdAt,
        )) {
          existing
            ..text = remote.text
            ..familiarState = remote.familiarState
            ..updatedAtRemote = remote.updatedAtRemote
            ..updatedAtLocal = DateTime.now()
            ..externalKey = remote.externalKey ?? existing.externalKey
            ..createdAt = remote.createdAt
            ..deletedAt = null;
          await _isar.sentences.put(existing);
          _logger.info(
              'Updated sentence $remoteId text="${remote.text}", updatedAt=${remote.updatedAtRemote}');
        } else {
          _logger.debug('Skipped sentence $remoteId (local copy is newer)');
        }
      }
    });
  }

  Future<void> _syncHighlights(NotionApi api, String databaseId) async {
    final pages = await api.queryDatabase(databaseId);
    _logger.info('Fetched ${pages.length} highlight pages from Notion');
    if (pages.isEmpty) return;
    await _isar.writeTxn(() async {
      for (final page in pages) {
        _logJson('Raw highlight page', page);
        final remote = Highlight.fromNotion(page);
        _logger.debug(
            'Remote highlight parsed: id=${remote.notionPageId}, sentenceKey=${remote.sentenceExternalKey}, sentenceNotionId=${remote.sentenceNotionPageId}, range=(${remote.start}, ${remote.end}), color=${remote.color}');
        final remoteId = remote.notionPageId;
        if (remoteId == null) {
          _logger.warn('Skipped highlight with null Notion page id');
          continue;
        }
        final sentenceKey = remote.sentenceExternalKey;
        _logger.debug(
            'Highlight $remoteId references sentence external key $sentenceKey');
        if (sentenceKey == null || sentenceKey.isEmpty) {
          _logger.error(
              'Highlight $remoteId missing SentenceExternalKey. Cannot link to local sentence.');
          continue;
        }
        final sentence =
            await _isar.sentences.getByExternalKey(sentenceKey);
        if (sentence == null) {
          _logger.error(
              'Highlight $remoteId references sentence external key $sentenceKey but local sentence not found.');
          continue;
        }
        remote
          ..sentenceLocalId = sentence.id
          ..sentenceExternalKey = sentence.externalKey
          ..sentenceNotionPageId = sentence.notionPageId
          ..updatedAtLocal = DateTime.now();
        final existing = await _isar.highlights.getByNotionPageId(remoteId);
        if (existing == null) {
          await _isar.highlights.put(remote);
          _logger.info(
              'Inserted highlight $remoteId range=(${remote.start}, ${remote.end}) color=${remote.color}');
        } else if (_remoteWins(
          remoteUpdated: remote.updatedAtRemote,
          localUpdated: existing.updatedAtLocal,
        )) {
          existing
            ..start = remote.start
            ..end = remote.end
            ..color = remote.color
            ..note = remote.note
            ..sentenceLocalId = sentence.id
            ..sentenceNotionPageId = sentence.notionPageId
            ..sentenceExternalKey = sentence.externalKey
            ..updatedAtRemote = remote.updatedAtRemote
            ..updatedAtLocal = DateTime.now();
          await _isar.highlights.put(existing);
          _logger.info(
              'Updated highlight $remoteId range=(${remote.start}, ${remote.end}) color=${remote.color}');
        } else {
          _logger.debug('Skipped highlight $remoteId (local copy is newer)');
        }
      }
    });
  }

  Future<void> _syncPrefs(NotionApi api, String databaseId) async {
    final pages = await api.queryDatabase(databaseId);
    _logger.info('Fetched ${pages.length} preference pages from Notion');
    if (pages.isEmpty) return;
    pages.sort((a, b) {
      final da = DateTime.tryParse('${a['last_edited_time'] ?? ''}') ??
          DateTime.fromMillisecondsSinceEpoch(0);
      final db = DateTime.tryParse('${b['last_edited_time'] ?? ''}') ??
          DateTime.fromMillisecondsSinceEpoch(0);
      return db.compareTo(da);
    });
    Map<String, dynamic>? target;
    for (final page in pages) {
      final key = readTextProperty(
              (page['properties'] as Map<String, dynamic>?)
                  ?['ExternalKey'] as Map<String, dynamic>?) ??
          '';
      if (key == ReadingPrefs.defaultExternalKey) {
        target = page;
        break;
      }
    }
    final remote =
        ReadingPrefs.fromNotion(target ?? pages.first)..updatedAtLocal = DateTime.now();
    remote.ensureExternalKey();

    await _isar.writeTxn(() async {
      final existing = await _isar.readingPrefs.get(1);
      if (existing == null) {
        await _isar.readingPrefs.put(remote);
        _logger.info(
            'Inserted reading prefs theme=${remote.theme} fontSize=${remote.fontSize}');
      } else if (_remoteWins(
        remoteUpdated: remote.updatedAtRemote,
        localUpdated: existing.updatedAtLocal,
      )) {
        existing
          ..notionPageId = remote.notionPageId ?? existing.notionPageId
          ..externalKey = remote.externalKey
          ..theme = remote.theme
          ..fontSize = remote.fontSize
          ..lineHeight = remote.lineHeight
          ..paragraphSpacing = remote.paragraphSpacing
          ..filterState = remote.filterState
          ..scrollOffsetAll = remote.scrollOffsetAll
          ..scrollOffsetFamiliar = remote.scrollOffsetFamiliar
          ..scrollOffsetUnfamiliar = remote.scrollOffsetUnfamiliar
          ..scrollOffsetNeutral = remote.scrollOffsetNeutral
          ..updatedAtRemote = remote.updatedAtRemote
          ..updatedAtLocal = DateTime.now();
        await _isar.readingPrefs.put(existing);
        _logger.info(
            'Updated reading prefs theme=${remote.theme} fontSize=${remote.fontSize}');
      } else {
        _logger.debug('Skipped reading prefs (local copy is newer)');
        if (existing.externalKey.isEmpty) {
          existing.externalKey = ReadingPrefs.defaultExternalKey;
          await _isar.readingPrefs.put(existing);
        }
      }
    });
  }

  bool _remoteWins({
    DateTime? remoteUpdated,
    DateTime? localUpdated,
    DateTime? remoteCreated,
    DateTime? localCreated,
  }) {
    final epoch = DateTime.fromMillisecondsSinceEpoch(0);
    final remoteTime = remoteUpdated ?? remoteCreated ?? epoch;
    final localTime = localUpdated ?? localCreated ?? epoch;
    return remoteTime.isAfter(localTime);
  }

  void _logJson(String label, Map<String, dynamic> page) {
    _logger.debug(label, data: page);
  }
}
