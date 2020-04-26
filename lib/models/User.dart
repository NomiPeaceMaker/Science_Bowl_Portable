import 'package:sciencebowlportable/globals.dart';

class User {
  String userName, email;
  bool _isLoggedIn;

  User() {
    this.email = "";
    this.userName = "";
    this._isLoggedIn = true;
  }

  set isLoggedIn(bool value) {
    _isLoggedIn = value;
  }

  bool _isModerator;

  set isModerator(bool value) {
    _isModerator = value;
  }

  set userEmail(String E) {
    this.email = E;
  }

  set usernameSet(String username) {
    this.userName = username;
  }

  bool get isModerator => _isModerator;

  bool get isLoggedIn => _isLoggedIn;
}
