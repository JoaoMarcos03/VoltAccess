package com.example.voltaccess

import io.flutter.app.FlutterApplication
import androidx.multidex.MultiDex
import android.content.Context

class MyApplication : FlutterApplication() {
    override fun attachBaseContext(base: Context) {
        super.attachBaseContext(base)
        MultiDex.install(this)
    }
}
