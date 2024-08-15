// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:admin_app/providers/printer.dart';
// import 'package:blue_print_pos/blue_print_pos.dart';
// import 'package:blue_print_pos/models/models.dart';
// import 'package:blue_print_pos/receipt/receipt.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// Future<void> _connectToStoredDevice(WidgetRef ref) async {
//   final BluePrintPos _bluePrintPos = BluePrintPos.instance;
//   final printerStateNotifier = ref.read(printerProvider.notifier);
//   // List<BlueDevice> _blueDevices = <BlueDevice>[];
//   // BlueDevice? _selectedDevice;
//   // bool _isLoading = false;
//   // bool _isConnected = false;
//   // int _loadingAtIndex = -1;
//   BlueDevice? _blueDevice;

//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   final String? storedAddress = prefs.getString('printer_device_address');

//   if (storedAddress != null) {
//     printerStateNotifier.
//     // setState(() => _isLoading = true);

//     final List<BlueDevice> devices = await _bluePrintPos.scan();

//     if (devices.isNotEmpty) {
//       // setState(() {
//       //   _blueDevices = devices;
//       //   _isLoading = false;
//       // });

//       final BlueDevice? device =
//           devices.firstWhere((d) => d.address == storedAddress);

//       if (device != null) {
//         _bluePrintPos.connect(device).then((ConnectionStatus status) {
//           if (status == ConnectionStatus.connected) {
//             // setState(() {
//             //   _selectedDevice = device;
//             //   _isConnected = true;
//             // });
//           }
//           // setState(() => _isLoading = false);
//         });
//       } else {
//         // setState(() => _isLoading = false);
//       }
//     } else {
//       // setState(() => _isLoading = false);
//     }
//   }
// }
