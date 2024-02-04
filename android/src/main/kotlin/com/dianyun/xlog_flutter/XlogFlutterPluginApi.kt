// Autogenerated from Pigeon (v14.0.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon


import android.util.Log
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MessageCodec
import io.flutter.plugin.common.StandardMessageCodec
import java.io.ByteArrayOutputStream
import java.nio.ByteBuffer

private fun wrapResult(result: Any?): List<Any?> {
  return listOf(result)
}

private fun wrapError(exception: Throwable): List<Any?> {
  if (exception is FlutterError) {
    return listOf(
      exception.code,
      exception.message,
      exception.details
    )
  } else {
    return listOf(
      exception.javaClass.simpleName,
      exception.toString(),
      "Cause: " + exception.cause + ", Stacktrace: " + Log.getStackTraceString(exception)
    )
  }
}

/**
 * Error class for passing custom error details to Flutter via a thrown PlatformException.
 * @property code The error code.
 * @property message The error message.
 * @property details The error details. Must be a datatype supported by the api codec.
 */
class FlutterError (
  val code: String,
  override val message: String? = null,
  val details: Any? = null
) : Throwable()

enum class LogLevel(val raw: Int) {
  NONE(0),
  FATAL(1),
  ERROR(2),
  WARNING(3),
  INFO(4),
  DEBUG(5),
  VERBOSE(6);

  companion object {
    fun ofRaw(raw: Int): LogLevel? {
      return values().firstOrNull { it.raw == raw }
    }
  }
}

enum class XlogMode(val raw: Int) {
  DEBUG(0),
  RELEASE(1);

  companion object {
    fun ofRaw(raw: Int): XlogMode? {
      return values().firstOrNull { it.raw == raw }
    }
  }
}

/** Generated interface from Pigeon that represents a handler of messages from Flutter. */
interface XlogFlutterApi {
  fun init(mode: XlogMode, logFileName: String, logMaxSize: Long, logDir: String, cacheDir: String, cacheDay: Long, callback: (Result<Unit>) -> Unit)
  fun print(tag: String, level: LogLevel, message: String, fileName: String, funcName: String, lineNumber: Long, callback: (Result<Unit>) -> Unit)
  fun flush(callback: (Result<Unit>) -> Unit)

  companion object {
    /** The codec used by XlogFlutterApi. */
    val codec: MessageCodec<Any?> by lazy {
      StandardMessageCodec()
    }
    /** Sets up an instance of `XlogFlutterApi` to handle messages through the `binaryMessenger`. */
    @Suppress("UNCHECKED_CAST")
    fun setUp(binaryMessenger: BinaryMessenger, api: XlogFlutterApi?) {
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.xlog_flutter.XlogFlutterApi.init", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val modeArg = XlogMode.ofRaw(args[0] as Int)!!
            val logFileNameArg = args[1] as String
            val logMaxSizeArg = args[2].let { if (it is Int) it.toLong() else it as Long }
            val logDirArg = args[3] as String
            val cacheDirArg = args[4] as String
            val cacheDayArg = args[5].let { if (it is Int) it.toLong() else it as Long }
            api.init(modeArg, logFileNameArg, logMaxSizeArg, logDirArg, cacheDirArg, cacheDayArg) { result: Result<Unit> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                reply.reply(wrapResult(null))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.xlog_flutter.XlogFlutterApi.print", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val tagArg = args[0] as String
            val levelArg = LogLevel.ofRaw(args[1] as Int)!!
            val messageArg = args[2] as String
            val fileNameArg = args[3] as String
            val funcNameArg = args[4] as String
            val lineNumberArg = args[5].let { if (it is Int) it.toLong() else it as Long }
            api.print(tagArg, levelArg, messageArg, fileNameArg, funcNameArg, lineNumberArg) { result: Result<Unit> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                reply.reply(wrapResult(null))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.xlog_flutter.XlogFlutterApi.flush", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            api.flush() { result: Result<Unit> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                reply.reply(wrapResult(null))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
    }
  }
}
