package com.dianyun.meet.xlog_flutter

import XlogFlutterApi
import androidx.annotation.NonNull
import com.dianyun.xlog_flutter.XlogFlutterApiImpl
import io.flutter.embedding.engine.plugins.FlutterPlugin

/** XlogFlutterPlugin */
class XlogFlutterPlugin : FlutterPlugin {
    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val mContext = flutterPluginBinding.applicationContext
        XlogFlutterApi.setUp(flutterPluginBinding.binaryMessenger, XlogFlutterApiImpl(mContext))
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        XlogFlutterApi.setUp(binding.binaryMessenger, null)
    }
}
