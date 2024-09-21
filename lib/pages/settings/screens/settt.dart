import 'package:admin_app/providers/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Settings extends ConsumerStatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<Settings> {

@override
  void initState() {

    final initSettings = ref.read(settingsProvider.notifier).fetchSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);

    if (settings == null) {
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
                  Text(settings.selectedCopyCount.toString()),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          if (settings.selectedCopyCount > 0) {
                            final updatedSettings = settings.copyWith(
                              selectedCopyCount: settings.selectedCopyCount - 1,
                            );
                            ref
                                .read(settingsProvider.notifier)
                                .updateSettings(updatedSettings);
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          if (settings.selectedCopyCount <
                              settings.maxPrintCopies) {
                            final updatedSettings = settings.copyWith(
                              selectedCopyCount: settings.selectedCopyCount + 1,
                            );
                            ref
                                .read(settingsProvider.notifier)
                                .updateSettings(updatedSettings);
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
    return ['Print Format (CP)', 'Print Format Normal'];
  }

  Future<List<String>> fetchAudios() async {
    // Replace with actual API call
    return ['Nice Alarm', 'School Bell'];
  }

  Future<List<int>> fetchPrintCopies() async {
    // Replace with actual API call
    return [0, 1, 2, 3, 4, 5];
  }
}
