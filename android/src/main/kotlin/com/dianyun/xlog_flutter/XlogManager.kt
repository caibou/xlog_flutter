package com.dianyun.xlog_flutter

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
        mode: XlogMode,
        logFileName: String,
        logMaxSize: Long,
        logDir: String,
        cacheDir: String,
        cacheDay: Int,
        callback: (Result<Unit>) -> Unit
    ) {

        mXLog = Xlog().apply {
            appenderOpen(
                if (mode == XlogMode.DEBUG) Xlog.LEVEL_DEBUG else Xlog.LEVEL_INFO,
                Xlog.AppednerModeAsync, cacheDir, logDir, logFileName, cacheDay
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

}
