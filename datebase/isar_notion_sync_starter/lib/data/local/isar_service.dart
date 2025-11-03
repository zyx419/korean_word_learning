import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'isar_schemas.dart';

class IsarService {
  late final Isar isar;
  bool _inited = false;

  /// Open (or reuse) the Isar instance with all app schemas.
  ///
  /// Java analogy: similar to opening a Room/Realm database. We cache the
  /// instance and only open once. The path_provider gives the app documents dir.
  Future<void> init() async {
    if (_inited) return;
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(allSchemas, directory: dir.path, inspector: false);
    _inited = true;
  }
}
