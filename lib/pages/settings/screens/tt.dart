import 'package:admin_app/models/menu_category.dart';
import 'package:admin_app/providers/food_item_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsPage extends ConsumerStatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    final foodDisplayData = ref.read(foodDisplayDataProvider);
    _tabController = TabController(length: foodDisplayData.length, vsync: this);

    // Select the first menu category by default
    if (foodDisplayData.isNotEmpty) {
      ref.read(foodItemStateNotifierProvider.notifier).selectMenuCategory(
          foodDisplayData.first.catgVariantTypeId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<MenuCategory> foodDisplayData =
        ref.watch(foodDisplayDataProvider);
    final state = ref.watch(foodItemStateNotifierProvider);

    if (foodDisplayData.isEmpty) {
      return Scaffold(
        body: Center(child: Text('No data available')),
      );
    }

    final selectedMenuCategory = foodDisplayData.firstWhere(
      (menuCategory) =>
          menuCategory.catgVariantTypeId == state.selectedMenuCategoryId,
      orElse: () => foodDisplayData.first,
    );

    final selectedFoodCategory = selectedMenuCategory.foodCategories.firstWhere(
      (foodCategory) =>
          foodCategory.foodItemCategoryId == state.selectedFoodCategoryId,
      orElse: () => selectedMenuCategory.foodCategories.first,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Product Display View'),
        actions: [
          DropdownButton<int>(
            value: state.selectedFoodCategoryId,
            items: selectedMenuCategory.foodCategories
                .map<DropdownMenuItem<int>>((category) {
              return DropdownMenuItem<int>(
                value: category.foodItemCategoryId,
                child: Text(category.categoryName),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                ref
                    .read(foodItemStateNotifierProvider.notifier)
                    .selectFoodCategory(value);
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: selectedFoodCategory.foodItems.length,
              itemBuilder: (context, index) {
                final foodItem = selectedFoodCategory.foodItems[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(foodItem.foodItemName),
                      Switch(
                        value: foodItem.display == 1,
                        onChanged: (bool value) {
                          updateFoodItemDisplayStatus(
                              foodItem.foodItemId, value ? 1 : 0);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          tabs: foodDisplayData.map((menuCategory) {
            return Tab(
              text: menuCategory.catgVariantTypeName,
            );
          }).toList(),
          onTap: (index) {
            final selectedMenuCategory = foodDisplayData[index];
            ref
                .read(foodItemStateNotifierProvider.notifier)
                .selectMenuCategory(selectedMenuCategory.catgVariantTypeId);
          },
        ),
      ),
    );
  }

  void updateFoodItemDisplayStatus(int foodItemId, int displayStatus) {
    // Implement API call to update display status
    // Example:
    // await api.updateFoodItemDisplayStatus(foodItemId, displayStatus);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
