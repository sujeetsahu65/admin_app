import 'package:admin_app/common/widgets/order_widgets/orderCard.dart';
import 'package:admin_app/models/order_model.dart';
import 'package:admin_app/pages/home/services/audio.dart';
import 'package:admin_app/providers/basic.dart';
import 'package:admin_app/providers/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePage();
}

class _HomePage extends ConsumerState<HomePage> {


  final String page = 'home';

  @override
  void initState() {

    ref.read(orderProvider.notifier).loadOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
// NOTE: DO NOT COMMENT OUT THE basicDataProvider
    final basicDataProvider = ref.watch(generalDataProvider);
    // final languageContent = ref.watch(languageContentProvider);
    // final authNotifier = ref.read(authProvider.notifier);

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

             if (orders.isEmpty) {
          return const Center(child: Text('No orders'));
        } else {

        

          final hasPendingOrders = filteredOrders.any((Order order) =>
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
        }
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
