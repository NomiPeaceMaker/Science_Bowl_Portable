import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import 'package:sciencebowlportable/utilities/sizeConfig.dart';
import 'package:sciencebowlportable/utilities/styles.dart';
import 'package:sciencebowlportable/screens/player_buzzer_screen.dart';
import 'package:sciencebowlportable/screens/home.dart';
import 'package:sciencebowlportable/models/Client.dart';
import 'package:sciencebowlportable/models/Player.dart';
import 'package:sciencebowlportable/globals.dart';

class JoinSet extends StatefulWidget {
  Client client;
  Player player;

  JoinSet(this.client, this.player);
  @override
  _JoinSetState createState() => _JoinSetState(this.client, this.player);
}

class _JoinSetState extends State<JoinSet> {
  Client client;
  Player player;

  _JoinSetState(this.client, this.player);

  StreamSubscription socketDataStreamSubscription;

  @override
  void initState() {

    Stream socketDataStream = socketDataStreamController.stream;
    socketDataStreamSubscription = socketDataStream.listen((data) {
      if (data["type"] == "startGame") {
        print("Moving on to game");
        socketDataStreamSubscription.cancel();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PlayerBuzzer(this.client, this.player)),
        );
      } else if (data["type"] == "moderatorLeaving") {
        client.disconnect();
        _moderatorEndedGameDialog();
      }
    });
    super.initState();
  }

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
                          text: "${player.playerID}!\n\n",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                            text: "Game will start once\nhost",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 18
                            )),
                        TextSpan( //ADD HOSTNAME HERE
                            text: " ${game.moderatorName}\n",
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

  _moderatorEndedGameDialog() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: Text("Moderator Ended Game"),
            content: Text("The moderator has ended the game. Press Okay to go back to home screen."),
            actions: <Widget>[
              FlatButton(
                child: Text("Okay", style: staystyle),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) => MyHomePage(),),
                      ModalRoute.withName('/')
                  );
//                  Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
                },
              ),
            ],
          );
        });
  }
}
