import 'package:admin_app/providers/printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:blue_print_pos/blue_print_pos.dart';


class Settings extends ConsumerStatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  ConsumerState<Settings> createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<Settings> {

  @override
  void initState() {
    super.initState();
    final printerNotifier = ref.read(printerProvider.notifier);

    // printerNotifier.checkPrinterConnection();
    printerNotifier.connectToStoredDevice();
  }
// class Settings extends ConsumerWidget {
  @override
  Widget build(BuildContext context) {
    final printerState = ref.watch(printerProvider);
    final printerNotifier = ref.read(printerProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: printerState.isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              )
            : Column(
                children: [
                 ...[

//  Text('${printerState.connectedDevice!.address}')
                 ],
                  printerState.connectedDevice != null && printerState.isConnected
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                // 'Connected to: ${printerState.connectedDevice!.name}',
                                'Connected to: ${printerState.connectedDevice!.name}',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Address: ${printerState.connectedDevice!.address}',
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              ElevatedButton(
                                onPressed: () =>
                                    printerNotifier.disconnectDevice(),
                                child: Text('Disconnect'),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: printerState.scannedDevices.length,
                      itemBuilder: (context, index) {
                        final device = printerState.scannedDevices[index];
                        return ListTile(
                          title: Text(device.name),
                          subtitle: Text(device.address),
                          onTap: () => printerNotifier.selectDevice(device),
                          trailing: printerState.isLoading &&
                                  printerState.connectedDevice?.address ==
                                      device.address
                              ? CircularProgressIndicator()
                              : null,
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            printerState.isLoading ? null : () => printerNotifier.scanDevices(),
        child: const Icon(Icons.search),
        backgroundColor: printerState.isLoading ? Colors.grey : Colors.blue,
      ),
    );
  }
}
