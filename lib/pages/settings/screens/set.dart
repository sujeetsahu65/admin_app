import 'package:admin_app/common/widgets/other_widgets/time_picker.dart';
import 'package:admin_app/pages/settings/services/shop_schedule.dart';
import 'package:admin_app/providers/shop_schedule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShopTimingsPage extends ConsumerStatefulWidget {
  @override
  _ShopTimingsPageState createState() => _ShopTimingsPageState();
}

class _ShopTimingsPageState extends ConsumerState<ShopTimingsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<String> tabs = [
    'Visiting Timings',
    'Lunch Timings',
    'Delivery Timings'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop Timings'),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Visiting Timings Tab
          ref.watch(visitingTimingsProvider).when(
            data: (timings) => TimingsTableWidget(timings: timings),
            loading: () => CircularProgressIndicator(),
            error: (err, stack) => Text('Error: $err'),
          ),
          // Lunch Timings Tab
          ref.watch(lunchTimingsProvider).when(
            data: (timings) => TimingsTableWidget(timings: timings),
            loading: () => CircularProgressIndicator(),
            error: (err, stack) => Text('Error: $err'),
          ),
          // Delivery Timings Tab
          ref.watch(deliveryTimingsProvider).when(
            data: (timings) => TimingsTableWidget(timings: timings),
            loading: () => CircularProgressIndicator(),
            error: (err, stack) => Text('Error: $err'),
          ),
        ],
      ),
      bottomNavigationBar: Material(
        color: Theme.of(context).primaryColor, // Match AppBar color
        child: TabBar(
          controller: _tabController,
          tabs: tabs.map((tab) => Tab(text: tab)).toList(),
          labelColor: Theme.of(context).cardColor,
          unselectedLabelColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorPadding: EdgeInsets.all(5.0),
          indicatorColor: Theme.of(context).cardColor,
        ),
      ),
    );
  }
}

class TimingsTableWidget extends StatelessWidget {
  final List<dynamic> timings;

  final scheduleService = ScheduleService();

  TimingsTableWidget({required this.timings});

  void updateScheduleData(String field, TimeOfDay newValue, dynamic tableData) {
    // You might need to adjust this method to fit the actual data update mechanism
    scheduleService.updateScheduleData(field, newValue, tableData);
  }

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: [
        DataColumn(label: Text('Day')),
        DataColumn(label: Text('Open Time')),
        DataColumn(label: Text('Close Time')),
        DataColumn(label: Text('Closed')),
      ],
      rows: timings.map((timing) {
        return DataRow(cells: [
          DataCell(Text(getDayNumber(timing.dayNumber))),
          DataCell(TimePickerWidget(
            initialTime: stringToTimeOfDay(timing.fromTime),
            onTimeChanged: (newTime) {
              updateScheduleData('fromTime', newTime, timing);
            },
          )),
          DataCell(TimePickerWidget(
            initialTime: stringToTimeOfDay(timing.toTime),
            onTimeChanged: (newTime) {
              updateScheduleData('toTime', newTime, timing);
            },
          )),
          DataCell(Checkbox(
            value: timing.closeStatus,
            onChanged: (bool? value) {
              // Implementation needed for what happens when the checkbox is toggled
            },
          )),
        ]);
      }).toList(),
    );
  }

  String getDayNumber(int day) {
    List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[day - 1];
  }

  TimeOfDay stringToTimeOfDay(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }
}
