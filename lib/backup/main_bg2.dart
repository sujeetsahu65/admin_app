// import 'package:admin_app/constants/global_variables.dart';
import 'package:admin_app/pages/auth/services/language.dart';
import 'package:admin_app/pages/auth/services/version.dart';
import 'package:admin_app/providers/language.dart';
// import 'package:admin_app/providers/error_handler.dart';
import 'package:admin_app/providers/printer.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_background/flutter_background.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin_app/router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:google_fonts/google_fonts.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'dart:async';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Needed for background execution
  // await FlutterBackground.initialize(); // Initialize background execution

  // Initialize port for communication between TaskHandler and UI.
  FlutterForegroundTask.initCommunicationPort();

  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Europe/Helsinki'));
  // FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);

  runApp(ProviderScope(child: MyApp()));
}

// The callback function should always be a top-level function.
@pragma('vm:entry-point')
void startCallback() {
  // The setTaskHandler function must be called to handle the task in the background.
  FlutterForegroundTask.setTaskHandler(MyTaskHandler());
}

class MyTaskHandler extends TaskHandler {
  // static const String incrementCountCommand = 'incrementCount';

  // int _count = 0;

  // void _incrementCount() {
  //   _count++;

  //   // Update notification content.
  //   FlutterForegroundTask.updateService(
  //     notificationTitle: 'Hello MyTaskHandler :)',
  //     notificationText: 'count: $_count',
  //   );

  //   // Send data to main isolate.
  //   FlutterForegroundTask.sendDataToMain(_count);
  // }

  // Called when the task is started.
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    print('onStart(starter: ${starter.name})');
    // _incrementCount();

    print('Foreground service started');
    FlutterForegroundTask.updateService(
      notificationTitle: 'Order Polling Service',
      notificationText: 'Polling new orders...',
    );
  }

  // Called by eventAction in [ForegroundTaskOptions].
  // - nothing() : Not use onRepeatEvent callback.
  // - once() : Call onRepeatEvent only once.
  // - repeat(interval) : Call onRepeatEvent at milliseconds interval.
  @override
  void onRepeatEvent(DateTime timestamp) {
    // _incrementCount();

    // Notify the foreground task to fetch new orders every 30 seconds
    FlutterForegroundTask.sendDataToMain('fetch_orders');
  }

  // Called when the task is destroyed.
  @override
  Future<void> onDestroy(DateTime timestamp) async {
    print('onDestroy');
  }

  // Called when data is sent using [FlutterForegroundTask.sendDataToTask].
  @override
  void onReceiveData(Object data) {
    print('onReceiveData: $data');
    // if (data == incrementCountCommand) {
    //   _incrementCount();
    // }
  }

  // Called when the notification button is pressed.
  @override
  void onNotificationButtonPressed(String id) {
    print('onNotificationButtonPressed: $id');
  }

  // Called when the notification itself is pressed.
  //
  // AOS: "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted
  // for this function to be called.
  @override
  void onNotificationPressed() {
    FlutterForegroundTask.launchApp('/');
    print('onNotificationPressed');
  }

  // Called when the notification itself is dismissed.
  //
  // AOS: only work Android 14+
  // iOS: only work iOS 10+
  @override
  void onNotificationDismissed() {
    print('onNotificationDismissed');
  }
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MyApp> createState() => _MyApp();
}

class _MyApp extends ConsumerState<MyApp> {
  static const appcastURL =
      'https://raw.githubusercontent.com/larryaasen/upgrader/master/test/testappcast.xml';

  Key _appKey = UniqueKey();

  Future<void> _requestPermissions() async {
    final NotificationPermission notificationPermission =
        await FlutterForegroundTask.checkNotificationPermission();
    if (notificationPermission != NotificationPermission.granted) {
      await FlutterForegroundTask.requestNotificationPermission();
    }

    if (Platform.isAndroid) {
      if (!await FlutterForegroundTask.canDrawOverlays) {
        await FlutterForegroundTask.openSystemAlertWindowSettings();
      }

      if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
        await FlutterForegroundTask.requestIgnoreBatteryOptimization();
      }
    }
  }

  void _initService() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'order_polling',
        channelName: 'Order Polling Service',
        channelDescription: 'Polls new orders in the background',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: false,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(30000), // 30 seconds
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  Future<void> _startService() async {
    await FlutterForegroundTask.startService(
      serviceId: 256,
      notificationTitle: 'Polling for new orders',
      notificationText: 'Foreground service is active',
      callback: startCallback,
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _requestPermissions();
      _initService();
      await _startService();
    });

    // Keep the screen on when the app is open
    WakelockPlus.enable();
    checkAppUpdate(context);

    ref.read(printerProvider.notifier).connectToStoredDevice();
    // final cachedLangCode = await cachedLanguageCode();

    ref.read(localizationProvider.notifier).setCachedLanguage();

    // You're correct that if the ref.listen is placed inside initState(), it will only set up the listener when the widget is first initialized. However, the listener itself will continue to respond to changes in the localizationProvider even after initState() is called, so it will still work when you change the language.
  }

  // Make sure to disable wakelock if required in certain cases (optional)
  @override
  void dispose() {
    // Disable the wakelock if you don't need it anymore (optional)
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final initializeLanguageContent =
    //   ref.watch(initializeLanguageContentProvider);
    final goRouter = ref.watch(goRouterProvider);
    final locale = ref.watch(localizationProvider);
    // Listen for language changes and trigger app rebuild
    ref.listen<Locale>(localizationProvider, (previous, next) {
      setState(() {
        print("the locale is listened");
        _appKey = UniqueKey(); // Update the key to rebuild the app
      });
    });

    return MaterialApp.router(
      key: _appKey,
      routerConfig: goRouter,
      locale: locale,
      supportedLocales: [
        Locale('en'),
        Locale('fi'),
        Locale('es'),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate, // Add this line
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      title: 'Admin app',
      theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(
        Theme.of(context).textTheme,
      )),
    );
  }
}
