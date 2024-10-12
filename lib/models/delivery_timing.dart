// import 'package:admin_app/common/functions/common_class.dart';

// class DeliveryTiming implements TimingModelTest {
//   final int dayNumber;
//   final String fromTime;
//   final String toTime;
//   final bool nextDay;
//   final bool closeStatus;
//   final String tableName;

//   DeliveryTiming({
//     required this.dayNumber,
//     required this.fromTime,
//     required this.toTime,
//     required this.nextDay,
//     required this.closeStatus,
//     required this.tableName,
//   });

//   @override
//   DeliveryTiming copyWith({
//     String? fromTime,
//     String? toTime,
//     bool? closeStatus,
//   }) {
//     return DeliveryTiming(
//       dayNumber: dayNumber,
//       fromTime: fromTime ?? this.fromTime,
//       toTime: toTime ?? this.toTime,
//       nextDay: nextDay,
//       closeStatus: closeStatus ?? this.closeStatus,
//       tableName: tableName,
//     );
//   }

//     factory DeliveryTiming.fromJson(Map<String, dynamic> json) {
//     return DeliveryTiming(
//       dayNumber: json['dayNumber'],
//       fromTime: json['fromTime'],
//       toTime: json['toTime'],
//       nextDay: json['nextDay'] == 1,
//       closeStatus: json['closeStatus'] == 1,
//       tableName: json['tableName'],
//     );
//   }
// }
