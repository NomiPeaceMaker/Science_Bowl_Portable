import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:sciencebowlportable/screens/player_buzzer.dart';
import 'package:sciencebowlportable/globals.dart';
import 'package:sciencebowlportable/models/Client.dart';
import 'package:sciencebowlportable/models/Player.dart';
import 'package:sciencebowlportable/screens/widgets.dart';

class PlayerWaitingRoom extends StatefulWidget {
  Client client;
  Player player;

  PlayerWaitingRoom(this.client, this.player);
  @override
  _PlayerWaitingRoomState createState() {
    return _PlayerWaitingRoomState(this.client, this.player);
  }
}

class _PlayerWaitingRoomState extends State<PlayerWaitingRoom> {
  Client client;
  Player player;
  _PlayerWaitingRoomState(this.client, this.player);

  StreamSubscription socketDataStreamSubscription;
  @override
  void initState() {
    super.initState();
    Stream socketDataStream = socketDataStreamController.stream;
    socketDataStreamSubscription = socketDataStream.listen((data){
      String A = "A";
      String B = "B";
      print(data);
      String C = '$A$data$B';
      print(C);
      if (data[0] == "R") {
        print("R joined");
      } else if (data[0] == "G") {
        print("G joined");
      }
      if (data=="StartGame") {
        print("Moving on to game");
        socketDataStreamSubscription.cancel();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Game()),
        );
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Color(0xffF8B400),
        title: Text(
          "JOIN",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                "Slots Available",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0xffCC0066), fontSize: 22
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                "Red Team",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.red, fontSize: 18
                ),
              ),
              Text(
                "Green Team",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.green, fontSize: 18
                ),
              ),
            ],
          ),
          playerRowWidget("1", "1"),
          playerRowWidget("2", "2"),
          playerRowWidget("Captain", "Captain"),
          playerRowWidget("3", "3"),
          playerRowWidget("4", "4"),
          Container(
            margin: EdgeInsets.only(bottom: 20.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                "Please wait for the Moderator\nto Start the Game",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                  fontSize: 18
                ),
               ),
            ),
          ),
        ],
      ),
    );
  }
}