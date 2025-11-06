import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:isar_notion_sync_starter/data/models/highlight.dart';
import 'package:isar_notion_sync_starter/data/models/notion_auth.dart';
import 'package:isar_notion_sync_starter/data/models/notion_binding.dart';
import 'package:isar_notion_sync_starter/data/models/reading_prefs.dart';
import 'package:isar_notion_sync_starter/data/models/sentence.dart';
import 'package:isar_notion_sync_starter/data/remote/notion_api.dart';

/// Background puller that fetches the latest Notion data on app start.
class NotionPullService {
  NotionPullService(this._isar);
  final Isar _isar;

  /// Pull sentences/highlights/prefs from Notion and upsert into Isar.
  Future<void> pullAll() async {
    final auth = await _isar.notionAuths.get(1);
    if (auth == null || auth.token.isEmpty) {
      return;
    }

    final bindings = await _isar.notionDatabaseBindings.getAll([1, 2, 3]);
    final sentencesDb = bindings[0];
    final highlightsDb = bindings[1];
    final prefsDb = bindings[2];
    if ((sentencesDb?.databaseId.isEmpty ?? true) &&
        (highlightsDb?.databaseId.isEmpty ?? true) &&
        (prefsDb?.databaseId.isEmpty ?? true)) {
      return;
    }

    final api = NotionApi(auth.token);
    try {
      if (sentencesDb != null && sentencesDb.databaseId.isNotEmpty) {
        await _syncSentences(api, sentencesDb.databaseId);
      }
      if (highlightsDb != null && highlightsDb.databaseId.isNotEmpty) {
        await _syncHighlights(api, highlightsDb.databaseId);
      }
      if (prefsDb != null && prefsDb.databaseId.isNotEmpty) {
        await _syncPrefs(api, prefsDb.databaseId);
      }
    } catch (e, st) {
      if (kDebugMode) {
        debugPrint('Notion pull error: $e');
        debugPrint('$st');
      }
    }
  }

  Future<void> _syncSentences(NotionApi api, String databaseId) async {
    final pages = await api.queryDatabase(databaseId);
    if (pages.isEmpty) return;
    await _isar.writeTxn(() async {
      for (final page in pages) {
        final remote = Sentence.fromNotion(page);
        final remoteId = remote.notionPageId;
        if (remoteId == null) continue;
        remote.updatedAtLocal = DateTime.now();
        final existing = await _isar.sentences.getByNotionPageId(remoteId);
        if (existing == null) {
          await _isar.sentences.put(remote);
        } else if (_newer(remote.updatedAtRemote, existing.updatedAtRemote)) {
          existing
            ..text = remote.text
            ..familiarState = remote.familiarState
            ..updatedAtRemote = remote.updatedAtRemote
            ..updatedAtLocal = DateTime.now()
            ..deletedAt = null;
          await _isar.sentences.put(existing);
        }
      }
    });
  }

  Future<void> _syncHighlights(NotionApi api, String databaseId) async {
    final pages = await api.queryDatabase(databaseId);
    if (pages.isEmpty) return;
    await _isar.writeTxn(() async {
      for (final page in pages) {
        final remote = Highlight.fromNotion(page);
        final remoteId = remote.notionPageId;
        if (remoteId == null) continue;
        final sentenceLocalId =
            await _resolveSentenceLocalId(remote.sentenceNotionPageId);
        if (sentenceLocalId == null) continue;
        remote
          ..sentenceLocalId = sentenceLocalId
          ..updatedAtLocal = DateTime.now();
        final existing = await _isar.highlights.getByNotionPageId(remoteId);
        if (existing == null) {
          await _isar.highlights.put(remote);
        } else if (_newer(remote.updatedAtRemote, existing.updatedAtRemote)) {
          existing
            ..start = remote.start
            ..end = remote.end
            ..color = remote.color
            ..note = remote.note
            ..sentenceLocalId = sentenceLocalId
            ..sentenceNotionPageId = remote.sentenceNotionPageId
            ..updatedAtRemote = remote.updatedAtRemote
            ..updatedAtLocal = DateTime.now();
          await _isar.highlights.put(existing);
        }
      }
    });
  }

  Future<void> _syncPrefs(NotionApi api, String databaseId) async {
    final pages = await api.queryDatabase(databaseId);
    if (pages.isEmpty) return;
    pages.sort((a, b) {
      final da = DateTime.tryParse('${a['last_edited_time'] ?? ''}') ??
          DateTime.fromMillisecondsSinceEpoch(0);
      final db = DateTime.tryParse('${b['last_edited_time'] ?? ''}') ??
          DateTime.fromMillisecondsSinceEpoch(0);
      return db.compareTo(da);
    });
    final remote = ReadingPrefs.fromNotion(pages.first)
      ..updatedAtLocal = DateTime.now();

    await _isar.writeTxn(() async {
      final existing = await _isar.readingPrefs.get(1);
      if (existing == null) {
        await _isar.readingPrefs.put(remote);
      } else if (_newer(remote.updatedAtRemote, existing.updatedAtRemote)) {
        existing
          ..theme = remote.theme
          ..fontSize = remote.fontSize
          ..lineHeight = remote.lineHeight
          ..paragraphSpacing = remote.paragraphSpacing
          ..updatedAtRemote = remote.updatedAtRemote
          ..updatedAtLocal = DateTime.now();
        await _isar.readingPrefs.put(existing);
      }
    });
  }

  Future<int?> _resolveSentenceLocalId(String? remoteId) async {
    if (remoteId == null) return null;
    final sentence = await _isar.sentences.getByNotionPageId(remoteId);
    return sentence?.id;
  }

  bool _newer(DateTime? remote, DateTime? current) {
    final remoteTime = remote ?? DateTime.fromMillisecondsSinceEpoch(0);
    final currentTime = current ?? DateTime.fromMillisecondsSinceEpoch(0);
    return remoteTime.isAfter(currentTime);
  }
}
