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
  Player player;
  _PlayerWaitingRoomState(this.client);
  List<StreamController<String>> _playerJoinStreamControllers;
  List<bool> _playerSlotIsTakenList;
  List<String> _playerNamesList;
//  List<bool> playerSlotIsTakenList = List.generate(10, (_) => false);
//  List<String> playerNamesList = List.generate(10, (_) => "");

//  List<bool> redActive = List.generate(5, (_) => tr"'$a' '$b'"ue);
//  List<bool> greenActive = List.generate(5, (_) => true);

  StreamSubscription socketDataStreamSubscription;
  @override
  void initState() {
    super.initState();
      player = Player("");
      player.userName = user.userName;
      player.email = user.email;
      _playerSlotIsTakenList= List.generate(10, (_) => false);
      _playerNamesList = List.generate(10, (_) => "");
      _playerJoinStreamControllers = new List(10);
      for (var i = 0 ; i < 10; i++ ) {
        _playerJoinStreamControllers[i] = StreamController.broadcast();
//        greenPlayerJoinStreamController[i] = StreamController.broadcast();
      }
      Stream socketDataStream = socketDataStreamController.stream;
      socketDataStreamSubscription = socketDataStream.listen((data) {
        ///////////////////////////////////////////////////////////////////
        ///////////////////////////////////////////////////////////////////
        print("DATA FROM SERVER");
        print(data);
        data = json.decode(data);
        String d = data["type"];
        if (data["type"] == "buzzer") {
//          print("got a buzzer response");
          int playerPositionIndex = int.parse(data["playerPositionIndex"]);
          String userName = data["userName"];
          String previousState = data["previousState"];
          if (previousState!="") {
            int previousStateIndex = playerPositionIndexDict[previousState];
            _playerJoinStreamControllers[previousStateIndex].add("undoSelect");
          }
//          print("turn button grey");
          _playerJoinStreamControllers[playerPositionIndex].add(userName);
          // test this out it might cause async problems
          player.playerID = data["playerID"];
        }
        else if (data["type"] == "startGame") {
          print("Moving on to game");
          socketDataStreamSubscription.cancel();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Game(client, player)),
          );
        } else if (data["type"] == "waitingScreenState") {
          print("got waitingScreenState");
          _playerSlotIsTakenList = (json.decode(data["playerSlotIsTakenList"]) as List).cast<bool>();
          _playerNamesList = (json.decode(data["playerNamesList"]) as List).cast<String>();
          _playerSlotIsTakenList
              .asMap()
              .forEach(
                  (index, value) =>
                  (value) ? _playerJoinStreamControllers[index].add(_playerNamesList[index]) : _playerJoinStreamControllers[index].add("undoSelect")
              );

        }
        ///////////////////////////////////////////////////////////////////
        ///////////////////////////////////////////////////////////////////
    });
  }
  SizedBox teamSlotWidget(String playerPosition, String team) {
    var color, buttonColor, buttonText;
    String playerID = '$team $playerPosition';
    int playerPositionIndex = playerPositionIndexDict[playerID];
//    String buttonText = '$team $playerPosition';
//    print("team $team");
//    print("player index $playerPositionIndex");
//    print("stream $playerJoinStreamControllers[playerPositionIndex]");
    if (team == "A") {
      color = Colors.red;
    }  else if (team == "B") {
//      playerPositionIndex += 5;
      color = Colors.green;
    }
    if (_playerSlotIsTakenList[playerPositionIndex]) {
      buttonText = _playerNamesList[playerPositionIndex];
      buttonColor = Colors.grey;
    } else {
      buttonText = playerID;
      buttonColor = color;
    }
//    buttonColor = playerSlotIsActiveList[playerPositionIndex] ? color : Colors.grey;
    return new SizedBox(
      width: 140.0,
      height: 50,
      child:
      new StreamBuilder(
          stream: _playerJoinStreamControllers[playerPositionIndex].stream,
          builder: (context, snapshot) {
            if (snapshot.data == "undoSelect") {
              _playerJoinStreamControllers[playerPositionIndex].add(null);
              _playerSlotIsTakenList[playerPositionIndex] = false;
              _playerNamesList[playerPositionIndex] = playerID;
              buttonColor = Colors.grey;
              buttonText = _playerNamesList[playerPositionIndex];
              buttonColor = color;
              buttonText = playerID;
//              buttonText = playerPosition;
//              buttonColor = color;
            }
            else if (snapshot.data != null) {
//              buttonColor = playerSlotIsActiveList[playerPositionIndex] ? color : Colors.grey;
//              print("turn button grey inside widget");
              _playerJoinStreamControllers[playerPositionIndex].add(null);
              _playerSlotIsTakenList[playerPositionIndex] = true;
              _playerNamesList[playerPositionIndex] = snapshot.data;
              buttonColor = Colors.grey;
              buttonText = _playerNamesList[playerPositionIndex];
//              buttonText = snapshot.data;
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
                    "playerID": playerID,
                    "playerPositionIndex": playerPositionIndex.toString(),
                    "previousState": player.playerID,
                  };
                  print("SENDING TO SERVER");
                  print(message);
                  if (!_playerSlotIsTakenList[playerPositionIndex]) {
                    client.write(json.encode(message));
                  }
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
            teamSlotWidget(playerPosition, "A"),
            teamSlotWidget(playerPosition, "B"),
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
                "Team A",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    fontSize: 18),
              ),
              Text(
                "Team B",
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
