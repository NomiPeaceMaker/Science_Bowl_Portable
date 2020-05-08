import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sciencebowlportable/screens/home.dart';
import 'package:sciencebowlportable/screens/username.dart';
import 'package:sciencebowlportable/globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sciencebowlportable/utilities/sizeConfig.dart';
import 'package:sciencebowlportable/utilities/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

final databaseReference = Firestore.instance;

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  var loggedIn = false;

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, home: _buildSocialLogin(context));
  }

  // Method that builds main scaffold of the screen
  _buildSocialLogin(context) {
    SizeConfig().init(context);   

    return Scaffold(
      backgroundColor: themeColor,
      body: Container(
        // Background image is an asset 
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/login_alt_4.png',
                ),
                alignment: Alignment.topLeft,
                fit: BoxFit.scaleDown),
          ),
          child: Center(
            // Display Text that says logged in if successful, otherwise show log-in options
            child: loggedIn
                ? Text("Logged in")   
                : Stack(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: SizeConfig.safeBlockHorizontal * 4,
                            vertical: SizeConfig.blockSizeVertical * 2),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            // wrap height
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            // stretch across width of screen
                            children: <Widget>[
                              SizedBox(
                                  height: SizeConfig.safeBlockVertical * 50,
                                  width: SizeConfig.safeBlockHorizontal * 90,
                                  child: TypewriterAnimatedTextKit(
                                    speed: Duration(milliseconds: 60),
                                    alignment: Alignment.topLeft,
                                    text: ["Welcome to Science Bowl Portable"],
                                    isRepeatingAnimation: false,
                                    textStyle: TextStyle(
                                      // fontSize:
                                      // SizeConfig.safeBlockVertical * 8.5,
                                      fontSize: 60,
                                      fontWeight: FontWeight.bold,
                                      // color: themeColor,
                                      color: Colors.white,
                                    ),
                                  )),
                              SizedBox(height: 20),
                              _buildFacebookLoginButton(),
                              SizedBox(height: 20),
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
      child: ButtonTheme(
        height: 80,
        child: RaisedButton.icon(
            onPressed: () {
              initiateSignIn("G");
            },
            icon: FaIcon(FontAwesomeIcons.google),
            color: Color(0xFFEA4335),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            textColor: Colors.white,
            label: Text("    Continue with Google", style: loginButtonText)),
      ),
    );
  }

  Container _buildFacebookLoginButton() {
    return Container(
      child: ButtonTheme(
        height: 80,
        child: RaisedButton.icon(
            materialTapTargetSize: MaterialTapTargetSize.padded,
            onPressed: () {
              initiateSignIn("FB");
            },
            icon: FaIcon(FontAwesomeIcons.facebookF),
            color: Color(0xff1977F3),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            textColor: Colors.white,
            label: Text(
              "   Continue with Facebook",
              style: loginButtonText,
            )),
      ),
    );
  }


  // sets logged in bool as true if login suceeds and continues to next page accordingly
  // if user is a returning user then user is taken to home page
  // if user is a new user then user is directed to username page  
  void initiateSignIn(String type) {
    _handleSignIn(type).then((result) {
      print("If there is a 0 in the next line then login was unsucessful = ");
      print(result);
      if (result == 1) {
        setState(() {
          loggedIn = true;
        });

        if (user.userName == 'Guest' || user.userName == null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Username()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyHomePage()),
          );
        }
      } else {
        // Code for troubleshooting
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => Username()),
        // );
      }
    });
  }

  // To log in with Google or Facebook login API - called based on user input
  // User is created in database if does not exist
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
          setState(() {
            user.email = Fire_user.email;
          });
          final snapShot = await Firestore.instance
              .collection('User')
              .document(user.email)
              .get();
          if (!snapShot.exists) {
            print("creating user");
            createUser();
          } else {
            Map userMap = snapShot.data;
            user.userName = userMap['Username'];
            print("${user.userName} is the username");
          }

          user_email = user.email;
//          SharedPreferences prefs = await SharedPreferences.getInstance();
//          await prefs.setString("user_email", user_email);
          print('The email address is: ${user.email}');
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

//          FirebaseUser currentuser=await FirebaseAuth.instance.currentUser();
//          print("Current user is ${currentuser.displayName}");
//          print("Current user email is ${currentuser.email}");

//          user.email = Fire_user.email;
          setState(() {
            user.email = Fire_user.email;
          });
//          SharedPreferences prefs = await SharedPreferences.getInstance();
//          await prefs.setString("user_email", user.email);
          print('The email address is: ${user.email}');
          final snapShot = await Firestore.instance
              .collection('User')
              .document(user.email)
              .get();
          if (!snapShot.exists) {
            print("creating user");
            createUser();
          } else {
            Map userMap = snapShot.data;
            user.userName = userMap['Username'];
            print("user_name ${user.userName}");
          }
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
        await facebookLogin.logIn(['email']);
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
    GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    return googleSignInAccount;
  }

  //creates User with email as primary identifier
  void createUser() async {
    await databaseReference.collection("User").document(user.email).setData({
      "Username": null,
    });
  }
}
