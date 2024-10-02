import 'package:admin_app/models/order_items_model.dart';
// import 'package:admin_app/models/toppings_model.dart';

class ComboOfferItem {
  final String comboName;
  final double totalPrice;
  final int comboOfferId;
  final int comboOfferSetId;
  final List<OrderItem> orderItems;

  ComboOfferItem({
    required this.comboName,
    required dynamic totalPrice,
    required this.comboOfferId,
    required this.comboOfferSetId,
    required this.orderItems

  })  : totalPrice = _convertToDouble(totalPrice);

  static double _convertToDouble(dynamic value) {
    if (value is int) {
      return value.toDouble();
    } else if (value is double) {
      return value;
    } else if (value is String) {
      return double.tryParse(value) ?? 0.0;
    } else {
      throw ArgumentError('Invalid type for double conversion');
    }
  }

  factory ComboOfferItem.fromJson(Map<String, dynamic> json) {
    var orderItemsFromJson = json['order_items'] as List;
    List<OrderItem> orderItems =
        orderItemsFromJson.map((i) => OrderItem.fromJson(i)).toList();




    return ComboOfferItem(
      comboName: json['combo_name'],
      totalPrice: json['total_price'],
      comboOfferId: json['combo_offer_id'],
      comboOfferSetId: json['combo_offer_set_id'],
      orderItems: orderItems,
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'order_food_item_id': orderFoodItemId,
  //     'food_item_name': foodItemName,
  //     'food_item_image': foodItemImage,
  //     'basic_price': basicPrice,
  //     'item_order_qty': itemOrderQty,
  //     'total_basic_price': totalBasicPrice,
  //     'item_total_toppings_price': itemTotalToppingsPrice,
  //     'food_extratext': foodExtratext,
  //     'size_id': sizeId,
  //     'food_test_id': foodTestId,
  //     'toppings': toppings.map((topping) => topping.toJson()).toList(),
  //   };
  // }
}
