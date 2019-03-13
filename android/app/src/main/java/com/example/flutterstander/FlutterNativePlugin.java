package com.example.flutterstander;

import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageInfo;
import android.text.TextUtils;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;


/**
 * FlutterNativePlugin
 */
public class FlutterNativePlugin implements MethodChannel.MethodCallHandler {
    public static String CHANNEL = "com.example.flutterstander/flutter_native_plugin";
    private MainActivity mainActivity;

    private FlutterNativePlugin(Activity activity) {
        mainActivity = (MainActivity) activity;
    }

    /**
     * Plugin registration.
     */
    public static void registerWith(PluginRegistry.Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), CHANNEL);
        channel.setMethodCallHandler(new FlutterNativePlugin(registrar.activity()));
    }

    @Override
    public void onMethodCall(MethodCall call, final MethodChannel.Result result) {
      if (call.method.equals("getversion")) {
            result.success(CommonUtil.getVersionCode(mainActivity));
      }
    }




}
