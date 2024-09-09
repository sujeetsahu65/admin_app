import 'package:admin_app/constants/global_variables.dart';
import 'package:admin_app/models/food_category.dart';
import 'package:admin_app/models/food_item.dart';
import 'package:admin_app/models/menu_category.dart';
import 'package:admin_app/models/order_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FoodDisplayDataService {
  Future<List<MenuCategory>> fetchFoodData({required languageCode}) async {
    try {
      final token = await getLocalToken();

      final response = await http.get(
        Uri.parse('$uri/basic/food-display-data'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': '$token',
          'lang-code': '$languageCode',
        },
      );

      if (response.statusCode == 200) {
        // final List orderJson = json.decode(response.body)['data']['new_orders'];
        // // print(List);
        // state = orderJson.map((json) => json).toList();

        final List<dynamic> jsonList = json.decode(response.body)['data'];
        return jsonList.map((json) => MenuCategory.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (error) {
      print(error.toString());
      return [];
    }
  }

  Future<List<MenuCategory>> fetchMenuCategories(
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
        // final List orderJson = json.decode(response.body)['data']['new_orders'];
        // // print(List);
        // state = orderJson.map((json) => json).toList();

        final List<dynamic> jsonList =
            json.decode(response.body)['data']['menu_categories'];
        return jsonList.map((json) => MenuCategory.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (error) {
      print(error.toString());
      return [];
    }
  }

  Future<List<FoodCategory>> fetchFoodCategories(
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
        // final List orderJson = json.decode(response.body)['data']['new_orders'];
        // // print(List);
        // state = orderJson.map((json) => json).toList();

        final List<dynamic> jsonList =
            json.decode(response.body)['data']['food_categories'];
        return jsonList.map((json) => FoodCategory.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (error) {
      print(error.toString());
      return [];
    }
  }

  Future<List<FoodItem>> fetchFoodItems(
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
        // final List orderJson = json.decode(response.body)['data']['new_orders'];
        // // print(List);
        // state = orderJson.map((json) => json).toList();

        final List<dynamic> jsonList =
            json.decode(response.body)['data']['food_items'];
        return jsonList.map((json) => FoodItem.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (error) {
      print(error.toString());
      return [];
    }
  }

  Future<bool> updateFoodItemStatus({foodItemId, displayStatus}) async {
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
        return true;
      } else {
        return false;
      }
    } catch (error) {
      print(error.toString());
      return false;
    }
  }
}
