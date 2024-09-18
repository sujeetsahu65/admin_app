import 'package:admin_app/common/widgets/order_widgets/orderCard.dart';
import 'package:admin_app/models/order_model.dart';
import 'package:admin_app/providers/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PreOrders extends ConsumerWidget {
  final String page = 'pre-orders';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Order>> orders = ref.watch(preOrderProvider);
    return Scaffold(
        body: orders.when(
      data: (orders) {
        if (orders.isEmpty) {
          return const Center(child: Text('No orders'));
        } else {
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return OrderCard(
                order: order,
                page: page,
              );
            },
          );
        }
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(
        child: Text('Error: $error'),
      ),
    ));
  }
}
