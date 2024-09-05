import 'package:admin_app/constants/global_variables.dart';
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

        final List<dynamic> jsonList =
            json.decode(response.body)['data'];
        return jsonList.map((json) => MenuCategory.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (error) {
      print(error.toString());
      return [];
    }
  }

  Future<bool> setOrderDeliveryTime(Order order) async {
    try {
      final token = await getLocalToken();
      final response = await http.put(
        Uri.parse('$uri/order/delivery-time'),
        body: jsonEncode({
          'order_id': order.orderId,
          'delivery_time': order.setOrderMinutTime,
        }),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': '$token',
          'lang-id': '$localeId',
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
