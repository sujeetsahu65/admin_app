import 'dart:convert';
import 'package:admin_app/constants/global_variables.dart';
import 'package:admin_app/models/report.dart';
import 'package:http/http.dart' as http;

class ReportDataService {

  // Fetch report data based on date range
  Future<Report?> fetchReportData({required String startDate, required String endDate, required languageCode}) async {
final token = await getLocalToken();
    try {
           final response = await http.get(
        Uri.parse('$uri/order/report?start_date=$startDate&end_date=$endDate'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': '$token',
          'lang-code': '$languageCode',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body)['data'];
        // Assuming your Report model has a fromJson factory constructor
        return Report.fromJson(jsonData);
      } else {
        throw Exception("Failed to load report data");
      }
    } catch (e) {
      print("Error fetching report data: $e");
      return null;
    }
  }
}
