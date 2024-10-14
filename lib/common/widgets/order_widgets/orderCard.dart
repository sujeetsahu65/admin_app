import 'package:admin_app/common/widgets/order_widgets/orderItemsCard.dart';
import 'package:admin_app/constants/global_variables.dart';
// import 'package:admin_app/models/bluetooth.dart';
import 'package:admin_app/models/order_model.dart';
// import 'package:admin_app/models/printer.dart';
import 'package:admin_app/pages/auth/services/gauge_clock.dart';
import 'package:admin_app/pages/auth/services/language.dart';
import 'package:admin_app/providers/basic.dart';
import 'package:admin_app/providers/printer.dart';
// import 'package:admin_app/providers/printer_old.dart';
// import 'package:blue_print_pos/blue_print_pos.dart';
// import 'package:blue_print_pos/models/blue_device.dart';
// import 'package:blue_print_pos/receipt/receipt_section_text.dart';
// import 'package:blue_print_pos/receipt/receipt_text_size_type.dart';
// import 'package:blue_print_pos/receipt/receipt_text_style_type.dart';
import 'package:flutter/material.dart';
import 'package:admin_app/common/widgets/other_widgets/customFont.dart';
import 'package:admin_app/providers/order.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderCard extends ConsumerWidget {
  final Order order;
  final String page;
  // final WidgetRef ref;
  // final BluePrintPos _bluePrintPos = BluePrintPos.instance;
  OrderCard({required this.order, required this.page
      // required this.ref
      });

//  void _printOrder(BuildContext context, Order order, BlueDevice printerDevice) async {
//     if (!await _bluePrintPos.isBluetoothAvailable) {
//       _showMessage(context, 'Please turn on Bluetooth');
//       return;
//     }

//     if (printerDevice == null) {
//       _showMessage(context, 'No printer device selected');
//       return;
//     }

//     // Print logic here
//     final ReceiptSectionText receiptText = ReceiptSectionText();
//     receiptText.addText('Order #$orderId');
//     await _bluePrintPos.printReceiptText(receiptText);

//     _showMessage(context, 'Printing...');
//   }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

//   void _printOrder(BuildContext context,WidgetRef ref, Order order,PrinterState printerState) async {
//     // BlueDevice? printerDevice
//   final ReceiptSectionText receiptText = ReceiptSectionText();
// // final printerState = ref.watch(printerProvider);

//       receiptText.addText(
//       'EXTRA LARGE BOLD',
//       size: ReceiptTextSizeType.extraLarge,
//       style: ReceiptTextStyleType.bold,
//     );
//     // await _bluePrintPos.printReceiptText(receiptText);
//     // final ReceiptSectionText receiptSecondText = ReceiptSectionText();
//       // await printerState.bluePrintPos.printReceiptText(receiptText, feedCount: 0);

