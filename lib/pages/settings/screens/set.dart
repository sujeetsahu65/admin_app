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
  TabController? _tabController;

  @override
  Widget build(BuildContext context) {
    final asyncFoodDisplayData = ref.watch(foodDisplayDataProvider);

    return asyncFoodDisplayData.when(
      data: (foodDisplayData) {
        final state = ref.watch(foodItemStateNotifierProvider);

        if (foodDisplayData.isEmpty) {
          return Scaffold(
            body: Center(child: Text('No data available')),
          );
        }

        _tabController ??= TabController(
          length: foodDisplayData.length,
          vsync: this,
        );

        _tabController!.addListener(() {
          if (_tabController!.indexIsChanging) {
            final selectedMenuCategoryId =
                foodDisplayData[_tabController!.index].catgVariantTypeId;
            ref
                .read(foodItemStateNotifierProvider.notifier)
                .selectMenuCategory(selectedMenuCategoryId);
          }
        });

        final selectedMenuCategory = foodDisplayData.firstWhere(
          (menuCategory) =>
              menuCategory.catgVariantTypeId == state.selectedMenuCategoryId,
          orElse: () => foodDisplayData.first,
        );

        final selectedFoodCategory =
            selectedMenuCategory.foodCategories.firstWhere(
          (foodCategory) =>
              foodCategory.foodItemCategoryId == state.selectedFoodCategoryId,
          orElse: () => selectedMenuCategory.foodCategories.first,
        );

        return Scaffold(
          appBar: AppBar(
            title: Text('Food Category'),
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
              // Header
              Container(
                color: Colors.grey[200],
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 7, // 70% width
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          'Item Name',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3, // 30% width
                      child: Text(
                        'Display Status',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: selectedFoodCategory.foodItems.length,
                  itemBuilder: (context, index) {
                    final foodItem = selectedFoodCategory.foodItems[index];
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 7, // 70% width
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Text(foodItem.foodItemName),
                            ),
                          ),
                          Expanded(
                            flex: 3, // 30% width
                            child: Switch(
                              value: foodItem.display == 1,
                              onChanged: (bool value) {
                                updateFoodItemDisplayStatus(
                                    foodItem.foodItemId, value ? 1 : 0);
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          bottomNavigationBar: TabBar(
            controller: _tabController,
            tabs: foodDisplayData.map((menuCategory) {
              return Tab(
                text: menuCategory.catgVariantTypeName,
              );
            }).toList(),
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
          ),
        );
      },
      loading: () => Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => Scaffold(
        body: Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  void updateFoodItemDisplayStatus(int foodItemId, int displayStatus) {
    // Implement API call to update display status
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }
}
