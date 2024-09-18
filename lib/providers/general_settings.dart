import 'package:admin_app/models/general_settings.dart';
import 'package:admin_app/pages/settings/services/settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GeneralSettingsNotifier extends StateNotifier<GeneralSettings?> {
  GeneralSettingsNotifier() : super(null);

  Future<void> fetchGeneralSettings() async {
    final settings = await GeneralSettingsService.getGeneralSettings();
    state = settings;
  }

  Future<void> updateGeneralSettings(GeneralSettings updatedSettings) async {
    await GeneralSettingsService.updateGeneralSettings(updatedSettings);
    state = updatedSettings;
  }
}

final generalSettingsProvider = StateNotifierProvider<GeneralSettingsNotifier, GeneralSettings?>((ref) {
  return GeneralSettingsNotifier();
});
