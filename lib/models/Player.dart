import 'package:sciencebowlportable/models/User.dart';
import 'package:sciencebowlportable/globals.dart';

class Player extends User {
  String userName, email;
  int playerID;

  Player() {
    this.email = user.email;
    this.userName = user.userName;
  }
}
