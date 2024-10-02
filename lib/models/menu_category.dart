// import 'package:admin_app/models/food_category.dart';

class MenuCategory {
  final int catgVariantTypeId;
  final String catgVariantTypeName;
  // final List<FoodCategory> foodCategories;

  MenuCategory({
    required this.catgVariantTypeId,
    required this.catgVariantTypeName,
    // required this.foodCategories,
  });

  factory MenuCategory.fromJson(Map<String, dynamic> json) {
    return MenuCategory(
      catgVariantTypeId: json['catgVariantTypeId'],
      catgVariantTypeName: json['catgVariantTypeName'],
      // foodCategories: (json['MasterFoodCategories'] as List)
      //     .map((i) => FoodCategory.fromJson(i))
      //     .toList(),
    );
  }
}
