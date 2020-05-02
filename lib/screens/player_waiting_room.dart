import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:sciencebowlportable/screens/player_buzzer.dart';
import 'package:sciencebowlportable/globals.dart';
import 'package:sciencebowlportable/models/Client.dart';
import 'package:sciencebowlportable/models/Player.dart';
import 'package:sciencebowlportable/utilities/styles.dart';

import 'home.dart';

class PlayerWaitingRoom extends StatefulWidget {
  Client client;

  PlayerWaitingRoom(this.client);
  @override
  _PlayerWaitingRoomState createState() {
    return _PlayerWaitingRoomState(this.client);
  }
}

class _PlayerWaitingRoomState extends State<PlayerWaitingRoom> {
  Client client;
  Player player = Player("");
  _PlayerWaitingRoomState(this.client);
  List<StreamController<String>> playerJoinStreamControllers = new List(10);
  List<bool> playerSlotIsActiveList = List.generate(10, (_) => true);

//  List<bool> redActive = List.generate(5, (_) => true);
//  List<bool> greenActive = List.generate(5, (_) => true);

  StreamSubscription socketDataStreamSubscription;
  @override
  void initState() {
    super.initState();
      player.userName = user.userName;
      player.email = user.email;
      for (var i = 0 ; i < 10; i++ ) {
        playerJoinStreamControllers[i] = StreamController.broadcast();
//        greenPlayerJoinStreamController[i] = StreamController.broadcast();
      }
      Stream socketDataStream = socketDataStreamController.stream;
      socketDataStreamSubscription = socketDataStream.listen((data) {
        ///////////////////////////////////////////////////////////////////
        ///////////////////////////////////////////////////////////////////
        print("DATA FROM SERVER");
        print(data);
        data = json.decode(data);
        if (data["type"] == "buzzer") {
          int playerPositionIndex = int.parse(data["playerPositionIndex"]);
          String userName = data["userName"];
          String previousState = data["previousState"];
          if (previousState!=""){
            int previousStateIndex = playerPositionIndexDict[previousState];
            playerJoinStreamControllers[previousStateIndex].add("undoSelect");
          }
          playerJoinStreamControllers[playerPositionIndex].add(userName);
          // test this out it might cause async problems
          player.playerID = data["playerPosition"];
        }
        else if (data["type"] == "startGame") {
          print("Moving on to game");
          socketDataStreamSubscription.cancel();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Game(client, player)),
          );
        }

        ///////////////////////////////////////////////////////////////////
        ///////////////////////////////////////////////////////////////////
    });
  }
  SizedBox teamSlotWidget(String playerPosition, String team) {
    var color, buttonColor;
    String buttonText;
//    String buttonText = '$team $playerPosition';
    int playerPositionIndex = playerPositionIndexDict['$team $playerPosition'];
//    print("team $team");
//    print("player index $playerPositionIndex");
//    print("stream $playerJoinStreamControllers[playerPositionIndex]");
    if (team == "Red") {
      color = Colors.red;
    }  else if (team == "Green") {
//      playerPositionIndex += 5;
      color = Colors.green;
    }
    if (!playerSlotIsActiveList[playerPositionIndex]) {
      buttonText = '$team $playerPosition';
      buttonColor = Colors.grey;
    }
//    buttonColor = playerSlotIsActiveList[playerPositionIndex] ? color : Colors.grey;
    return new SizedBox(
      width: 140.0,
      height: 50,
      child:
      new StreamBuilder(
          stream: playerJoinStreamControllers[playerPositionIndex].stream,
          builder: (context, snapshot) {
            if (snapshot.data == "undoSelect") {
              playerJoinStreamControllers[playerPositionIndex].add(null);
              playerSlotIsActiveList[playerPositionIndex] = !playerSlotIsActiveList[playerPositionIndex];
//              buttonColor = color;
            }
            else if (snapshot.data != null) {
//              buttonColor = playerSlotIsActiveList[playerPositionIndex] ? color : Colors.grey;
              playerJoinStreamControllers[playerPositionIndex].add(null);
              playerSlotIsActiveList[playerPositionIndex] = !playerSlotIsActiveList[playerPositionIndex];
              buttonText = snapshot.data;
//              buttonColor = (buttonColor==color) ? Colors.grey : color;
//              redActive[teamNumber[playerPosition]] = !redActive[teamNumber[playerPosition]];
            }
            return new FlatButton (
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                  buttonText,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)
              ),
              color: buttonColor,
              textColor: Colors.white,
              onPressed: () {
                setState(() {
                  print("Constructing message");
                  var message = {
                    "type": "buzzer",
                    "userName": player.userName,
                    "playerPosition": '$team $playerPosition',
                    "playerPositionIndex": playerPositionIndex.toString(),
                    "previousState": player.playerID,
                  };
                  print("SENDING TO SERVER");
                  print(message);
                  client.write(json.encode(message));
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
            teamSlotWidget(playerPosition, "Red"),
            teamSlotWidget(playerPosition, "Green"),
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
