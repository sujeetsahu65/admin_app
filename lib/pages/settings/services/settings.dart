import 'dart:convert';
import 'package:admin_app/models/general_settings.dart';
import 'package:http/http.dart' as http;

class GeneralSettingsService {
  static const String apiUrl = 'https://yourapi.com/settings';

  static Future<GeneralSettings> getGeneralSettings() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return GeneralSettings.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load general settings');
    }
  }

  static Future<void> updateGeneralSettings(GeneralSettings settings) async {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(settings.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update general settings');
    }
  }
}
