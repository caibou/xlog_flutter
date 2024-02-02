package com.jitian.xlog_flutter

import XlogMode
import android.content.Context
import com.tencent.mars.xlog.Log
import com.tencent.mars.xlog.Xlog
import java.io.File

class XlogManager private constructor() {
    companion object {
        private object Holder {
            val instance = XlogManager()
        }

        fun getInstance() = Holder.instance
    }

    private lateinit var mXLog: Xlog


    // 加载 Xlog 所需的库
    fun loadXLogLib() {
        System.loadLibrary("c++_shared")
        System.loadLibrary("marsxlog")
    }

    fun initXLog(
        context: Context,
        mode: XlogMode,
        logFileName: String,
        logMaxSize: Long,
        callback: (Result<Unit>) -> Unit
    ) {
        val logFolder = fetchLogParentFolder(context)
        val logPath = "${logFolder}/${XlogVarDefine.xLogFolderName}"
        val cachePath = "${logFolder}/${XlogVarDefine.cacheLogFolderName}"
        mXLog = Xlog().apply {
            appenderOpen(
                if (mode == XlogMode.DEBUG) Xlog.LEVEL_DEBUG else Xlog.LEVEL_INFO,
                Xlog.AppednerModeAsync, cachePath, logPath, logFileName, 0
            )
            setMaxFileSize(0, logMaxSize)
            setConsoleLogOpen(0, mode == XlogMode.DEBUG)
        }
        Log.setLogImp(mXLog)
        callback(Result.success(Unit))
    }

    // 获取 Xlog 实例，如果未初始化则抛出异常
    fun getXLog(): Xlog = if (::mXLog.isInitialized) {
        mXLog
    } else {
        throw IllegalStateException("Xlog has not been initialized yet.")
    }

    private fun fetchLogParentFolder(context: Context): String {
        return createIfNotExists(context.filesDir.absolutePath, XlogVarDefine.logParentFolder)
    }

    fun fetchLogStorageFolder(context: Context): String {
        return createIfNotExists(
            fetchLogParentFolder(context), XlogVarDefine.xLogFolderName
        )
    }

    private fun createIfNotExists(parent: String, folderName: String): String {
        val marsXLogDir = File(parent, folderName)
        return marsXLogDir.apply { if (!exists()) mkdirs() }.absolutePath
    }


}