// _showMessage(context,'device: ${printerState.connectedDevice!.address}');
//   }

  Widget deliveryTimeButtons(BuildContext context, WidgetRef ref) {
    final basicDataProvider = ref.watch(generalDataProvider);
    // final deliveryInterval = context.read(deliveryIntervalProvider).state;
    // final maxDeliveryMinutes = context.read(maxDeliveryMinutesProvider).state;

    late int deliveryInterval;
    late int maxDeliveryMinutes;

    if (order.preOrderBooking == 1) {
      deliveryInterval = order.preOrderResponseAlertTime;
      maxDeliveryMinutes = order.preOrderResponseAlertTime;
    } else {
      deliveryInterval = basicDataProvider.orderResponseTime.responseInterval;
      maxDeliveryMinutes = basicDataProvider.orderResponseTime.maxDuration;
    }

// preOrderAlert
// preOrderDelivery

    List<Widget> buttons = [];
    for (int i = deliveryInterval;
        i <= maxDeliveryMinutes;
        i += deliveryInterval) {
      buttons.add(
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            // border: Border.all(
            //   // color: index == selectedChipIndex ? Colors.blue : Colors.grey,
            //   color: Colors.blue,
            //   width: 2.0,
            // ),
          ),
          child: ChoiceChip(
            padding: EdgeInsets.only(left: 12,right: 12),
            
            // shape: OvalBorder(side: BorderSide(width: 2.0)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0)),side: BorderSide(color: Colors.blue)),
            // backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            elevation: 5.0,
            shadowColor: Colors.grey,
            // color: ,
            // backgroundColor: const Color.fromARGB(255, 222, 240, 255),
            label: Text('$i'),
            // selected: time == 30, // default selected time
            selected: false, // default selected time
            onSelected: (selected) {
              _onDeliveryTimeSelected(context, i, ref);
            },
          ),
        ),
      );
    }

    return Flexible(
      child: Wrap(
        alignment: WrapAlignment.center, // Center the buttons
        spacing: 15.0, // Horizontal spacing between buttons
        runSpacing: 8.0, // Vertical spacing between wrapped lines
        children: buttons,
      ),
    );
  }

  void _onConcludeOrder(WidgetRef ref) {
    final orderNotifier = ref.read(orderProvider.notifier);
    final updatedOrder = order.copyWith(
      ordersStatusId: 6,
    );
    orderNotifier.updateOrder(updatedOrder, 'concludeOrder');
  }

  void _onMoveFailedOrder(WidgetRef ref) {
    final failedOrderNotifier = ref.read(failedOrderProvider.notifier);
    final updatedOrder = order.copyWith(ordersStatusId: 3, paymentStatusId: 5);
    failedOrderNotifier.updateOrder(updatedOrder, 'moveFailedOrder');
  }

  void _onCacelOrder(WidgetRef ref) {
    final orderNotifier = ref.read(orderProvider.notifier);
    final updatedOrder = order.copyWith(
      ordersStatusId: 4,
    );
    orderNotifier.updateOrder(updatedOrder, 'cancelOrder');
  }

  void _onDeliveryTimeSelected(
      BuildContext context, int minutes, WidgetRef ref) async {
    final orderNotifier = ref.read(orderProvider.notifier);
    final printerNotifier = ref.read(printerProvider.notifier);
    final now = TZ.now();

    if (order.preOrderBooking == 3) {
      final updatedOrder = order.copyWith(
          preOrderBooking: 2, preOrderResponseAlertTime: minutes);

      orderNotifier.updateOrder(updatedOrder, 'setPreOrderAlertTime');
    } else {
      final updatedOrder = order.copyWith(
          ordersStatusId: 5,
          setOrderMinutTime: '${minutes}|Minute',
          orderTimerStartTime: now);
      await orderNotifier.updateOrder(updatedOrder, 'setOrderDeliveryTime');
      printerNotifier.orderPrint(order, context);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOrderExpanded = ref.watch(orderExpansionProvider(order.orderId));
    //  final printerState = ref.watch(printerProvider);
    final printerNotifier = ref.read(printerProvider.notifier);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 4, // Adjust elevation as needed
        shadowColor: Colors.blueGrey, // Optional shadow color
        margin: EdgeInsets.all(4),

        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // MAIN ROW 1
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    page == 'home'
                        ? GestureDetector(
                            onTap: () => _onCacelOrder(ref),
                            child: Icon(
                              Icons.cancel_outlined,
                              color: const Color.fromARGB(255, 221, 15, 0),
                              size: 35.0,
                            ),
                          )
                        : SizedBox(
                            width: 35,
                          ),

                    // Spacer(),
                    CustomFont(text: order.orderNO, fontWeight: FontWeight.bold)
                        .large(),
                    GestureDetector(
                      child: Icon(
                        Icons.print,
                        color: Colors.blue,
                        size: 35.0,
                      ),
                      // onTap: () => _printOrder(context,ref,order,printerState),
                      onTap: () => printerNotifier.orderPrint(order, context),
                    ),
                  ],
                ),
                Divider(),
                if (order.preOrderBooking > 0) ...[
                  CustomFont(
                          text: 'PRE-ORDER',
                          fontWeight: FontWeight.bold,
                          textAlign: TextAlign.center,
                          color: Colors.blue)
                      .large(),
                  Divider(),
                ],

                // SizedBox(height: 1.0,),
                // MAIN ROW 2
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SECTION 1
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            // Icons.delivery_dining_outlined,
                            order.deliveryTypeId == 1
                                ? Icons.local_shipping_outlined
                                : Icons.restaurant_outlined,
                            size: 75.0,
                            color: Colors.blue,
                          ),
                          CustomFont(
                                  text: order.deliveryType,
                                  fontWeight: FontWeight.bold)
                              .medium()
                        ],
                      ),
                    ),
                    // SECTION 2
                    Expanded(
                      flex: 7,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.person_outline),
                              SizedBox(
                                width: 4,
                              ),
                              CustomFont(
                                      text:
                                          '${order.firstName} ${order.lastName}',
                                      fontWeight: FontWeight.bold)
                                  .medium()
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            children: [
                              Icon(Icons.phone_outlined),
                              SizedBox(
                                width: 4,
                              ),
                              CustomFont(text: order.userMobileNo).medium()
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          if (order.deliveryTypeId ==
                              1) //show address only on home delivery
                            Row(
                              children: [
                                Icon(Icons.location_on_outlined),
                                SizedBox(
                                  width: 4,
                                ),
                                Expanded(child: CustomFont(text: order.userAddress).medium())
                              ],
                            ),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            children: [
                              Icon(Icons.schedule_outlined),
                              SizedBox(
                                width: 4,
                              ),
                              CustomFont(text: '${order.orderDateTime}')
                                  .medium()
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                if (order.userNote.isNotEmpty) ...[
                  // SizedBox(
                  //   height: 4,
                  // ),
                  Divider(),
                  IntrinsicHeight(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.elliptical(5, 5)),
                                  // color: Color.fromARGB(255, 228, 228, 228)
                                ),
                                height: double.infinity,
                                child: Icon(
                                  Icons.description_outlined,
                                  color: Colors.blue,
                                  size: 30.0,
                                )),
                          ),
                          VerticalDivider(),
                          // SizedBox(
                          //   width: 8,
                          // ),
                          Expanded(
                            flex: 10,
                            child: CustomFont(text: order.userNote).medium(),
                          ),
                        ]),
                  ),
                ],
                Divider(),
                // MAIN ROW 3
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     Text('Order No'),
                    //     Text(orderId, style: TextStyle(fontWeight: FontWeight.bold)),
                    //   ],
                    // ),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppLocalizations.of(context)
                              .translate('title_payment_mode')),
                          Text(order.paymentMode,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (order.ordersStatusId == 5 && page == 'home')
                            GaugeClock(
                              setDeliveryMinutes: order.setOrderMinutTime,
                              setDeliveryMinuteDatetime:
                                  order.orderTimerStartTime,
                            )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(AppLocalizations.of(context)
                              .translate('label_amount')),
                          Text('${order.finalPayableAmountAsString}€',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(),
                // MAIN ROW 4
                GestureDetector(
                  onTap: () {
                    ref
                        .read(orderExpansionProvider(order.orderId).notifier)
                        .state = !isOrderExpanded;
                  },
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isOrderExpanded
                            ? Icons.do_not_disturb_on_outlined
                            : Icons.add_circle_outline,
                        color: Colors.blue,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      CustomFont(
                              text: isOrderExpanded
                                  ? AppLocalizations.of(context)
                                      .translate('label_view_less')
                                  : AppLocalizations.of(context)
                                      .translate('View Food lable'))
                          .medium()
                    ],
                  ),
                ),
                // SUB MAIN ROW 4
                if (isOrderExpanded) ...[
                  // Your expanded widget content goes here
                  SizedBox(height: 4.0),
                  OrderItemsCard(
                    order: order,
                  ),
                ],

                SizedBox(height: 4.0),
                // MAIN ROW 5
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: deliveryTimes.map((time) {
                //     return Container(
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(30.0),
                //     border: Border.all(
                //       // color: index == selectedChipIndex ? Colors.blue : Colors.grey,
                //       color: Colors.blue,
                //       width: 2.0,
                //     ),
                //   ),
                //       child: ChoiceChip(
                //         // backgroundColor: const Color.fromARGB(255, 222, 240, 255),
                //         label: Text('$time'),
                //         // selected: time == 30, // default selected time
                //         selected: false, // default selected time
                //         onSelected: (selected) {},
                //       ),
                //     );
                //   }).toList(),
                // ),
// MAIN ROW 6
                Padding(
                  padding: EdgeInsets.all(10),
                  child: (page == 'home' || page == 'failed-orders')
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (order.ordersStatusId == 3 &&
                                page == 'home' &&
                                (order.preOrderBooking == 0 ||
                                    order.preOrderBooking == 1 ||
                                    order.preOrderBooking == 3))
                              deliveryTimeButtons(context, ref)
                            else if (order.ordersStatusId == 5 &&
                                page == 'home')
                              ElevatedButton(
                                onPressed: () {
                                  // Respond to button press
                                  _onConcludeOrder(ref);
                                },
                                child: Text(AppLocalizations.of(context)
                                    .translate(order.deliveryTypeId == 1
                                        ? 'order on the way'
                                        : 'Ready to pick')),
                              )
                            else if (order.ordersStatusId == 7 &&
                                order.paymentModeId == 3 &&
                                page == 'failed-orders' &&
                                (order.paymentStatusId == 2 ||
                                    order.paymentStatusId == 3))
                              ElevatedButton(
                                onPressed: () {
                                  // Respond to button press
                                  _onMoveFailedOrder(ref);
                                },
                                child: Text(AppLocalizations.of(context)
                                    .translate('move to order title')),
                              )
                          ],
                        )
                      : null,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
