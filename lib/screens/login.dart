import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sciencebowlportable/screens/username.dart';
import 'package:sciencebowlportable/globals.dart';

// void main() => runApp(Login());

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  var loggedIn = false;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: _buildSocialLogin());
  }

  _buildSocialLogin() {
    return Scaffold(
      body: Container(
          child: Center(
        child: loggedIn
            ? Text("Logged in")
            : Stack(
                children: <Widget>[
                  SizedBox.expand(
                    child: _buildSignUpText(),
                  ),
                  Container(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        // wrap height
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        // stretch across width of screen
                        children: <Widget>[
                          _buildFacebookLoginButton(),
                          SizedBox(height: 50),
                          _buildGoogleLoginButton(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
      )),
    );
  }

  Container _buildGoogleLoginButton() {
    return Container(
      margin: EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 0),
      child: ButtonTheme(
        height: 59,
//        minWidth: 275,
        child: RaisedButton.icon(
            onPressed: () {
              initiateSignIn("G");
            },
            icon: FaIcon(FontAwesomeIcons.google),
            color: Color(0xFFEA4335),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            textColor: Colors.white,
            label: Text("   Connect with Google",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ))),
      ),
    );
  }

  Container _buildFacebookLoginButton() {
    return Container(
      margin: EdgeInsets.only(left: 16, top: 0, right: 16, bottom: 0),
      child: ButtonTheme(
        height: 59,
//        minWidth: 275,
        child: RaisedButton.icon(
            materialTapTargetSize: MaterialTapTargetSize.padded,
            onPressed: () {
              initiateSignIn("FB");
            },
            icon: FaIcon(FontAwesomeIcons.facebookF),
            color: Color(0xff1977F3),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            textColor: Colors.white,
            label: Text(
              "   Connect with Facebook",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            )),
      ),
    );
  }

  Container _buildSignUpText() {
    return Container(
      margin: EdgeInsets.only(top: 76),
      child: Text(
        "SBP",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Color(0xff707070),
            fontSize: 42,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  void initiateSignIn(String type) {
    _handleSignIn(type).then((result) {
      if (result == 1) {
        setState(() {
          loggedIn = true;
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Username()),
        );
      } else {
        //CHANGE THIS!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Username()),
        );
      }
      // firstusername();
    });
  }

  Future<int> _handleSignIn(String type) async {
    switch (type) {
      case "FB":
        FacebookLoginResult facebookLoginResult = await _handleFBSignIn();
        final accessToken = facebookLoginResult.accessToken.token;
        if (facebookLoginResult.status == FacebookLoginStatus.loggedIn) {
          final facebookAuthCred =
              FacebookAuthProvider.getCredential(accessToken: accessToken);
          final FirebaseUser Fire_user =
              (await firebaseAuth.signInWithCredential(facebookAuthCred)).user;
          user.email = Fire_user.email;
          return 1;
        } else
          return 0;
        break;
      case "G":
        try {
          GoogleSignInAccount googleSignInAccount = await _handleGoogleSignIn();
          final googleAuth = await googleSignInAccount.authentication;
          final googleAuthCred = GoogleAuthProvider.getCredential(
              idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
          final FirebaseUser Fire_user =
              (await firebaseAuth.signInWithCredential(googleAuthCred)).user;
          user.email = Fire_user.email;
          print(user.email);
          return 1;
        } catch (error) {
          return 0;
        }
    }
    return 0;
  }

  Future<FacebookLoginResult> _handleFBSignIn() async {
    FacebookLogin facebookLogin = FacebookLogin();
    FacebookLoginResult facebookLoginResult =
        await facebookLogin.logInWithReadPermissions(['email']);
    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.cancelledByUser:
        print("Cancelled");
        break;
      case FacebookLoginStatus.error:
        print("error");
        break;
      case FacebookLoginStatus.loggedIn:
        print("Logged In");
        break;
    }
    return facebookLoginResult;
  }

  Future<GoogleSignInAccount> _handleGoogleSignIn() async {
    GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'https://www.googleapis.com/auth/contacts.readonly']);
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    return googleSignInAccount;
  }
}
