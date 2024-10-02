import 'dart:convert';
import 'package:admin_app/models/basic_models.dart';
// import 'package:admin_app/providers/basic.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:admin_app/common/widgets/bottom_bar.dart';
// import 'package:admin_app/constants/error_handling.dart';
import 'package:admin_app/constants/global_variables.dart';
// import 'package:admin_app/constants/utils.dart';
import 'package:admin_app/models/language_model.dart';
// import 'package:admin_app/pages/home/screens/home.dart';
// import 'package:admin_app/models/user.dart';
// import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

class BasicService {
  Future<BasicModels> fetchGeneralData() async {
    final token = await getLocalToken();
    final response = await http.get(
      Uri.parse('$uri/basic/general-data'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> generalData =
          json.decode(response.body)['data'];
      return BasicModels.fromJson(generalData);
    }
    throw Exception('Failed to fetch general data');
  }

  Future<List<LanguageContent>> fetchLanguageContent(int languageId) async {
    final response = await http.get(
      Uri.parse('$uri/basic/language-data'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'lang-id': languageId.toString()
      },
    );

// print(jsonDecode(response.body));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body)['data']['language_master'];
      List<LanguageContent> languageContent = body
          .map(
            (dynamic item) => LanguageContent.fromJson(item),
          )
          .toList();
      // print(languageContent);
      return languageContent;
    } else {
      throw Exception('Failed to load language content');
    }
  }
}
