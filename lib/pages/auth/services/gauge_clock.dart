import 'dart:async';

import 'package:admin_app/constants/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class GaugeClock extends StatefulWidget {
  final String? setDeliveryMinutes;
  final DateTime? setDeliveryMinuteDatetime;

  GaugeClock(
      {required this.setDeliveryMinutes,
      required this.setDeliveryMinuteDatetime});
  @override
  _GaugeClockState createState() => _GaugeClockState();
}

class _GaugeClockState extends State<GaugeClock> {
  late Timer _timer;
  late int _remainingMinutes = 00;
  late int _totalRemainingSeconds = 0;
  late int _remainingSeconds = 00;
  late double _remainingPercentile = 0.0;

  late String deliveryMinutes;
  late DateTime deliveryMinuteDatetime;

  int _convertToInt(String setDeliveryMinutes) {
    List<String> parts = setDeliveryMinutes.split('|');
    int separatedInt = int.parse(parts[0]);
    return separatedInt;
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    final inputDateTime = widget.setDeliveryMinuteDatetime!.toLocal();
    // DateTime.utc()
    final inputMinute = _convertToInt(widget.setDeliveryMinutes!);
    Duration _duration = Duration(minutes: inputMinute);
    DateTime deliveryTime = inputDateTime.add(Duration(minutes: inputMinute));

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      // DateTime currentTime = DateTime.now();
      DateTime currentTime = TZ.now();
      Duration difference = deliveryTime.difference(currentTime);

      // Calculate remaining time in minutes and seconds
      _remainingMinutes = difference.inMinutes;
      _remainingSeconds = difference.inSeconds % 60;

      // Calculate remaining percentage

      if(difference.inSeconds <= Duration(minutes: inputMinute).inSeconds){

      _remainingPercentile =
          difference.inSeconds / Duration(minutes: inputMinute).inSeconds;
      }

      setState(() {
        _duration = difference;

        if (difference.inSeconds <= 0) {
          _timer.cancel();
          _remainingMinutes = 0;
          _remainingSeconds = 0;
          _remainingPercentile = 0.0;
        }

        // print(_duration.inMinutes);
        // print(difference.inMinutes);
        // print(deliveryTime);
        // print(currentTime);
        // print(_remainingMinutes);
        // print(_remainingSeconds);
        print(_remainingPercentile);
        print(_remainingMinutes);
        print(_remainingSeconds);
        print(currentTime);
        print(inputDateTime);
        print(inputMinute);
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.setDeliveryMinutes != null
        ? CircularPercentIndicator(
            radius: 23,
            percent: _remainingPercentile,
            progressColor: Color.fromARGB(255, 226, 15, 0),
            backgroundColor: Colors.grey,
            center: Text(
                '${_remainingMinutes.toString().padLeft(2, '0')}:${_remainingSeconds.toString().padLeft(2, '0')}'),
          )
        : Text('data');
  }
}
