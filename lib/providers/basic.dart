import 'package:admin_app/models/basic_models.dart';
import 'package:admin_app/pages/auth/services/basic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_preferences/shared_preferences.dart';

final BasicService basicService = BasicService();

// Define a StateProvider for the language ID
final languageIdProvider = StateProvider<int>((ref) {
  return 2; // Default language ID
});

// Define a StateNotifier to manage language content
class LanguageContentNotifier extends StateNotifier<Map<String, String>> {
  LanguageContentNotifier() : super({});

  Future<void> loadLanguageContent(int languageId) async {
    // print("jjjjjjjjjjjj");
    // print(languageId);
    final prefs = await SharedPreferences.getInstance();
    try {
      final content = await basicService.fetchLanguageContent(languageId);
      // print(content.toString());
      // Convert the list of maps into a map of header-title pairs
      final Map<String, String> contentMap = {
        for (var item in content) item.header: item.title
      };

      prefs.setInt('lang_id', languageId);
      state = contentMap;
      // print(state);
    } catch (e) {
      print(e);
      // Handle errors
      state = {};
    }
  }
}

// Define a provider for the LanguageContentNotifier
final languageContentProvider =
    StateNotifierProvider<LanguageContentNotifier, Map<String, String>>(
        (ref) => LanguageContentNotifier());

// Enum to represent supported languages
// enum AppLanguage { english, finnish }

// // State provider for the selected language
// final selectedLanguageProvider = StateProvider<AppLanguage>((ref) => AppLanguage.english);

// ==================

// Enum to represent supported languages
// enum AppLanguage { english, finnish, estonian }
enum AppLanguage { english, finnish }

// Map of language values
const Map<AppLanguage, int> languageValues = {
  AppLanguage.english: 1,
  AppLanguage.finnish: 2,
};

// State provider for the selected language
final selectedLanguageProvider =
    StateProvider<AppLanguage>((ref) => AppLanguage.english);

final generalDataProvider =
    StateNotifierProvider<GeneralDataNotifier, BasicModels>(
        (ref) => GeneralDataNotifier());

class GeneralDataNotifier extends StateNotifier<BasicModels> {
  GeneralDataNotifier() : super(BasicModels.initial()){}

  Future<void> loadGeneralData() async {
    final generalData = await basicService.fetchGeneralData();
    state = generalData;
  }
}



// ================LOADER==========

class LoadingNotifier extends StateNotifier<bool> {
  LoadingNotifier() : super(false);

  void showLoader() => state = true;
  void hideLoader() => state = false;
}

final loadingProvider = StateNotifierProvider<LoadingNotifier, bool>(
  (ref) => LoadingNotifier(),
);
