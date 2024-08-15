import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';



final localizationProvider = StateNotifierProvider<LocalizationNotifier, Locale>(
  (ref) => LocalizationNotifier(),
);

class LocalizationNotifier extends StateNotifier<Locale> {
  LocalizationNotifier() : super(Locale('en'));

  void changeLanguage(String languageCode) {

    print("changeLanguage:$languageCode");
    state = Locale(languageCode);
  }
}
