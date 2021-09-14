package com.waya.example

import androidx.annotation.NonNull;
import flutter.curiosity.CuriosityPlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.SplashScreen
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
    }

    override fun provideSplashScreen(): SplashScreen {
        return CuriosityPlugin.getIconSplashScreen(resources)
    }
}
