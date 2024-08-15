// import 'package:flutter/material.dart';

// Widget buildDeliveryButtons(BuildContext context, order) {
//   // final deliveryInterval = context.read(deliveryIntervalProvider).state;
//   // final maxDeliveryMinutes = context.read(maxDeliveryMinutesProvider).state;
//   final deliveryInterval = 20;
//   final maxDeliveryMinutes = 120;

//   List<Widget> buttons = [];
//   for (int i = deliveryInterval;
//       i <= maxDeliveryMinutes;
//       i += deliveryInterval) {
//     buttons.add(
//       Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(30.0),
//           border: Border.all(
//             // color: index == selectedChipIndex ? Colors.blue : Colors.grey,
//             color: Colors.blue,
//             width: 2.0,
//           ),
//         ),
//         child: ChoiceChip(
//           // backgroundColor: const Color.fromARGB(255, 222, 240, 255),
//           label: Text('$i minutes'),
//           // selected: time == 30, // default selected time
//           selected: false, // default selected time
//           onSelected: (selected) {
//             _onDeliveryTimeSelected(context, order, i);
//           },
//         ),
//       ),
//     );
//   }

//   return Row(
//     children: buttons,
//   );
// }

// void _onDeliveryTimeSelected(BuildContext context, order, int minutes) {
//   final currentTime = DateTime.now();
//   // Call API to update order status, delivery minutes, and set delivery datetime
//   updateOrder(order.orderId, 2, minutes, currentTime);
  
//   // Update local order state
//   context.read(orderProvider.notifier).updateOrder(order.copyWith(
//     status: 2,
//     deliveryMinutes: minutes,
//     setDeliveryMinuteDatetime: currentTime,
//   ));

//   // Call the function to start the gauge clock
//   _startGaugeClock(context, order.orderId, minutes, currentTime);
// }
