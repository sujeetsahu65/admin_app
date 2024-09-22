import 'package:admin_app/constants/global_variables.dart';
import 'package:admin_app/models/food_category.dart';
import 'package:admin_app/models/food_item.dart';
import 'package:admin_app/models/menu_category.dart';
import 'package:admin_app/models/order_model.dart';
import 'package:admin_app/providers/error_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FoodDisplayDataService {
  // Future<List<MenuCategory>> fetchFoodData({required languageCode}) async {
  //   try {
  //     final token = await getLocalToken();

  //     final response = await http.get(
  //       Uri.parse('$uri/basic/food-display-data'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'x-auth-token': '$token',
  //         'lang-code': '$languageCode',
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       // final List orderJson = json.decode(response.body)['data']['new_orders'];
  //       // // print(List);
  //       // state = orderJson.map((json) => json).toList();

  //       final List<dynamic> jsonList = json.decode(response.body)['data'];
  //       return jsonList.map((json) => MenuCategory.fromJson(json)).toList();
  //     } else {
  //       return [];
  //     }
  //   } catch (error) {
  //     print(error.toString());
  //     return [];
  //   }
  // }

 Future<ApiResponse<List<MenuCategory>>> fetchMenuCategories(
      {required languageCode}) async {
    try {
      final token = await getLocalToken();

      final response = await http.get(
        Uri.parse('$uri/basic/menu/menu-categories'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': '$token',
          'lang-code': '$languageCode',
        },
      );

      if (response.statusCode == 200) {


        final List<dynamic> jsonList =
            json.decode(response.body)['data']['menu_categories'];
        final data = jsonList.map((json) => MenuCategory.fromJson(json)).toList();
         return ApiResponse(
            data: data, statusCode: 200);
      } else {
             final errorMsg = json.decode(response.body)['message'];
        return ApiResponse(statusCode: response.statusCode, message: errorMsg);
      }
    } catch (error) {
      // print(error.toString());
      return ApiResponse(statusCode: 503, message: error.toString());
    }
  }

  Future<ApiResponse<List<FoodCategory>>> fetchFoodCategories(
      {required menuCategoryId, required languageCode}) async {
    try {
      final token = await getLocalToken();

      final response = await http.get(
        Uri.parse(
            '$uri/basic/menu/food-categories?menu_category_id=$menuCategoryId'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': '$token',
          'lang-code': '$languageCode',
        },
      );

      if (response.statusCode == 200) {

        final List<dynamic> jsonList =
            json.decode(response.body)['data']['food_categories'];
        final data = jsonList.map((json) => FoodCategory.fromJson(json)).toList();

         return ApiResponse(
            data: data, statusCode: 200);
      } else {
             final errorMsg = json.decode(response.body)['message'];
        return ApiResponse(statusCode: response.statusCode, message: errorMsg);
      }
    } catch (error) {
      // print(error.toString());
      return ApiResponse(statusCode: 503, message: error.toString());
    }
  }

  Future<ApiResponse<List<FoodItem>>> fetchFoodItems(
      {required foodCategoryId, required languageCode}) async {
    try {
      final token = await getLocalToken();

      final response = await http.get(
        Uri.parse(
            '$uri/basic/menu/food-items?food_category_id=$foodCategoryId'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': '$token',
          'lang-code': '$languageCode',
        },
      );

      if (response.statusCode == 200) {

        final List<dynamic> jsonList =
            json.decode(response.body)['data']['food_items'];
        final data =  jsonList.map((json) => FoodItem.fromJson(json)).toList();
         return ApiResponse(
            data: data, statusCode: 200);
      } else {
             final errorMsg = json.decode(response.body)['message'];
        return ApiResponse(statusCode: response.statusCode, message: errorMsg);
      }
    } catch (error) {
      // print(error.toString());
      return ApiResponse(statusCode: 503, message: error.toString());
    }
  }

  Future<ApiResponse<bool>> updateFoodItemStatus({foodItemId, displayStatus}) async {
    try {
      final token = await getLocalToken();
      final response = await http.put(
        Uri.parse(
            '$uri/basic/menu/food-item-display?food_item_id=$foodItemId&display_status=$displayStatus'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': '$token',
        },
      );

      if (response.statusCode == 200) {
        final data =  true;
         return ApiResponse(
            data: data, statusCode: 200);
      } else {
             final errorMsg = json.decode(response.body)['message'];
        return ApiResponse(statusCode: response.statusCode, message: errorMsg);
      }
    } catch (error) {
      // print(error.toString());
      return ApiResponse(statusCode: 503, message: error.toString());
    }
  }
}
