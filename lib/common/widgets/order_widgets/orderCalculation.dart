import 'package:admin_app/common/widgets/other_widgets/customFont.dart';
import 'package:admin_app/models/order_model.dart';
import 'package:admin_app/pages/auth/services/language.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderCalculation extends ConsumerWidget {
  final Order order;

  OrderCalculation({required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,

        // crossAxisAlignment: CrossAxisAlignment.end,

        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                  '${AppLocalizations.of(context).translate('sub total label')} : ${order.foodItemSubtotalAmt}€'),
              Text(
                  '${AppLocalizations.of(context).translate('tax label')} : ${order.totalItemTaxAmt}€'),
              if (order.discountAmt > 0)
                Text(
                    '${AppLocalizations.of(context).translate('discount label')} : ${order.discountAmt}€'),
              if (order.regOfferAmount > 0)
                Text(
                    '${AppLocalizations.of(context).translate('title_registration_Offers')} : ${order.regOfferAmount}€'),
              if (order.deliveryTypeId == 1) ...[
                Text(
                    '${AppLocalizations.of(context).translate('title_distance')} : ${order.orderUserDistance}Km'),
                Text(
                    '${AppLocalizations.of(context).translate('delivery charge label')} : ${order.deliveryCharges}€'),
              if (order.extraDeliveryCharges > 0)
                Text(
                    '${AppLocalizations.of(context).translate('Extra Delivery Charges label')} : ${order.extraDeliveryCharges}€'),

              ],
                if (order.minimumOrderPrice > 0)
                Text(
                    '${AppLocalizations.of(context).translate('title_Minimum_order_price')} : ${order.minimumOrderPrice}€'),
                if (order.deliveryCouponAmt > 0)
                Text(
                    '${AppLocalizations.of(context).translate('delivery_coupon_discount_title')} : ${order.deliveryCouponAmt}€'),
                if (order.couponDiscount > 0)
                Text(
                    '${AppLocalizations.of(context).translate('coupon discount title')} : ${order.couponDiscount}€'),
              Text(
                  '${AppLocalizations.of(context).translate('title_Grand_Total')} : ${order.grandTotal}€'),
              Text(
                  '${AppLocalizations.of(context).translate('total label')} : ${order.finalPayableAmount}€')
            ],
          )
        ],
      ),
    );
  }
}
