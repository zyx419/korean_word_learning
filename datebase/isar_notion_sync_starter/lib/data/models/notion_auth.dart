import 'package:isar/isar.dart';

part 'notion_auth.g.dart';

@collection
class NotionAuth {
  Id id = 1;
  String token = '';
  String status = 'untested'; // untested|success|error
  DateTime? testedAt;
  String? errorMessage;
}
