// import 'package:admin_app/pages/auth/services/gauge_clock_service.dart';
// import 'package:flutter/material.dart';
// import 'package:admin_app/common/widgets/custom_font.dart';
// import 'package:admin_app/constants/global_variables.dart';
// import 'package:admin_app/providers/order_provider.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class OrderWidget extends ConsumerWidget {
//   final String userName;
//   final String userPhone;
//   final String userEmail;
//   final String userAddress;
//   final String userNote;
//   final String orderNo;
//   final int orderId;
//   final DateTime orderDateTime;
//   final String paymentType;
//   final int deliveryTypeId;
//   final int orderStatusId;
//   final String deliveryType;
//   final double discount;
//   final double tax;
//   final double grandTotal;
//   final double subTotal;
//   final double total;
//   final List<int> deliveryTimes;
//   final String? setDeliveryMinutes;
//   final DateTime? setDeliveryMinuteDatetime;
//   // final WidgetRef ref;

//   OrderWidget({
//     required this.userName,
//     required this.userPhone,
//     required this.userEmail,
//     required this.address,
//     required this.userNote,
//     required this.orderNo,
//     required this.orderId,
//     required this.orderStatusId,
//     required this.orderDateTime,
//     required this.deliveryTypeId,
//     required this.paymentType,
//     required this.deliveryType,
//     required this.discount,
//     required this.tax,
//     required this.subTotal,
//     required this.grandTotal,
//     required this.total,
//     required this.deliveryTimes,
//     required this.setDeliveryMinutes,
//     required this.setDeliveryMinuteDatetime,
//     // required this.ref
//   });

//   Widget buildDeliveryButtons(BuildContext context, orderId, WidgetRef ref) {
//     // final deliveryInterval = context.read(deliveryIntervalProvider).state;
//     // final maxDeliveryMinutes = context.read(maxDeliveryMinutesProvider).state;
//     final deliveryInterval = 20;
//     final maxDeliveryMinutes = 120;

//     List<Widget> buttons = [];
//     for (int i = deliveryInterval;
//         i <= maxDeliveryMinutes;
//         i += deliveryInterval) {
//       buttons.add(
//         Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(30.0),
//             border: Border.all(
//               // color: index == selectedChipIndex ? Colors.blue : Colors.grey,
//               color: Colors.blue,
//               width: 2.0,
//             ),
//           ),
//           child: ChoiceChip(
//             // backgroundColor: const Color.fromARGB(255, 222, 240, 255),
//             label: Text('$i'),
//             // selected: time == 30, // default selected time
//             selected: false, // default selected time
//             onSelected: (selected) {
//               _onDeliveryTimeSelected(context, orderId, i, ref);
//             },
//           ),
//         ),
//       );
//     }

//     return Row(
//       children: buttons,
//     );
//   }

//   void _onDeliveryTimeSelected(
//       BuildContext context, orderId, int minutes, WidgetRef ref) {
//     final orderNotifier = ref.read(orderProvider.notifier);

//     final currentTime = DateTime.now();
//     // Call API to update order status, delivery minutes, and set delivery datetime
//     // updateOrder(order.orderId, 2, minutes, currentTime);
// // orderId.copyWith()
//     // Update local order state
//     // orderNotifier.updateOrder(orderId.copyWith(
//     //   status: 2,
//     //   deliveryMinutes: minutes,
//     //   setDeliveryMinuteDatetime: currentTime,
//     // ));

