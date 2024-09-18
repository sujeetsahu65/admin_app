import 'package:admin_app/common/widgets/order_widgets/orderCard.dart';
import 'package:admin_app/models/order_model.dart';
import 'package:admin_app/pages/home/services/audio.dart';
import 'package:admin_app/providers/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  final String page = 'home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the order provider that returns AsyncValue<List<Order>>
    final orderAsyncValue = ref.watch(orderProvider);

    return Scaffold(

      body: orderAsyncValue.when(
        data: (orders) {
          // Filter orders with status 3 or 5
          final filteredOrders = orders.where((order) {
            return (order.ordersStatusId == 3 || order.ordersStatusId == 5) &&
                (order.preOrderBooking == 0 ||
                    order.preOrderBooking == 1 ||
                    order.preOrderBooking == 3);
          }).toList();

          final hasPendingOrders = orders.any((Order order) =>
              order.ordersStatusId == 3 &&
              (order.preOrderBooking == 0 ||
                  order.preOrderBooking == 1 ||
                  order.preOrderBooking == 3));

          // Play or stop alarm sound based on pending orders
          if (hasPendingOrders) {
            AudioService().playAlarmSound();
          } else {
            AudioService().stopAlarmSound();
          }

          // If no filtered orders, display a message
          if (filteredOrders.isEmpty) {
            return const Center(child: Text('No new orders'));
          }

          // Display the filtered orders
          return ListView.builder(
            itemCount: filteredOrders.length,
            itemBuilder: (context, index) {
              final order = filteredOrders[index];
              return OrderCard(
                order: order,
                page: page,
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}
