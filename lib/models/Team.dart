import 'package:sciencebowlportable/models/Player.dart';

class Team {
  String teamName;
  int score;
  bool canAnswer;
  List<Player> players;
  Team(this.teamName);
}