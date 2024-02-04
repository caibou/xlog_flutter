package com.dianyun.xlog_flutter

import LogLevel
import XlogFlutterApi
import XlogMode
import android.content.Context
import android.os.Looper
import android.os.Process
import com.tencent.mars.xlog.Xlog
import java.io.File
import java.util.Arrays

class XlogFlutterApiImpl : XlogFlutterApi {

    init {
        XlogManager.getInstance().loadXLogLib();
    }


    override fun init(
        mode: XlogMode,
        logFileName: String,
        logMaxSize: Long,
        logDir: String,
        cacheDir: String,
        cacheDay: Long,
        callback: (Result<Unit>) -> Unit
    ) {
        XlogManager.getInstance()
            .initXLog(mode, logFileName, logMaxSize, logDir, cacheDir, cacheDay.toInt(), callback)
    }

    override fun print(
        tag: String,
        level: LogLevel,
        message: String,
        fileName: String,
        funcName: String,
        lineNumber: Long,
        callback: (Result<Unit>) -> Unit
    ) {
        val logLevel = when (level) {
            LogLevel.DEBUG -> Xlog.LEVEL_DEBUG
            LogLevel.FATAL -> Xlog.LEVEL_FATAL
            LogLevel.ERROR -> Xlog.LEVEL_ERROR
            LogLevel.WARNING -> Xlog.LEVEL_WARNING
            LogLevel.INFO -> Xlog.LEVEL_INFO
            LogLevel.VERBOSE -> Xlog.LEVEL_VERBOSE
            else -> Xlog.LEVEL_ALL
        }
        val pid = Process.myPid()
        val threadId = Thread.currentThread().id
        val mainThreadId = Looper.getMainLooper().thread.id
        Xlog.logWrite2(
            logLevel,
            tag,
            fileName,
            funcName,
            lineNumber.toInt(),
            pid,
            threadId,
            mainThreadId,
            message
        )
        callback(Result.success(Unit))

    }

    override fun flush(callback: (Result<Unit>) -> Unit) {
        XlogManager.getInstance().getXLog().appenderFlush(0, true)
        callback(Result.success(Unit))
    }


}