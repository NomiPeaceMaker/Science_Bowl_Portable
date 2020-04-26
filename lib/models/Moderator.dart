import 'package:sciencebowlportable/models/User.dart';
import 'package:sciencebowlportable/models/Team.dart';

import 'package:sciencebowlportable/globals.dart';

class Moderator extends User {
  String gameDifficulty, gamePin;
  int numberOfQuestion, tossUpTime, bonusTime, gameTime;
  var subjects;
  Team redTeam, greenTeam;
}

//
//void main() {
//  Moderator m = Moderator("userName", "user.email");
//  print(m.gameDifficulty);
//  m.bonusTime = 8.88;
//}
