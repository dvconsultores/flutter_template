package com.example.prod

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.embedding.engine.FlutterEngine
import androidx.annotation.NonNull;
// import android.content.Intent
// import android.net.Uri
// import android.os.Bundle

class MainActivity: FlutterFragmentActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
    }

    //? 🖊️ App linking 🖊️
    // override fun onCreate(savedInstanceState: Bundle?) {
    //     super.onCreate(savedInstanceState)

    //     // playstore deep link setting
    //     val intent = Intent(Intent.ACTION_VIEW).apply {
    //         data = Uri.parse("https://play.google.com/store/apps/details?id=com.example.prod")
    //         setPackage("com.android.vending")
    //     }

    //     startActivity(intent)
    // }
}
