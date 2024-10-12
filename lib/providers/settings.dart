import 'package:admin_app/models/settings.dart';
import 'package:admin_app/pages/settings/services/settings.dart';
import 'package:admin_app/providers/error_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsNotifier extends StateNotifier<Settings?> {
  SettingsNotifier(this.ref) : super(null);
  final Ref ref;
  SettingsService settingsService = SettingsService();
  Future<void> fetchSettings() async {
    try {
      final response = await settingsService.getSettings();
      if (response.isSuccess) {
        state = response.data;
      } else {
        ref.read(globalMessageProvider.notifier).showError(response.message);
      }
    } catch (error) {
      ref
          .read(globalMessageProvider.notifier)
          .showError("Something went wrong");
    }
  }

  Future<void> updateSettings(Settings updatedSettings) async {
    try {
      final response = await settingsService.updateSettings(updatedSettings);
      if (response.isSuccess) {
        state = updatedSettings;
        ref.read(globalMessageProvider.notifier).showSuccess(response.message);
      } else {
        ref.read(globalMessageProvider.notifier).showError(response.message);
      }
    } catch (error) {
      ref
          .read(globalMessageProvider.notifier)
          .showError("Something went wrong");
    }
  }
}

final settingsProvider =
    StateNotifierProvider.autoDispose<SettingsNotifier, Settings?>((ref) {
  return SettingsNotifier(ref);
});
