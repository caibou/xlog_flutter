import 'dart:async';
import 'xlog_flutter_api.g.dart';

class XlogFlutter {
  static final XlogFlutterApi api = XlogFlutterApi();

  static const int _kMaxXLogFileSize = 1024 * 1024 * 1;
  static const bool deBugMode = false;

  static Future init(
          {XlogMode mode = XlogMode.debug,
          String fileName = 'xlogFlutter',
          int maxLogFileSize = _kMaxXLogFileSize}) =>
      api.init(mode: mode, logFileName: fileName, logMaxSize: maxLogFileSize);

  static Future print(
          {String tag = '',
          LogLevel level = LogLevel.info,
          required String message}) =>
      api.print(tag: tag, level: level, message: message);

  static Future<String?> getLogFilePath() => api.getLogFilePath();
  
  static Future<String?> getLogFolderPath() => api.getLogFolderPath();

  static Future flush() => api.flush();
}
