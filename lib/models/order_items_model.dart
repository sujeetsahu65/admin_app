import 'package:admin_app/models/toppings_model.dart';

class OrderItem {
  final int orderFoodItemId;
  final String foodItemName;
  final String foodItemImage;
  final double basicPrice;
  final int itemOrderQty;
  final double totalBasicPrice;
  final double itemTotalToppingsPrice;
  final String foodExtratext;
  final int sizeId;
  final String itemSizeName;
  final String comboProductType;
  final int foodTestId;
  final List<Topping> toppings;

  OrderItem({
    required this.orderFoodItemId,
    required this.foodItemName,
    required this.foodItemImage,
    required dynamic basicPrice,
    required this.itemOrderQty,
    required dynamic totalBasicPrice,
    required dynamic itemTotalToppingsPrice,
    required this.foodExtratext,
    required this.sizeId,
    required this.itemSizeName,
    required this.comboProductType,
    required this.foodTestId,
    required this.toppings,
  })  : basicPrice = _convertToDouble(basicPrice),
        totalBasicPrice = _convertToDouble(totalBasicPrice),
        itemTotalToppingsPrice = _convertToDouble(itemTotalToppingsPrice);

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

    // Getter methods to return double values as strings with trailing zeros
  String get basicPriceAsString => _formatDouble(basicPrice);
  String get totalBasicPriceAsString => _formatDouble(totalBasicPrice);
  String get itemTotalToppingsPriceAsString => _formatDouble(itemTotalToppingsPrice);

  // Format double values as strings with two decimal places
  static String _formatDouble(double value) {
    return value.toStringAsFixed(2);  // Ensures two decimal places with trailing zeros
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    var toppingsFromJson = json['toppings'] as List;
    List<Topping> toppingsList =
        toppingsFromJson.map((i) => Topping.fromJson(i)).toList();

    return OrderItem(
      orderFoodItemId: json['order_food_item_id'],
      foodItemName: json['food_item_name'],
      foodItemImage: json['food_item_image'],
      basicPrice: (json['basic_price']),
      itemOrderQty: json['item_order_qty'],
      totalBasicPrice: json['total_basic_price'],
      itemTotalToppingsPrice: (json['item_total_toppings_price']),
      foodExtratext: json['food_extratext'],
      sizeId: json['size_id'],
      itemSizeName: json['item_size_name'],
      comboProductType: json['combo_product_type'],
      foodTestId: json['food_test_id'],
      toppings: toppingsList,
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
