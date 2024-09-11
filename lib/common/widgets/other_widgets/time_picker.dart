import 'package:flutter/material.dart';


class TimePickerWidget extends StatelessWidget {
  final TimeOfDay initialTime;
  final Function(TimeOfDay) onTimeChanged;

  TimePickerWidget({required this.initialTime, required this.onTimeChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: initialTime,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
              child: child!,
            );
          },
        );
        if (pickedTime != null) {
          onTimeChanged(pickedTime);
        }
      },
      child: Text(initialTime.format(context)), // Display in 12-hour format
    );
  }
}
