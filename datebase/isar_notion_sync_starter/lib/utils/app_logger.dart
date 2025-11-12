import 'dart:async';
import 'dart:io';

import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

/// Simple logger that mirrors messages to console and to a persistent log file.
class AppLogger {
  AppLogger._internal() {
    _logger = Logger(
      filter: DevelopmentFilter(),
      level: Level.debug,
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 8,
        lineLength: 80,
        dateTimeFormat: DateTimeFormat.dateAndTime,
      ),
    );
    _prepareLogFile();
  }

  static final AppLogger instance = AppLogger._internal();

  late final Logger _logger;
  final Completer<File> _logFileCompleter = Completer<File>();

  /// Public logging helpers
  void debug(String message, {Object? data}) =>
      _log(Level.debug, message, data: data);
  void info(String message, {Object? data}) =>
      _log(Level.info, message, data: data);
  void warn(String message, {Object? data}) =>
      _log(Level.warning, message, data: data);
  void error(String message,
      {Object? error, StackTrace? stackTrace, Object? data}) {
    final detail = error == null ? message : '$message | error: $error';
    _log(Level.error, detail, stackTrace: stackTrace, data: data);
  }

  Future<File> get _logFile => _logFileCompleter.future;

  Future<void> _prepareLogFile() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/notion_sync.log');
      if (!await file.exists()) {
        await file.create(recursive: true);
      }
      _logFileCompleter.complete(file);
    } catch (e) {
      _logFileCompleter.completeError(e);
    }
  }

  void _log(Level level, String message,
      {StackTrace? stackTrace, Object? data}) {
    if (data != null) {
      _logger.log(level, '$message | data=$data', stackTrace: stackTrace);
    } else {
      _logger.log(level, message, stackTrace: stackTrace);
    }

    _logFile.then((file) async {
      final timestamp = DateTime.now().toIso8601String();
      final line = '[$timestamp] [${level.name}] $message'
          '${data == null ? '' : ' | data=$data'}'
          '${stackTrace == null ? '' : '\n$stackTrace'}\n';
      await file.writeAsString(line, mode: FileMode.append, flush: true);
    }).catchError((_) {
      // Swallow errors writing to log file to keep app running.
    });
  }
}
