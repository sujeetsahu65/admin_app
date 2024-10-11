import 'dart:async';
import 'dart:ui';
import 'package:admin_app/constants/global_variables.dart';
import 'package:admin_app/models/order_model.dart';
import 'package:admin_app/pages/auth/services/language.dart';
import 'package:admin_app/pages/auth/services/version.dart';
import 'package:admin_app/pages/home/services/audio.dart';
import 'package:admin_app/providers/error_handler.dart';
import 'package:admin_app/providers/language.dart';
import 'package:admin_app/providers/order.dart';
import 'package:admin_app/providers/printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin_app/router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:google_fonts/google_fonts.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Europe/Helsinki'));
  runApp(ProviderScope(child: MyApp()));
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    notificationChannelId,
    'MY FOREGROUND SERVICE',
    description: 'This channel is used for important notifications.',
    importance: Importance.low,
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
        onStart: onStart,
        autoStart: false,
        isForegroundMode: true,
        notificationChannelId: notificationChannelId,
        initialNotificationTitle: 'ADMIN SERVICE',
        initialNotificationContent: 'Running',
        foregroundServiceNotificationId: notificationId,
      ));
}

@pragma('vm:entry-point')
Future<void> onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  final token = await getLocalToken();
  Timer.periodic(const Duration(seconds: 30), (timer) async {
    print("serive is running");

    if (token != null) {
      var hasNewOrder = await fetchNewOrders(service);
      if (hasNewOrder) {
        playAlertSound();
        final flutterLocalNotificationsPlugin =
            FlutterLocalNotificationsPlugin();
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
      } else {
        playAlertSound(mode: false);
      }
    } else {
      service.stopSelf();
    }
  });

  service.on("stop").listen((event) {
    service.stopSelf();
    print("background process is now stopped");
  });
}

void playAlertSound({mode = true}) {
  if (mode) {
    AudioService().playAlarmSound();
  } else {
    AudioService().stopAlarmSound();
  }
}

Future<bool> fetchNewOrders(ServiceInstance service) async {
  final ApiResponse<List<Order>> response =
      await orderService.fetchOrders(languageCode: "fi", mode: "newOrders");

  if (response.isSuccess) {
    print('gotcha');
    final data = response.data!;
    final hasPendingOrders = data.any((Order order) =>
        order.ordersStatusId == 3 &&
        (order.preOrderBooking == 0 ||
            order.preOrderBooking == 1 ||
            order.preOrderBooking == 3));

    // Play or stop alarm sound based on pending orders
    if (hasPendingOrders) {
      print('has pending orders');
      return true;
    } else {
      print('no pending orders found');
      return false;
    }
  } else if (response.statusCode == 401) {
    service.stopSelf();
    return false;
  } else {
    // ref.read(globalMessageProvider.notifier).showError(response.message);
    // throw Exception(response.message);
    print('no orders found');
    return false;
  }
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MyApp> createState() => _MyApp();
}

class _MyApp extends ConsumerState<MyApp> with WidgetsBindingObserver {
  static const appcastURL =
      'https://raw.githubusercontent.com/larryaasen/upgrader/master/test/testappcast.xml';
  Key _appKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    requestPermissions();
    ref.read(printerProvider.notifier).connectToStoredDevice();
    WakelockPlus.enable();
    checkAppUpdate(context);
    ref.read(localizationProvider.notifier).setCachedLanguage();
    WidgetsBinding.instance.addObserver(this);
    _stopBackgroundService();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    WakelockPlus.disable(); // Disable wakelock if not needed
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      print("app is off");

      _startBackgroundService();
    } else if (state == AppLifecycleState.resumed) {
      print("app is on");
      _stopBackgroundService();
    }
    AudioService().stopAlarmSound();
  }

  void _startBackgroundService() {
    FlutterBackgroundService().startService();
  }

  void _stopBackgroundService() {
    FlutterBackgroundService().invoke('stop');
  }

  @override
  Widget build(BuildContext context) {
    final goRouter = ref.watch(goRouterProvider);
    final locale = ref.watch(localizationProvider);
    ref.listen<Locale>(localizationProvider, (previous, next) {
      setState(() {
        _appKey = UniqueKey();
      });
    });
    return PopScope(
        canPop: false,
        child: MaterialApp.router(
          key: _appKey,
          routerConfig: goRouter,
          locale: locale,
          supportedLocales: const [Locale('en'), Locale('fi'), Locale('es')],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          debugShowCheckedModeBanner: false,
          title: 'Admin app',
          theme: ThemeData(
            textTheme:
                GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
          ),
        ));
  }
}

Future<void> requestPermissions() async {
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
  if (await Permission.ignoreBatteryOptimizations.isDenied) {
    await Permission.ignoreBatteryOptimizations.request();
  }
  // if (await Permission.audio.isDenied) {
  //   await Permission.audio.request();
  // }
  // if (await Permission.bluetooth.isDenied) {
  //   await Permission.bluetooth.request();
  // }
  // if (await Permission.bluetoothScan.isDenied) {
  //   await Permission.bluetoothScan.request();
  // }
  // if (await Permission.bluetoothConnect.isDenied) {
  //   await Permission.bluetoothConnect.request();
  // }
  // if (await Permission.bluetoothAdvertise.isDenied) {
  //   await Permission.bluetoothAdvertise.request();
  // }
  // if (await Permission.locationWhenInUse.isDenied) {
  //   await Permission.locationWhenInUse.request();
  // }
}
