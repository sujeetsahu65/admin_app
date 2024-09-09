import 'package:admin_app/models/menu_category.dart';
import 'package:admin_app/pages/settings/services/food_display_data.dart';
import 'package:admin_app/providers/language.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final FoodDisplayDataService foodDisplayDataService = FoodDisplayDataService();

class FoodItemState {
  final int selectedMenuCategoryId;
  final int selectedFoodCategoryId;

  FoodItemState(
      {required this.selectedMenuCategoryId,
      required this.selectedFoodCategoryId});
}

final foodItemStateNotifierProvider =
    StateNotifierProvider<FoodItemStateNotifier, FoodItemState>(
  (ref) {
    // Initialize with first category IDs (replace with actual initial IDs from your API response)
    return FoodItemStateNotifier(
        initialMenuCategoryId: 0, initialFoodCategoryId: 0);
  },
);

class FoodItemStateNotifier extends StateNotifier<FoodItemState> {
  FoodItemStateNotifier(
      {required int initialMenuCategoryId, required int initialFoodCategoryId})
      : super(FoodItemState(
          selectedMenuCategoryId: initialMenuCategoryId,
          selectedFoodCategoryId: initialFoodCategoryId,
        ));





        

  void selectMenuCategory(int menuCategoryId,int foodCategoryId) {
    state = FoodItemState(
      selectedMenuCategoryId: menuCategoryId,
      selectedFoodCategoryId: foodCategoryId,
    );
  }

  void selectFoodCategory(int foodCategoryId) {
    state = FoodItemState(
      selectedMenuCategoryId: state.selectedMenuCategoryId,
      selectedFoodCategoryId: foodCategoryId,
    );
  }
}

// final foodItemStateNotifierProvider =
//     StateNotifierProvider.autoDispose<FoodItemStateNotifier, FoodItemState>(
//   (ref) {
//     final foodDisplayData = ref.watch(foodDisplayDataProvider);

//     // Check if the data is loaded and not empty.
//     if (foodDisplayData.hasValue) {
//       // final initialMenuCategoryId = foodDisplayData.first.catgVariantTypeId;
//       final initialMenuCategoryId = foodDisplayData.first.catgVariantTypeId;
//       final initialFoodCategoryId =
//           foodDisplayData.first.foodCategories.first.foodItemCategoryId;
//       return FoodItemStateNotifier(
//         initialMenuCategoryId: initialMenuCategoryId,
//         initialFoodCategoryId: initialFoodCategoryId,
//       );
//     } else {
//       // If data isn't ready yet, return a default state (you can modify this)
//       return FoodItemStateNotifier(
//         initialMenuCategoryId: 0, // Default/fallback IDs
//         initialFoodCategoryId: 0,
//       );
//     }
//   },
// );

// =============== FOOD DISPLAY DATA PROVIDER=========
final foodDisplayDataProvider = StateNotifierProvider.autoDispose<
    FoodDisplayDataNotifier, AsyncValue<List<MenuCategory>>>((ref) {
  return FoodDisplayDataNotifier(ref);
});

class FoodDisplayDataNotifier
    extends StateNotifier<AsyncValue<List<MenuCategory>>> {
  FoodDisplayDataNotifier(this.ref) : super(const AsyncValue.loading()) {
    _loadFoodData();
  }

  final Ref ref;

  Future<void> _loadFoodData() async {
    try {
      // Set state to loading before fetching data
      state = const AsyncValue.loading();

      // Fetch data
      final languageCode = ref.watch(localizationProvider).languageCode;
      final List<MenuCategory> dataList = await foodDisplayDataService
          .fetchFoodData(languageCode: languageCode);

      ref
          .read(foodItemStateNotifierProvider.notifier)
          .selectMenuCategory(dataList.first.catgVariantTypeId, dataList.first.foodCategories.first.foodItemCategoryId);
      // ref.read(foodItemStateNotifierProvider.notifier).selectFoodCategory(
      //     dataList.first.foodCategories.first.foodItemCategoryId);

      // If data is successfully fetched, set it to data state
      state = AsyncValue.data(dataList);
    } catch (e, stackTrace) {
      // If there's an error, set the state to error
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
