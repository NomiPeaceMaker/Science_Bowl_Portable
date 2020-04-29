import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sciencebowlportable/globals.dart';
import 'package:sciencebowlportable/models/Moderator.dart';
import 'package:sciencebowlportable/screens/moderator.dart';
import 'package:sciencebowlportable/models/Server.dart';
import 'package:sciencebowlportable/models/Player.dart';
import 'package:sciencebowlportable/screens/widgets.dart';
import 'package:sciencebowlportable/models/Questions.dart';

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

  _ModeratorWaitingRoomState(this.server, this.moderator,this.questionSet);

  StreamSubscription socketDataStreamSubscription;
  initState() {
    Stream socketDataStream = socketDataStreamController.stream;
    socketDataStreamSubscription = socketDataStream.listen((data){
      data = data.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
      print(data);
      Player player = Player(data);
      print("AT WAITING SCREEN");
      int playerNumber = teamNumber[data.substring(1)];
      print(playerNumber);
      if (data[0] == "R") {
        redPlayerJoinStreamController[teamNumber[playerNumber]].add("jj");
        moderator.redTeam.players.add(player);
      } else if (data[0] == "G") {
        greenPlayerJoinStreamController[teamNumber[playerNumber]].add("jj");
        moderator.redTeam.players.add(player);
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

  Row playerRowWidget(String rNum, String gNum) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        SizedBox(
          width: 140.0,
          height: 50,
          child:
          StreamBuilder(
          stream: redPlayerJoinStreamController[teamNumber[rNum]].stream,
          builder: (context, snapshot) {
          redActive[teamNumber[rNum]] = !redActive[teamNumber[rNum]];
          return FlatButton (
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Text(
                'Red $rNum',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)
            ),
            color: redActive[teamNumber[rNum]] ? Colors.red : Colors.grey,
            textColor: Colors.white,
            onPressed: () {
              setState(() {
              });
            },
           );
          })
        ),
        SizedBox(
          width: 140.0,
          height: 50,
          child: StreamBuilder(
            stream: greenPlayerJoinStreamController[teamNumber[gNum]].stream,
            builder: (context, snapshot) {
              greenActive[teamNumber[gNum]] = !greenActive[teamNumber[gNum]];
              return FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                    'Green $gNum',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)
                ),
                color: greenActive[teamNumber[gNum]] ? Colors.green : Colors.grey,
                textColor: Colors.white,
                onPressed: () {
                  setState(() {});
                },
              );
            })
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
          playerRowWidget("1", "1"),
          playerRowWidget("2", "2"),
          playerRowWidget("Captain", "Captain"),
          playerRowWidget("3", "3"),
          playerRowWidget("4", "4"),
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
}