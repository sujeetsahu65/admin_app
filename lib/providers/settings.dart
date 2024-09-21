import 'package:admin_app/models/settings.dart';
import 'package:admin_app/pages/settings/services/settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsNotifier extends StateNotifier<Settings?> {
  SettingsNotifier() : super(null);

  Future<void> fetchSettings() async {
    final settings = await SettingsService.getSettings();
    state = settings;
  }

  Future<void> updateSettings(Settings updatedSettings) async {
    await SettingsService.updateSettings(updatedSettings);
    state = updatedSettings;
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, Settings?>((ref) {
  return SettingsNotifier();
});
