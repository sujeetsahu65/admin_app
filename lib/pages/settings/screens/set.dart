import 'package:admin_app/common/widgets/other_widgets/time_picker.dart';
import 'package:admin_app/models/timing.dart';
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
  List<String> tabs = ['Visiting_Timings', 'Lunch_Timings', 'Delivery_Timings'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    ref.read(timingsNotifierProvider.notifier).fetchTimings('visiting_timings');
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void onTabChanged(int index) {
    // final timingType = tabs[index].split(' ')[0].toLowerCase();
    final timingType = tabs[index].toLowerCase();
    print(timingType);
    ref.read(timingsNotifierProvider.notifier).fetchTimings(timingType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // TabBar(
          //   controller: _tabController,
          //   tabs: tabs.map((tab) => Tab(text: tab)).toList(),
          //   onTap: onTabChanged,
          // ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                for (final tab in tabs)
                  ref.watch(timingsNotifierProvider).isEmpty
                      ? Center(child: CircularProgressIndicator())
                      : TimingsTableWidget(timings: ref.watch(timingsNotifierProvider)),
              ],
            ),
            
          ),
        ],
      ),
          bottomNavigationBar: Material(
        color: Theme.of(context).primaryColor, // Match AppBar color
        child: TabBar(
          onTap: onTabChanged,
          controller: _tabController,
          tabs: tabs.map((tab) => Tab(text: tab)).toList(),
          labelColor: Theme.of(context).cardColor,
          unselectedLabelColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorPadding: EdgeInsets.all(5.0),
          indicatorColor: Theme.of(context).cardColor,
        ),
      )
    );
  }
}

class TimingsTableWidget extends ConsumerWidget {
  final List<TimingModel> timings;

  TimingsTableWidget({required this.timings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DataTable(
      columns: const [
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
              ref.read(timingsNotifierProvider.notifier).updateTiming('fromTime', newTime, timing);
            },
          )),
          DataCell(TimePickerWidget(
            initialTime: stringToTimeOfDay(timing.toTime),
            onTimeChanged: (newTime) {
              ref.read(timingsNotifierProvider.notifier).updateTiming('toTime', newTime, timing);
            },
          )),
          DataCell(Checkbox(
            value: timing.closeStatus,
            onChanged: (value) {
              ref.read(timingsNotifierProvider.notifier).updateClosedStatus(value!, timing);
            },
          )),
        ]);
      }).toList(),
    );
  }

  String getDayNumber(int day) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[day - 1];
  }

  TimeOfDay stringToTimeOfDay(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }
}

