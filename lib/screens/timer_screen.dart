import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:async';
import '../tools/utils.dart';

enum TimerStatus {
  running,
  paused,
  stopped,
  resting,
}

class TimerScreen extends StatefulWidget {
  const TimerScreen({Key? key}) : super(key: key);

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  static const WORK_SECONDS = 50 * 60;
  static const REST_SECOND = 10 * 60;

  late TimerStatus _timerStatus;
  late int _timer;
  late int _pomodoroCount;

  @override
  void initState() {
    super.initState();

    _timerStatus = TimerStatus.stopped;
    _timer = WORK_SECONDS;
    _pomodoroCount = 0;
  }

  void run() {
    setState(() {
      _timerStatus = TimerStatus.running;
      print("=> $_timerStatus");
      runTimer();
    });
  }

  void paused() {
    setState(() {
      _timerStatus = TimerStatus.paused;
      print("=> $_timerStatus");
    });
  }

  void rest() {
    setState(() {
      _timer = REST_SECOND;
      _timerStatus = TimerStatus.resting;
      print("=> $_timerStatus");
    });
  }

  void resume() {
    run();
  }

  void stop() {
    setState(() {
      _timer = WORK_SECONDS;
      _timerStatus = TimerStatus.stopped;
      print("=> $_timerStatus");
    });
  }

  void runTimer() {
    Timer.periodic(const Duration(seconds: 1), (t) {
      switch (_timerStatus) {
        case TimerStatus.paused:
          t.cancel();
          break;
        case TimerStatus.stopped:
          t.cancel();
          break;
        case TimerStatus.running:
          if (_timer <= 0) {
            print("작업완료");
            rest();
          } else {
            setState(() {
              _timer--;
            });
          }
          break;
        case TimerStatus.resting:
          if (_timer <= 0) {
            setState(() {
              _pomodoroCount++;
              showToast(_pomodoroCount);
              t.cancel();
              stop();
            });
          } else {
            setState(() {
              _timer--;
            });
          }
          break;
        default:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _runningButtons = [
      ElevatedButton(
        child: Text(
          _timerStatus == TimerStatus.paused ? '계속하기' : '일시정지',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        onPressed: () {
          if (_timerStatus == TimerStatus.paused) {
            resume();
          } else {
            paused();
          }
        },
        style: ElevatedButton.styleFrom(primary: Colors.blue),
      ),
      Padding(
        padding: EdgeInsets.all(20),
      ),
      ElevatedButton(
        child: Text(
          '포기하기',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        onPressed: stop,
        style: ElevatedButton.styleFrom(primary: Colors.blue),
      ),
    ];

    final List<Widget> _stoppedButtons = [
      ElevatedButton(
        child: Text(
          '시작하기',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        onPressed: run,
        style: ElevatedButton.styleFrom(
            primary: _timerStatus == TimerStatus.resting
                ? Colors.green
                : Colors.blue),
      ),
    ];

    return Scaffold(
        appBar: AppBar(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width * 0.6,
              child: Center(
                child: Text(
                  secondsToString(_timer),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold),
                ),
              ),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _timerStatus == TimerStatus.resting
                      ? Colors.green
                      : Colors.blue),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _timerStatus == TimerStatus.resting
                  ? const []
                  : _timerStatus == TimerStatus.stopped
                      ? _stoppedButtons
                      : _runningButtons,
            )
          ],
        ));
  }
}
