import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

// String uri = 'https://api.foozu3.fi/admin-app';
String uri = 'http://localhost:8000/admin-app';
String defaultLangCode = 'fi';
int localeId = 2;
Future getLocalToken() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('x-auth-token');
  return token;
}


class GlobalVariables {
  // COLORS
  static const appBarGradient = LinearGradient(
    colors: [
      Color.fromARGB(255, 29, 201, 192),
      Color.fromARGB(255, 125, 221, 216),
    ],
    stops: [0.5, 1.0],
  );

  static const secondaryColor = Color.fromRGBO(41, 6, 177, 1);
  static const backgroundColor = Colors.white;
  static const Color greyBackgroundCOlor = Color(0xffebecee);
  static var selectedNavBarColor = Colors.cyan[800]!;
  static const unselectedNavBarColor = Colors.black87;

  // STATIC IMAGES
  static const List<String> carouselImages = [
    'https://images-eu.ssl-images-amazon.com/images/G/31/img21/Wireless/WLA/TS/D37847648_Accessories_savingdays_Jan22_Cat_PC_1500.jpg',
    'https://images-eu.ssl-images-amazon.com/images/G/31/img2021/Vday/bwl/English.jpg',
    'https://images-eu.ssl-images-amazon.com/images/G/31/img22/Wireless/AdvantagePrime/BAU/14thJan/D37196025_IN_WL_AdvantageJustforPrime_Jan_Mob_ingress-banner_1242x450.jpg',
    'https://images-na.ssl-images-amazon.com/images/G/31/Symbol/2020/00NEW/1242_450Banners/PL31_copy._CB432483346_.jpg',
    'https://images-na.ssl-images-amazon.com/images/G/31/img21/shoes/September/SSW/pc-header._CB641971330_.jpg',
  ];

  static const List<Map<String, String>> categoryImages = [
    {
      'title': 'Mobiles',
      'image': 'assets/images/mobiles.jpeg',
    },
    {
      'title': 'Essentials',
      'image': 'assets/images/essentials.jpeg',
    },
    {
      'title': 'Appliances',
      'image': 'assets/images/appliances.jpeg',
    },
    {
      'title': 'Books',
      'image': 'assets/images/books.jpeg',
    },
    {
      'title': 'Fashion',
      'image': 'assets/images/fashion.jpeg',
    },
  ];
}

class FontSizes {
  static const double extraSmall = 10.0;
  static const double small = 12.0;
  static const double medium = 15.0;
  static const double large = 18.0;
  static const double extraLarge = 24.0;
}

class TZ {
  static DateTime now() {
    final now = tz.TZDateTime.now(tz.local);
    final nowString = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    DateTime.parse(nowString);
    // return DateTime.parse(nowString);
    return DateTime.now();
  }

  static String currentDate() {
    final now = tz.TZDateTime.now(tz.local);
    return DateFormat('yyyy-MM-dd').format(now);
  }

  static String currentDateTime() {
    final now = tz.TZDateTime.now(tz.local);
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
  }
}
