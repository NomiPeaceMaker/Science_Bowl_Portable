class User {
  String userName, email;
  bool _isLoggedIn;
  User(String userName, String email) {
    this.userName = userName;
    this.email = email;
  }

  bool get isLoggedIn => _isLoggedIn;
}