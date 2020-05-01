import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:sciencebowlportable/globals.dart';
import 'package:sciencebowlportable/models/Moderator.dart';
import 'package:sciencebowlportable/screens/moderator.dart';
import 'package:sciencebowlportable/models/Server.dart';
import 'package:sciencebowlportable/models/Player.dart';
import 'package:sciencebowlportable/screens/widgets.dart';
import 'package:sciencebowlportable/models/Questions.dart';
import 'package:sciencebowlportable/utilities/styles.dart';

import 'home.dart';

class ModeratorWaitingRoom extends StatefulWidget {
  Server server;
  Moderator moderator;
  List<Question> questionSet;

  @override
  ModeratorWaitingRoom(this.server, this.moderator);
  _ModeratorWaitingRoomState createState() {
    return _ModeratorWaitingRoomState(this.server, this.moderator,this.questionSet);
  }
}

class _ModeratorWaitingRoomState extends State<ModeratorWaitingRoom> {
  Server server;
  Moderator moderator;
  List<Question> questionSet;

  List<bool> redActive = List.generate(5, (_) => true);
  List<bool> greenActive = List.generate(5, (_) => true);
  var teamNumber = {"1": 0, "2":1, "Captain":2, "3":3, "4":4};

//  List<StreamController<String>> redPlayerJoinStreamController = new List(5);
//  List<StreamController<String>> greenPlayerJoinStreamController = new List(5);

  _ModeratorWaitingRoomState(this.server, this.moderator,this.questionSet);

  StreamSubscription socketDataStreamSubscription;
  initState() {
    Stream socketDataStream = socketDataStreamController.stream;
//    List<StreamController<String>> redPlayerJoinStreamController = new List.filled(5, StreamController.broadcast());
//    List<StreamController<String>> greenPlayerJoinStreamController = new List.filled(5, StreamController.broadcast());

    for( var i = 0 ; i < 5; i++ ) {
      redPlayerJoinStreamController[i] = StreamController.broadcast();
      greenPlayerJoinStreamController[i] = StreamController.broadcast();
    }
    socketDataStreamSubscription = socketDataStream.listen((data){
      data = data.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
      print(data);
      server.sendAll(data);
      Player player = Player(data);
      print("AT WAITING SCREEN MODERATOR");
      int playerNumber = teamNumber[data.substring(1)];
      print(playerNumber);
      if (data[0] == "R") {
        print("check");
        print(playerNumber);
        redPlayerJoinStreamController[playerNumber].add("toggleButton");
//        moderator.redTeam.players.add(player);
      } else if (data[0] == "G") {
        greenPlayerJoinStreamController[playerNumber].add("toggleButton");
//        moderator.redTeam.players.add(player);
      }
    });
//    R1controller = new StreamController();
//    R1stream = R1controller.stream;
//    super.initState();
      moderator.questionSet.then((list){
      questionSet=list;
      print("Retrieved questions");
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
              if (snapshot.data == 'toggleButton'){
                redPlayerJoinStreamController[teamNumber[playerPosition]].add(" ");
                redActive[teamNumber[playerPosition]] = !redActive[teamNumber[playerPosition]];
              }
              return new FlatButton (
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                    'Red $playerPosition',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)
                ),
                color: redActive[teamNumber[playerPosition]] ? Colors.red : Colors.grey,
                textColor: Colors.white,
                onPressed: () {
                  setState(() {
                  });
                },
              );
            })
    );
  }

  Row moderatorRowWidget(String playerPosition) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        teamSlot(playerPosition, "Red"),
        teamSlot(playerPosition, "Green"),
//        new SizedBox(
//          width: 140.0,
//          height: 50,
//          child: new StreamBuilder(
//            stream: greenPlayerJoinStreamController[teamNumber[playerPosition]].stream,
//            builder: (context, snapshot) {
//              if (snapshot.data == 'toggleButton'){
//                greenPlayerJoinStreamController[teamNumber[playerPosition]].add(" ");
//                greenActive[teamNumber[playerPosition]] = !greenActive[teamNumber[playerPosition]];
//              }
//              return new FlatButton(
//                shape: RoundedRectangleBorder(
//                  borderRadius: BorderRadius.circular(10.0),
//                ),
//                child: Text(
//                    'Green $playerPosition',
//                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)
//                ),
//                color: greenActive[teamNumber[playerPosition]] ? Colors.green : Colors.grey,
//                textColor: Colors.white,
//                onPressed: () {
//                  setState(() {});
//                },
//              );
//            })
//        ),
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.cancel, color: Colors.white),
          onPressed: () => _exitDialog(),
        ),
        backgroundColor: Color(0xffF8B400),
        title: Text(
          "HOST",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                      "You're hosting,\n${user.userName}",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey, fontSize: 18),
                  ),
                  Text(
                      "Game Pin:\n${moderator.gamePin}",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey, fontSize: 18),
                  ),
                ],
              )
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
          moderatorRowWidget("1"),
          moderatorRowWidget("2"),
          moderatorRowWidget("Captain"),
          moderatorRowWidget("3"),
          moderatorRowWidget("4"),
          Container(
            margin: EdgeInsets.only(bottom: 20.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: 140.0,
                height: 60.0,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Text(
                      "Start Game",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)
                  ),
                  color: Colors.pink,
                  textColor: Colors.white,
                  onPressed: () => {
                    socketDataStreamSubscription.cancel(),
                      server.sendAll("StartGame"),
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Host(this.server, this.moderator,this.questionSet)),
                      ),
                  },
                ),
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



