# Add project specific ProGuard rules here.
# By default, the flags in this file are appended to flags specified
# in /usr/local/Cellar/android-sdk/24.3.3/tools/proguard/proguard-android.txt
# You can edit the include path and order by changing the proguardFiles
# directive in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# Add any project specific keep options here:

# Si tu proyecto utiliza WebView con JS, descomenta y ajusta la siguiente línea:
# Reemplaza com.example.myapp.WebAppInterface con el nombre completo de tu clase de interfaz JavaScript.
#-keepclassmembers class com.example.myapp.WebAppInterface {
#  public *;
#}

# Descomenta esta línea para conservar la información de número de línea para las trazas de pila de depuración.
-keepattributes SourceFile,LineNumberTable

# Si conservas la información del número de línea, descomenta esto para ocultar el nombre del archivo fuente original.
# -renamesourcefileattribute SourceFile

# Reglas básicas de Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Reglas para Firebase (Ajusta según tus dependencias de Firebase)
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Ejemplos de reglas para otras dependencias (Ajusta según tus dependencias)
-keep class com.squareup.okhttp3.** { *; } # OkHttp
-keep class retrofit2.** { *; } # Retrofit
-keep class com.google.gson.** { *; } # Gson
-keep class org.greenrobot.eventbus.** { *; } # EventBus
-keep class com.airbnb.lottie.** { *; } # Lottie

-ignorewarnings
-keepattributes *Annotation*
-keepattributes Exceptions
-keepattributes InnerClasses
-keepattributes Signature
-keep class com.huawei.hianalytics.**{*;}
-keep class com.huawei.updatesdk.**{*;}
-keep class com.huawei.hms.**{*;}