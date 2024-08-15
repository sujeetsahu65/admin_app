import 'package:admin_app/models/order_items_model.dart';
import 'package:admin_app/models/toppings_model.dart';

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