import 'package:admin_app/models/menu_category.dart';
import 'package:admin_app/models/food_category.dart';
import 'package:admin_app/models/food_item.dart';
import 'package:admin_app/pages/settings/services/food_item_display.dart';
import 'package:admin_app/providers/error_handler.dart';
import 'package:admin_app/providers/language.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final FoodDisplayDataService foodDisplayDataService = FoodDisplayDataService();

// Menu Categories Provider
final menuCategoryProvider =
    StateNotifierProvider<MenuCategoryNotifier, AsyncValue<List<MenuCategory>>>(
        (ref) {
  return MenuCategoryNotifier(ref);
});

// Food Categories Provider
final foodCategoryProvider =
    StateNotifierProvider<FoodCategoryNotifier, AsyncValue<List<FoodCategory>>>(
        (ref) {
  return FoodCategoryNotifier(ref);
});

// Food Items Provider
final foodItemProvider =
    StateNotifierProvider<FoodItemNotifier, AsyncValue<List<FoodItem>>>((ref) {
  return FoodItemNotifier(ref);
});

// State Notifier for the selected categories
class FoodItemState {
  final int selectedMenuCategoryId;
  final int selectedFoodCategoryId;

  FoodItemState({
    required this.selectedMenuCategoryId,
    required this.selectedFoodCategoryId,
  });
}

final foodItemStateNotifierProvider =
    StateNotifierProvider<FoodItemStateNotifier, FoodItemState>((ref) {
  return FoodItemStateNotifier(
      initialMenuCategoryId: 0, initialFoodCategoryId: 0);
});

class FoodItemStateNotifier extends StateNotifier<FoodItemState> {
  FoodItemStateNotifier(
      {required int initialMenuCategoryId, required int initialFoodCategoryId})
      : super(FoodItemState(
          selectedMenuCategoryId: initialMenuCategoryId,
          selectedFoodCategoryId: initialFoodCategoryId,
        ));

  void selectMenuCategory(int menuCategoryId) {
    state = FoodItemState(
      selectedMenuCategoryId: menuCategoryId,
      selectedFoodCategoryId:
          0, // Reset food category when a new menu category is selected
    );
  }

  void selectFoodCategory(int foodCategoryId) {
    state = FoodItemState(
      selectedMenuCategoryId: state.selectedMenuCategoryId,
      selectedFoodCategoryId: foodCategoryId,
    );
  }
}

// Notifier to fetch Menu Categories
class MenuCategoryNotifier
    extends StateNotifier<AsyncValue<List<MenuCategory>>> {
  final Ref ref;
  MenuCategoryNotifier(this.ref) : super(const AsyncValue.loading()) {
    // _loadMenuCategories();
  }

  Future<void> loadMenuCategories() async {
    try {
      state = const AsyncValue.loading();
      final languageCode = ref.watch(localizationProvider).languageCode;

      final ApiResponse<List<MenuCategory>> response =
          await foodDisplayDataService.fetchMenuCategories(
              languageCode: languageCode);
      if (response.isSuccess) {
        final menuCategories = response.data!;
        if (mounted && menuCategories.isNotEmpty) {
          // Select the first menu category by default
          ref
              .read(foodItemStateNotifierProvider.notifier)
              .selectMenuCategory(menuCategories.first.catgVariantTypeId);
          ref
              .read(foodCategoryProvider.notifier)
              .loadFoodCategories(menuCategories.first.catgVariantTypeId);

          state = AsyncValue.data(menuCategories);
        }
      } else {
        ref.read(globalMessageProvider.notifier).showError(response.message);
      }
    } catch (e, stackTrace) {
      if (mounted) {
        state = AsyncValue.error(e, stackTrace);
      }
    }
  }
}

// Notifier to fetch Food Categories
class FoodCategoryNotifier
    extends StateNotifier<AsyncValue<List<FoodCategory>>> {
  final Ref ref;
  FoodCategoryNotifier(this.ref) : super(const AsyncValue.loading());

  Future<void> loadFoodCategories(int menuCategoryId) async {
    try {
      state = const AsyncValue.loading();
      final languageCode = ref.watch(localizationProvider).languageCode;
      final ApiResponse<List<FoodCategory>> response =
          await foodDisplayDataService.fetchFoodCategories(
              menuCategoryId: menuCategoryId, languageCode: languageCode);
  if (response.isSuccess) {

final foodCategories= response.data!;

      if (mounted && foodCategories.isNotEmpty) {
        // Select the first food category by default
        ref
            .read(foodItemStateNotifierProvider.notifier)
            .selectFoodCategory(foodCategories.first.foodItemCategoryId);
        ref
            .read(foodItemProvider.notifier)
            .loadFoodItems(foodCategories.first.foodItemCategoryId);
        state = AsyncValue.data(foodCategories);
      }


    }

    else{
 ref.read(globalMessageProvider.notifier).showError(response.message);

    }
    } catch (e, stackTrace) {
      if (mounted) {
        state = AsyncValue.error(e, stackTrace);
      }
    }
  }
}

// Notifier to fetch Food Items
class FoodItemNotifier extends StateNotifier<AsyncValue<List<FoodItem>>> {
  final Ref ref;
  FoodItemNotifier(this.ref) : super(const AsyncValue.loading());

  Future<void> loadFoodItems(int foodCategoryId) async {
      final languageCode = ref.watch(localizationProvider).languageCode;
      state = const AsyncValue.loading();
    try {
      final ApiResponse<List<FoodItem>> response =
          await foodDisplayDataService.fetchFoodItems(
              foodCategoryId: foodCategoryId, languageCode: languageCode);

            final  foodItems = response.data!;

                if (response.isSuccess) {
      if (mounted) {
        state = AsyncValue.data(foodItems);
      }

    }

    else{
 ref.read(globalMessageProvider.notifier).showError(response.message);

    }

    } catch (e, stackTrace) {
      if (mounted) {
        state = AsyncValue.error(e, stackTrace);
      }
    }
  }

  // New method to toggle the display status of a food item
  Future<void> toggleFoodItemDisplay(
      int foodItemId, bool currentDisplayStatus) async {
    try {
      // Call the API to update the display status in the database
      final response = await foodDisplayDataService.updateFoodItemStatus(
          foodItemId: foodItemId, displayStatus: currentDisplayStatus ? 0 : 1);

      if (response.isSuccess) {
        state = state.whenData((foodItems) {
          return foodItems.map((foodItem) {
            if (foodItem.foodItemId == foodItemId) {
              return foodItem.copyWith(display: currentDisplayStatus ? 0 : 1);
            }
            return foodItem;
          }).toList();
        });

        // ref.read(globalMessageProvider.notifier).showSuccess("uuuuuuuu");
      } else {
        ref.read(globalMessageProvider.notifier).showError(response.message);
      }
    } catch (e, stackTrace) {
      // Revert the state if the API call fails
      state = AsyncValue.error(e, stackTrace);
      ref.read(globalMessageProvider.notifier).showError(e.toString());
    }
  }
}
