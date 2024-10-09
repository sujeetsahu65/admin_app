# Keep flutter background service classes
-keep class id.flutter.flutter_background_service.** { *; }

# Keep flutter local notifications classes
-keep class com.dexterous.flutterlocalnotifications.** { *; }

# Keep all your app's models, services, and other important classes
-keep class com.example.admin_app.** { *; }

# Keep annotations
-keepattributes *Annotation*

# Prevent stripping of the main activity
-keep class com.example.admin_app.MainActivity { *; }
