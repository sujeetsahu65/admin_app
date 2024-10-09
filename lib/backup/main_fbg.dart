// import 'package:admin_app/constants/global_variables.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:admin_app/models/order_model.dart';
import 'package:admin_app/pages/auth/services/language.dart';
import 'package:admin_app/pages/auth/services/version.dart';
import 'package:admin_app/pages/home/services/audio.dart';
import 'package:admin_app/providers/language.dart';
// import 'package:admin_app/providers/error_handler.dart';
import 'package:admin_app/providers/printer.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin_app/router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:google_fonts/google_fonts.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Needed for background execution
  // await FlutterBackground.initialize(); // Initialize background execution
await initializeService();
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Europe/Helsinki'));
  // FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);

  runApp(ProviderScope(child: MyApp()));
}


// this will be used as notification channel id
const notificationChannelId = 'my_foreground';

// this will be used for notification id, So you can update your custom notification with this id.
const notificationId = 888;

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    notificationChannelId, // id
    'MY FOREGROUND SERVICE', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.low, // importance must be at low or higher level
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    iosConfiguration: IosConfiguration(),
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,

      notificationChannelId: notificationChannelId, // this must match with notification channel you created above.
      initialNotificationTitle: 'AWESOME SERVICE',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: notificationId,
    ));
}


// Mark the onStart function with the pragma to prevent it from being tree-shaken
@pragma('vm:entry-point')
Future<void> onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  Timer.periodic(const Duration(seconds: 30), (timer) async {
    // Fetch orders from your API
    var hasNewOrder = await fetchNewOrders();

    if (hasNewOrder) {
      // Play sound if there is a new order
      playAlertSound();

      // Update notification
      final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      flutterLocalNotificationsPlugin.show(
        notificationId,
        'New Order Alert',
        'You have a new order!',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            notificationChannelId,
            'MY FOREGROUND SERVICE',
            icon: 'ic_bg_service_small',
            ongoing: true,
          ),
        ),
      );
    }

    else{
      playAlertSound(mode: false);
    }
  });
}
void playAlertSound({mode=true}) {

  if(mode){

  AudioService().playAlarmSound(); // Add your sound file to assets
  }
  else{
     AudioService().stopAlarmSound();
  }
}

Future<bool> fetchNewOrders() async {
  print("ttttttttttt");
  // Call your API here
      final response = await http.get(
        Uri.parse('https://api.foozu3.fi/admin-app/order/new-orders'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJsb2dpbl9pZCI6MSwiY2xpZW50X2lkIjo2LCJyb2xlIjoiYWRtaW4iLCJsb2NfaWQiOjQyLCJpYXQiOjE3Mjc5NzYzNzl9.NAYNqoCIV7yGxPm3ckfXnjIHZ22hHlHvk8I-K_ggLPw',
          'lang-code': 'en',
        },
      );

print("stauscode"+response.statusCode.toString());
      if (response.statusCode == 200) {
         print("yeeeeeeee");
        // final List orderJson = json.decode(response.body)['data']['new_orders'];
        // // print(List);
        // state = orderJson.map((json) => json).toList();

        final List<dynamic> jsonList =
            json.decode(response.body)['data']['new_orders'];
        final data =  jsonList.map((json) => Order.fromJson(json)).toList();
  return true;
}
else if(response.statusCode == 404){
print("yessss33333");
  return false;
}
else{
     print("noooooooooo");
  return false;
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

  @override
  void initState() {
    super.initState();

  requestPermissions();
    // Keep the screen on when the app is open
    WakelockPlus.enable();
    checkAppUpdate(context);

    // ref.read(printerProvider.notifier).connectToStoredDevice();
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


Future<void> requestPermissions() async {
  // Request notification permission (Android 13+)
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }

  // Request wake lock permission (to prevent the device from sleeping)
  if (await Permission.ignoreBatteryOptimizations.isDenied) {
    await Permission.ignoreBatteryOptimizations.request();
  }

  // Request permission to run the service in the background
  if (await Permission.audio.isDenied) {
    await Permission.audio.request();
  }
}