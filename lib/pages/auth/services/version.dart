import 'dart:convert';

// import 'package:admin_app/common/widgets/show_version_dialog.dart';
import 'package:admin_app/constants/global_variables.dart';
import 'package:http/http.dart' as http;
// import 'package:package_info_plus/package_info_plus.dart';

Future<Map> fetchLatestVersion() async {
    // final Uri _url = Uri.parse('https://flutter.dev');
  var url = '$uri/basic/version';
  var response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body)['data']; 
  
    return data;
    
  } else {
    throw Exception('Failed to fetch latest version');
  }
}

Future<void> checkAppUpdate(context) async {


//   Map latestVersion = await fetchLatestVersion();
//  final version = latestVersion['version'];
//     final update_url = latestVersion['update_url'];
//   PackageInfo packageInfo = await PackageInfo.fromPlatform();
//     print("packageInfo.version: ${packageInfo.version}");

//   if (version != packageInfo.version) {
//     // Show update dialog or notification
//     // showVersionDialog(context,update_url); // Implement this method
//   }
}
