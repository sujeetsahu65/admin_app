class LunchTiming {
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
}
