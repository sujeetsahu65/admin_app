// import 'package:admin_app/common/widgets/other_widgets/customFont.dart';
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
                  '${AppLocalizations.of(context).translate('sub total label')} : ${order.foodItemSubtotalAmtAsString}€'),
              Text(
                  '${AppLocalizations.of(context).translate('tax label')} : ${order.totalItemTaxAmtAsString}€'),
              if (order.discountAmt > 0)
                Text(
                    '${AppLocalizations.of(context).translate('discount label')} : ${order.discountAmtAsString}€'),
              if (order.regOfferAmount > 0)
                Text(
                    '${AppLocalizations.of(context).translate('title_registration_Offers')} : ${order.regOfferAmountAsString}€'),
              if (order.deliveryTypeId == 1) ...[
                Text(
                    '${AppLocalizations.of(context).translate('title_distance')} : ${order.orderUserDistanceAsString}Km'),
                Text(
                    '${AppLocalizations.of(context).translate('delivery charge label')} : ${order.deliveryChargesAsString}€'),
              if (order.extraDeliveryCharges > 0)
                Text(
                    '${AppLocalizations.of(context).translate('Extra Delivery Charges label')} : ${order.extraDeliveryChargesAsString}€'),

              ],
                if (order.minimumOrderPrice > 0)
                Text(
                    '${AppLocalizations.of(context).translate('title_Minimum_order_price')} : ${order.minimumOrderPriceAsString}€'),
                if (order.deliveryCouponAmt > 0)
                Text(
                    '${AppLocalizations.of(context).translate('delivery_coupon_discount_title')} : ${order.deliveryCouponAmtAsString}€'),
                if (order.couponDiscount > 0)
                Text(
                    '${AppLocalizations.of(context).translate('coupon discount title')} : ${order.couponDiscountAsString}€'),
              Text(
                  '${AppLocalizations.of(context).translate('title_Grand_Total')} : ${order.grandTotalAsString}€'),
              Text(
                  '${AppLocalizations.of(context).translate('total label')} : ${order.finalPayableAmountAsString}€')
            ],
          )
        ],
      ),
    );
  }
}
