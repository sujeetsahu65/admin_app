import 'dart:async';

import 'package:admin_app/constants/global_variables.dart';
import 'package:admin_app/models/order_items_model.dart';
import 'package:admin_app/models/order_model.dart';
import 'package:admin_app/pages/auth/services/order.dart';
import 'package:admin_app/providers/error_handler.dart';
import 'package:admin_app/providers/language.dart';
import 'package:dio/dio.dart';
// import 'package:admin_app/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:quiver/async.dart'; // quiver provides useful debounce utilities

final OrderService orderService = OrderService();
final orderExpansionProvider =
    StateProvider.family<bool, int>((ref, id) => false);



// ===============ORDER ITEM PROVIDER=========

final orderItemsProvider =
    FutureProvider.autoDispose.family<Map<String, List>, int>((ref, orderId) async {
  // return data.map((item) => OrderItem.fromJson(item)).toList();
  final languageCode = ref.watch(localizationProvider).languageCode;

  try {
    final response = await orderService.fetchOrderItems(
        orderId: orderId, languageCode: languageCode);

    if (response.isSuccess) {
      final orderItemsData = response.data!;

      return orderItemsData;
    } else {
      ref.read(globalMessageProvider.notifier).showError(response.message);
      return {};
    }
  } catch (error) {
    ref.read(globalMessageProvider.notifier).showError("Something went wrong");
    return {};
  }
});

// =============== RECEIVED ORDER PROVIDER=========
final receivedOrderProvider = StateNotifierProvider.autoDispose<
    ReceivedOrderNotifier, AsyncValue<List<Order>>>((ref) {
  return ReceivedOrderNotifier(ref);
});

class ReceivedOrderNotifier extends StateNotifier<AsyncValue<List<Order>>> {
  ReceivedOrderNotifier(this.ref) : super(const AsyncValue.loading()) {
    // _loadOrders();
  }

