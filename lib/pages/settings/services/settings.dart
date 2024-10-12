import 'dart:convert';
import 'package:admin_app/constants/global_variables.dart';
import 'package:admin_app/constants/http.dart';
import 'package:admin_app/models/settings.dart';
import 'package:admin_app/providers/error_handler.dart';
// import 'package:http/http.dart' as http;

class SettingsService {
  final HttpClientService httpClient = HttpClientService();

  Future<ApiResponse<Settings>> getSettings() async {
    try {
      final token = await getLocalToken();

      final url = '$uri/basic/settings';
      final Map<String, String> headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token,
      };

      final response = await httpClient.getRequest(url, headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> generalData =
            json.decode(response.body)['data']['general_settings'];

        return ApiResponse(
            data: Settings.fromJson(generalData), statusCode: 200);

        // return Settings.fromJson(generalData);
      } else {
        final errorMsg = json.decode(response.body)['message'];
        return ApiResponse(statusCode: response.statusCode, message: errorMsg);
      }
    } catch (error) {
      return ApiResponse(statusCode: 503, message: error.toString());
    }
  }

  Future<ApiResponse> updateSettings(Settings settings) async {
    try {
      final token = await getLocalToken();

      final url = '$uri/basic/settings';
      final Map<String, String> headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token,
      };

      final response =
          await httpClient.putRequest(url, settings.toJson(), headers: headers);

      if (response.statusCode == 200) {
        return ApiResponse(
            statusCode: 200, message: 'Setting updated successfully');
      } else {
        final errorMsg = json.decode(response.body)['message'];
        return ApiResponse(statusCode: response.statusCode, message: errorMsg);
      }
    } catch (error) {
      return ApiResponse(statusCode: 503, message: error.toString());
    }
  }
}
