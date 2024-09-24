import 'dart:convert';
import 'package:admin_app/constants/global_variables.dart';
import 'package:admin_app/models/delivery_timing.dart';
import 'package:admin_app/models/lunch_timing.dart';
import 'package:admin_app/models/timing.dart';
import 'package:admin_app/models/visiting_timing.dart';
import 'package:admin_app/providers/error_handler.dart';
import 'package:http/http.dart' as http;

class ScheduleService {
  // final String baseUrl = 'https://your-api-url/api/timings';

  Future<ApiResponse<List<TimingModel>>> fetchTimings(tableName) async {
    late final path;
    if (tableName == 'visiting_timings') {
      path = "visiting-timing";
    } else if (tableName == 'lunch_timings') {
      path = "lunch-timing";
    } else if (tableName == 'delivery_timings') {
      path = "delivery-timing";
    }

    try {
      final token = await getLocalToken();
      final response = await http.get(
        Uri.parse('$uri/basic/timing/$path'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': '$token',
        },
      );

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body)['data'][tableName];
        final data =
            jsonResponse.map((data) => TimingModel.fromJson(data)).toList();
        return ApiResponse(data: data, statusCode: 200);
      } else {
        final errorMsg = json.decode(response.body)['message'];
        return ApiResponse(statusCode: response.statusCode, message: errorMsg);
      }
    } catch (error) {
      return ApiResponse(statusCode: 503, message: error.toString());
    }
  }

  // Future<List<LunchTiming>> fetchLunchTimings() async {
  //   final token = await getLocalToken();
  //   final response = await http.get(
  //     Uri.parse('$uri/basic/timing/lunch-timing'),
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'x-auth-token': '$token',
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     List jsonResponse = json.decode(response.body)['data']['lunch_timings'];
  //     return jsonResponse.map((data) => LunchTiming.fromJson(data)).toList();
  //   } else {
  //     throw Exception('Failed to load lunch timings');
  //   }
  // }

  // Future<List<DeliveryTiming>> fetchDeliveryTimings() async {
  //   final token = await getLocalToken();
  //   final response = await http.get(
  //     Uri.parse('$uri/basic/timing/delivery-timing'),
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'x-auth-token': '$token',
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     List jsonResponse =
  //         json.decode(response.body)['data']['delivery_timings'];
  //     return jsonResponse.map((data) => DeliveryTiming.fromJson(data)).toList();
  //   } else {
  //     throw Exception('Failed to load delivery timings');
  //   }
  // }

  Future<ApiResponse> updateScheduleData(
      String field, dynamic newValue, tableData) async {
    try {
      final token = await getLocalToken();
      final response = await http.put(
        Uri.parse('$uri/basic/timing/schedule-update'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': '$token',
        },
        body: jsonEncode({
          'table_name': tableData.tableName,
          'day_number': tableData.dayNumber,
          'field': field,
          'new_value': newValue,
        }),
      );

      if (response.statusCode == 200) {
        return ApiResponse(data: true, statusCode: 200);
      } else {
        final errorMsg = json.decode(response.body)['message'];
        return ApiResponse(statusCode: response.statusCode, message: errorMsg);
      }
    } catch (error) {
      return ApiResponse(statusCode: 503, message: error.toString());
    }

    // Handle response or error
  }
}
