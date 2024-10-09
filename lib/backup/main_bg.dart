// import 'package:admin_app/constants/global_variables.dart';
import 'package:admin_app/pages/auth/services/language.dart';
import 'package:admin_app/pages/auth/services/version.dart';
import 'package:admin_app/providers/language.dart';
// import 'package:admin_app/providers/error_handler.dart';
import 'package:admin_app/providers/printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin_app/router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:google_fonts/google_fonts.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Needed for background execution
  // await FlutterBackground.initialize(); // Initialize background execution

  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Europe/Helsinki'));
  // FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);

  runApp(ProviderScope(child: MyApp()));
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
    // Enable background execution
    // FlutterBackground.enableBackgroundExecution();
        // Initialize background service with Android-specific config
    initializeBackgroundService();

    // Keep the screen on when the app is open
    WakelockPlus.enable();
    checkAppUpdate(context);

    ref.read(printerProvider.notifier).connectToStoredDevice();
    // final cachedLangCode = await cachedLanguageCode();

    ref.read(localizationProvider.notifier).setCachedLanguage();

    // You're correct that if the ref.listen is placed inside initState(), it will only set up the listener when the widget is first initialized. However, the listener itself will continue to respond to changes in the localizationProvider even after initState() is called, so it will still work when you change the language.
  }


  Future<void> initializeBackgroundService() async {
    // Define Android-specific configuration for the background service
    final androidConfig = FlutterBackgroundAndroidConfig(
      notificationTitle: "Admin App",
      notificationText: "App is running in the background",
      notificationImportance: AndroidNotificationImportance.Default,
      notificationIcon: AndroidResource(name: 'background_icon', defType: 'drawable'), // Make sure to add an icon in your drawable folder
    );

    // Initialize the background service with the config
    bool success = await FlutterBackground.initialize(androidConfig: androidConfig);
    
    if (success) {
      // Enable background execution if initialization was successful
      await FlutterBackground.enableBackgroundExecution();
    } else {
      print('Background service initialization failed');
    }
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
