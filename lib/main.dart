import 'dart:isolate';
import 'dart:ui';

import 'package:alarm_manager_example/alarms.dart';

import 'package:flutter/material.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';

void main() async {
  // Start the AlarmManager service.
  await AndroidAlarmManager.initialize();

  printLocalMessage("AndroidAlarmManager initialized!");
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
      home: MyHomePage(title: 'Simple Alarm Manager Demo'),
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
  int _periodic = 0;
  ReceivePort _foregroundPort = ReceivePort();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void initPlatformState() {
    // The IsolateNameServer allows for us to create a mapping between a String
    // and a SendPort that is managed by the Flutter engine. A SendPort can
    // then be looked up elsewhere, like a background callback, to establish
    // communication channels between isolates that were not spawned by one
    // another.
    if (!IsolateNameServer.registerPortWithName(
        _foregroundPort.sendPort, kAlarmManagerExamplePortName)) {
      throw 'Unable to register port!';
    }
    _foregroundPort.listen((dynamic message) {
      final int periodicCount = message;
      print('periodicCount was: $periodicCount');
      setState(() {
        _periodic = periodicCount;
      });
    }, onDone: () {});
  }

  @override
  void dispose() {
    super.dispose();
    // Remove the port mapping just in case the UI is shutting down but
    // background isolate is continuing to run.
    IsolateNameServer.removePortNameMapping(kAlarmManagerExamplePortName);
  }

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
              _startedAlarm ? 'running ($_periodic)' : 'stopped ($_periodic)',
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
          ],
        ),
      ),
    );
  }
}
