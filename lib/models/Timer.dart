import 'package:quiver/async.dart';
import 'dart:async';

class myTimer extends CountdownTimer {
  void Function(String) onData;
  void Function() onDone;
  myTimer(this._start) : super(Duration(seconds: _start), Duration(seconds: 1));
  var _sub;
  int _start, _timeLeftInSeconds;
  bool _isInMinutes;

  void pauseTimer() {
    _start = _timeLeftInSeconds;
    this._sub.cancel();
  }


  void resumeTimer() {
    startTimer(_isInMinutes);
  }

  void startTimer (bool isInMinutes) {
    this._isInMinutes = isInMinutes;
    this._sub = this.listen(null);
    this._sub.onData((duration) {
      String timerText;
      int _timeLeftInSeconds = this._start - duration.elapsed.inSeconds;
      if (isInMinutes) {
        timerText = '${(_timeLeftInSeconds/60).round().toString()}:${(_timeLeftInSeconds.remainder(60) % 60).toString().padLeft(2, '0')}';
      } else {
        timerText = _timeLeftInSeconds.toString();
      }
      this.onData(timerText);
    });
    this._sub.onDone(() {
      print("done");
      this.onDone();
      this._sub.cancel();
    });
  }

//  void startMinutesTimer () {
//    Duration clockTimer = Duration(seconds: this._start);
//
//    String timerText =
//        '${clockTimer.inMinutes.remainder(60).toString()}:${(clockTimer.inSeconds.remainder(60) % 60).toString().padLeft(2, '0')}';
//  }
}