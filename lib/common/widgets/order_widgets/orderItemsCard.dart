import 'package:admin_app/common/widgets/order_widgets/comboOfferItems.dart';
import 'package:admin_app/common/widgets/order_widgets/orderItems.dart';
import 'package:admin_app/common/widgets/other_widgets/customFont.dart';
import 'package:admin_app/common/widgets/order_widgets/orderCalculation.dart';
import 'package:admin_app/models/combo_offer_model.dart';
import 'package:admin_app/models/order_items_model.dart';
import 'package:admin_app/models/order_model.dart';
import 'package:admin_app/models/toppings_model.dart';
import 'package:admin_app/providers/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderItemsCard extends ConsumerWidget {
  final Order order;

  OrderItemsCard({required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderItemsData = ref.watch(orderItemsProvider(order.orderId));

    return orderItemsData.when(
      data: (data) {

        List<OrderItem> orderItems =
            List<OrderItem>.from(data['orderItems'] ?? []);
        List<ComboOfferItem> comboOfferItems =
            List<ComboOfferItem>.from(data['comboOfferItems'] ?? []);

        return Card(
          elevation: 3.0,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Use Flexible with SingleChildScrollView
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(children: [
                      if(orderItems.isNotEmpty)
                      OrderItems(orderItems: orderItems),
                      // OrderItems(order: order,orderItems: orderItems),

                      if(comboOfferItems.isNotEmpty)
                      ComboOfferItems(
                        comboOfferItems: comboOfferItems,
                      )
                    ]),
                  ),
                ),
                Divider(
                  thickness: 1.0,
                ),
                OrderCalculation(order: order),
              ],
            ),
          ),
        );
      },
      loading: () => CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
    );
  }
}
