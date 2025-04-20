# Prevent R8 from stripping Google Tink & annotations
-keep class com.google.crypto.tink.** { *; }
-keep class com.google.errorprone.annotations.** { *; }
-keep class javax.annotation.** { *; }
-keep class javax.annotation.concurrent.** { *; }

-dontwarn com.google.errorprone.annotations.**
-dontwarn javax.annotation.**
-dontwarn javax.annotation.concurrent.**
# Keep Joda-Time and Joda-Convert classes
-keep class org.joda.time.** { *; }
-keep class org.joda.convert.** { *; }
-dontwarn org.joda.convert.**
