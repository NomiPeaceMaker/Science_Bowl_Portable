import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:sciencebowlportable/utilities/sizeConfig.dart';
import 'package:sciencebowlportable/utilities/styles.dart';

class JoinSet extends StatefulWidget {
  @override
  _JoinSetState createState() => _JoinSetState();
}

class _JoinSetState extends State<JoinSet> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        backgroundColor: themeColor,
        appBar: AppBar(
          backgroundColor: themeColor,
          title: Text(
            "JOIN",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: Container(
          margin: EdgeInsets.symmetric(vertical: SizeConfig.safeBlockVertical *5),
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image(
              image: AssetImage('assets/join_succ.png'),
              height: SizeConfig.safeBlockVertical * 25,
              width: SizeConfig.safeBlockVertical * 25,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.safeBlockVertical * 4),
              child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: "You are set as ",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.normal,
                        fontSize: 20.0,
                      ),
                      children: <TextSpan>[
                        TextSpan( //ADD PLAYER PERSONA NAME HERE e.g A1
                          text: "PLAYER!\n\n",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                            text: "Game will start once\nhost",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 18
                            )),
                        TextSpan( //ADD HOSTNAME HERE
                            text: " HOSTNAME\n",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            )),
                        TextSpan(
                            text: "starts the game",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 18,
                            )),
                      ])),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: SizeConfig.safeBlockVertical * 4.0),
              child: Image(
                image: AssetImage('assets/join_wait.png'),
                height: SizeConfig.safeBlockVertical * 10,
                width: SizeConfig.safeBlockVertical * 10,
              ),
            ),
            FadeAnimatedTextKit(
              alignment: Alignment.center,
              textAlign: TextAlign.center,
              text: ["Waiting for host   ","Waiting for host.  ", "Waiting for host.. ", "Waiting for host..."],
              isRepeatingAnimation: true,
              // duration: Duration(milliseconds: 1500),
              textStyle: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16.0,
                              color: Colors.white,
              )

            )],
        )));
  }
}
