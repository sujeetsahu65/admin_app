import 'package:admin_app/constants/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final localizationProvider =
    StateNotifierProvider<LocalizationNotifier, Locale>(
  (ref) => LocalizationNotifier(),
);

class LocalizationNotifier extends StateNotifier<Locale> {
  LocalizationNotifier() : super(Locale(defaultLangCode));

  void changeLanguage(String languageCode) async {
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setString('language_code', languageCode);

    // print("changeLanguage:$languageCode");
    switch (languageCode) {
      case 'en':
        localeId = 1;
      case 'fi':
        localeId = 2;
      case 'es':
        localeId = 3;
    }
    state = Locale(languageCode);
  }

  void setCachedLanguage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final langCode =  prefs.getString('language-code');
    if (langCode != null) {
      changeLanguage(langCode);
    }
  }
}
