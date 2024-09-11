import 'dart:convert';
import 'package:admin_app/constants/global_variables.dart';
import 'package:admin_app/models/delivery_timing.dart';
import 'package:admin_app/models/lunch_timing.dart';
import 'package:admin_app/models/visiting_timing.dart';
import 'package:http/http.dart' as http;

class ScheduleService {
  // final String baseUrl = 'https://your-api-url/api/timings';

  Future<List<VisitingTiming>> fetchVisitingTimings() async {
     final token = await getLocalToken();
    final response = await http.get(
      Uri.parse('$uri/basic/timing/visiting-timing'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': '$token',
        },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['data']['visting_timings'];
      return jsonResponse.map((data) => VisitingTiming.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load visiting timings');
    }
  }

  Future<List<LunchTiming>> fetchLunchTimings() async {
     final token = await getLocalToken();
    final response = await http.get(
      Uri.parse('$uri/basic/timing/lunch-timing'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': '$token',
        },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['data']['lunch_timings'];
      return jsonResponse.map((data) => LunchTiming.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load lunch timings');
    }
  }

  Future<List<DeliveryTiming>> fetchDeliveryTimings() async {
     final token = await getLocalToken();
    final response = await http.get(
      Uri.parse('$uri/basic/timing/delivery-timing'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': '$token',
        },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['data']['delivery_timings'];
      return jsonResponse.map((data) => DeliveryTiming.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load delivery timings');
    }
  }


  Future<void> updateScheduleData(String field, dynamic newValue, tableData) async {
         final token = await getLocalToken();
  final response = await http.post(
    Uri.parse('$uri/basic/timing/visiting-timing'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': '$token',
        },
    body: jsonEncode({
      'table_name': tableData.tableName,
      'day_number': tableData.dayName,
      'field': field,
      'new_value': newValue,
    }),
  );
  // Handle response or error
}

}
