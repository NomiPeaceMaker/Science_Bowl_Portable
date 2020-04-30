import 'dart:async';

import 'package:flutter/material.dart';
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

  _ModeratorWaitingRoomState(this.server, this.moderator,this.questionSet);

  StreamSubscription socketDataStreamSubscription;
  initState() {
    Stream socketDataStream = socketDataStreamController.stream;
    socketDataStreamSubscription = socketDataStream.listen((data){
      Player player = Player(data);
      print("AT WAITING SCREEN");
      print(data);
      if (data[0] == "R") {
        int playerNumber = int.parse(data[1]);
        print(data.substring(2));
        moderator.redTeam.players.add(player);
      } else if (data[0] == "G") {
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
            child: FlatButton (
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                  'Red $rNum',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)
              ),
              color: Colors.red,
              textColor: Colors.white,
              onPressed: () {
                setState(() {
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
                  'Green $rNum',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)
              ),
              color: Colors.green,
              textColor: Colors.white,
              onPressed: () {
                setState(() {
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
                      server.broadCast("StartGame"),
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



