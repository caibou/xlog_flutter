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

class XlogFlutterApiImpl constructor(
    private val mContext: Context
) : XlogFlutterApi {

    init {
        XlogManager.getInstance().loadXLogLib();
    }


    override fun init(
        mode: XlogMode, logFileName: String, logMaxSize: Long, callback: (Result<Unit>) -> Unit
    ) {
        XlogManager.getInstance().initXLog(mContext, mode, logFileName, logMaxSize, callback)
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


    override fun getLogFolderPath(callback: (Result<String>) -> Unit) {
        callback(Result.success(XlogManager.getInstance().fetchLogStorageFolder(mContext)))
    }


    override fun getLogFilePath(callback: (Result<String>) -> Unit) {
        val logFolder = XlogManager.getInstance().fetchLogStorageFolder(mContext)
        val folder = File(logFolder)
        if (!folder.exists()) {
            return callback(Result.success(""))
        }
        val files = folder.listFiles()
        Arrays.sort(files, LastModifiedComparator())
        val filePath = folder.listFiles()?.maxByOrNull { it.lastModified() }
        callback(Result.success(filePath?.absolutePath ?: ""))
    }

    override fun flush(callback: (Result<Unit>) -> Unit) {
        XlogManager.getInstance().getXLog().appenderFlush(0, true)
        callback(Result.success(Unit))
    }


}