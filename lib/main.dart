import 'package:alarm_manager_example/alarms.dart';

import 'package:flutter/material.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';

void main() async {
  // Start the AlarmManager service.
  await AndroidAlarmManager.initialize();

  printLocalMessage("Hello, main()!");
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

class _MyHomePageState extends State<MyHomePage> {
  bool _startedAlarm = false;
  bool _startedClosure = false;

  void _startAlarms() {
    startAlarms();
    setState(() {
      _startedAlarm = true;
    });
  }

  void _startClosure() {
    startClosure();
    setState(() {
      _startedClosure = true;
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
              _startedAlarm || _startedClosure ? 'running' : 'stopped',
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
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: _startedClosure ? null : _startClosure,
                  child: Text('start closure'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
