// // import 'package:blue_print_pos/blue_print_pos.dart';
// import 'package:blue_print_pos/models/models.dart';

// class PrinterState {
//   final BlueDevice? connectedDevice;
//   final List<BlueDevice> scannedDevices;
//   // final BluePrintPos _bluePrintPos = BluePrintPos.instance;
//   final bool isLoading;
//   final bool isConnected;

//   PrinterState({
//     this.connectedDevice,
//    this.scannedDevices=const [],
//     this.isLoading = false,
//     this.isConnected = false,
//   });

//     // BluePrintPos get bluePrintPos => _bluePrintPos;

//   PrinterState copyWith({
//     BlueDevice? connectedDevice,
//     List<BlueDevice>? scannedDevices,
//     bool? isLoading,
//     bool? isConnected,
//   }) {
//     return PrinterState(
//       connectedDevice: connectedDevice ?? this.connectedDevice,
//       scannedDevices: scannedDevices ?? this.scannedDevices,
//       isLoading: isLoading ?? this.isLoading,
//       isConnected: isConnected ?? this.isConnected,
//     );
//   }
// }