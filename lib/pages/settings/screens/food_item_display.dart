import 'package:admin_app/common/widgets/other_widgets/customFont.dart';
import 'package:admin_app/providers/food_item_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FoodItemDisplay extends ConsumerStatefulWidget {
  @override
  _FoodItemDisplayState createState() => _FoodItemDisplayState();
}

class _FoodItemDisplayState extends ConsumerState<FoodItemDisplay>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    final menuCategoryNotifier = ref.read(menuCategoryProvider.notifier);
    menuCategoryNotifier.loadMenuCategories();
  }

  @override
  Widget build(BuildContext context) {
    final asyncMenuCategories = ref.watch(menuCategoryProvider);

    return asyncMenuCategories.when(
      data: (menuCategories) {
        // print('Menu categories loaded');
        final state = ref.watch(foodItemStateNotifierProvider);

        if (_tabController == null) {
          _tabController =
              TabController(length: menuCategories.length, vsync: this);
          _tabController?.addListener(_handleTabChange);
        }

        return Scaffold(
          body: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: _buildFoodCategoriesAndItems(),
                ),
              ],
            ),
          ),
          bottomNavigationBar: TabBar(
            labelColor: Colors.blue,
            controller: _tabController,
            tabs: menuCategories
                .map((menuCategory) =>
                    Tab(text: menuCategory.catgVariantTypeName))
                .toList(),
          ),
        );
      },
      loading: () => Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Scaffold(
        body: Center(child: Text('Error: $error')),
      ),
    );
  }

  void _handleTabChange() {
    if (_tabController!.indexIsChanging) {
      // print('Tab changed');
      final asyncMenuCategories = ref.watch(menuCategoryProvider);
      final menuCategories = asyncMenuCategories.value!;
      final selectedMenuCategoryId =
          menuCategories[_tabController!.index].catgVariantTypeId;

      ref
          .read(foodCategoryProvider.notifier)
          .loadFoodCategories(selectedMenuCategoryId);
      ref
          .read(foodItemStateNotifierProvider.notifier)
          .selectMenuCategory(selectedMenuCategoryId);
    }
  }

  @override
  void dispose() {
    _tabController?.removeListener(_handleTabChange);
    _tabController?.dispose();
    super.dispose();
  }

  Widget _buildFoodCategoriesAndItems() {
    final asyncFoodCategories = ref.watch(foodCategoryProvider);

    return asyncFoodCategories.when(
      data: (foodCategories) {
        final asyncFoodItems = ref.watch(foodItemProvider);

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomFont(
                  text: 'Category',
                  fontWeight: FontWeight.bold,
                ).large(),
                DropdownButton<int>(
                  value: ref
                      .watch(foodItemStateNotifierProvider)
                      .selectedFoodCategoryId,
                  items: foodCategories.map((foodCategory) {
                    return DropdownMenuItem<int>(
                      value: foodCategory.foodItemCategoryId,
                      child: Text(foodCategory.categoryName),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(foodItemProvider.notifier).loadFoodItems(value);
                      ref
                          .read(foodItemStateNotifierProvider.notifier)
                          .selectFoodCategory(value);
                    }
                  },
                ),
              ],
            ),
            // Divider()
            //  ,
            SizedBox(height: 4,),
            asyncFoodItems.when(
              data: (foodItems) {
                return Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Table Header
                        Table(
                           border: TableBorder.symmetric(inside: BorderSide(width: 0.2)),
                          columnWidths: {
                            0: FlexColumnWidth(7), // 70% width for food item
                            1: FlexColumnWidth(
                                3), // 30% width for display status
                          },
                          children: [
                            
                            TableRow(
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 229, 229, 229)),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CustomFont(text: 'Food Item',fontWeight: FontWeight.bold,textAlign: TextAlign.center).mediumHigh(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CustomFont(text: 'Status',fontWeight: FontWeight.bold,textAlign: TextAlign.center).mediumHigh(),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Table(
                          // border: TableBorder.symmetric(inside: BorderSide(width: 0.2)),
                       
                          border: TableBorder(bottom: BorderSide(width: 0.2), verticalInside: BorderSide(width: 0.2),horizontalInside: BorderSide(width: 0.2)),
                          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                          columnWidths: {
                            0: FlexColumnWidth(7),
                            1: FlexColumnWidth(3),

                          },
                          children: foodItems.map((foodItem) {
                            return TableRow(
                              // decoration: BoxDecoration(
                              //   border: Border(
                              //     bottom: BorderSide(color: Colors.grey[300]!),
                              //   ),
                              // ),
                              children: [
                                
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(foodItem.foodItemName),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Switch(
                                    value: foodItem.display == 1,
                                    onChanged: (bool value) {
                                      // Call the notifier to toggle the display status
                                      ref
                                          .read(foodItemProvider.notifier)
                                          .toggleFoodItemDisplay(
                                              foodItem.foodItemId,
                                              foodItem.display == 1);
                                    },
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                );
              },
              loading: () =>
                  Expanded(child: Center(child: CircularProgressIndicator())),
              error: (error, stackTrace) =>
                  Expanded(child: Center(child: Text('Error: $error'))),
            ),
          ],
        );
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
    );
  }
}
