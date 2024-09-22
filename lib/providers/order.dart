import 'package:admin_app/constants/global_variables.dart';
import 'package:admin_app/models/order_items_model.dart';
import 'package:admin_app/models/order_model.dart';
import 'package:admin_app/pages/auth/services/order.dart';
import 'package:admin_app/providers/language.dart';
import 'package:dio/dio.dart';
// import 'package:admin_app/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final OrderService orderService = OrderService();
final orderExpansionProvider =
    StateProvider.family<bool, int>((ref, id) => false);

// final orderProvider = StateNotifierProvider<OrderNotifier, List<Order>>((ref) {
//   return OrderNotifier(ref);
// });

// class OrderNotifier extends StateNotifier<List<Order>> {
//   OrderNotifier(this.ref) : super([]) {
//     _loadOrders();
//   }

//     final Ref ref;
// // sdgfdg
// // await Future.delayed(Duration(seconds: 30));
//   Future<void> _loadOrders() async {
// final languageCode = ref.watch(localizationProvider).languageCode;
//     while (true) {
//       final List<Order> orderList = await orderService.fetchOrders(languageCode: languageCode);
//       // print(List);
//       // state = orderJson.map((json) => json).toList();
//       state = orderList;
//       await Future.delayed(Duration(seconds: 30));
//     }
//   }

//   void updateOrder(Order updatedOrder, mode) async {
//     state = [
//       for (final order in state)
//         if (order.orderId == updatedOrder.orderId) updatedOrder else order,
//     ];

//     if (mode == 'setOrderDeliveryTime') {
//       final bool isOrderUpdated =
//           await orderService.setOrderDeliveryTime(updatedOrder);
//     } else if (mode == 'setPreOrderAlertTime') {
//       final bool isOrderUpdated =
//           await orderService.setPreOrderAlertTime(updatedOrder);
//     } else if (mode == 'concludeOrder') {
//       final bool isOrderUpdated =
//           await orderService.concludeOrder(updatedOrder);
//     } else if (mode == 'cancelOrder') {
//       final bool isOrderUpdated = await orderService.cancelOrder(updatedOrder);
//     }

//     // if (isOrderUpdated) {
//     //   state = [
//     //     for (final order in state)
//     //       if (order.orderId == updatedOrder.orderId) updatedOrder else order,
//     //   ];
//     // }
//   }
// }

// ===============ORDER ITEM PROVIDER=========

final orderItemsProvider =
    FutureProvider.family<Map<String, List>, int>((ref, orderId) async {
  // return data.map((item) => OrderItem.fromJson(item)).toList();
  final languageCode = ref.watch(localizationProvider).languageCode;
  final orderItemsData = await orderService.fetchOrderItems(
      orderId: orderId, languageCode: languageCode);

  return orderItemsData;
});

// =============== RECEIVED ORDER PROVIDER=========
final receivedOrderProvider = StateNotifierProvider.autoDispose<
    ReceivedOrderNotifier, AsyncValue<List<Order>>>((ref) {
  return ReceivedOrderNotifier(ref);
});

class ReceivedOrderNotifier extends StateNotifier<AsyncValue<List<Order>>> {
  ReceivedOrderNotifier(this.ref) : super(const AsyncValue.loading()) {
    _loadOrders();
  }

  Ref ref;
  Future<void> _loadOrders() async {
    while (mounted) {
      state = const AsyncValue.loading();
      final languageCode = ref.watch(localizationProvider).languageCode;
      final List<Order> orderList = await orderService.fetchOrders(
          mode: "receivedOrders", languageCode: languageCode);
      // print(List);
      // state = orderJson.map((json) => json).toList();
      state = AsyncValue.data(orderList);
      await Future.delayed(Duration(seconds: 30));
    }
  }
}

// =============== CANCELLED ORDER PROVIDER=========
final cancelledOrderProvider = StateNotifierProvider.autoDispose<
    CancelledOrderNotifier, AsyncValue<List<Order>>>((ref) {
  return CancelledOrderNotifier(ref);
});

class CancelledOrderNotifier extends StateNotifier<AsyncValue<List<Order>>> {
  CancelledOrderNotifier(this.ref) : super(const AsyncValue.loading()) {
    _loadOrders();
  }
  Ref ref;
  Future<void> _loadOrders() async {
    while (mounted) {
      state = const AsyncValue.loading();
      final languageCode = ref.watch(localizationProvider).languageCode;
      final List<Order> orderList = await orderService.fetchOrders(
          mode: "cancelledOrders", languageCode: languageCode);
      // print(List);
      // state = orderJson.map((json) => json).toList();
      state = AsyncValue.data(orderList);
      await Future.delayed(Duration(seconds: 30));
    }
  }
}

// =============== PRE-ORDER PROVIDER=========
final preOrderProvider = StateNotifierProvider.autoDispose<PreOrderNotifier,
    AsyncValue<List<Order>>>((ref) {
  return PreOrderNotifier(ref);
});

class PreOrderNotifier extends StateNotifier<AsyncValue<List<Order>>> {
  PreOrderNotifier(this.ref) : super(const AsyncValue.loading()) {
    _loadOrders();
  }
  Ref ref;
  Future<void> _loadOrders() async {
    while (mounted) {
      state = const AsyncValue.loading();
      final languageCode = ref.watch(localizationProvider).languageCode;
      final List<Order> orderList = await orderService.fetchOrders(
          mode: "preOrders", languageCode: languageCode);
      // print(List);
      // state = orderJson.map((json) => json).toList();
      state = AsyncValue.data(orderList);
      await Future.delayed(Duration(seconds: 30));
    }
  }
}

