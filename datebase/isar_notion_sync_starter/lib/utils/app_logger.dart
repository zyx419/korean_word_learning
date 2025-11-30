import 'dart:async';
import 'dart:io';

import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

/// Simple logger that mirrors messages to console and to a persistent log file.
/// 
/// Features:
/// - Logs to both console and file
/// - Automatic log file rotation when size exceeds limit
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

  /// Maximum log file size before rotation (10MB)
  static const int _maxLogFileSizeBytes = 10 * 1024 * 1024;

  late final Logger _logger;
  final Completer<File> _logFileCompleter = Completer<File>();
  Future<void> _writeLock = Future<void>.value();

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

  /// Rotates the log file if it exceeds the maximum size.
  /// 
  /// The current log file is renamed to `.1` suffix, and a new log file is created.
  Future<void> _rotateLogIfNeeded(File file) async {
    try {
      final length = await file.length();
      if (length < _maxLogFileSizeBytes) {
        return;
      }

      final rotatedPath = '${file.path}.1';
      final rotatedFile = File(rotatedPath);
      
      // Delete old rotated file if it exists
      if (await rotatedFile.exists()) {
        await rotatedFile.delete();
      }
      
      // Rename current log file to rotated file
      await file.rename(rotatedPath);
      
      // Create new log file
      await file.create();
    } catch (e) {
      // Swallow rotation errors to keep app running
      // Log rotation failure should not break the application
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
      // Wait for any ongoing write to complete
      await _writeLock;
      
      // Create a new lock for this write operation
      final lockCompleter = Completer<void>();
      _writeLock = lockCompleter.future;
      
      try {
        // Check and rotate log file if needed
        await _rotateLogIfNeeded(file);
        
        final timestamp = DateTime.now().toIso8601String();
        final line = '[$timestamp] [${level.name}] $message'
            '${data == null ? '' : ' | data=$data'}'
            '${stackTrace == null ? '' : '\n$stackTrace'}\n';
        await file.writeAsString(line, mode: FileMode.append, flush: true);
      } catch (_) {
        // Swallow errors writing to log file to keep app running.
      } finally {
        // Release the lock
        lockCompleter.complete();
      }
    }).catchError((_) {
      // Swallow errors writing to log file to keep app running.
    });
  }
}
