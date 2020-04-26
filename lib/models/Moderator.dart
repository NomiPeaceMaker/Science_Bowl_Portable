import 'package:sciencebowlportable/models/User.dart';
import 'package:sciencebowlportable/globals.dart';

class Moderator extends User {
  String gameDifficulty;
  int gamePin, numberOfQuestion, tossUpTime, bonusTime, gameTime;
  var subjects;
}

//
//void main() {
//  Moderator m = Moderator("userName", "user.email");
//  print(m.gameDifficulty);
//  m.bonusTime = 8.88;
//}
