import 'package:sciencebowlportable/globals.dart';

class User {
  String userName, email;
  bool isLoggedIn, isModerator;
  User() {
    userName = "Guest";
    this.isLoggedIn = true;
  }
}
