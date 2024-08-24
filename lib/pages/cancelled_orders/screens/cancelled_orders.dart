import 'package:admin_app/common/widgets/order_widgets/orderCard.dart';
import 'package:admin_app/common/widgets/other_widgets/loader.dart';
import 'package:admin_app/models/order_model.dart';
import 'package:admin_app/providers/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CancelledOrders extends ConsumerWidget {
  final String page = 'cancelled-orders';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Order> orders = ref.watch(cancelledOrderProvider);
    // final filteredOrders = orders.where((order) {
    //   return (order.ordersStatusId == 6);
    // }).toList();

    return Stack(
      children: [
        Scaffold(
          body: orders.isEmpty
              ? const Center(child: Text('No orders'))
              : ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    // return ListTile(
                    //   title: Text('Order ID: ${order['order_id']}'),
                    //   // subtitle: Text('Amount: ${order.amount}'),
                    // );
                    return OrderCard(
                      order: order,
                      page: page,
                    );
                  },
                ),
        ),
        GlobalLoader()
      ],
    );
  }
}
