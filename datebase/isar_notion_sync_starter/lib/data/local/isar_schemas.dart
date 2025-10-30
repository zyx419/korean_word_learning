import 'package:isar/isar.dart';
import '../models/sentence.dart';
import '../models/highlight.dart';
import '../models/reading_prefs.dart';
import '../models/sync_queue_item.dart';
import '../models/notion_auth.dart';
import '../models/notion_binding.dart';

final allSchemas = <CollectionSchema>[
  SentenceSchema,
  HighlightSchema,
  ReadingPrefsSchema,
  SyncQueueItemSchema,
  NotionAuthSchema,
  NotionDatabaseBindingSchema,
];
