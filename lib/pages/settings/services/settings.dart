import 'dart:convert';
import 'package:admin_app/constants/global_variables.dart';
import 'package:admin_app/models/settings.dart';
import 'package:http/http.dart' as http;

class SettingsService {

 static Future<Settings> getSettings() async {
    final token = await getLocalToken();
    final response = await http.get(
      Uri.parse('$uri/basic/settings'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> generalData =
          json.decode(response.body)['data']['general_settings'];
      return Settings.fromJson(generalData);
    }
    throw Exception('Failed to fetch general data');
  }

 static Future<void> updateSettings(Settings settings) async {

    final token = await getLocalToken();
    final response = await http.put(
      Uri.parse('$uri/basic/settings'),
        body: jsonEncode(settings.toJson()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update general settings');
    }

    print("update settings called");
  }
}
