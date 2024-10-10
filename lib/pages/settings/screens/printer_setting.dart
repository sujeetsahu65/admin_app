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
    // TODO: implement initState
    super.initState();
    ref.read(printerProvider.notifier).initPrinter();
  }

  @override
  Widget build(BuildContext context) {
    final printerState = ref.watch(printerProvider);
    final printerNotifier = ref.read(printerProvider.notifier);

    return Scaffold(
      body: Column(
        children: [
          if (printerState.errorMessage != null)
            Text(printerState.errorMessage!,
                style: TextStyle(color: Colors.red)),
          Expanded(
            child: ListView.builder(
              itemCount: printerState.devices.length,
              itemBuilder: (context, index) {
                final device = printerState.devices[index];
                return ListTile(
                  tileColor: printerState.connectedDevice == device
                      ? const Color.fromARGB(255, 210, 224, 255)
                      : null,
                  title: Text(device.name ?? 'Unknown Device'),
                  subtitle: Text(device.address ?? 'no device'),
                  onTap: () async {
                    await printerNotifier.connectPrinter(
                        device); // Connect to the selected device
                  },
                  trailing: printerState.connectedDevice == device
                      ? Icon(Icons.check, color: Colors.green)
                      : null,
                );
              },
            ),
          ),
//           if (printerState.isConnected && printerState.connectedDevice != null)
//             Column(
//               children: [
//                 if (printerState.isConnected && printerState.connectedDevice != null)

//                 ...[
//  Text('Connected to: ${printerState.connectedDevice!.name}'),
//                 ElevatedButton(
//                   onPressed: () async {
//                     await printerNotifier.disconnectPrinter(); // Disconnect
//                   },
//                   child: Text('Disconnect'),
//                 ),
//                 ],
//               ],
//             ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () async {
                  await printerNotifier.getDevices(); // Refresh the device list
                },
                child: Text('Search Devices'),
              ),
              if (printerState.isConnected &&
                  printerState.connectedDevice != null)
                ElevatedButton(
                  onPressed: () async {
                    await printerNotifier
                        .printReceipt(); // Print a test receipt
                  },
                  child: Text('Test Print'),
                )
            ],
          ),
        ],
      ),
    );
  }
}
