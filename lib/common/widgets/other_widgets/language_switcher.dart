// import 'package:admin_app/providers/basic_provider.dart';
import 'package:admin_app/providers/language.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Sample language code to flag asset mapping
Map<String, String> languageFlags = {
  'en': 'assets/images/en.png',
  // 'es': 'assets/images/es.png',
  'fi': 'assets/images/fi.png',
  // Add other languages and their corresponding flag paths here
};

class LanguageSwitcher extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final langNotifier = ref.read(localizationProvider.notifier);

    final locale = ref.watch(localizationProvider);
    final currentLanguageCode = locale.languageCode;
    final languageCodes = ['en', 'fi'];

    return GestureDetector(
      onTap: () async {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
        if (languageCodes.length == 2) {
          // Toggle between two languages
          final newLanguageCode = languageCodes.firstWhere(
            (code) => code != currentLanguageCode,
          );
          langNotifier.changeLanguage(newLanguageCode);
         await prefs.setString('language-code', newLanguageCode);
        }

      },
      child: languageCodes.length == 2
          ? _buildFlag(languageFlags[
              languageCodes.firstWhere((code) => code == currentLanguageCode)]!)
          : _buildDropdown(
              context, langNotifier, currentLanguageCode, languageCodes),
    );
  }

  Widget _buildFlag(String flagAsset) {
    return Image.asset(
      flagAsset,
      width: 24,
      height: 24,
    );
  }

  Widget _buildDropdown(
      BuildContext context,
      LocalizationNotifier localizationNotifier,
      currentLanguageCode,
      languageCodes) {
    return DropdownButton<String>(
      value: currentLanguageCode,
      icon: Icon(Icons.arrow_drop_down),
      onChanged: (String? newLanguageCode) {
        if (newLanguageCode != null) {
          localizationNotifier.changeLanguage(newLanguageCode);
        }
      },
      items: languageCodes.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Row(
            children: [
              _buildFlag(languageFlags[value]!),
              SizedBox(width: 8),
              Text(value.toUpperCase()),
            ],
          ),
        );
      }).toList(),
    );
  }
}
