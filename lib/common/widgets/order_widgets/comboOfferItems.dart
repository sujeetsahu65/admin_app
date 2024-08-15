import 'package:admin_app/common/widgets/order_widgets/orderItems.dart';
import 'package:admin_app/common/widgets/other_widgets/customFont.dart';
import 'package:admin_app/models/combo_offer_model.dart';
import 'package:admin_app/models/order_items_model.dart';
import 'package:admin_app/models/order_model.dart';
import 'package:admin_app/models/toppings_model.dart';
import 'package:admin_app/pages/auth/services/language.dart';
import 'package:admin_app/providers/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ComboOfferItems extends ConsumerWidget {
  final List<ComboOfferItem> comboOfferItems;

  ComboOfferItems({required this.comboOfferItems});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(children: [
      CustomFont(
              text: 'Combo Offer',
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center)
          .medium(),
      Divider(),
      for (int i = 0; i < comboOfferItems.length; i++)
        ...[
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 10,
                    child: CustomFont(
                      text: '${comboOfferItems[i].comboName}:',
                      fontWeight: FontWeight.bold,
                    ).mediumHigh(),
                  ),
                  Expanded(
                      flex: 2,
                      child: CustomFont(
                              text: '${comboOfferItems[i].totalPrice}€',
                              textAlign: TextAlign.right)
                          .medium()),
                ],
              ),
              SizedBox(
                height: 2,
              ),
              OrderItems(
                orderItems: comboOfferItems[i].orderItems,
                isComboOffer: true,
              ),
              if (i < comboOfferItems.length - 1) Divider(),
            ],
          )
        ].toList(),
    ]);
  }
}
