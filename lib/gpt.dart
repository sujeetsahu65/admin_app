// To achieve the described functionality in your Flutter admin app, you'll need to follow these steps:

// 1. *API Integration:* Set up an API call to fetch the list of orders every 60 seconds.
// 2. *State Management:* Use Riverpod to manage the state for delivery time intervals and max delivery minutes.
// 3. *Dynamic Button Generation:* Generate the delivery time buttons dynamically based on the state.
// 4. *Button Click Handling:* Update the order status, delivery minutes, and set delivery datetime when a button is clicked.
// 5. *Gauge Clock Implementation:* Implement a gauge clock that updates every second to show the remaining delivery time for each order with status 2.
// 6. *Real-Time Updates:* Ensure the gauge is updated correctly when the order list is refreshed every 60 seconds.

// Here's a high-level implementation:

// ### 1. API Integration
// Set up a function to fetch orders from the API every 60 seconds.

// dart
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'dart:async';

// final orderProvider = StateNotifierProvider<OrderNotifier, List<Order>>((ref) {
//   return OrderNotifier();
// });

// class OrderNotifier extends StateNotifier<List<Order>> {
//   OrderNotifier() : super([]) {
//     _fetchOrders();
//     Timer.periodic(Duration(seconds: 60), (timer) {
//       _fetchOrders();
//     });
//   }

//   Future<void> _fetchOrders() async {
//     // Call your API to fetch orders
//     final fetchedOrders = await fetchOrdersFromApi();
//     state = fetchedOrders;
//   }
// }


// ### 2. State Management
// Define the state for delivery time intervals and max delivery minutes.

// dart
// final deliveryIntervalProvider = StateProvider<int>((ref) => 5);
// final maxDeliveryMinutesProvider = StateProvider<int>((ref) => 60);


// ### 3. Dynamic Button Generation
// Generate buttons based on the state.

// dart
// Widget buildDeliveryButtons(BuildContext context, Order order) {
//   final deliveryInterval = context.read(deliveryIntervalProvider).state;
//   final maxDeliveryMinutes = context.read(maxDeliveryMinutesProvider).state;

//   List<Widget> buttons = [];
//   for (int i = deliveryInterval; i <= maxDeliveryMinutes; i += deliveryInterval) {
//     buttons.add(
//       ElevatedButton(
//         onPressed: () {
//           _onDeliveryTimeSelected(context, order, i);
//         },
//         child: Text('$i minutes'),
//       ),
//     );
//   }

//   return Row(
//     children: buttons,
//   );
// }

// void _onDeliveryTimeSelected(BuildContext context, Order order, int minutes) {
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


// ### 4. Gauge Clock Implementation
// Implement the gauge clock widget.

// dart
// class GaugeClock extends StatefulWidget {
//   final int deliveryMinutes;
//   final DateTime setDeliveryMinuteDatetime;

//   GaugeClock({required this.deliveryMinutes, required this.setDeliveryMinuteDatetime});

//   @override
//   _GaugeClockState createState() => _GaugeClockState();
// }

// class _GaugeClockState extends State<GaugeClock> {
//   late Timer _timer;
//   late int _remainingTime;

//   @override
//   void initState() {
//     super.initState();
//     _startTimer();
//   }

//   void _startTimer() {
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       setState(() {
//         final now = DateTime.now();
//         final elapsed = now.difference(widget.setDeliveryMinuteDatetime).inMinutes;
//         _remainingTime = widget.deliveryMinutes - elapsed;
//         if (_remainingTime <= 0) {
//           _timer.cancel();
//           _remainingTime = 0;
//         }
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CircularProgressIndicator(
//       value: _remainingTime / widget.deliveryMinutes,
//       semanticsLabel: 'Delivery time remaining',
//     );
//   }
// }


// ### 5. Real-Time Updates
// Ensure the gauge clock is updated when the order list is refreshed.

// dart
// class OrderCard extends StatelessWidget {
//   final Order order;

//   OrderCard({required this.order});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Column(
//         children: [
//           Text('Order ID: ${order.orderId}'),
//           // Other order details
//           if (order.status == 1)
//             buildDeliveryButtons(context, order)
//           else if (order.status == 2)
//             GaugeClock(
//               deliveryMinutes: order.deliveryMinutes,
//               setDeliveryMinuteDatetime: order.setDeliveryMinuteDatetime,
//             ),
//           ElevatedButton(
//             onPressed: () {
//               // Handle On-The-Way button click
//             },
//             child: Text('On-The-Way'),
//           ),
//         ],
//       ),
//     );
//   }
// }


// This implementation covers the main functionality of your requirements. Make sure to handle error cases, loading states, and other edge cases as needed.