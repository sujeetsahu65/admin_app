import 'package:admin_app/common/widgets/order_widgets/orderCard.dart';
import 'package:admin_app/common/widgets/other_widgets/loader.dart';
import 'package:admin_app/models/order_model.dart';
import 'package:admin_app/providers/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FailedOrders extends ConsumerStatefulWidget {
  const FailedOrders({Key? key}) : super(key: key);

  @override
  ConsumerState<FailedOrders> createState() => _FailedOrders();
}

class _FailedOrders extends ConsumerState<FailedOrders> {
  final String page = 'failed-orders';

  @override
  void initState() {
    ref.read(failedOrderProvider.notifier).loadOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<Order>> orders = ref.watch(failedOrderProvider);

    return Scaffold(
      body: Stack(children: [
        orders.when(
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
        ),
        GlobalLoader(),
      ]),
    );
  }
}
