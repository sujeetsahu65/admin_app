import 'package:admin_app/models/delivery_timing.dart';
import 'package:admin_app/models/lunch_timing.dart';
import 'package:admin_app/models/visiting_timing.dart';
import 'package:admin_app/pages/settings/services/shop_schedule.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Service instance
final scheduleServiceProvider = Provider((ref) => ScheduleService());

// Visiting Timings Provider
final visitingTimingsProvider = FutureProvider<List<VisitingTiming>>((ref) async {
  final service = ref.read(scheduleServiceProvider);
  return await service.fetchVisitingTimings();
});

// Lunch Timings Provider
final lunchTimingsProvider = FutureProvider<List<LunchTiming>>((ref) async {
  final service = ref.read(scheduleServiceProvider);
  return await service.fetchLunchTimings();
});

// Delivery Timings Provider
final deliveryTimingsProvider = FutureProvider<List<DeliveryTiming>>((ref) async {
  final service = ref.read(scheduleServiceProvider);
  return await service.fetchDeliveryTimings();
});
