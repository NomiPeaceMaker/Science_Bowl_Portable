import 'package:sciencebowlportable/models/User.dart';
import 'package:sciencebowlportable/globals.dart';

class Moderator extends User {
  String userName, email;
  String gameDifficulty;
  int gamePin, numberOfQuestion;
  double gameTime, tossUpTime, bonusTime;
  var subjects;

  Moderator() {
    this.userName = user.userName;
    this.email = user.email;
  }
}

//
//void main() {
//  Moderator m = Moderator("userName", "user.email");
//  print(m.gameDifficulty);
//  m.bonusTime = 8.88;
//}
