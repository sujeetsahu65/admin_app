import 'package:admin_app/constants/global_variables.dart';
import 'package:admin_app/pages/auth/services/language.dart';
import 'package:admin_app/pages/auth/services/version.dart';
import 'package:admin_app/providers/language.dart';
import 'package:admin_app/providers/printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin_app/router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:google_fonts/google_fonts.dart';

void main() {
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Europe/Helsinki'));
  FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);
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

  // Key _appKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    checkAppUpdate(context);

    ref.read(printerProvider.notifier).connectToStoredDevice();
    // final cachedLangCode = await cachedLanguageCode();

   
    ref.read(localizationProvider.notifier).setCachedLanguage();

    // You're correct that if the ref.listen is placed inside initState(), it will only set up the listener when the widget is first initialized. However, the listener itself will continue to respond to changes in the localizationProvider even after initState() is called, so it will still work when you change the language.
  }

  @override
  Widget build(BuildContext context) {
    // final initializeLanguageContent =
    //   ref.watch(initializeLanguageContentProvider);
    final goRouter = ref.watch(goRouterProvider);
    final locale = ref.watch(localizationProvider);
    // Listen for language changes and trigger app rebuild
    // ref.listen<Locale>(localizationProvider, (previous, next) {
    //   setState(() {
    //     print("the locale is listened");
    //     _appKey = UniqueKey(); // Update the key to rebuild the app
    //   });
    // });

    return MaterialApp.router(
      // key: _appKey,
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
