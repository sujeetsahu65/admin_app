import 'package:admin_app/constants/global_variables.dart';
import 'package:admin_app/constants/http.dart';
import 'package:admin_app/models/combo_offer_model.dart';
import 'package:admin_app/models/order_items_model.dart';
import 'package:admin_app/models/order_model.dart';
import 'package:admin_app/providers/error_handler.dart';
// import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dio/dio.dart';

class OrderService {
  final Dio _dio = Dio();
  final HttpClientService httpClient = HttpClientService();
// TO DO: =========
  // final Dio _dio = Dio(BaseOptions(
  //   baseUrl: 'https://api.example.com',
  //   headers: {
  //     'Authorization': 'Bearer your_token',  // Example of Authorization header
  //     'Content-Type': 'application/json',    // Example of Content-Type
  //   },
  // ));

  Future<ApiResponse<List<Order>>> fetchOrders(
      {mode = 'newOrders', required languageCode}) async {
    try {
      final token = await getLocalToken();
      late final String path;
      late final String dataKey;
      if (mode == 'receivedOrders') {
        path = 'received-orders';
        dataKey = 'received_orders';
      } else if (mode == 'preOrders') {
        path = 'pre-orders';
        dataKey = 'pre_orders';
      } else if (mode == 'failedOrders') {
        path = 'failed-orders';
        dataKey = 'failed_orders';
      } else if (mode == 'cancelledOrders') {
        path = 'cancelled-orders';
        dataKey = 'cancelled_orders';
      } else {
        path = 'new-orders';
        dataKey = 'new_orders';
      }

      final url = '$uri/order/$path';
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'x-auth-token': token,
        'lang-code': languageCode,
      };

      final response = await httpClient.getRequest(url, headers: headers);

      //   final response = await http.get(
      //     Uri.parse('$uri/order/$path'),
      //     headers: {
      //       'Content-Type': 'application/json',
      //       'x-auth-token': '$token',
      //       'lang-code': '$languageCode',
      //     },
      //   ).timeout(
      //   Duration(seconds: 20), // Set the timeout duration
      //   // onTimeout: () {
      //   //   // Optional: handle the timeout case
      //   //   return http.Response(json.encode('Request Timeout111'), 408); // You can return a custom response here
      //   //   //  return ApiResponse(statusCode: 408, message: "Timeout of 10 secs");
      //   // },
      // );

      if (response.statusCode == 200) {
        print("uuuuuuuuuu");
        // final List orderJson = json.decode(response.body)['data']['new_orders'];
        // // print(List);
        // state = orderJson.map((json) => json).toList();

        final List<dynamic> jsonList =
            json.decode(response.body)['data'][dataKey];
        final data = jsonList.map((json) => Order.fromJson(json)).toList();
        return ApiResponse(data: data, statusCode: 200);
      } else {
        final errorMsg = json.decode(response.body)['message'];
        print("$errorMsg");
        return ApiResponse(statusCode: response.statusCode, message: errorMsg);
      }
    } catch (error) {
      print(error);
      return ApiResponse(statusCode: 503, message: error.toString());
    }
  }

  Future<ApiResponse<bool>> setOrderDeliveryTime(Order order) async {
    try {
      final token = await getLocalToken();

      final url = '$uri/order/delivery-time';
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'x-auth-token': token,
      };
      final Map<String, dynamic> body = {
        'order_id': order.orderId,
        'delivery_time': order.setOrderMinutTime,
      };

      final response = await httpClient.putRequest(url, body, headers: headers,timeoutDuration: 5);

      if (response.statusCode == 200) {
        return ApiResponse(data: true, statusCode: 200);
      } else {
        final errorMsg = json.decode(response.body)['message'];
        return ApiResponse(statusCode: response.statusCode, message: errorMsg);
      }
    } catch (error) {
      return ApiResponse(statusCode: 503, message: error.toString());
    }
  }

  Future<ApiResponse<bool>> setPreOrderAlertTime(Order order) async {
    try {
      final token = await getLocalToken();

      final url = '$uri/order/pre-order/alert-time';
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'x-auth-token': token,
      };
      final Map<String, dynamic> body = {
        'order_id': order.orderId,
        'alert_time': order.preOrderResponseAlertTime,
      };

      final response = await httpClient.putRequest(url, body, headers: headers,timeoutDuration: 5);

      if (response.statusCode == 200) {
        return ApiResponse(data: true, statusCode: 200);
      } else {
        final errorMsg = json.decode(response.body)['message'];
        return ApiResponse(statusCode: response.statusCode, message: errorMsg);
      }
    } catch (error) {
      return ApiResponse(statusCode: 503, message: error.toString());
    }
  }

  Future<ApiResponse<bool>> concludeOrder(Order order) async {
    try {
      final token = await getLocalToken();

      final url = '$uri/order/conclude';
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'x-auth-token': token,
      };
      final Map<String, dynamic> body = {
        'order_id': order.orderId,
      };

      final response = await httpClient.putRequest(url, body, headers: headers,timeoutDuration: 5);

      if (response.statusCode == 200) {
        return ApiResponse(data: true, statusCode: 200);
      } else {
        final errorMsg = json.decode(response.body)['message'];
        return ApiResponse(statusCode: response.statusCode, message: errorMsg);
      }
    } catch (error) {
      return ApiResponse(statusCode: 503, message: error.toString());
    }
  }

  Future<ApiResponse<bool>> cancelOrder(Order order) async {
    try {
      final token = await getLocalToken();

      final url = '$uri/order/cancel';
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'x-auth-token': token,
      };
      final Map<String, dynamic> body = {
        'order_id': order.orderId,
      };

      final response = await httpClient.putRequest(url, body, headers: headers,timeoutDuration: 5);

      if (response.statusCode == 200) {
        return ApiResponse(data: true, statusCode: 200);
      } else {
        final errorMsg = json.decode(response.body)['message'];
        return ApiResponse(statusCode: response.statusCode, message: errorMsg);
      }
    } catch (error) {
      return ApiResponse(statusCode: 503, message: error.toString());
    }
  }

  Future<ApiResponse<bool>> moveFailedOrder(Order order) async {
    try {
      final token = await getLocalToken();

      final url = '$uri/order/move-failed-order';
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'x-auth-token': token,
      };
      final Map<String, dynamic> body = {
        'order_id': order.orderId,
      };

      final response = await httpClient.putRequest(url, body, headers: headers,timeoutDuration: 5);

      if (response.statusCode == 200) {
        return ApiResponse(data: true, statusCode: 200);
      } else {
        final errorMsg = json.decode(response.body)['message'];
        return ApiResponse(statusCode: response.statusCode, message: errorMsg);
      }
    } catch (error) {
      return ApiResponse(statusCode: 503, message: error.toString());
    }
  }

  Future<ApiResponse<Map<String, List>>> fetchOrderItems(
      {orderId, required languageCode}) async {
    try {
      final token = await getLocalToken();

      final url = '$uri/order/order-items?order_id=$orderId&include_toppings=1';
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'x-auth-token': token,
        'lang-code': '$languageCode',
      };

      final response = await httpClient.getRequest(url, headers: headers);

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

        final data = {
          'orderItems': orderItems,
          'comboOfferItems': comboOfferItems
        };
        return ApiResponse(data: data, statusCode: 200);
      } else {
        final errorMsg = json.decode(response.body)['message'];
        return ApiResponse(statusCode: response.statusCode, message: errorMsg);
      }
    } catch (error) {
      return ApiResponse(statusCode: 503, message: error.toString());
    }
  }

  Future<ApiResponse<Order?>> fetchOrderDetails(
      {required String query, required languageCode}) async {
    try {
      final token = await getLocalToken();

      //       final url = '$uri/order/order-details';
      // final Map<String, String> headers = {
      //   'Content-Type': 'application/json',
      //   'x-auth-token': token,
      //    'lang-code': '$languageCode',
      // };

      // final response = await httpClient.getRequest(url, headers: headers);

      final response = await _dio.get('$uri/order/order-details',
          queryParameters: {
            'order_id':
                query.isNotEmpty && query.startsWith('ID') ? query : null,
            'order_number':
                query.isNotEmpty && !query.startsWith('ID') ? query : null,
          },
          options: Options(headers: {
            'Content-Type': 'application/json',
            'x-auth-token': '$token',
            'lang-code': '$languageCode',
          }));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData =
            response.data['data']['order_details'];
        final data = Order.fromJson(jsonData);
        return ApiResponse(data: data, statusCode: 200);
      } else {
        final errorMsg = json.decode(response.data)['message'];
        return ApiResponse(
            statusCode: response.statusCode ?? 404, message: errorMsg);
      }
    } on DioException catch (error) {
      return ApiResponse(statusCode: 404, message: 'Order not found');
    }
  }
}
