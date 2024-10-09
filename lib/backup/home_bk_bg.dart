import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:admin_app/common/widgets/order_widgets/orderCard.dart';
import 'package:admin_app/common/widgets/other_widgets/loader.dart';
import 'package:admin_app/models/order_model.dart';
import 'package:admin_app/pages/home/services/audio.dart';
import 'package:admin_app/providers/basic.dart';
import 'package:admin_app/providers/error_handler.dart';
import 'package:admin_app/providers/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePage();
}

class _HomePage extends ConsumerState<HomePage> {
  final String page = 'home';
  bool isBackgroundServiceRunning = false;
  final providerContainer = ProviderContainer();

  @override
  void initState() {
    super.initState();
    // Trigger general data loading first
    Future.wait([
      _loadGeneralData(), // First load general data
      _initializeOtherData(), // Then load other data like orders, etc.
    ]).then((_) {
      print("Data loaded successfully");
    }).catchError((error) {
      ref
          .read(globalMessageProvider.notifier)
          .showError("Failed to initialize data.");
      print("Error initializing data: $error");
    });
  }

  Future<void> _initializeOtherData() async {
    OrderBackgroundService orderBackgroundService =
        OrderBackgroundService(providerContainer);
    print("Initializing other data and starting order fetching");
    await orderBackgroundService.startOrderFetching();
  }

  Future<void> _loadGeneralData() async {
    ref.read(generalDataProvider.notifier).loadGeneralData();
  }

  @override
  Widget build(BuildContext context) {
    final orderAsyncValue = ref.watch(orderProvider);

    return Scaffold(
      body: Stack(children: [
        orderAsyncValue.when(
          data: (orders) {
            final filteredOrders = orders.where((order) {
              return (order.ordersStatusId == 3 || order.ordersStatusId == 5) &&
                  (order.preOrderBooking == 0 ||
                      order.preOrderBooking == 1 ||
                      order.preOrderBooking == 3);
            }).toList();

            if (filteredOrders.isEmpty) {
              return const Center(child: Text('No orders'));
            } else {
              final hasPendingOrders = filteredOrders.any((Order order) =>
                  order.ordersStatusId == 3 &&
                  (order.preOrderBooking == 0 ||
                      order.preOrderBooking == 1 ||
                      order.preOrderBooking == 3));

              if (hasPendingOrders) {
                AudioService().playAlarmSound();
              } else {
                AudioService().stopAlarmSound();
              }

              return ListView.builder(
                itemCount: filteredOrders.length,
                itemBuilder: (context, index) {
                  final order = filteredOrders[index];
                  return OrderCard(
                    order: order,
                    page: page,
                  );
                },
              );
            }
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(child: Text('Error: $error')),
        ),
        GlobalLoader(),
      ]),
    );
  }
}

class OrderBackgroundService {
  final ProviderContainer container;

  OrderBackgroundService(this.container);

  Future<void> startOrderFetching() async {
    print('OrderBackgroundService ccccccccccc');
    // bool hasBackgroundService = await _startBackgroundServiceIfNeeded();
    // if (!hasBackgroundService) {
    //   print("Fallback to polling, background service not available");
    //   container.read(orderProvider.notifier).startOrderPolling();
    // } else {
    //   print("Background service started successfully");
    // }
      container.read(orderProvider.notifier).startOrderPolling();
  }

  Future<bool> _startBackgroundServiceIfNeeded() async {
    if (await Permission.notification.isGranted &&
        await Permission.ignoreBatteryOptimizations.isGranted) {
      final service = FlutterBackgroundService();
      // bool isRunning = await service.isRunning();
      // print("Service running: $isRunning");

      // if (!isRunning) {
      //   print("Service not running, starting service...");
      //   return false;
      // } else {
      //   print("Service is already running");
        container.read(orderProvider.notifier).startOrderPolling();
        return true;
      // }

      // return true;
    } else {
      print("Service permissions not granted");
      return false;
    }
  }
}
