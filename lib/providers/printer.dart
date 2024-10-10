import 'package:admin_app/models/bluetooth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';

// StateNotifier for managing Bluetooth device list and connection status
class PrinterStateNotifier extends StateNotifier<PrinterState> {
  PrinterStateNotifier() : super(PrinterState()) {
    // _initPrinter();
  }

  final BlueThermalPrinter _bluetooth = BlueThermalPrinter.instance;

  Future<void> initPrinter() async {
    try {
      bool isConnected = await _bluetooth.isConnected ?? false;
      if (!isConnected) {
        final BluetoothPermissionHandler _bluetoothPermissionHandler = BluetoothPermissionHandler();
        await _bluetoothPermissionHandler.requestAndEnsureBluetooth();
      }
      await getDevices();
    } catch (e) {
      state = state.copyWith(errorMessage: 'Bluetooth initialization failed');
    }
  }

  Future<void> getDevices() async {
    try {
      List<BluetoothDevice> devices = await _bluetooth.getBondedDevices();
      state = state.copyWith(devices: devices);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to fetch devices');
    }
  }

  Future<void> connectPrinter(BluetoothDevice device) async {
    try {
      await _bluetooth.connect(device);
      state = state.copyWith(connectedDevice: device, isConnected: true);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to connect');
    }
  }

  Future<void> disconnectPrinter() async {
    try {
      await _bluetooth.disconnect();
      state = state.copyWith(connectedDevice: null, isConnected: false);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to disconnect');
    }
  }

  Future<void> printReceipt() async {
    if (state.isConnected) {
      _bluetooth.printCustom('RECEIPT', 3, 1);
      _bluetooth.printLeftRight('Item', 'Price', 1);
      _bluetooth.printLeftRight('Burger', '\$5.99', 1);
      _bluetooth.printLeftRight('Fries', '\$2.99', 1);
      _bluetooth.printLeftRight('Coke', '\$1.99', 1);
      _bluetooth.printCustom('Total: \$10.97', 2, 1);
      _bluetooth.printQRcode('www.example.com', 200, 200, 1);
      _bluetooth.paperCut();
    }
  }
}

class PrinterState {
  final List<BluetoothDevice> devices;
  final BluetoothDevice? connectedDevice;
  final bool isConnected;
  final bool isLoading;
  final String? errorMessage;

  PrinterState({
    this.devices = const [],
    this.connectedDevice,
    this.isConnected = false,
    this.isLoading = false,
    this.errorMessage,
  });

  PrinterState copyWith({
    List<BluetoothDevice>? devices,
    BluetoothDevice? connectedDevice,
    bool? isConnected,
     bool? isLoading,
    String? errorMessage,
  }) {
    return PrinterState(
      devices: devices ?? this.devices,
      connectedDevice: connectedDevice ?? this.connectedDevice,
      isConnected: isConnected ?? this.isConnected,
        isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// Provide the PrinterStateNotifier
final printerProvider = StateNotifierProvider<PrinterStateNotifier, PrinterState>(
  (ref) => PrinterStateNotifier(),
);
