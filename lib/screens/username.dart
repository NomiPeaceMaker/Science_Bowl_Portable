import 'package:flutter/material.dart';
import 'package:sciencebowlportable/globals.dart';
// import 'package:science_bowl_portable/screens/edit_account.dart';
import 'package:sciencebowlportable/screens/home.dart';
import 'package:sciencebowlportable/globals.dart';

void firstusername() => runApp(Username());

String temp_username="";

class Username extends StatefulWidget {
  @override
  Username({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _usernameState createState() => _usernameState();
}

// class username extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return new MaterialApp(
//       home: new _usernameState(),
//     );
//   }
// }

class _usernameState extends State<Username> {
  @override
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
          child: Center(
              child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildSignUpText(),
          SizedBox(height: 200),
          _usernameText(),
          SizedBox(height: 50),
          _confirmbutton(),
          SizedBox(height: 170),
          _skipbutton(),
        ],
      ))),
    );
  }

  Container _buildSignUpText() {
    return Container(
        margin: EdgeInsets.only(top: 76),
        child: Center(
          child: Text(
            "SBP",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color(0xff707070),
                fontSize: 42,
                fontWeight: FontWeight.bold),
          ),
        ));
  }

  Container _usernameText() {
    return Container(
        child: Center(
            child: Container(
                width: 230,
                child: TextField(
                  controller: myController,
                  onChanged: (String text)
                  {temp_username=text;},
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF66CCCC),
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: UnderlineInputBorder( borderSide: const BorderSide(color: Color(0xFF66CCCC), width: 2.0)),
                    hintText: "Please Enter Username",
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF66CCCC),
                      fontSize: 20,
                    ),
                  ),
                ))));
  }

  Container _confirmbutton() {
    return Container(
      child: Center(
          child: FlatButton(
              child: Text("Confirm",
                  style: TextStyle(
                      color: Color(0xffCC0066),
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
                onPressed: (){
                  name1 = myController.text;
                  user.userName=temp_username;
                  print(name1);
                  Navigator.pushNamed(context, '/home');
                      
                }
                )),
    );
  }

  Container _skipbutton() {
    return Container(
      child: Center(
          child: FlatButton(
              child: Text("Skip",
                style: TextStyle(
                  color: Color(0xff707070),
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                )
              ),
            onPressed: (){
                Navigator.pushNamed(context, '/home');
                  
              },
            )
          ),

    );
  }
}