  Ref ref;
  Future<void> loadOrders() async {
    while (mounted) {
      state = const AsyncValue.loading();
      try {
        final languageCode = ref.watch(localizationProvider).languageCode;
        final ApiResponse<List<Order>> response = await orderService
            .fetchOrders(mode: "receivedOrders", languageCode: languageCode);
        final orderList = response.data!;

        if (response.isSuccess) {
          state = AsyncValue.data(orderList);
        } else if (response.isNotFound) {
          state = AsyncValue.data([]);
        } else {
          ref.read(globalMessageProvider.notifier).showError(response.message);
        }
      } catch (error) {
        ref
            .read(globalMessageProvider.notifier)
            .showError("Something went wrong");
      }
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
    // _loadOrders();
  }
  Ref ref;
  Future<void> loadOrders() async {
    while (mounted) {
      state = const AsyncValue.loading();
      final languageCode = ref.watch(localizationProvider).languageCode;

      try {
        final ApiResponse<List<Order>> response = await orderService
            .fetchOrders(mode: "cancelledOrders", languageCode: languageCode);

        if (response.isSuccess) {
          final orderList = response.data!;
          state = AsyncValue.data(orderList);
        } else if (response.isNotFound) {
          state = AsyncValue.data([]);
        } else {
          ref.read(globalMessageProvider.notifier).showError(response.message);
        }
      } catch (error) {
        ref
            .read(globalMessageProvider.notifier)
            .showError("Something went wrong");
      }
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
    // _loadOrders();
  }
  Ref ref;
  Future<void> loadOrders() async {
    while (mounted) {
      state = const AsyncValue.loading();
      final languageCode = ref.watch(localizationProvider).languageCode;
      try {
        final ApiResponse<List<Order>> response = await orderService
            .fetchOrders(mode: "preOrders", languageCode: languageCode);

        if (response.isSuccess) {
          final orderList = response.data!;
          state = AsyncValue.data(orderList);
        } else if (response.isNotFound) {
          state = AsyncValue.data([]);
        } else {
          ref.read(globalMessageProvider.notifier).showError(response.message);
        }
      } catch (error) {
        ref
            .read(globalMessageProvider.notifier)
            .showError("Something went wrong");
      }

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
    // _loadOrders();
  }
  Ref ref;
  Future<void> loadOrders() async {
    while (mounted) {
      state = const AsyncValue.loading();
      final languageCode = ref.watch(localizationProvider).languageCode;

      try {
        final ApiResponse<List<Order>> response = await orderService
            .fetchOrders(mode: "failedOrders", languageCode: languageCode);

        if (response.isSuccess) {
          final orderList = response.data!;
          state = AsyncValue.data(orderList);
        } else if (response.isNotFound) {
          state = AsyncValue.data([]);
        } else {
          ref.read(globalMessageProvider.notifier).showError(response.message);
        }
      } catch (error) {
        ref
            .read(globalMessageProvider.notifier)
            .showError("Something went wrong");
      }
      await Future.delayed(Duration(seconds: 30));
    }
  }

    Future<void> updateOrder(Order updatedOrder, String mode) async {


    ApiResponse<bool> response =
        ApiResponse(data: false, statusCode: 404, message: 'initial');

    try {
      if (mode == 'moveFailedOrder') {
        response = await orderService.moveFailedOrder(updatedOrder);
      }

      if (response.isSuccess) {
        // Final update if the order is successfully updated on the server
        state = state.whenData((orders) => [
              for (final order in orders)
                if (order.orderId == updatedOrder.orderId)
                  updatedOrder
                else
                  order,
            ]);
              ref.read(globalMessageProvider.notifier).showSuccess('Order moved to new order list');
              ref.read(orderProvider.notifier).dispose();
              ref.read(orderProvider.notifier).startOrderPolling();
      } else {
        ref.read(globalMessageProvider.notifier).showError(response.message);
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      ref
          .read(globalMessageProvider.notifier)
          .showError("Something went wrong");
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
      final response = await _orderService.fetchOrderDetails(
          query: query, languageCode: languageCode);

      if (response.isSuccess) {
        final order = response.data!;

        if (order != null) {
          print('order is not null');
          state = state.copyWith(isLoading: false, order: order);
        } else {
          // Clear previous order and show 'no order found' message
          state = state.copyWith(
              isLoading: false, order: null, errorMessage: 'No order found');
        }
      } else if (response.isNotFound) {
        state = state.copyWith(
            isLoading: false, order: null, errorMessage: 'No order found');
      } else {
        ref.read(globalMessageProvider.notifier).showError(response.message);
      }
    } on DioException catch (e) {
      ref.read(globalMessageProvider.notifier).showError("No order found");
      state = state.copyWith(
          isLoading: false, order: null, errorMessage: 'No order found');
    } catch (e) {
      // Handle any other errors
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      ref
          .read(globalMessageProvider.notifier)
          .showError("Something went wrong");
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

// class OrderNotifier extends StateNotifier<AsyncValue<List<Order>>> {
//   OrderNotifier(this.ref) : super(const AsyncValue.loading()) {
//     // _loadOrders();
//   }

//   final Ref ref;
//   bool _isDisposed = false;

//   Future<void> loadOrders() async {
//     final languageCode = ref.watch(localizationProvider).languageCode;
//     while (!_isDisposed) {
//       try {
//         final ApiResponse<List<Order>> response =
//             await orderService.fetchOrders(languageCode: languageCode);

//         if (response.isSuccess) {
//           final orderList = response.data!;

//           if (!_isDisposed) {
//             state = AsyncValue.data(orderList);
//           }
//         } else if (response.isNotFound) {
//           state = AsyncValue.data([]);
//         } else {
//           ref.read(globalMessageProvider.notifier).showError(response.message);
//         }
//       } catch (error, stackTrace) {
//         if (!_isDisposed) {
//           state = AsyncValue.error(error, stackTrace);
//           ref
//               .read(globalMessageProvider.notifier)
//               .showError("Something went wrong");
//         }
//       }
//       await Future.delayed(Duration(seconds: 30));
//     }
//   }

//   Future<void> updateOrder(Order updatedOrder, String mode) async {
//     // Optimistically update the UI
//     // state = state.whenData((orders) => [
//     //       for (final order in orders)
//     //         if (order.orderId == updatedOrder.orderId) updatedOrder else order,
//     //     ]);

//     ApiResponse<bool> response =
//         ApiResponse(data: false, statusCode: 404, message: 'initial');

//     try {
//       if (mode == 'setOrderDeliveryTime') {
//         response = await orderService.setOrderDeliveryTime(updatedOrder);
//       } else if (mode == 'setPreOrderAlertTime') {
//         response = await orderService.setPreOrderAlertTime(updatedOrder);
//       } else if (mode == 'concludeOrder') {
//         response = await orderService.concludeOrder(updatedOrder);
//       } else if (mode == 'cancelOrder') {
//         response = await orderService.cancelOrder(updatedOrder);
//       }

//       if (response.isSuccess) {
//         // Final update if the order is successfully updated on the server
//         state = state.whenData((orders) => [
//               for (final order in orders)
//                 if (order.orderId == updatedOrder.orderId)
//                   updatedOrder
//                 else
//                   order,
//             ]);
//       } else {
//         ref.read(globalMessageProvider.notifier).showError(response.message);
//       }
//     } catch (error, stackTrace) {
//       state = AsyncValue.error(error, stackTrace);
//       ref
//           .read(globalMessageProvider.notifier)
//           .showError("Something went wrong");
//     }
//   }

//   void disposeNotifier() {
//     _isDisposed = true;
//   }
// }


class OrderNotifier extends StateNotifier<AsyncValue<List<Order>>> {
  OrderNotifier(this.ref) : super(const AsyncValue.loading());

  final Ref ref;
  StreamSubscription<List<Order>>? _orderSubscription;

  // This starts the stream that fetches orders immediately, then every 30 seconds
  void startOrderPolling() async {
    _orderSubscription?.cancel(); // Cancel any previous stream
    final languageCode = ref.watch(localizationProvider).languageCode;

    // Fetch orders immediately
    await _fetchOrdersImmediately(languageCode);

    // Create a stream that fetches orders every 30 seconds
    _orderSubscription = Stream.periodic(Duration(seconds: 30), (_) async {
      return await _loadOrders(languageCode);
    }).asyncMap((event) async => await event) // Wait for async fetch result
      .listen(
        (orderList) => state = AsyncValue.data(orderList),
        onError: (error, stackTrace) {
          state = AsyncValue.error(error, stackTrace);
          ref.read(globalMessageProvider.notifier).showError("Something went wrong");
        },
      );
  }

  // Function to fetch orders immediately
  Future<void> _fetchOrdersImmediately(String languageCode) async {
    try {
      final orderList = await _loadOrders(languageCode);
      state = AsyncValue.data(orderList);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      ref.read(globalMessageProvider.notifier).showError("Something went wrong");
    }
  }

  // Function to fetch orders
  Future<List<Order>> _loadOrders(String languageCode) async {
    final ApiResponse<List<Order>> response =
        await orderService.fetchOrders(languageCode: languageCode);

    if (response.isSuccess) {
      return response.data!;
    } else if (response.isNotFound) {
      return [];
    } else {
      ref.read(globalMessageProvider.notifier).showError(response.message);
      throw Exception(response.message);
    }
  }

  @override
  void dispose() {
    _orderSubscription?.cancel(); // Clean up subscription on dispose
    super.dispose();
  }


  Future<void> updateOrder(Order updatedOrder, String mode) async {
    // Optimistically update the UI
    // state = state.whenData((orders) => [
    //       for (final order in orders)
    //         if (order.orderId == updatedOrder.orderId) updatedOrder else order,
    //     ]);

    ApiResponse<bool> response =
        ApiResponse(data: false, statusCode: 404, message: 'initial');

    try {
      if (mode == 'setOrderDeliveryTime') {
        response = await orderService.setOrderDeliveryTime(updatedOrder);
      } else if (mode == 'setPreOrderAlertTime') {
        response = await orderService.setPreOrderAlertTime(updatedOrder);
      } else if (mode == 'concludeOrder') {
        response = await orderService.concludeOrder(updatedOrder);
      } else if (mode == 'cancelOrder') {
        response = await orderService.cancelOrder(updatedOrder);
      }

      if (response.isSuccess) {
        // Final update if the order is successfully updated on the server
        state = state.whenData((orders) => [
              for (final order in orders)
                if (order.orderId == updatedOrder.orderId)
                  updatedOrder
                else
                  order,
            ]);
      } else {
        ref.read(globalMessageProvider.notifier).showError(response.message);
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      ref
          .read(globalMessageProvider.notifier)
          .showError("Something went wrong");
    }
  }

  // void disposeNotifier() {
  //   _isDisposed = true;
  // }
}