// =============== FAILED-ORDER PROVIDER=========
final failedOrderProvider = StateNotifierProvider.autoDispose<
    FailedOrderNotifier, AsyncValue<List<Order>>>((ref) {
  return FailedOrderNotifier(ref);
});

class FailedOrderNotifier extends StateNotifier<AsyncValue<List<Order>>> {
  FailedOrderNotifier(this.ref) : super(const AsyncValue.loading()) {
    _loadOrders();
  }
  Ref ref;
  Future<void> _loadOrders() async {
    while (mounted) {
      state = const AsyncValue.loading();
      final languageCode = ref.watch(localizationProvider).languageCode;
      final List<Order> orderList = await orderService.fetchOrders(
          mode: "failedOrders", languageCode: languageCode);
      // print(List);
      // state = orderJson.map((json) => json).toList();
      state = AsyncValue.data(orderList);
      await Future.delayed(Duration(seconds: 30));
    }
  }
}

// =============== PRE-ORDER PROVIDER=========
// final orderDetailsProvider =
//     StateNotifierProvider.autoDispose<OrderSearchNotifier, OrderSearchState>((ref) {
//   return OrderSearchNotifier(ref);
// });

// Provider for the OrderSearchNotifier
final orderSearchProvider =
    StateNotifierProvider<OrderSearchNotifier, OrderSearchState>((ref) {
  return OrderSearchNotifier(ref, orderService);
});

class OrderSearchNotifier extends StateNotifier<OrderSearchState> {
  // OrderDetailsNotifier(this.ref) : super([]);
  Ref ref;

  final OrderService _orderService;

  OrderSearchNotifier(this.ref, this._orderService) : super(OrderSearchState());

  Future<void> searchOrder(String query) async {
    final languageCode = ref.watch(localizationProvider).languageCode;
    state = state.copyWith(isLoading: true, order: null, errorMessage: null);
    try {
      final order = await _orderService.fetchOrderDetails(
          query: query, languageCode: languageCode);

      if (order != null) {
        print('order is not null');
        state = state.copyWith(isLoading: false, order: order);
      } else {
        // Clear previous order and show 'no order found' message
        state = state.copyWith(
            isLoading: false, order: null, errorMessage: 'No order found');
      }
    } on DioException catch (e) {
      state = state.copyWith(
          isLoading: false, order: null, errorMessage: 'No order found');
    } catch (e) {
      // Handle any other errors
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}

class OrderSearchState {
  final bool isLoading;
  final Order? order;
  final String? errorMessage;

  OrderSearchState({this.isLoading = false, this.order, this.errorMessage});

  // Helper method for updating state
  OrderSearchState copyWith({
    bool? isLoading,
    Order? order,
    String? errorMessage,
  }) {
    return OrderSearchState(
      isLoading: isLoading ?? this.isLoading,
      order: order,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

final orderProvider =
    StateNotifierProvider<OrderNotifier, AsyncValue<List<Order>>>((ref) {
  return OrderNotifier(ref);
});

class OrderNotifier extends StateNotifier<AsyncValue<List<Order>>> {
  OrderNotifier(this.ref) : super(const AsyncValue.loading()) {
    // _loadOrders();
  }

  final Ref ref;
  bool _isDisposed = false;

  Future<void> loadOrders() async {
    final languageCode = ref.watch(localizationProvider).languageCode;
    while (!_isDisposed) {
      try {
        final List<Order> orderList =
            await orderService.fetchOrders(languageCode: languageCode);
        if (!_isDisposed) {
          state = AsyncValue.data(orderList);
        }
      } catch (error, stackTrace) {
        if (!_isDisposed) {
          state = AsyncValue.error(error, stackTrace);
        }
      }
      await Future.delayed(Duration(seconds: 30));
    }
  }

  Future<void> updateOrder(Order updatedOrder, String mode) async {
    // Optimistically update the UI
    state = state.whenData((orders) => [
          for (final order in orders)
            if (order.orderId == updatedOrder.orderId) updatedOrder else order,
        ]);

    bool isOrderUpdated = false;

    try {
      if (mode == 'setOrderDeliveryTime') {
        isOrderUpdated = await orderService.setOrderDeliveryTime(updatedOrder);
      } else if (mode == 'setPreOrderAlertTime') {
        isOrderUpdated = await orderService.setPreOrderAlertTime(updatedOrder);
      } else if (mode == 'concludeOrder') {
        isOrderUpdated = await orderService.concludeOrder(updatedOrder);
      } else if (mode == 'cancelOrder') {
        isOrderUpdated = await orderService.cancelOrder(updatedOrder);
      }

      if (isOrderUpdated) {
        // Final update if the order is successfully updated on the server
        state = state.whenData((orders) => [
              for (final order in orders)
                if (order.orderId == updatedOrder.orderId)
                  updatedOrder
                else
                  order,
            ]);
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(
          error, stackTrace); // Handle error by setting error state
    }
  }

  void disposeNotifier() {
    _isDisposed = true;
  }
}
