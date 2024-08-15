import 'package:admin_app/common/widgets/other_widgets/customFont.dart';
import 'package:admin_app/models/combo_offer_model.dart';
import 'package:admin_app/models/order_items_model.dart';
import 'package:admin_app/models/order_model.dart';
import 'package:admin_app/models/toppings_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderItems extends ConsumerWidget {
  final List<OrderItem> orderItems;
  final bool isComboOffer;

  OrderItems({required this.orderItems, this.isComboOffer = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        for (int i = 0; i < orderItems.length; i++) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 10,
                      child: CustomFont(
                        text: '${orderItems[i].itemOrderQty} x ${orderItems[i].foodItemName}(${orderItems[i].itemSizeName})',
                        fontWeight: !isComboOffer ? FontWeight.bold : null,
                      ).medium(),
                    ),
                    if (!isComboOffer)
                      Expanded(
                        flex: 2,
                        child: CustomFont(
                          text: '${orderItems[i].totalBasicPrice}€',
                          textAlign: TextAlign.right,
                        ).medium(),
                      ),
                  ],
                ),
                if (orderItems[i].foodExtratext.isNotEmpty) ...[
                  CustomFont(
                    text: 'Extra Comment:',
                    fontWeight: FontWeight.bold,
                  ).medium(),
                  Text('${orderItems[i].foodExtratext}'),
                ],
                ...orderItems[i].toppingsByVariantOption.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomFont(
                          text: '${entry.key}',
                          fontWeight: FontWeight.bold,
                        ).small(),
                        ...entry.value.map((topping) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: CustomFont(
                                  text: '${topping.toppingslistname}',
                                  fontWeight: FontWeight.w300,
                                  color: Colors.red,
                                ).small(),
                              ),
                              Expanded(
                                child: CustomFont(
                                  text: ':',
                                  fontWeight: FontWeight.w300,
                                  color: Colors.red,
                                  textAlign: TextAlign.center,
                                ).small(),
                              ),
                              Expanded(
                                child: CustomFont(
                                  text: '${topping.foodVariantOptionPrice}€',
                                  fontWeight: FontWeight.w300,
                                  color: Colors.red,
                                  textAlign: TextAlign.right,
                                ).small(),
                              ),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          if ((i < orderItems.length - 1) && !isComboOffer)
            Divider(),
        ],
      ],
    );
  }
}

extension on OrderItem {
  Map<String, List<Topping>> get toppingsByVariantOption {
    final Map<String, List<Topping>> toppingsByVariantOption = {};

    for (var topping in toppings) {
      if (!toppingsByVariantOption.containsKey(topping.toppingsheading)) {
        toppingsByVariantOption[topping.toppingsheading] = [];
      }
      toppingsByVariantOption[topping.toppingsheading]!.add(topping);
    }

    return toppingsByVariantOption;
  }
}
