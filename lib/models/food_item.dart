class FoodItem {
  final int foodItemId;
  final String foodItemName;
  final int displayOrder;
  final int display;
  final int isActive;

  FoodItem({
    required this.foodItemId,
    required this.foodItemName,
    required this.displayOrder,
    required this.display,
    required this.isActive,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      foodItemId: json['foodItemId'],
      foodItemName: json['foodItemName'],
      displayOrder: json['displayOrder'],
      display: json['display'],
      isActive: json['isActive'],
    );
  }
}
