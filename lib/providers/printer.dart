import 'package:admin_app/models/basic_models.dart';
import 'package:admin_app/models/bluetooth.dart';
import 'package:admin_app/models/combo_offer_model.dart';
import 'package:admin_app/models/order_items_model.dart';
import 'package:admin_app/models/order_model.dart';
import 'package:admin_app/models/printer.dart';
import 'package:admin_app/models/toppings_model.dart';
import 'package:admin_app/providers/basic.dart';
import 'package:admin_app/providers/order.dart';
import 'package:blue_print_pos/models/blue_device.dart';
import 'package:blue_print_pos/models/connection_status.dart';
import 'package:blue_print_pos/receipt/receipt_section_text.dart';
import 'package:blue_print_pos/receipt/receipt_text_size_type.dart';
import 'package:blue_print_pos/receipt/receipt_text_style_type.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';
import 'package:blue_print_pos/blue_print_pos.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

final bluePrintPosProvider = Provider<BluePrintPos>((ref) {
  return BluePrintPos.instance;
});

final printerProvider =
    StateNotifierProvider<PrinterNotifier, PrinterState>((ref) {
  final bluePrintPos = ref.read(bluePrintPosProvider);
  return PrinterNotifier(bluePrintPos,ref);
});

class PrinterNotifier extends StateNotifier<PrinterState> {
  final BluetoothPermissionHandler _bluetoothPermissionHandler =
      BluetoothPermissionHandler();

        final Ref ref;


  final BluePrintPos _bluePrintPos;

  PrinterState printerState = PrinterState();
  // final BluePrintPos _bluePrintPos = printerState.bluePrintPos;
//  final BluePrintPos _bluePrintPos = BluePrintPos.instance;
  PrinterNotifier(this._bluePrintPos,this.ref) : super(PrinterState());

  Future<void> connectToStoredDevice() async {
    await _bluePrintPos.disconnect();
    await _bluetoothPermissionHandler.requestAndEnsureBluetooth();
    print('jhnskjfnkshgjhgbjbhjhb');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? storedAddress = prefs.getString('printer_address');

    if (storedAddress != null) {
      state = state.copyWith(isLoading: true);

      final List<BlueDevice> devices = await _bluePrintPos.scan();

      if (devices.isNotEmpty) {
        final BlueDevice? device = devices.firstWhere(
          (d) => d.address == storedAddress,
          orElse: () => null as BlueDevice,
        );

        if (device != null) {
          final ConnectionStatus status = await _bluePrintPos.connect(device);
          if (status == ConnectionStatus.connected) {
            state = state.copyWith(
              connectedDevice: device,
              isConnected: true,
              isLoading: false,
            );
          } else {
            state = state.copyWith(isLoading: false, isConnected: false);
          }
        } else {
          state = state.copyWith(isLoading: false);
        }
      }
    }
  }

  Future<void> checkPrinterConnection() async {
    final isConnected =
        await _bluePrintPos.isConnected; // Method to check connection status
    if (isConnected) {
      final connectedDevice =
          await _bluePrintPos.selectedDevice; // Fetch connected device info
      state = state.copyWith(
        isConnected: true,
        connectedDevice: connectedDevice,
      );
    } else {
      state = state.copyWith(
        isConnected: false,
        connectedDevice: null,
      );
    }
  }

  void disconnectDevice() async {
    final ConnectionStatus status = await _bluePrintPos.disconnect();
    if (status == ConnectionStatus.disconnect) {
      print("disconnectedddddddddd");
      state = state.copyWith(
          connectedDevice: null, isConnected: false, isLoading: false);
    }
  }

  Future<void> scanDevices() async {
//  await _bluetoothPermissionHandler.requestAndEnsureBluetooth();
//  await _bluetoothPermissionHandler.;
//

    state = state.copyWith(isLoading: true);
    final List<BlueDevice> devices = await _bluePrintPos.scan();
    state = state.copyWith(scannedDevices: devices, isLoading: false);
    // Handle the scanned devices as needed
  }

  void selectDevice(BlueDevice device) async {
    // final tt= disconnectDevice();
    print("selelelelele");
    state = state.copyWith(isLoading: true);
    final ConnectionStatus status = await _bluePrintPos.connect(device);
    if (status == ConnectionStatus.connected) {
      print('connecttttttttttttttttttt');
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('printer_address', device.address);
      state = state.copyWith(
        connectedDevice: device,
        isConnected: true,
        isLoading: false,
      );

// final ReceiptSectionText receiptHeadText = ReceiptSectionText();

//       receiptHeadText.addText(
//       'EXTRA LARGE BOLD',
//       size: ReceiptTextSizeType.extraLarge,
//       style: ReceiptTextStyleType.bold,
//     );
//     // await _bluePrintPos.printReceiptText(receiptHeadText);
//     // final ReceiptSectionText receiptSecondText = ReceiptSectionText();
//       await _bluePrintPos.printReceiptText(receiptHeadText, feedCount: 0);
    } else {
      print('not connecttttttttttttttttttt');
      state = state.copyWith(isLoading: false, isConnected: false);
    }
  }

