# Add project specific ProGuard rules here.
# By default, the flags in this file are appended to flags specified
# in C:\Work\Android\AndroidSDK/tools/proguard/proguard-android.txt
# You can edit the include path and order by changing the proguardFiles
# directive in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# Add any project specific keep options here:

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}
-dontwarn com.fingerprint.recognization.**
#enum类的特殊性，以下两个方法会被反射调用
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}
-keep enum com.fingerprint.recognization.FingerprintRecognize{*;}
-keep class com.fingerprint.recognization.util.FingerResultCode{*;}