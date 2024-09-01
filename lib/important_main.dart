// import 'package:admin_app/common/widgets/appbar_wrapper.dart';
// import 'package:admin_app/common/widgets/sidebar_panel.dart';
// import 'package:admin_app/pages/auth/services/language_services.dart';
// import 'package:admin_app/providers/auth_provider.dart';
import 'package:admin_app/common/widgets/other_widgets/loader.dart';
import 'package:admin_app/constants/global_variables.dart';
import 'package:admin_app/pages/auth/services/language.dart';
import 'package:admin_app/pages/auth/services/version.dart';
import 'package:admin_app/providers/basic.dart';
// import 'package:admin_app/providers/basic_provider.dart';
import 'package:admin_app/providers/language.dart';
import 'package:admin_app/providers/printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin_app/router.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
// import 'package:upgrader/upgrader.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/timezone.dart';

import 'package:google_fonts/google_fonts.dart';

void main() {
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Europe/Helsinki'));
  FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);
  // final finland = tz.getLocation('Europe/Helsinki');
  // tz.setLocalLocation(finland);
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

  @override
  void initState() {
    super.initState();
    checkAppUpdate(context);

    // final printerNotifier = ref.read(printerProvider.notifier);

    // printerNotifier.connectToStoredDevice();

// this is called even before the app starts:
    //     WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ref.read(printerProvider.notifier).connectToStoredDevice();
    // });

    ref.read(printerProvider.notifier).connectToStoredDevice();

// final inputMinute = 30;
//     final inputDateTime = time.toLocal();
//     DateTime currentTime = TZ.now();
// print(currentTime);
//       Duration difference = deliveryTime.difference(currentTime);

    // final inputDateTime = DateTime.parse("2024-07-22 19:30:20").toLocal();
    // final currtime = DateTime.parse("2024-07-22 19:54:26.136").toLocal();
    // DateTime.utc()
//     final inputMinute = 60;
//     DateTime deliveryTime = inputDateTime.add(Duration(minutes: inputMinute));
//     Duration _duration = Duration(minutes: inputMinute);

//           DateTime currentTime = TZ.now();
//           // DateTime currentTimesys = DateTime.now();
//       Duration difference = deliveryTime.difference(currentTime);
//       final diffmin = difference.inMinutes;
// print("deltime:$deliveryTime");
// print("curr:$currentTime");
// // print("currsys:$currentTimesys");
// print("diffmin:$diffmin");
  }

// final initializeLanguageContentProvider = FutureProvider<void>((ref) async {
//   final prefs = await SharedPreferences.getInstance();
//   int? lang_id = await prefs.getInt('lang_id');
//   lang_id = lang_id == null ? 2 : lang_id;

//   // final languageId = await ref.watch(languageIdProvider);
//      ref.read(languageIdProvider.notifier).state = lang_id;
//   await ref.read(languageContentProvider.notifier).loadLanguageContent(lang_id);
// });

  @override
  Widget build(BuildContext context) {
    // final initializeLanguageContent =
    //   ref.watch(initializeLanguageContentProvider);
    final goRouter = ref.watch(goRouterProvider);
    final locale = ref.watch(localizationProvider);

    return MaterialApp.router(
      routerConfig: goRouter,

      //  builder: (context, child) {
      //     return Stack(
      //       children: [
      //         Overlay(
      //           initialEntries: [
      //             OverlayEntry(
      //               builder: (context) => child!,
      //             ),
      //           ],
      //         ),
      //         GlobalLoader(), // Add the global loader here
      //       ],
      //     );
      //   },

      //  builder: (context, child) {
      //     return UpgradeAlert(
      //        key: goRouter.routerDelegate.navigatorKey,
      //       upgrader: Upgrader(
      //         minAppVersion: "2.0.0",
      //         debugDisplayAlways: true,
      //         debugLogging: true,
      //         languageCode: 'en',
      //         countryCode: "IND",
      //         messages: UpgraderMessages(code: 'en'),
      //         dialogStyle: UpgradeDialogStyle.material,
      //         showLater: true
      //       ),

      //       //   upgrader: Upgrader(
      //       //   dialogStyle: UpgradeDialogStyle.material,
      //       //   durationUntilAlertAgain: Duration(days: 1),
      //       //   showIgnore: false,
      //       //   showLater: false,
      //       //   canDismissDialog: false,
      //       //   appcastConfig: AppcastConfiguration(
      //       //     // url: '$uri/appcast.xml',
      //       //     url: appcastURL,
      //       //     supportedOS: ['android'],
      //       //   ),
      //       //   debugLogging: true,  // Enable debug logging for testing
      //       // ),
      //       child: child!,
      //     );
      //   },
      /*
    // Note:
    //1) We can wrap the all pages with appBarWrapper using builder, also we can skip the app bar for some specific page
    // 2)we can wrap each page with appbar in routers as well see the commented example there
    //3) We can also apply the codition in appBarWrapper widget also to skip any page

    */

      /*
  builder: (context, child) {


        // Check the current route
        // final GoRouterState? goRouterState = GoRouter.of(context).routerDelegate.state;
        // final bool isLoginRoute = goRouterState?.location == '/login';

        // Wrap with AppScaffold if not on the login route
        // return isLoginRoute ? child! : AppScaffold(child: child!);


             /*

  GoRouter _router = goRouter;
                 final Uri location = _router.routerDelegate.currentConfiguration.uri;
        print("location is: $location");
        
                final Widget mainChild= location =='/login'?child!:AppBarWrapper(child: child,title: "ttt");
                return mainChild;

              */

 return Overlay(
          initialEntries: [
            OverlayEntry(
              builder: (context) => AppBarWrapper(child: child),
            ),
          ],
        );

        // return AppBarWrapper(child: child!,title: "ttt",);
        // return SideBarPanel();
      },

      */

/*
// Note: if routerConfig is provided all the router delgates must not be provided
      // routerDelegate: goRouter.routerDelegate,
      // routeInformationParser: goRouter.routeInformationParser,
      // routeInformationProvider: goRouter.routeInformationProvider,

*/

      // localizationsDelegates: [
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate,
      // ],
      // supportedLocales: [
      //   Locale('en'), // English
      //   Locale('en'), // Spanish
      // ],

      //   localizationsDelegates: AppLocalizations.localizationsDelegates,
      // supportedLocales: AppLocalizations.supportedLocales,

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

// Customizing Text Styles
// If you want to customize specific text styles, you can do so within the textTheme property:

// theme: ThemeData(
//   textTheme: GoogleFonts.poppinsTextTheme(
//     Theme.of(context).textTheme,
//   ).copyWith(
//     headline1: GoogleFonts.poppins(
//       textStyle: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
//     ),
//     bodyText2: GoogleFonts.poppins(
//       textStyle: TextStyle(fontSize: 14.0),
//     ),
//   ),
// ),
    );
  }
}
