import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/src/xlog_flutter_api.g.dart',
  kotlinOptions: KotlinOptions(errorClassName: "XlogFlutterError"),
  kotlinOut:
      'android/src/main/kotlin/com/dianyun/xlog_flutter/XlogFlutterPluginApi.kt',
  objcSourceOut: 'ios/Classes/XlogFlutterPluginApi.g.m',
  objcHeaderOut: 'ios/Classes/XlogflutterPluginApi.g.h',

))
enum LogLevel { none, fatal, error, warning, info, debug, verbose }

enum XlogMode { debug, release }

@HostApi()
abstract class XlogFlutterApi {
  @async
  void init({
    required XlogMode mode,
    required String logFileName,
    required int logMaxSize,
    required String logDir,
    required String cacheDir,
    int cacheDay = 0,
  });



  @async
  void print(
      {required String tag,
      required LogLevel level,
      required String message,
      required String fileName,
      required String funcName,
      required int lineNumber});


  @async
  void flush();
}
