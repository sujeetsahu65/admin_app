import 'package:admin_app/common/widgets/order_widgets/orderCard.dart';
import 'package:admin_app/common/widgets/other_widgets/loader.dart';
// import 'package:admin_app/models/bluetooth.dart';
import 'package:admin_app/models/order_model.dart';
import 'package:admin_app/pages/home/services/audio.dart';
import 'package:admin_app/providers/basic.dart';
import 'package:admin_app/providers/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  final String page = 'home';
  // DateTime? dateTime;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basicDataProvider = ref.watch(generalDataProvider);
    // final languageContent = ref.watch(languageContentProvider);
    // final authNotifier = ref.read(authProvider.notifier);

    final List<Order> orders = ref.watch(orderProvider);

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
    // print(orders);
    print(AudioService().getPlayerState());
    if (hasPendingOrders) {
      // Play alarming sound
      // Example: AudioService.playAlarmSound();
      AudioService().playAlarmSound();
    } else {
      // Stop alarming sound
      // Example: AudioService.stopAlarmSound();
      AudioService().stopAlarmSound();
    }

    return Stack(
      children: [
        Scaffold(
          body: filteredOrders.isEmpty
              ? const Center(child: Text('No new orders'))
              : ListView.builder(
                  itemCount: filteredOrders.length,
                  itemBuilder: (context, index) {
                    final order = filteredOrders[index];
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
