import 'package:admin_app/constants/global_variables.dart';
import 'package:admin_app/models/order_items_model.dart';
import 'package:admin_app/models/order_model.dart';
import 'package:admin_app/pages/auth/services/order.dart';
// import 'package:admin_app/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final OrderService orderService = OrderService();
final orderExpansionProvider =
    StateProvider.family<bool, int>((ref, id) => false);

final orderProvider = StateNotifierProvider<OrderNotifier, List<Order>>((ref) {
  return OrderNotifier();
});

class OrderNotifier extends StateNotifier<List<Order>> {
  OrderNotifier() : super([]) {
    _loadOrders();
  }
// sdgfdg
// await Future.delayed(Duration(seconds: 30));

  Future<void> _loadOrders() async {
    while (true) {
      final List<Order> orderList = await orderService.fetchOrders();
      // print(List);
      // state = orderJson.map((json) => json).toList();
      state = orderList;
      await Future.delayed(Duration(seconds: 30));
    }
  }

  void updateOrder(Order updatedOrder, mode) async {
    state = [
      for (final order in state)
        if (order.orderId == updatedOrder.orderId) updatedOrder else order,
    ];

    if (mode == 'setOrderDeliveryTime') {
      final bool isOrderUpdated =
          await orderService.setOrderDeliveryTime(updatedOrder);
    } else if (mode == 'setPreOrderAlertTime') {
      final bool isOrderUpdated =
          await orderService.setPreOrderAlertTime(updatedOrder);
    } else if (mode == 'concludeOrder') {
      final bool isOrderUpdated =
          await orderService.concludeOrder(updatedOrder);
    } else if (mode == 'cancelOrder') {
      final bool isOrderUpdated = await orderService.cancelOrder(updatedOrder);
    }

    // if (isOrderUpdated) {
    //   state = [
    //     for (final order in state)
    //       if (order.orderId == updatedOrder.orderId) updatedOrder else order,
    //   ];
    // }
  }
}

// ===============ORDER ITEM PROVIDER=========

final orderItemsProvider =
    FutureProvider.family<Map<String, List>, int>((ref, orderId) async {
  // return data.map((item) => OrderItem.fromJson(item)).toList();

  final orderItemsData = await orderService.fetchOrderItems(orderId);

  return orderItemsData;
});

// =============== RECEIVED ORDER PROVIDER=========
final receivedOrderProvider =
    StateNotifierProvider.autoDispose<ReceivedOrderNotifier, List<Order>>((ref) {
  return ReceivedOrderNotifier();
});

class ReceivedOrderNotifier extends StateNotifier<List<Order>> {
  ReceivedOrderNotifier() : super([]) {
    _loadOrders();
  }
  Future<void> _loadOrders() async {
    while (mounted) {
      final List<Order> orderList =
          await orderService.fetchOrders(mode: "receivedOrders");
      // print(List);
      // state = orderJson.map((json) => json).toList();
      state = orderList;
      await Future.delayed(Duration(seconds: 30));
    }
  }
}

// =============== CANCELLED ORDER PROVIDER=========
final cancelledOrderProvider =
    StateNotifierProvider.autoDispose<CancelledOrderNotifier, List<Order>>((ref) {
  return CancelledOrderNotifier();
});

class CancelledOrderNotifier extends StateNotifier<List<Order>> {
  CancelledOrderNotifier() : super([]) {
    _loadOrders();
  }
  Future<void> _loadOrders() async {
    while (mounted) {
      final List<Order> orderList =
          await orderService.fetchOrders(mode: "cancelledOrders");
      // print(List);
      // state = orderJson.map((json) => json).toList();
      state = orderList;
      await Future.delayed(Duration(seconds: 30));
    }
  }
}
