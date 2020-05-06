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
    this._start = this._timeLeftInSeconds;
    this._sub.cancel();
  }


  void resumeTimer() {
    this.startTimer(_isInMinutes);
  }

  void startTimer (bool isInMinutes) {
    this._isInMinutes = isInMinutes;
    this._sub = this.listen(null);
    this._sub.onData((duration) {
      String timerText;
      this._timeLeftInSeconds = this._start - duration.elapsed.inSeconds;
      if (isInMinutes) {
        timerText = '${(this._timeLeftInSeconds/60).round().toString()}:${(this._timeLeftInSeconds.remainder(60) % 60).toString().padLeft(2, '0')}';
      } else {
        timerText = this._timeLeftInSeconds.toString();
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