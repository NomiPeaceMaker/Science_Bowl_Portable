import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:sciencebowlportable/screens/player_buzzer.dart';
import 'package:sciencebowlportable/globals.dart';
import 'package:sciencebowlportable/models/Client.dart';
import 'package:sciencebowlportable/models/Player.dart';
import 'package:sciencebowlportable/screens/widgets.dart';
import 'package:sciencebowlportable/utilities/styles.dart';

import 'home.dart';

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
      for (var i = 0 ; i < 5; i++ ) {
        redPlayerJoinStreamController[i] = StreamController.broadcast();
        greenPlayerJoinStreamController[i] = StreamController.broadcast();
      }
      Stream socketDataStream = socketDataStreamController.stream;
      socketDataStreamSubscription = socketDataStream.listen((data) {
        data = data.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
        print(data);
        int playerNumber = teamNumber[data.substring(1)];
        print(playerNumber);
        if (data[0] == "R") {
          redPlayerJoinStreamController[playerNumber].add("toggleButton");
        } else if (data[0] == "G") {
          greenPlayerJoinStreamController[playerNumber].add("toggleButton");
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
  }
  SizedBox teamSlot(String playerPosition, String team) {
    var buttonColor;
    if (team == "Red") {
      buttonColor = Colors.red;
    }
    else if (team == "Green") {
      buttonColor = Colors.green;
    }
    return new SizedBox(
      width: 140.0,
      height: 50,
      child:
      new StreamBuilder(
          stream: redPlayerJoinStreamController[teamNumber[playerPosition]].stream,
          builder: (context, snapshot) {
            if (snapshot.data == 'toggleButton') {
              print("toggle");
              print(playerPosition);
              buttonColor = Colors.grey;
//              redActive[teamNumber[playerPosition]] = !redActive[teamNumber[playerPosition]];
            }
            return new FlatButton (
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                  '$team $playerPosition',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)
              ),
              color: redActive[teamNumber[playerPosition]] ? buttonColor : Colors.grey,
              textColor: Colors.white,
              onPressed: () {
                setState(() {
                  client.write("R$playerPosition");
//                              redActive[teamNumber[num]] = !redActive[teamNumber[num]];
                });
              },
            );
          })
    );
  }

  Row playerRowWidget(String playerPosition) {
      print(client);
      return new Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            teamSlot(playerPosition, "Red"),
            teamSlot(playerPosition, "Green"),
//            SizedBox(
//                width: 140.0,
//                height: 50,
//                child: new StreamBuilder(
//                  stream: greenPlayerJoinStreamController[teamNumber[num]].stream,
//                  builder: (context, snapshot) {
//                  if (snapshot.data == 'toggleButton'){
//                    greenActive[teamNumber[num]] = !greenActive[teamNumber[num]];
//                  }
//                  return new FlatButton (
//                    shape: RoundedRectangleBorder(
//                      borderRadius: BorderRadius.circular(10.0),
//                    ),
//                    child: Text(
//                        'Green $num',
//                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)
//                    ),
//                    color: greenActive[teamNumber[num]] ? Colors.green : Colors.grey,
//                    textColor: Colors.white,
//                    onPressed: () {
//                      client.write("G$num");
//                      setState(() {
//                      });
//                    },
//                  );})
//            ),
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
          onPressed: () => _exitDialog(),
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
                    fontWeight: FontWeight.bold,
                    color: Color(0xffCC0066),
                    fontSize: 22),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                "Red Team",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    fontSize: 18),
              ),
              Text(
                "Green Team",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                    fontSize: 18),
              ),
            ],
          ),
          playerRowWidget("1"),
          playerRowWidget("2",),
          playerRowWidget("Captain"),
          playerRowWidget("3"),
          playerRowWidget("4"),
          Container(
            margin: EdgeInsets.only(bottom: 20.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                "Please wait for the Moderator\nto Start the Game",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                    fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

_exitDialog() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: Text("Exit to Home Page"),
            content: Text("Are you sure you want to exit to the home page?"),
            actions: <Widget>[
              FlatButton(
                child: Text("No", style: staystyle),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Exit", style: exitstyle),
                onPressed: () {  Navigator.pushAndRemoveUntil(context, 
                  MaterialPageRoute(builder: (BuildContext context) => MyHomePage(),
                  ),
                  ModalRoute.withName('/'));},
              ),
            ],
          );
        });
  }
}
