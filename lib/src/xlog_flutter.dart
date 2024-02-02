import 'dart:async';
import 'package:flutter/foundation.dart';
import 'xlog_flutter_api.g.dart';
import 'package:stack_trace/stack_trace.dart';

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
      required String message}) {
    String fileName = '';
    String funcName = '';
    int lineNumber = 0;

    var chain = Chain.current();

    chain =
        chain.foldFrames((frame) => frame.isCore || frame.package == "flutter");
    final frames = chain.toTrace().frames;

    final idx =
        frames.indexWhere((element) => element.member == "XlogFlutter.print");
    if (!(idx == -1 || idx + 1 >= frames.length)) {
      final frame = frames[idx + 1];
      fileName = frame.library;
      funcName = frame.member ?? '';
      lineNumber = frame.line ?? 0;
    }

    return api.print(
        tag: tag,
        level: level,
        message: message,
        fileName: fileName,
        funcName: funcName,
        lineNumber: lineNumber);
  }

  static Future<String?> getLogFilePath() => api.getLogFilePath();

  static Future<String?> getLogFolderPath() => api.getLogFolderPath();

  static Future flush() => api.flush();
}