//     // Call the function to start the gauge clock
//     // _startGaugeClock(context, orderId, minutes, currentTime);
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Card(
//         elevation: 4, // Adjust elevation as needed
//         shadowColor: Colors.blueGrey, // Optional shadow color
//         margin: EdgeInsets.all(4),

//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: SingleChildScrollView(
//             child: Column(
//               // crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // MAIN ROW 1
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   // crossAxisAlignment: CrossAxisAlignment.center,
//                   textBaseline: TextBaseline.alphabetic,
//                   children: [
//                     Icon(
//                       Icons.cancel_outlined,
//                       color: const Color.fromARGB(255, 221, 15, 0),
//                       size: 35.0,
//                     ),
          
//                     // Spacer(),
//                     CustomFont(text: orderNo, fontWeight: FontWeight.bold)
//                         .large(),
//                     Icon(
//                       Icons.print,
//                       color: Colors.blue,
//                       size: 35.0,
//                     ),
//                   ],
//                 ),
//                 Divider(),
//                 // SizedBox(height: 1.0,),
//                 // MAIN ROW 2
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // SECTION 1
//                     Expanded(
//                       flex: 3,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Icon(
//                             Icons.delivery_dining_outlined,
//                             size: 75.0,
//                             color: Colors.blue,
//                           ),
//                           CustomFont(
//                                   text: deliveryType, fontWeight: FontWeight.bold)
//                               .medium()
//                         ],
//                       ),
//                     ),
//                     // SECTION 2
//                     Expanded(
//                       flex: 7,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Icon(Icons.person_outline),
//                               SizedBox(
//                                 width: 4,
//                               ),
//                               CustomFont(text: name, fontWeight: FontWeight.bold)
//                                   .medium()
//                             ],
//                           ),
//                           SizedBox(
//                             height: 4,
//                           ),
//                           Row(
//                             children: [
//                               Icon(Icons.phone_outlined),
//                               SizedBox(
//                                 width: 4,
//                               ),
//                               CustomFont(text: phone).medium()
//                             ],
//                           ),
//                           SizedBox(
//                             height: 4,
//                           ),
//                           if (deliveryTypeId ==
//                               1) //show address only on home delivery
//                             Row(
//                               children: [
//                                 Icon(Icons.location_on_outlined),
//                                 SizedBox(
//                                   width: 4,
//                                 ),
//                                 CustomFont(text: address).medium()
//                               ],
//                             ),
//                           SizedBox(
//                             height: 4,
//                           ),
//                           Row(
//                             children: [
//                               Icon(Icons.schedule_outlined),
//                               SizedBox(
//                                 width: 4,
//                               ),
//                               CustomFont(text: '$orderDateTime').medium()
//                             ],
//                           )
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 Divider(),
//                 // MAIN ROW 3
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     // Column(
//                     //   crossAxisAlignment: CrossAxisAlignment.start,
//                     //   children: [
//                     //     Text('Order No'),
//                     //     Text(orderId, style: TextStyle(fontWeight: FontWeight.bold)),
//                     //   ],
//                     // ),
          
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('Payment Type'),
//                         Text(paymentType,
//                             style: TextStyle(fontWeight: FontWeight.bold)),
//                       ],
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('Order Amount'),
//                         Text('$total',
//                             style: TextStyle(fontWeight: FontWeight.bold)),
//                       ],
//                     ),
//                   ],
//                 ),
//                 Divider(),
//                 // MAIN ROW 4
//                 Row(
//                   // mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.add_circle_outline,
//                       color: Colors.blue,
//                     ),
//                     SizedBox(
//                       width: 4,
//                     ),
//                     CustomFont(text: 'View food').medium()
//                   ],
//                 ),
//                 SizedBox(height: 16.0),
//                 // MAIN ROW 5
//                 // Row(
//                 //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 //   children: deliveryTimes.map((time) {
//                 //     return Container(
//                 //   decoration: BoxDecoration(
//                 //     borderRadius: BorderRadius.circular(30.0),
//                 //     border: Border.all(
//                 //       // color: index == selectedChipIndex ? Colors.blue : Colors.grey,
//                 //       color: Colors.blue,
//                 //       width: 2.0,
//                 //     ),
//                 //   ),
//                 //       child: ChoiceChip(
//                 //         // backgroundColor: const Color.fromARGB(255, 222, 240, 255),
//                 //         label: Text('$time'),
//                 //         // selected: time == 30, // default selected time
//                 //         selected: false, // default selected time
//                 //         onSelected: (selected) {},
//                 //       ),
//                 //     );
//                 //   }).toList(),
//                 // ),
          
//                 Row(
                  
//                   children: [
//                     if (orderStatusId == 3)
//                       buildDeliveryButtons(context, orderId, ref)
//                     else if (orderStatusId == 5)
//                       GaugeClock(
//                         setDeliveryMinutes: setDeliveryMinutes,
//                         setDeliveryMinuteDatetime: setDeliveryMinuteDatetime,
//                       )
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
