import 'package:sciencebowlportable/models/Team.dart';
import 'package:sciencebowlportable/globals.dart';

class Game{
  String moderatorName;
  String gameDifficulty, gamePin;
  int numberOfQuestion, tossUpTime, bonusTime, gameTime;

  Team aTeam = Team("A");
  Team bTeam = Team("B");
}