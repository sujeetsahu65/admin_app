import 'package:admin_app/common/functions/common_class.dart';

class LunchTiming implements TimingModelTest{
  final int dayNumber;
  final String fromTime;
  final String toTime;
  final bool closeStatus;
  final String tableName;

  LunchTiming({
    required this.dayNumber,
    required this.fromTime,
    required this.toTime,
    required this.closeStatus,
    required this.tableName,
  });

  factory LunchTiming.fromJson(Map<String, dynamic> json) {
    return LunchTiming(
      dayNumber: json['dayNumber'],
      fromTime: json['fromTime'],
      toTime: json['toTime'],
      closeStatus: json['closeStatus'] == 1,
      tableName: json['tableName'],
    );
  }


    @override
  LunchTiming copyWith({
    String? fromTime,
    String? toTime,
    bool? closeStatus,
  }) {
    return LunchTiming(
      dayNumber: dayNumber,
      fromTime: fromTime ?? this.fromTime,
      toTime: toTime ?? this.toTime,
      closeStatus: closeStatus ?? this.closeStatus,
      tableName: tableName,
    );
  }
}
