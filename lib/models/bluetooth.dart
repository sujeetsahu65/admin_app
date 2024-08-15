import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothPermissionHandler {
  // final FlutterBluePlus flutterBluePlus = FlutterBluePlus.instance;

  // Method to request Bluetooth permissions and ensure Bluetooth is turned on
  Future<bool> requestAndEnsureBluetooth() async {
    // Request permissions
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.bluetoothAdvertise,
      Permission.locationWhenInUse,
    ].request();

    // Check if any permissions are denied
    bool allPermissionsGranted = statuses.entries
        .every((entry) => entry.value.isGranted || entry.value.isLimited);

    // If any permissions are denied, return false
    if (!allPermissionsGranted) {
      // Open app settings if permissions are permanently denied
      if (statuses.entries.any((entry) => entry.value.isPermanentlyDenied)) {
        openAppSettings();
      }
      return false;
    }

    // Check if Bluetooth is available and enabled
    bool isBluetoothAvailable = await FlutterBluePlus.isSupported;
    if (!isBluetoothAvailable) {
      // Bluetooth is not available on this device
      return false;
    }
// BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;

    //   bool isBluetoothOn = _adapterState == BluetoothAdapterState.on;
    //   if (!isBluetoothOn) {
    // await FlutterBluePlus.turnOn();
    //   }
await FlutterBluePlus.turnOn();
    var subscription = FlutterBluePlus.adapterState
        .listen((BluetoothAdapterState state) async {
      print(state);
      if (state == BluetoothAdapterState.on) {
        print("bllllllll_is on");
        // usually start scanning, connecting, etc
        // await FlutterBluePlus.turnOn();
      } else {
        // show an error to the user, etc
      }
    });

    // All permissions granted and Bluetooth is on
    return true;
  }

  // Helper method to prompt the user to turn on Bluetooth
  Future<bool?> _promptUserToTurnOnBluetooth() async {
    // This function can be enhanced to actually prompt the user
    // For demonstration, we return true to simulate the Bluetooth being turned on
    // In practice, you would use platform-specific code to open Bluetooth settings
    // return await showDialog<bool>(
    //   context: navigatorKey.currentContext!,
    //   builder: (context) {
    //     return AlertDialog(
    //       title: Text('Bluetooth Required'),
    //       content: Text('Bluetooth is turned off. Please enable Bluetooth.'),
    //       actions: [
    //         TextButton(
    //           onPressed: () {
    //             Navigator.of(context).pop(false);
    //           },
    //           child: Text('Cancel'),
    //         ),
    //         TextButton(
    //           onPressed: () {
    //             Navigator.of(context).pop(true);
    //           },
    //           child: Text('Open Bluetooth Settings'),
    //         ),
    //       ],
    //     );
    //   },
    // );

    await FlutterBluePlus.turnOn();
    return true;
  }
}
