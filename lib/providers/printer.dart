import 'package:admin_app/constants/print_enum.dart';
import 'package:admin_app/models/bluetooth.dart';
import 'package:admin_app/models/combo_offer_model.dart';
import 'package:admin_app/models/order_items_model.dart';
import 'package:admin_app/models/order_items_model.dart';
import 'package:admin_app/models/order_model.dart';
import 'package:admin_app/models/toppings_model.dart';
import 'package:admin_app/pages/auth/services/language.dart';
import 'package:admin_app/providers/basic.dart';
import 'package:admin_app/providers/error_handler.dart';
import 'package:admin_app/providers/language.dart';
import 'package:admin_app/providers/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:shared_preferences/shared_preferences.dart';

// StateNotifier for managing Bluetooth device list and connection status
class PrinterStateNotifier extends StateNotifier<PrinterState> {
  PrinterStateNotifier(this.ref) : super(PrinterState()) {
    // _initPrinter();
  }
  final Ref ref;
  final BluetoothPermissionHandler _bluetoothPermissionHandler =
      BluetoothPermissionHandler();

  final BlueThermalPrinter _bluetooth = BlueThermalPrinter.instance;

  Future<void> initPrinter() async {
    try {
      bool isConnected = await _bluetooth.isConnected ?? false;
      if (!isConnected) {
        await _bluetoothPermissionHandler.requestAndEnsureBluetooth();
      }
      await getDevices();
    } catch (e) {
      state = state.copyWith(errorMessage: 'Bluetooth initialization failed');
    }
  }

  Future<void> getDevices() async {
    try {
      await _bluetoothPermissionHandler.requestAndEnsureBluetooth();
      List<BluetoothDevice> devices = await _bluetooth.getBondedDevices();
      state = state.copyWith(devices: devices);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to fetch devices');
    }
  }

  Future<void> connectPrinter(BluetoothDevice device) async {
    ref.read(loadingProvider.notifier).showLoader();
    try {
      await disconnectPrinter();
      await _bluetooth.connect(device);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('printer_address', device.address.toString());

      state = state.copyWith(connectedDevice: device, isConnected: true);
    } catch (e) {
      state =
          state.copyWith(errorMessage: 'Failed to connect', isConnected: false);
    }
    ref.read(loadingProvider.notifier).hideLoader();
  }

  Future<void> connectToStoredDevice() async {
    try {
      // bool isConnected = await _bluetooth.isConnected ?? false;
      //     if (!isConnected) {

      await disconnectPrinter();
      // await _bluetoothPermissionHandler.requestAndEnsureBluetooth();

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? storedAddress = prefs.getString('printer_address');

      if (storedAddress != null) {
        state = state.copyWith(isLoading: true);

        List<BluetoothDevice> devices = await _bluetooth.getBondedDevices();

        if (devices.isNotEmpty) {
          final BluetoothDevice device = devices.firstWhere(
            (d) => d.address == storedAddress,
            orElse: () => null as BluetoothDevice,
          );

          if (device != null) {
            await _bluetooth.connect(device);

            bool isConnected = await _bluetooth.isConnected ?? false;
            if (!isConnected) {
              state = state.copyWith(
                  errorMessage: 'Failed to connect', isConnected: false);
            } else {
              state =
                  state.copyWith(connectedDevice: device, isConnected: true);
            }
          } else {
            state = state.copyWith(
                errorMessage: 'Failed to connect', isConnected: false);
          }
        }
        // }
      }
    } catch (e) {
      print(e);
      state = state.copyWith(errorMessage: 'Failed to connect');
    }
  }

  Future<void> disconnectPrinter() async {
    try {
      await _bluetooth.disconnect();
      state = state.copyWith(connectedDevice: null, isConnected: false);
    } catch (e) {
      state = state.copyWith(
          errorMessage: 'Failed to disconnect', isConnected: false);
    }
  }

  Future<void> testPrint() async {
    ref.read(loadingProvider.notifier).showLoader();
    if (state.isConnected) {
      _bluetooth.printCustom(
          'TEST PRINT', Size.boldMedium.val, alignText.center.val,
          charset: "windows-1252");
      // _bluetooth.printCustom('Metsälä  €5.00', 3, 1,charset: "utf-8");
      // _bluetooth.printCustom('Metsälä  €5.00', 3, 1,charset: "windows-1252");
      // _bluetooth.printCustom('Metsälä  €5.00', 3, 1,charset: "ISO-8859-1");
      // _bluetooth.printCustom('Metsälä  €5.00', 3, 1,charset: "windows-1252");
      // _bluetooth.printCustom('Metsälä  €5.00', 3, 1,charset: "gbk");
      // _bluetooth.printCustom('Metsälä  €5.00', 3, 1,charset: "GB2312");
      _bluetooth.printNewLine();
      // _bluetooth.printNewLine();
      // _bluetooth.printCustom('!#%^&*()_+=-', 3, 1);
      _bluetooth.printLeftRight('Coke', '\$1.99', 1);
      _bluetooth.printCustom('Total: \$10.97', 2, 1);
      _bluetooth.printQRcode('www.example.com', 200, 200, 1);
      _bluetooth.paperCut();
    }
    ref.read(loadingProvider.notifier).hideLoader();
  }

