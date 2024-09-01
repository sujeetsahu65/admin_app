import 'package:admin_app/constants/global_variables.dart';
import 'package:admin_app/models/combo_offer_model.dart';
import 'package:admin_app/models/order_items_model.dart';
import 'package:admin_app/models/order_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderService {
  Future<List<Order>> fetchOrders({mode = 'newOrders', required languageCode}) async {
    try {
      final token = await getLocalToken();
      late final path;
      late final dataKey;
      if (mode == 'receivedOrders') {
        path = 'received-orders';
        dataKey = 'received_orders';
      } else if (mode == 'preOrders') {
        path = 'pre-orders';
        dataKey = 'pre_orders';
      } else if (mode == 'cancelledOrders') {
        path = 'cancelled-orders';
        dataKey = 'cancelled_orders';
      } else {
        path = 'new-orders';
         dataKey = 'new_orders';
      }
      final response = await http.get(
        Uri.parse('$uri/order/$path'),
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
            json.decode(response.body)['data'][dataKey];
        return jsonList.map((json) => Order.fromJson(json)).toList();
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

  Future<bool> setPreOrderAlertTime(Order order) async {
    try {
      final token = await getLocalToken();
      final response = await http.put(
        Uri.parse('$uri/order/pre-order/alert-time'),
        body: jsonEncode({
          'order_id': order.orderId,
          'alert_time': order.preOrderResponseAlertTime,
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

  Future<bool> concludeOrder(Order order) async {
    try {
      final token = await getLocalToken();
      final response = await http.put(
        Uri.parse('$uri/order/conclude'),
        body: jsonEncode({
          'order_id': order.orderId,
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

  Future<bool> cancelOrder(Order order) async {
    try {
      final token = await getLocalToken();
      final response = await http.put(
        Uri.parse('$uri/order/cancel'),
        body: jsonEncode({
          'order_id': order.orderId,
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

  Future<Map<String, List>> fetchOrderItems({orderId,required languageCode}) async {
    try {
      final token = await getLocalToken();
      final response = await http.get(
        Uri.parse(
            '$uri/order/order-items?order_id=$orderId&include_toppings=1'),
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

        List<dynamic> orderItemsJson =
            json.decode(response.body)['data']['order_items'];

        List<dynamic> comboOfferItemsJson =
            json.decode(response.body)['data']['combo_offer_items'];

        List<OrderItem> orderItems =
            orderItemsJson.map((json) => OrderItem.fromJson(json)).toList();

        List<ComboOfferItem> comboOfferItems = comboOfferItemsJson
            .map((json) => ComboOfferItem.fromJson(json))
            .toList();

        return {'orderItems': orderItems, 'comboOfferItems': comboOfferItems};
      } else {
        return {};
      }
    } catch (error) {
      print(error.toString());
      return {};
    }
  }
}
