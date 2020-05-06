import 'package:quiver/async.dart';
import 'dart:async';

class myTimer extends CountdownTimer {
  int _start;
  void Function(String) onData;
  void Function() onDone;
  var sub;
  myTimer(this._start) : super(Duration(seconds: _start), Duration(seconds: 1));

  void pauseTimer() {
    this.sub.cancel();
  }


  void resumeTimer() {

  }

  void startTimer (bool isInMinutes) {
    this.sub = this.listen(null);
    this.sub.onData((duration) {
      String timerText;
      int timeLeftInSeconds = this._start - duration.elapsed.inSeconds;
      if (isInMinutes) {
        timerText = '${(timeLeftInSeconds/60).round().toString()}:${(timeLeftInSeconds.remainder(60) % 60).toString().padLeft(2, '0')}';
      } else {
        timerText = timeLeftInSeconds.toString();
      }
      this.onData(timerText);
    });
    this.sub.onDone(() {
      print("done");
      this.onDone();
      this.sub.cancel();
    });
  }

//  void startMinutesTimer () {
//    Duration clockTimer = Duration(seconds: this._start);
//
//    String timerText =
//        '${clockTimer.inMinutes.remainder(60).toString()}:${(clockTimer.inSeconds.remainder(60) % 60).toString().padLeft(2, '0')}';
//  }
}