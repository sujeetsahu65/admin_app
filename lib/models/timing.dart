class TimingModel {
  final int dayNumber;
  final String fromTime;
  final String toTime;
  // final bool nextDay;
  final bool closeStatus;
  final String tableName;

  TimingModel({
    required this.dayNumber,
    required this.fromTime,
    required this.toTime,
    // required this.nextDay,
    required this.closeStatus,
    required this.tableName,
  });

  TimingModel copyWith({
    int? dayNumber,
    String? fromTime,
    String? toTime,
    bool? nextDay,
    bool? closeStatus,
    String? tableName,
  }) {
    return TimingModel(
      dayNumber: dayNumber ?? this.dayNumber,
      fromTime: fromTime ?? this.fromTime,
      toTime: toTime ?? this.toTime,
      // nextDay: nextDay ?? this.nextDay,
      closeStatus: closeStatus ?? this.closeStatus,
      tableName: tableName ?? this.tableName,
    );
  }

  factory TimingModel.fromJson(Map<String, dynamic> json) {
    return TimingModel(
      dayNumber: json['dayNumber'],
      fromTime: json['fromTime'],
      toTime: json['toTime'],
      // nextDay: json['nextDay'] == 1,
      closeStatus: json['closeStatus'] == 1,
      tableName: json['tableName'],
    );
  }
}
