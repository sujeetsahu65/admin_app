// global_loader.dart
import 'package:admin_app/providers/basic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GlobalLoader extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(loadingProvider);

    if (!isLoading) {
      return SizedBox.shrink(); // No loader when not loading
    }

    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
