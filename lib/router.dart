import 'package:admin_app/common/widgets/other_widgets/appbar_wrapper.dart';
import 'package:admin_app/pages/cancelled_orders/screens/cancelled_orders.dart';
import 'package:admin_app/pages/failed_orders/screens/failed_orders.dart';
import 'package:admin_app/pages/order_report/screens/order_report.dart';
import 'package:admin_app/pages/pre_orders/screens/pre_orders.dart';
import 'package:admin_app/pages/received_orders/screens/received_orders.dart';
import 'package:admin_app/pages/settings/screens/food_item_display.dart';
import 'package:admin_app/pages/settings/screens/order_search.dart';
import 'package:admin_app/pages/settings/screens/printer_setting.dart';
import 'package:admin_app/pages/settings/screens/settings.dart';
import 'package:admin_app/pages/settings/screens/shop_timings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin_app/providers/auth.dart';
import 'package:admin_app/pages/auth/screens/login_page.dart';
import 'package:admin_app/pages/home/screens/home.dart';
import 'package:admin_app/pages/auth/screens/splash_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) => SplashPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) => LoginPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (BuildContext context, GoRouterState state) =>
            AppBarWrapper(child: HomePage()),
      ),
      ShellRoute(
        builder: (context, state, child) {
          // Use ShellRoute to wrap all settings-related routes with AppBarWrapper
          return AppBarWrapper(child: child);
        },
        routes: [
          GoRoute(
            path: '/settings',
            builder: (BuildContext context, GoRouterState state) => Settings(),
            routes: [
              GoRoute(
                path: 'printer-setting', // '/settings/printer-setting'
                builder: (BuildContext context, GoRouterState state) =>
                    PrinterSetting(),
              ),
              GoRoute(
                path: 'shop-timings', // '/settings/shop-timings'
                builder: (BuildContext context, GoRouterState state) =>
                    ShopTimings(),
              ),
              GoRoute(
                path: 'order-search', // '/settings/order-search'
                builder: (BuildContext context, GoRouterState state) =>
                    OrderSearch(),
              ),
              GoRoute(
                path: 'food-item-display', // '/settings/food-item-display'
                builder: (BuildContext context, GoRouterState state) =>
                    FoodItemDisplay(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/received-orders',
        builder: (BuildContext context, GoRouterState state) =>
            AppBarWrapper(child: ReceivedOrders()),
      ),
      GoRoute(
        path: '/pre-orders',
        builder: (BuildContext context, GoRouterState state) =>
            AppBarWrapper(child: PreOrders()),
      ),
      GoRoute(
        path: '/failed-orders',
        builder: (BuildContext context, GoRouterState state) =>
            AppBarWrapper(child: FailedOrders()),
      ),
      GoRoute(
        path: '/cancelled-orders',
        builder: (BuildContext context, GoRouterState state) =>
            AppBarWrapper(child: CancelledOrders()),
      ),
      GoRoute(
        path: '/order-report',
        builder: (BuildContext context, GoRouterState state) =>
            AppBarWrapper(child: OrderReport()),
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final isLoggedIn = authState.isLoggedIn;
      final goingToLogin = state.uri == '/login';
      if (!isLoggedIn && !goingToLogin) {
        return '/login';
      }
      if (isLoggedIn && goingToLogin) {
        return '/home';
      }
      return null;
    },
  );
});
