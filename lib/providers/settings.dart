import 'package:admin_app/models/settings.dart';
import 'package:admin_app/pages/settings/services/settings.dart';
import 'package:admin_app/providers/error_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsNotifier extends StateNotifier<Settings?> {
  SettingsNotifier(this.ref) : super(null);
final Ref ref;
  Future<void> fetchSettings() async {
    final response = await SettingsService.getSettings();
    if(response.isSuccess){
    state = response.data;
    }
    else{
        ref.read(globalMessageProvider.notifier).showError('Failed to fetch settings');
    }
  }

  Future<void> updateSettings(Settings updatedSettings) async {
    final response = await SettingsService.updateSettings(updatedSettings);
    if(response.isSuccess){
    state = updatedSettings;
        ref.read(globalMessageProvider.notifier).showSuccess(response.message);
    }
    else{
        ref.read(globalMessageProvider.notifier).showError(response.message);
    }
  }
}

final settingsProvider = StateNotifierProvider.autoDispose<SettingsNotifier, Settings?>((ref) {
  return SettingsNotifier(ref);
});
