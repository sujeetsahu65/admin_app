class Topping {
  final int foodVariantOptionTypeId;
  final String toppingsheading;
  final String toppingslistname;
  final double foodVariantOptionBasePrice;
  final double foodVariantOptionPrice;
  final int itemAddingToppingTypes;

  Topping({
    required this.foodVariantOptionTypeId,
    required this.toppingsheading,
    required this.toppingslistname,
    required dynamic foodVariantOptionBasePrice,
    required dynamic foodVariantOptionPrice,
    required this.itemAddingToppingTypes,
  })  : foodVariantOptionBasePrice =
            _convertToDouble(foodVariantOptionBasePrice),
        foodVariantOptionPrice = _convertToDouble(foodVariantOptionPrice);

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
  String get foodVariantOptionBasePriceAsString => _formatDouble(foodVariantOptionBasePrice);
  String get foodVariantOptionPriceAsString => _formatDouble(foodVariantOptionPrice);

  // Format double values as strings with two decimal places
  static String _formatDouble(double value) {
    return value.toStringAsFixed(2);  // Ensures two decimal places with trailing zeros
  }

  factory Topping.fromJson(Map<String, dynamic> json) {
    return Topping(
      foodVariantOptionTypeId: json['food_varient_option_type_id'],
      toppingsheading: json['toppingsheading'],
      toppingslistname: json['toppingslistname'],
      foodVariantOptionBasePrice:
          (json['food_varient_option_base_price'] as num).toDouble(),
      foodVariantOptionPrice:
          (json['food_varient_option_price'] as num).toDouble(),
      itemAddingToppingTypes: json['item_adding_topping_types'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'food_varient_option_type_id': foodVariantOptionTypeId,
      'toppingsheading': toppingsheading,
      'toppingslistname': toppingslistname,
      'food_varient_option_base_price': foodVariantOptionBasePrice,
      'food_varient_option_price': foodVariantOptionPrice,
      'item_adding_topping_types': itemAddingToppingTypes,
    };
  }
}
