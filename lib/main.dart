import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:isolate';

import 'package:android_alarm_manager/android_alarm_manager.dart';

final int periodicAlarmID = 0;
final int oneShotAlarmID = 1;
final int oneShotID = 2;

void main() async {
  // Start the AlarmManager service.
  await AndroidAlarmManager.initialize();

  printHelloMessage("Hello, main()!");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alarm Manager Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Alarm Manager Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

int _periodicCount = 0;

class _MyHomePageState extends State<MyHomePage> {
  bool _startedAlarm = false;

  void _startAlarms() {
    startAlarms();
    setState(() {
      _startedAlarm = true;
    });
  }

  void _stopAlarms() {
    stopAlarms();
    setState(() {
      _startedAlarm = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Alarms are:',
            ),
            Text(
              _startedAlarm ? 'running' : 'stopped',
              style: Theme.of(context).textTheme.display1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: _startedAlarm ? null : _startAlarms,
                  child: Text('start'),
                ),
                Container(padding: EdgeInsets.all(20.0)),
                RaisedButton(
                  onPressed: _startedAlarm ? _stopAlarms : null,
                  child: Text('stop'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class HelloMessage {
  final DateTime _now;
  final String _msg;
  final int _isolate;

  HelloMessage(this._now, this._msg, this._isolate);

  @override
  String toString() {
    return "[$_now] $_msg "
        "isolate=$_isolate ";
  }
}

void printHelloMessage(String msg) {
  print(HelloMessage(
    DateTime.now(),
    msg,
    Isolate.current.hashCode,
  ));
}

void periodicCallback() {
  _periodicCount++;
  printHelloMessage("$_periodicCount. periodic Alarm!!!");
}

void oneShotCallback() {
  printHelloMessage("oneShot Alarm!!!");
}

Future<Null> stopAlarms() async {
  print('stop all alarms');
  await AndroidAlarmManager.cancel(periodicAlarmID);
  await AndroidAlarmManager.cancel(oneShotAlarmID);
}

Future<Null> startAlarms() async {
  print('startAlarms');

  await AndroidAlarmManager.periodic(
      const Duration(seconds: 5), periodicAlarmID, periodicCallback,
      wakeup: true);
  await AndroidAlarmManager.oneShot(
      const Duration(seconds: 5), oneShotAlarmID, oneShotCallback);
}