  Future<void> orderPrint(Order order, BuildContext context) async {
    ref.read(loadingProvider.notifier).showLoader();
//     // final currentPaperSize = ref.watch(printerSizeProvider);
//     // late final paperSize;
//     // if (currentPaperSize == 'mm72') {
//     //   paperSize = PaperSize.mm72;
//     // } else if (currentPaperSize == 'mm80') {
//     //   paperSize = PaperSize.mm80;
//     // } else {
//     //   paperSize = PaperSize.mm58;
//     // }
//     // mm58

// //  final orderItemsData = ref.watch(orderItemsProvider(order.orderId));
    final basicDataProvider = ref.watch(generalDataProvider);
    final locationContact = basicDataProvider.contactUs;
    final locationDetails = basicDataProvider.locationMaster;
    final languageCode = ref.watch(localizationProvider).languageCode;

    final response = await orderService.fetchOrderItems(
        orderId: order.orderId, languageCode: languageCode);

    if (response.isSuccess) {
      final orderItemsData = response.data!;
      List<OrderItem> orderItems =
          List<OrderItem>.from(orderItemsData['orderItems'] ?? []);
      List<ComboOfferItem> comboOfferItems =
          List<ComboOfferItem>.from(orderItemsData['comboOfferItems'] ?? []);

// // ==============LOCATION DETAILS========

      _bluetooth.printCustom("TANDOORIVILLA".toUpperCase(), Size.boldMedium.val,
          alignText.center.val,
          charset: "windows-1252");

      _bluetooth.printNewLine();
      _bluetooth.printCustom(
          order.orderNO, Size.boldMedium.val, alignText.center.val,
          charset: "windows-1252");
      _bluetooth.printNewLine();

      _bluetooth.printCustom(
          order.orderDateTime.toString(), Size.medium.val, alignText.center.val,
          charset: "windows-1252");
      // _bluetooth.printNewLine();
      _bluetooth.printCustom(
          '----------------', Size.boldMedium.val, alignText.center.val,
          charset: "windows-1252");
      _bluetooth.printCustom(
          order.paymentMode.toUpperCase(), Size.bold.val, alignText.center.val,
          charset: "windows-1252");
      _bluetooth.printNewLine();
      _bluetooth.printCustom(
          order.deliveryType.toUpperCase(), Size.bold.val, alignText.center.val,
          charset: "windows-1252");
      // _bluetooth.printNewLine();
      _bluetooth.printCustom(
          '----------------', Size.boldMedium.val, alignText.center.val,
          charset: "windows-1252");
      _bluetooth.printNewLine();
      // ==============CUSTOMER DETAILS========

      _bluetooth.printCustom(
          '${order.firstName} ${order.lastName}'.toUpperCase(),
          Size.bold.val,
          alignText.center.val,
          charset: "windows-1252");
      _bluetooth.printNewLine();
      _bluetooth.printCustom(
          order.userMobileNo, Size.bold.val, alignText.center.val,
          charset: "windows-1252");
      _bluetooth.printNewLine();

      if (order.deliveryTypeId == 1) {
        _bluetooth.printCustom(
            "${order.userAddress}${order.userBuildingNo.isNotEmpty ? ', ${order.userBuildingNo}' : ','}"
                .toUpperCase(),
            Size.bold.val,
            alignText.center.val,
            charset: "windows-1252");
        _bluetooth.printNewLine();

        _bluetooth.printCustom(
            '${order.userZipcode}, ${order.userCity}'.toUpperCase(),
            Size.bold.val,
            alignText.center.val,
            charset: "windows-1252");
      }
      _bluetooth.printCustom(
          '----------------', Size.boldMedium.val, alignText.center.val,
          charset: "windows-1252");
      _bluetooth.printNewLine();

      // ==============CUSTOMER COMMENT========

      if (order.userNote.isNotEmpty) {
        _bluetooth.printCustom(
            'Extra Comment:'.toUpperCase(), Size.bold.val, alignText.left.val,
            charset: "windows-1252");
        _bluetooth.printCustom(
            order.userNote, Size.medium.val, alignText.left.val,
            charset: "windows-1252");
        _bluetooth.printNewLine();
      }

// ==============ORDER ITEMS========

      for (int i = 0; i < orderItems.length; i++) {
        final item = orderItems[i];

        // Print item quantity, name, and size
        _bluetooth.printCustom(
            '${item.itemOrderQty} x ${item.foodItemName}(${item.itemSizeName}) : ${item.totalBasicPriceAsString}€'
                .toUpperCase(),
            Size.bold.val,
            alignText.right.val,
            charset: "windows-1252");
        _bluetooth.printNewLine();

        // Print extra comment if available
        if (item.foodExtratext.isNotEmpty) {
          _bluetooth.printCustom(
              'Food Comment:'.toUpperCase(), Size.bold.val, alignText.left.val,
              charset: "windows-1252");
          _bluetooth.printCustom(
              item.foodExtratext, Size.medium.val, alignText.left.val,
              charset: "windows-1252");
          _bluetooth.printNewLine();
        }

        // Print toppings
        for (var entry in item.toppingsByVariantOption.entries) {
          _bluetooth.printCustom(
              entry.key.toUpperCase(), Size.bold.val, alignText.left.val,
              charset: "windows-1252");

          for (var topping in entry.value) {
            _bluetooth.printCustom(
                '${topping.toppingslistname} : ${topping.foodVariantOptionPriceAsString}€'
                    .toUpperCase(),
                Size.bold.val,
                alignText.right.val,
                charset: "windows-1252");
          }
          _bluetooth.printNewLine();
        }

        // Add a divider if there are more items and not a combo offer
        // if (i < orderItems.length - 1 && !isComboOffer) {
        //   receiptHeadText.addSpacer(useDashed: true);
        // }
        // if (i < (orderItems.length - 1)) {
        _bluetooth.printCustom(
            '----------------', Size.boldMedium.val, alignText.center.val,
            charset: "windows-1252");
        // }
      }

// ==============COMBO ITEMS========
      if (comboOfferItems.isNotEmpty) {
        _bluetooth.printNewLine();
        _bluetooth.printCustom(
            'COMBO OFFER ITEMS', Size.bold.val, alignText.center.val,
            charset: "windows-1252");
      }

      for (int j = 0; j < comboOfferItems.length; j++) {
        final comboItem = comboOfferItems[j];

        _bluetooth.printLeftRight(comboItem.comboName,
            '${comboItem.totalPriceAsString}€'.toUpperCase(), Size.bold.val,
            charset: "windows-1252");
        _bluetooth.printNewLine();

        for (int k = 0; k < comboOfferItems[j].orderItems.length; k++) {
          final comboFooditem = comboOfferItems[j].orderItems[k];

          // Print comboFooditem quantity, name, and size

          _bluetooth.printCustom(
              '${comboFooditem.itemOrderQty} x ${comboFooditem.foodItemName}(${comboFooditem.itemSizeName})'
                  .toUpperCase(),
              Size.bold.val,
              alignText.left.val,
              charset: "windows-1252");
          _bluetooth.printNewLine();

          // Print extra comment if available
          if (comboFooditem.foodExtratext.isNotEmpty) {
            _bluetooth.printCustom(
                'Food Comment:', Size.bold.val, alignText.left.val,
                charset: "windows-1252");
            _bluetooth.printCustom(comboFooditem.foodExtratext, Size.medium.val,
                alignText.left.val,
                charset: "windows-1252");
            _bluetooth.printNewLine();
          }

          // Print toppings
          for (var entry in comboFooditem.toppingsByVariantOption.entries) {
            _bluetooth.printCustom(
                entry.key.toUpperCase(), Size.bold.val, alignText.left.val,
                charset: "windows-1252");

            for (var topping in entry.value) {
              _bluetooth.printCustom(
                  '${topping.toppingslistname} : ${topping.foodVariantOptionPriceAsString}€'
                      .toUpperCase(),
                  Size.bold.val,
                  alignText.right.val,
                  charset: "windows-1252");
            }
            _bluetooth.printNewLine();
          }
        }

        // if (j < (comboOfferItems.length - 1)) {
        _bluetooth.printCustom(
            '----------------', Size.boldMedium.val, alignText.center.val,
            charset: "windows-1252");
        // }
      }

// ==============CALCULATIONS========
      _bluetooth.printNewLine();
      _bluetooth.printCustom(
          ('${AppLocalizations.of(context).translate('sub total label')} : ${order.foodItemSubtotalAmtAsString}€')
              .toUpperCase(),
          Size.bold.val,
          alignText.right.val,
          charset: "windows-1252");
      _bluetooth.printNewLine();

      _bluetooth.printCustom(
          '${AppLocalizations.of(context).translate('tax label')} : ${order.totalItemTaxAmtAsString}€'
              .toUpperCase(),
          Size.bold.val,
          alignText.right.val,
          charset: "windows-1252");
      _bluetooth.printNewLine();
      _bluetooth.printCustom(
          '${AppLocalizations.of(context).translate('discount label')} : ${order.discountAmtAsString}€'
              .toUpperCase(),
          Size.bold.val,
          alignText.right.val,
          charset: "windows-1252");
      _bluetooth.printNewLine();

      if (order.regOfferAmount > 0) {
        _bluetooth.printCustom(
            '${AppLocalizations.of(context).translate('title_registration_Offers')} : ${order.regOfferAmountAsString}€'
                .toUpperCase(),
            Size.bold.val,
            alignText.right.val,
            charset: "windows-1252");
        _bluetooth.printNewLine();
      }

      if (order.deliveryTypeId == 1) {
        _bluetooth.printCustom(
            '${AppLocalizations.of(context).translate('title_distance')} : ${order.orderUserDistanceAsString} Km'
                .toUpperCase(),
            Size.bold.val,
            alignText.right.val,
            charset: "windows-1252");
        _bluetooth.printNewLine();
        _bluetooth.printCustom(
            '${AppLocalizations.of(context).translate('delivery charge label')} : ${order.deliveryChargesAsString}€'
                .toUpperCase(),
            Size.bold.val,
            alignText.right.val,
            charset: "windows-1252");

        _bluetooth.printNewLine();

        if (order.extraDeliveryCharges > 0) {
          _bluetooth.printCustom(
              '${AppLocalizations.of(context).translate('Extra Delivery Charges label')} : ${order.extraDeliveryChargesAsString}€'
                  .toUpperCase(),
              Size.bold.val,
              alignText.right.val,
              charset: "windows-1252");
          _bluetooth.printNewLine();
        }
      }

      if (order.minimumOrderPrice > 0) {
        _bluetooth.printCustom(
            '${AppLocalizations.of(context).translate('title_Minimum_order_price')} : ${order.minimumOrderPriceAsString}€'
                .toUpperCase(),
            Size.bold.val,
            alignText.right.val,
            charset: "windows-1252");
        _bluetooth.printNewLine();
      }
      if (order.deliveryCouponAmt > 0) {
        _bluetooth.printCustom(
            '${AppLocalizations.of(context).translate('delivery_coupon_discount_title')} : ${order.deliveryCouponAmtAsString}€'
                .toUpperCase(),
            Size.bold.val,
            alignText.right.val,
            charset: "windows-1252");
        _bluetooth.printNewLine();
      }
      if (order.couponDiscount > 0) {
        _bluetooth.printCustom(
            '${AppLocalizations.of(context).translate('coupon discount title')} : ${order.couponDiscountAsString}€'
                .toUpperCase(),
            Size.bold.val,
            alignText.right.val,
            charset: "windows-1252");
        _bluetooth.printNewLine();
      }

      _bluetooth.printCustom(
          '${AppLocalizations.of(context).translate('title_Grand_Total')} : ${order.grandTotalAsString}€'
              .toUpperCase(),
          Size.bold.val,
          alignText.right.val,
          charset: "windows-1252");
      _bluetooth.printNewLine();

      _bluetooth.printCustom(
          '${AppLocalizations.of(context).translate('total label')} : ${order.finalPayableAmountAsString}€'
              .toUpperCase(),
          Size.bold.val,
          alignText.right.val,
          charset: "windows-1252");

      _bluetooth.printCustom(
          '_______________', Size.boldMedium.val, alignText.center.val,
          charset: "windows-1252");
      _bluetooth.printNewLine();

// ==============FOOTER========
      _bluetooth.printCustom(
          locationContact.address, Size.bold.val, alignText.center.val,
          charset: "windows-1252");
      _bluetooth.printNewLine();
      _bluetooth.printCustom(
          locationContact.phone, Size.bold.val, alignText.center.val,
          charset: "windows-1252");
      _bluetooth.printNewLine();
      _bluetooth.printCustom(
          locationContact.emailId, Size.bold.val, alignText.center.val,
          charset: "windows-1252");
      _bluetooth.printNewLine();
      _bluetooth.printCustom(
          locationContact.businessId, Size.bold.val, alignText.center.val,
          charset: "windows-1252");
      _bluetooth.printNewLine();
      _bluetooth.printCustom(
          locationDetails.website, Size.bold.val, alignText.center.val,
          charset: "windows-1252");

      _bluetooth.printNewLine();
      _bluetooth.printNewLine();
      _bluetooth.paperCut();

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

      // await _bluePrintPos.printReceiptText(
      //   receiptHeadText,
      //   feedCount: 0,
      // );
      // await _bluePrintPos.printReceiptText(
      //   receiptHeadText,
      //   feedCount: 0,
      // );
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
    } else {
      ref.read(globalMessageProvider.notifier).showError(response.message);
    }
    ref.read(loadingProvider.notifier).hideLoader();
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
final printerProvider =
    StateNotifierProvider<PrinterStateNotifier, PrinterState>(
  (ref) => PrinterStateNotifier(ref),
);
