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
              data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child!,
            );
          },
        );
        if (pickedTime != null) {
          onTimeChanged(pickedTime);
        }
      },
      child: Text(formatTime(initialTime)), // Display in 12-hour format
    );
  }

    // Helper method to format TimeOfDay to HH:mm format
  String formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');  // Add leading zero if needed
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute'; // Format to HH:mm
  }
}
