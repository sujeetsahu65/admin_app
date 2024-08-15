import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void showVersionDialog(context,updateUrl) {


  showDialog(
    context: context,
    barrierDismissible: false, // Prevent user from dismissing dialog
    
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('New Update Available'),
        content: Text('A new version of the app is available. Please update to the latest version.'),
        actions: <Widget>[
          TextButton(
            child: Text('Update'),
            onPressed: ()async {
             if (!await launchUrl(updateUrl)) {
    throw Exception('Could not launch $updateUrl');
  }
            },
          ),
        ],
      );
    },
  );
}
