import 'package:admin_app/common/widgets/other_widgets/loader.dart';
import 'package:admin_app/providers/printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:blue_thermal_printer/blue_thermal_printer.dart';

class PrinterSetting extends ConsumerStatefulWidget {
  @override
  _PrinterSettingState createState() => _PrinterSettingState();
}

class _PrinterSettingState extends ConsumerState<PrinterSetting> {
  @override
  void initState() {
    super.initState();
    ref.read(printerProvider.notifier).initPrinter();
  }

  @override
  Widget build(BuildContext context) {
    final printerState = ref.watch(printerProvider);
    final printerNotifier = ref.read(printerProvider.notifier);

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              if (!printerState.isConnected && printerState.errorMessage != null)
                Text(printerState.errorMessage!, style: TextStyle(color: Colors.red)),
              Expanded(
                child: ListView.builder(
                  itemCount: printerState.devices.length,
                  itemBuilder: (context, index) {
                    final device = printerState.devices[index];
                    return ListTile(
                      tileColor: printerState.isConnected && printerState.connectedDevice == device
                          ? const Color.fromARGB(255, 210, 224, 255)
                          : null,
                      title: Text(device.name ?? 'Unknown Device'),
                      subtitle: Text(device.address ?? 'no device'),
                      onTap: () async {
                        await printerNotifier.connectPrinter(device); // Connect to the selected device
                      },
                      trailing: printerState.isConnected && printerState.connectedDevice == device
                          ? Icon(Icons.check, color: Colors.green)
                          : null,
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0), // Add margin around the Row
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          await printerNotifier.getDevices(); // Refresh the device list
                        },
                        child: Text('Search Devices'),
                      ),
                    ),
                    SizedBox(width: 16), // Add space between the two buttons
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (printerState.isConnected && printerState.connectedDevice != null) {
                            await printerNotifier.testPrint(); // Print a test receipt
                          }
                        },
                        child: Text('Test Print'),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            printerState.isConnected && printerState.connectedDevice != null
                                ? null
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
            GlobalLoader(),
        ],
      ),
    );
  }
}

