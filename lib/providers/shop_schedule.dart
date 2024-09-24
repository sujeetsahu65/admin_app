import 'package:admin_app/common/functions/common_class.dart';
import 'package:admin_app/models/delivery_timing.dart';
import 'package:admin_app/models/lunch_timing.dart';
import 'package:admin_app/models/timing.dart';
import 'package:admin_app/models/visiting_timing.dart';
import 'package:admin_app/pages/settings/services/shop_schedule.dart';
import 'package:admin_app/providers/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Service instance
final scheduleServiceProvider = Provider((ref) => ScheduleService());

// // Visiting Timings Provider
// final visitingTimingsProvider = FutureProvider<List<VisitingTiming>>((ref) async {
//   final service = ref.read(scheduleServiceProvider);
//   return await service.fetchVisitingTimings();
// });

// // Lunch Timings Provider
// final lunchTimingsProvider = FutureProvider<List<LunchTiming>>((ref) async {
//   final service = ref.read(scheduleServiceProvider);
//   return await service.fetchLunchTimings();
// });

// // Delivery Timings Provider
// final deliveryTimingsProvider = FutureProvider<List<DeliveryTiming>>((ref) async {
//   final service = ref.read(scheduleServiceProvider);
//   return await service.fetchDeliveryTimings();
// });

class TimingsNotifier extends StateNotifier<List<TimingModel>> {
  final ScheduleService _scheduleService;

  TimingsNotifier(this.ref, this._scheduleService) : super([]);
  final Ref ref;
  Future<void> fetchTimings(String tableName) async {
    try {
      ApiResponse<List<TimingModel>> response;
      response = await _scheduleService.fetchTimings(tableName);

      if (response.isSuccess) {
        final timings = response.data!;
        // if (timingType == 'visiting') {
        //   timings = await _scheduleService.fetchVisitingTimings();
        // } else if (timingType == 'lunch') {
        //   timings = await _scheduleService.fetchLunchTimings();
        // } else {
        //   timings = await _scheduleService.fetchDeliveryTimings();
        // }

        state = timings
            .map((t) => t.copyWith(tableName: tableName))
            .toList(); //maybe giving table name is helpful in differentiating the two or more UI data structure so that whenever we tap on tab it detecs difference and call api otherwise with same UI data it won't call api(though we have table name with each data row but still it is good practice to tag this this way)
      } else {
        ref.read(globalMessageProvider.notifier).showError(response.message);
      }
    } catch (error) {
      ref
          .read(globalMessageProvider.notifier)
          .showError("Something went wrong");
    }
  }

  void updateTiming(String field, TimeOfDay newTime, TimingModel timing) async {
    try {
      final response = await _scheduleService.updateScheduleData(
          field, timeOfDayToString(newTime), timing);

      if (response.isSuccess) {
        final updatedTiming = timing.copyWith(
          fromTime: field == 'fromTime'
              ? timeOfDayToString(newTime)
              : timing.fromTime,
          toTime:
              field == 'toTime' ? timeOfDayToString(newTime) : timing.toTime,
        );

        state = [
          for (final t in state)
            if (t.dayNumber == timing.dayNumber &&
                t.tableName == timing.tableName)
              updatedTiming
            else
              t,
        ];
      } else {
        ref.read(globalMessageProvider.notifier).showError(response.message);
      }
    } catch (error) {
      ref
          .read(globalMessageProvider.notifier)
          .showError("Something went wrong");
    }
  }

  void updateClosedStatus(bool newValue, TimingModel timing) async {
    try {
      final response = await _scheduleService.updateScheduleData(
          'closeStatus', newValue, timing);

      if (response.isSuccess) {
        final updatedTiming = timing.copyWith(closeStatus: newValue);

        state = [
          for (final t in state)
            if (t.dayNumber == timing.dayNumber &&
                t.tableName == timing.tableName)
              updatedTiming
            else
              t,
        ];
        
      } else {
        ref.read(globalMessageProvider.notifier).showError(response.message);
      }
    } catch (error) {
      ref
          .read(globalMessageProvider.notifier)
          .showError("Something went wrong");
    }
  }

  String timeOfDayToString(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

// Provider
final timingsNotifierProvider =
    StateNotifierProvider.autoDispose<TimingsNotifier, List<TimingModel>>(
  (ref) => TimingsNotifier(ref, ref.watch(scheduleServiceProvider)),
);






// final visitingTimingsNotifierProvider = StateNotifierProvider<TimingsNotifier<VisitingTiming>, List<VisitingTiming>>((ref) {
//   final scheduleService = ref.read(scheduleServiceProvider);
//   return TimingsNotifier<VisitingTiming>(scheduleService)..fetchTimings('visiting');
// });

// final lunchTimingsNotifierProvider = StateNotifierProvider<TimingsNotifier<LunchTiming>, List<LunchTiming>>((ref) {
//   final scheduleService = ref.read(scheduleServiceProvider);
//   return TimingsNotifier<LunchTiming>(scheduleService)..fetchTimings('lunch');
// });

// final deliveryTimingsNotifierProvider = StateNotifierProvider<TimingsNotifier<DeliveryTiming>, List<DeliveryTiming>>((ref) {
//   final scheduleService = ref.read(scheduleServiceProvider);
//   return TimingsNotifier<DeliveryTiming>(scheduleService)..fetchTimings('delivery');
// });