  Future<void> printReceipt(Order order, BasicModels basicDataProvider) async {

    ref.read(loadingProvider.notifier).showLoader();
// await _bluetoothPermissionHandler.requestAndEnsureBluetooth();
    final ReceiptSectionText receiptHeadText = ReceiptSectionText();
    final ReceiptSectionText receiptBody1Text = ReceiptSectionText();
    final ReceiptSectionText receiptBody2Text = ReceiptSectionText();

//  final orderItemsData = ref.watch(orderItemsProvider(order.orderId));

final orderItemsData = await orderService.fetchOrderItems(order.orderId);

      List<OrderItem> orderItems =
            List<OrderItem>.from(orderItemsData['orderItems'] ?? []);
        List<ComboOfferItem> comboOfferItems =
            List<ComboOfferItem>.from(orderItemsData['comboOfferItems'] ?? []);



// ==============

    receiptHeadText.addText(
      basicDataProvider.locationMaster.disName.toUpperCase(),
      size: ReceiptTextSizeType.extraLarge,
      style: ReceiptTextStyleType.bold,
    );
    receiptHeadText.addText(
      order.orderNO,
      size: ReceiptTextSizeType.large,
      style: ReceiptTextStyleType.bold,
    );
    receiptHeadText.addText(
      order.orderDateTime.toString(),
      size: ReceiptTextSizeType.large,
      style: ReceiptTextStyleType.normal,
    );
    receiptHeadText.addText(
      order.deliveryTypeTitle,
      size: ReceiptTextSizeType.large,
      style: ReceiptTextStyleType.bold,
    );

    // receiptHeadText.addSpacer(useDashed: true);
    // receiptHeadText.;

      receiptHeadText.addText(
      '----------------------',
      size: ReceiptTextSizeType.extraLarge,
      style: ReceiptTextStyleType.bold,
    );

    receiptHeadText.addText(
      '${order.firstName} ${order.lastName}',
      size: ReceiptTextSizeType.large,
      style: ReceiptTextStyleType.bold,
    );
    receiptHeadText.addText(
      order.userMobileNo,
      size: ReceiptTextSizeType.large,
      style: ReceiptTextStyleType.bold,
    );
    if(order.deliveryTypeId ==1){

    receiptHeadText.addText(
      // "${order.userAddress} ${order.userBuildingNo.isNotEmpty?', '+order.userBuildingNo:','}",
      "${order.userAddress}${order.userBuildingNo.isNotEmpty ? ', ${order.userBuildingNo}' : ','}",
      size: ReceiptTextSizeType.large,
      style: ReceiptTextStyleType.bold,
    );

    receiptHeadText.addText(
      order.userZipcode+', '+order.userCity,
      size: ReceiptTextSizeType.large,
      style: ReceiptTextStyleType.bold,
    );

    }
// ===============

  for (int i = 0; i < orderItems.length; i++) {
    final item = orderItems[i];
    
    // Print item quantity, name, and size
    receiptBody1Text.addLeftRightText(
      '${item.itemOrderQty} x ${item.foodItemName}(${item.itemSizeName})',
      '${item.totalBasicPrice}€',
   leftStyle: ReceiptTextStyleType.bold,
          rightStyle: ReceiptTextStyleType.bold,
          leftSize: ReceiptTextSizeType.medium,
          rightSize: ReceiptTextSizeType.medium,
    );

    // Print extra comment if available
    if (item.foodExtratext.isNotEmpty) {
      receiptBody1Text.addText(
        'Extra Comment:',
        style: ReceiptTextStyleType.bold,
        size: ReceiptTextSizeType.medium,
      );
      receiptBody1Text.addText(item.foodExtratext, size: ReceiptTextSizeType.medium);
    }

    // Print toppings
    for (var entry in item.toppingsByVariantOption.entries) {
      receiptBody1Text.addText(
        entry.key,
        style: ReceiptTextStyleType.bold,
        size: ReceiptTextSizeType.medium,
      );
      for (var topping in entry.value) {
        receiptBody1Text.addLeftRightText(
          topping.toppingslistname,
          '${topping.foodVariantOptionPrice}€',
          leftStyle: ReceiptTextStyleType.normal,
          rightStyle: ReceiptTextStyleType.normal,
          leftSize: ReceiptTextSizeType.medium,
          rightSize: ReceiptTextSizeType.medium,
        );
      }
    }

    // Add a divider if there are more items and not a combo offer
    // if (i < orderItems.length - 1 && !isComboOffer) {
    //   receiptBody1Text.addSpacer(useDashed: true);
    // }
    if(i<(orderItems.length-1)){
      receiptBody1Text.addText(
      '----------------------',
      size: ReceiptTextSizeType.extraLarge,
      style: ReceiptTextStyleType.bold,
    );

    }
  }


  // ===========Combooffers==========
if(comboOfferItems.isNotEmpty){
   receiptBody2Text.addText(
        'Combo Offer',
        style: ReceiptTextStyleType.bold,
        size: ReceiptTextSizeType.large,
      );
}

for (int j = 0; j< comboOfferItems.length; j++) {
final comboItem = comboOfferItems[j];

    receiptBody2Text.addLeftRightText(
      '${comboItem.comboName}',
      '${comboItem.totalPrice}€',
   leftStyle: ReceiptTextStyleType.bold,
          rightStyle: ReceiptTextStyleType.bold,
          leftSize: ReceiptTextSizeType.medium,
          rightSize: ReceiptTextSizeType.medium,
    );



for (int k = 0; k < comboOfferItems[j].orderItems.length; k++) {
    final comboFooditem = comboOfferItems[j].orderItems[k];
    
    // Print comboFooditem quantity, name, and size
    receiptBody2Text.addText(
      '${comboFooditem.itemOrderQty} x ${comboFooditem.foodItemName}(${comboFooditem.itemSizeName})',
      // style: ReceiptTextStyleType.bold,
        size: ReceiptTextSizeType.medium,
    );

    // Print extra comment if available
    if (comboFooditem.foodExtratext.isNotEmpty) {
      receiptBody2Text.addText(
        'Extra Comment:',
        style: ReceiptTextStyleType.bold,
        size: ReceiptTextSizeType.medium,
      );
      receiptBody2Text.addText(comboFooditem.foodExtratext, size: ReceiptTextSizeType.medium);
    }

    // Print toppings
    for (var tentry in comboFooditem.toppingsByVariantOption.entries) {
      receiptBody2Text.addText(
        tentry.key,
        style: ReceiptTextStyleType.bold,
        size: ReceiptTextSizeType.medium,
      );
      for (var topping in tentry.value) {
        receiptBody2Text.addLeftRightText(
          topping.toppingslistname,
          '${topping.foodVariantOptionPrice}€',
          leftStyle: ReceiptTextStyleType.normal,
          rightStyle: ReceiptTextStyleType.normal,
          leftSize: ReceiptTextSizeType.medium,
          rightSize: ReceiptTextSizeType.medium,
        );
      }
    }



    

  }

      if(j<(comboOfferItems.length-1)){
      receiptBody2Text.addText(
      '----------------------',
      size: ReceiptTextSizeType.extraLarge,
      style: ReceiptTextStyleType.bold,
    );

    }

}
   

  



// ==============
// final List byteBuffer = await _getBytes(
// bytes,
// paperSize: PaperSize.mm58,
// feedCount: feedCount,
// useCut: useCut,
// useRaster: useRaster,
// );
// _printProcess(byteBuffer);
    // receiptHeadText.addSpacer(useDashed: true);
    // receiptHeadText.addText(
    //   'EXTRA LARGE WITHOUT BOLD',
    //   size: ReceiptTextSizeType.small,
    //   style: ReceiptTextStyleType.normal,
    // );
    // receiptHeadText.addSpacer(useDashed: true);

    // Add more text as needed
    await _bluePrintPos.printReceiptText(
      receiptHeadText,
      feedCount: 0,
    );

   
    await _bluePrintPos.printReceiptText(
      receiptBody1Text,
      feedCount: 0,
    );
    await _bluePrintPos.printReceiptText(
      receiptBody2Text,
      feedCount: 0,
    );
    ref.read(loadingProvider.notifier).hideLoader();
    // await _bluePrintPos.printReceiptText(
    //   receiptFooterText,
    //   feedCount: 1,
    // );

// var subscription = FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
//     print(state);
//     if (state == BluetoothAdapterState.on) {
//         // usually start scanning, connecting, etc
//     } else {
//         // show an error to the user, etc
//     }
// });

// if (Platform.isAndroid) {
    // await FlutterBluePlus.turnOn();
// }

// cancel to prevent duplicate listeners
// subscription.cancel();
  }


  
}


extension on OrderItem {
  Map<String, List<Topping>> get toppingsByVariantOption {
    final Map<String, List<Topping>> toppingsByVariantOption = {};

    for (var topping in toppings) {
      if (!toppingsByVariantOption.containsKey(topping.toppingsheading)) {
        toppingsByVariantOption[topping.toppingsheading] = [];
      }
      toppingsByVariantOption[topping.toppingsheading]!.add(topping);
    }

    return toppingsByVariantOption;
  }
}