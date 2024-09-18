import 'package:admin_app/providers/general_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Settings extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final generalSettings = ref.watch(generalSettingsProvider);

    if (generalSettings == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Print Copies
            Text('Print Copies:'),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(generalSettings.selectedCopyCount.toString()),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          if (generalSettings.selectedCopyCount > 0) {
                            final updatedSettings = generalSettings.copyWith(
                              selectedCopyCount: generalSettings.selectedCopyCount - 1,
                            );
                            ref.read(generalSettingsProvider.notifier).updateGeneralSettings(updatedSettings);
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          if (generalSettings.selectedCopyCount < generalSettings.maxPrintCopies) {
                            final updatedSettings = generalSettings.copyWith(
                              selectedCopyCount: generalSettings.selectedCopyCount + 1,
                            );
                            ref.read(generalSettingsProvider.notifier).updateGeneralSettings(updatedSettings);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Other sections for Print Format, Home Delivery, Online Ordering, etc.
          ],
        ),
      ),
    );
  }



  // Mock API calls for dropdown data
  Future<List<String>> fetchPrintFormats() async {
    // Replace with actual API call
    return ['Print Fromat(CP)', 'Print Format Normal'];
  }

  // Mock API calls for dropdown data
  Future<List<String>> fetchAudios() async {
    // Replace with actual API call
    return ['Nice Alarm', 'School Bell'];
  }

  Future<List<int>> fetchPrintCopies() async {
    // Replace with actual API call
    return [0, 1, 2, 3, 4, 5];
  }
}
