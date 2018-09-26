import 'dart:isolate';
import 'dart:ui';
import 'package:android_alarm_manager/android_alarm_manager.dart';

final int periodicAlarmID = 0;
final int oneShotAlarmID = 1;
int _periodicCount = 0;
const String kAlarmManagerExamplePortName = 'simple_alarm_manager_example_port';

void printLocalMessage(String msg) {
  print("[${DateTime.now()}](${Isolate.current.hashCode}) $msg");
}

Function oneShotClosure(int x) => () {
      printLocalMessage("oneShot-closure Alarm, x=$x!!!");
    };

void periodicCallback() {
  _periodicCount++;
  final SendPort mainSendPort =
      IsolateNameServer.lookupPortByName(kAlarmManagerExamplePortName);
  mainSendPort?.send(_periodicCount);
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
