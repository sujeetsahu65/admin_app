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


    // Add a copyWith method to easily update display status
  FoodItem copyWith({int? display}) {
    return FoodItem(
      foodItemId: this.foodItemId,
      foodItemName: this.foodItemName,
      displayOrder: this.displayOrder,
      isActive: this.isActive,
      display: display ?? this.display,
    );
  }


}
