import 'package:admin_app/common/widgets/other_widgets/appbarWrapper.dart';
import 'package:admin_app/pages/settings/screens/settings.dart';
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
        builder: (BuildContext context, GoRouterState state) =>

LoginPage(),
      ),
      GoRoute(
        path: '/home',
         builder: (BuildContext context, GoRouterState state) => AppBarWrapper(child: HomePage()),
      ),
      GoRoute(
        path: '/settings',
         builder: (BuildContext context, GoRouterState state) => AppBarWrapper(child: Settings()),
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final isLoggedIn = authState.isLoggedIn;
      print(state.uri);
      // print(state.path);
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

