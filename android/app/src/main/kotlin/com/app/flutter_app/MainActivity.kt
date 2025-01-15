package com.app.flutter_app

//import android.content.Context

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
//import android.os.Bundle

//import io.flutter.app.FlutterActivity
//import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodChannel




class MainActivity: FlutterActivity() {

  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    GeneratedPluginRegistrant.registerWith(flutterEngine)
    MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "MyNativeChannel")
            .setMethodCallHandler { call, result ->
           val param = call.arguments as Map<String, String>
      if (call.method == "getData") {
        print("call");
        result.success(PasswordEncoder.encode(param.get("input")));
      } else {
        result.notImplemented()
      }
      }

      MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "DownloadChannel").setMethodCallHandler{ call, result ->
      val param = call.arguments as Map<String,String>
      if (call.method == "download") {
        print("calling download");
        result.success(DownloadPDF.download(param.get("input"),applicationContext));
      } else {
        result.notImplemented()
      }
      
    }

  }
  // override fun onCreate(savedInstanceState: Bundle?) {
  //   super.onCreate(savedInstanceState)
  //   GeneratedPluginRegistrant.registerWith(this)


  //   MethodChannel(flutterView, "MyNativeChannel").setMethodCallHandler { call, result ->

  //     val param = call.arguments as Map<String, String>
  //     if (call.method == "getData") {
  //       print("call");
  //       result.success(PasswordEncoder.encode(param.get("input")));
  //     } else {
  //       result.notImplemented()
  //     }
  //   }
  //   MethodChannel(flutterView, "DownloadChannel").setMethodCallHandler { call, result ->

  //     val param = call.arguments as Map<String,String>
  //     if (call.method == "download") {
  //       print("calling download");
  //       result.success(DownloadPDF.download(param.get("input"),applicationContext));
  //     } else {
  //       result.notImplemented()
  //     }
  //   }

  // }


}
