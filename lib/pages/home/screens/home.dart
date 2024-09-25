import 'package:admin_app/common/widgets/order_widgets/orderCard.dart';
import 'package:admin_app/models/order_model.dart';
import 'package:admin_app/pages/home/services/audio.dart';
import 'package:admin_app/providers/basic.dart';
import 'package:admin_app/providers/error_handler.dart';
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

    super.initState();

    // Trigger general data loading first
    Future.wait([
// Note:The generalDataProvider.loadGeneralData() must be called before any other;
      _loadGeneralData(), // First load general data
      _initializeOtherData(), // Then load other data like orders etc.
    ]).then((_) {
      // After all the initial data is loaded, proceed with widget setup if needed.
      // ref
      //     .read(globalMessageProvider.notifier)
      //     .showSuccess("Successfully to initialize data.");
    }).catchError((error) {
      ref
          .read(globalMessageProvider.notifier)
          .showError("Failed to initialize data.");
    });
  }

  // Function to load general data (language, app update, etc.)
  Future<void> _loadGeneralData() async {
    ref.read(generalDataProvider.notifier).loadGeneralData();
  }

// Function to load other data, like orders or printers
  Future<void> _initializeOtherData() async {
    // Start order polling after general data
    ref
        .read(orderProvider.notifier)
        .startOrderPolling(); // Start order polling after general data
  }

  @override
  Widget build(BuildContext context) {
// NOTE: DO NOT COMMENT OUT THE basicDataProvider

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
