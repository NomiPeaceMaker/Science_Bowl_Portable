import 'package:sciencebowlportable/models/User.dart';

class Player extends User {
  String userName, email;
  int playerID;
  Player(this.userName, this.email) : super(userName, email);
}