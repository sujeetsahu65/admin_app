class VisitingTiming {
  final int dayNumber;
  final String fromTime;
  final String toTime;
  final bool nextDay;
  final bool closeStatus;
  final String tableName;

  VisitingTiming({
    required this.dayNumber,
    required this.fromTime,
    required this.toTime,
    required this.nextDay,
    required this.closeStatus,
    required this.tableName,
  });

  factory VisitingTiming.fromJson(Map<String, dynamic> json) {
    return VisitingTiming(
      dayNumber: json['dayNumber'],
      fromTime: json['fromTime'],
      toTime: json['toTime'],
      nextDay: json['nextDay'] == 1,
      closeStatus: json['closeStatus'] == 1,
      tableName: json['tableName'],
    );
  }
}
