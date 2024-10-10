import 'package:admin_app/providers/printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';

class PrinterSettingsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final printerState = ref.watch(printerProvider);
    final printerNotifier = ref.read(printerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('Printer Settings'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              await printerNotifier.getDevices(); // Refresh the device list
            },
            child: Text('Search for Bluetooth Devices'),
          ),
          if (printerState.errorMessage != null)
            Text(printerState.errorMessage!, style: TextStyle(color: Colors.red)),
          Expanded(
            child: ListView.builder(
              itemCount: printerState.devices.length,
              itemBuilder: (context, index) {
                final device = printerState.devices[index];
                return ListTile(
                  title: Text(device.name ?? 'Unknown Device'),
                  subtitle: Text(device.address??'no device'),
                  onTap: () async {
                    await printerNotifier.connectPrinter(device); // Connect to the selected device
                  },
                  trailing: printerState.connectedDevice == device
                      ? Icon(Icons.check, color: Colors.green)
                      : null,
                );
              },
            ),
          ),
          if (printerState.isConnected && printerState.connectedDevice != null)
            Column(
              children: [
                Text('Connected to: ${printerState.connectedDevice!.name}'),
                ElevatedButton(
                  onPressed: () async {
                    await printerNotifier.disconnectPrinter(); // Disconnect
                  },
                  child: Text('Disconnect'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await printerNotifier.printReceipt(); // Print a test receipt
                  },
                  child: Text('Print Test Receipt'),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
