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
  var teamNumber = {"1": 0, "2":1, "Captain":2, "3":3, "4":4};

  List<bool> redActive = List.generate(5, (_) => true);
  List<bool> greenActive = List.generate(5, (_) => true);

  StreamSubscription socketDataStreamSubscription;
  @override
  void initState() {
    super.initState();
    Stream socketDataStream = socketDataStreamController.stream;
    socketDataStreamSubscription = socketDataStream.listen((data){
      data = data.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
      print(data);
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
          MaterialPageRoute(builder: (context) => Game(client, player)),
        );
      }
    });
    print("CLIENT EXISTS--------------------------------------");
    print(client.socket);
    print("CLIENT EXISTS--------------------------------------");
  }

  Row playerRowWidget(String num, Client client) {
    print(client);
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SizedBox(
              width: 140.0,
              height: 50,
              child: FlatButton (
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                    'Red $num',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)
                ),
                color: redActive[teamNumber[num]] ? Colors.red : Colors.grey,
                textColor: Colors.white,
                onPressed: () {
                  setState(() {
                    client.write("R$num");
                    print(teamNumber[num]);
                    redActive[teamNumber[num]] = !redActive[teamNumber[num]];
//                    int playerNumber = teamNumber[rNum];
//                    Stream s = redPlayerJoinStreamController[playerNumber].stream;
//                    redPlayerJoinStreamSubscription[playerNumber] = s.listen((data) {
//                      redActive[playerNumber] = !redActive[playerNumber];
//                    });
//                    redPlayerJoinStreamController[playerNumber].add("R$rNum");
                  });
                },
              )
          ),
          SizedBox(
              width: 140.0,
              height: 50,
              child: FlatButton (
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                    'Green $num',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)
                ),
                color: greenActive[teamNumber[num]] ? Colors.green : Colors.grey,
                textColor: Colors.white,
                onPressed: () {
                  client.write("G$num");
                  setState(() {
                    print(teamNumber[num]);
                    greenActive[teamNumber[num]] = !greenActive[teamNumber[num]];
//                    int playerNumber = teamNumber[gNum];
//                    Stream s = greenPlayerJoinStreamController[playerNumber].stream;
//                    greenPlayerJoinStreamSubscription[playerNumber] = s.listen((data) {
//                      greenActive[playerNumber] = !greenActive[playerNumber];
//                    });
//                    greenPlayerJoinStreamController[playerNumber].add("G$gNum");
                  });
                },
              )
          ),
        ]
    );
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
          playerRowWidget("1", client),
          playerRowWidget("2", client),
          playerRowWidget("Captain", client),
          playerRowWidget("3", client),
          playerRowWidget("4", client),
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