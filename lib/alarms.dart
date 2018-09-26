import 'dart:isolate';
import 'package:android_alarm_manager/android_alarm_manager.dart';

final int periodicAlarmID = 0;
final int oneShotAlarmID = 1;
final int oneShotClosureID = 2;
int _periodicCount = 0;

void printLocalMessage(String msg) {
  print("[${DateTime.now()}](${Isolate.current.hashCode}) $msg");
}

Function oneShotClosure(int x) => () {
      printLocalMessage("oneShot-closure Alarm, x=$x!!!");
    };

void periodicCallback() {
  _periodicCount++;
  printLocalMessage("$_periodicCount. periodic Alarm!!!");
}

void oneShotCallback() {
  printLocalMessage("oneShot Alarm!!!");
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

Future<Null> startClosure() async {
  final closure = oneShotClosure(42);
  print('startClosure (type: ${closure.runtimeType.toString()})');
  await AndroidAlarmManager.oneShot(
      const Duration(seconds: 5), oneShotClosureID, closure);
}
