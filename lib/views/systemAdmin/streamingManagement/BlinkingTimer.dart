import 'dart:async';

import 'package:flutter/material.dart';

class BlinkingTimers extends StatefulWidget {
  const BlinkingTimers({super.key});

  @override
  State<BlinkingTimers> createState() => _BlinkingTimersState();
}

class _BlinkingTimersState extends State<BlinkingTimers>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late DateTime currentTime;
  late String _timeString;
  late Timer _timer;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _animationController.repeat();
    _timeString = "00:00";
    currentTime = DateTime.now();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getTimer());
  }

  @override
  void dispose() {
    //cancel before calling super.dispose
    _animationController.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _getTimer() {
    final DateTime now = DateTime.now();
    Duration d = now.difference(currentTime);

    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    setState(() {
      _timeString =
          '${twoDigits(d.inMinutes.remainder(60))}:${twoDigits(d.inSeconds.remainder(60))}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FadeTransition(
          opacity: _animationController,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
        ),
        SizedBox(width: 10),
        Text(_timeString, style: TextStyle(color: Colors.white)),
      ],
    );
  }
}
