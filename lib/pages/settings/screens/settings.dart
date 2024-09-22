import 'package:admin_app/models/settings.dart';
import 'package:admin_app/providers/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class Settings extends ConsumerStatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<Settings> {
  @override
  void initState() {
    super.initState();
    // Fetch the settings when the page is loaded
    ref.read(settingsProvider.notifier).fetchSettings();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);

    if (settings == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
// print(settings.printFormats[0].printFormatId);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First Section: Navigations
            ListTile(
              leading: Icon(Icons.print),
              title: Text('Select Printer'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                GoRouter.of(context).go('/settings/printer-setting');
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_month),
              title: Text('Shop Timings'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                GoRouter.of(context).go('/settings/shop-timings');
              },
            ),
            ListTile(
              leading: Icon(Icons.search),
              title: Text('Order Search'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                GoRouter.of(context).go('/settings/order-search');
              },
            ),
            ListTile(
              leading: Icon(Icons.restaurant),
              title: Text('Product Display'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                GoRouter.of(context).go('/settings/food-item-display');
              },
            ),
            Divider(),
            Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Print Format:'),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      isExpanded: true,
                      value: settings
                          .selectedPrintFormat, // Use selected value from state
                      items: settings.printFormats.map((format) {
                        return DropdownMenuItem<int>(
                          value: format.printFormatId,
                          child: Text(format.printFormatName),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          final updatedSettings =
                              settings.copyWith(selectedPrintFormat: value);
                          ref
                              .read(settingsProvider.notifier)
                              .updateSettings(updatedSettings);
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(height: 8),

                // Print Copies Section
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
                      Text(
                        settings.selectedCopyCount.toString(),
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              if (settings.selectedCopyCount > 0) {
                                final updatedSettings = settings.copyWith(
                                  selectedCopyCount:
                                      settings.selectedCopyCount - 1,
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
                                  selectedCopyCount:
                                      settings.selectedCopyCount + 1,
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

                Divider(),

                // Third Section: Toggle Buttons for Home Delivery and Online Ordering
                SwitchListTile(
                  title: Text('Home Delivery'),
                  value: settings.homeDeliveryFeature == 1,
                  onChanged: (bool value) {
                    final updatedSettings =
                        settings.copyWith(homeDeliveryFeature: value ? 1 : 0);
                    ref
                        .read(settingsProvider.notifier)
                        .updateSettings(updatedSettings);
                  },
                ),
                SwitchListTile(
                  title: Text('Online Ordering'),
                  value: settings.onlineOrderingFeature == 1,
                  onChanged: (bool value) {
                    final updatedSettings =
                        settings.copyWith(onlineOrderingFeature: value ? 1 : 0);
                    ref
                        .read(settingsProvider.notifier)
                        .updateSettings(updatedSettings);
                  },
                )
              ],
            )
            // Second Section: Dropdown for Print Formats
            ,
          ],
        ),
      ),
    );
  }
}
