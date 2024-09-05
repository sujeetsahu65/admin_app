import 'package:admin_app/models/food_item.dart';

class FoodCategory {
  final int foodItemCategoryId;
  final String categoryName;
  final List<FoodItem> foodItems;

  FoodCategory({
    required this.foodItemCategoryId,
    required this.categoryName,
    required this.foodItems,
  });

  factory FoodCategory.fromJson(Map<String, dynamic> json) {
    return FoodCategory(
      foodItemCategoryId: json['foodItemCategoryId'],
      categoryName: json['categoryName'],
      foodItems: (json['MasterFoodItems'] as List)
          .map((i) => FoodItem.fromJson(i))
          .toList(),
    );
  }
}
