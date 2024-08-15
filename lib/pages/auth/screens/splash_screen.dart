import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin_app/providers/auth.dart';

class SplashPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future.delayed(Duration(seconds: 2), () {
      final authState = ref.read(authProvider);
      if (authState.isLoggedIn) {
        context.go('/home');
      } else {
        context.go('/login');
      }
    });
 return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
