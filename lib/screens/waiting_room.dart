import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:sciencebowlportable/globals.dart';
import 'package:sciencebowlportable/utilities/styles.dart';
import 'home.dart';

// super class for moderator and player waiting rooms

class waitingRoom extends StatefulWidget {
  @override
  waitingRoomState createState() => waitingRoomState();
}

List<bool> playerSlotIsOccupiedList = List.generate(10, (_) => false);
List<String> playerSlotNamesList = List.generate(10, (_) => "");

class waitingRoomState<T extends waitingRoom> extends State<T> {
  List<StreamController<String>> playerJoinStreamControllers = new List(10);
  StreamSubscription socketDataStreamSubscription;
  String appBarText; // JOIN or HOST depending on moderator or player
  var userSlotsDict = {};

  var retrievePlayerSlotIndexDict;
  @override
  void initState() {
    super.initState();
    for (var i = 0 ; i < 10; i++ ) {
      playerJoinStreamControllers[i] = StreamController.broadcast();
    }
    retrievePlayerSlotIndexDict =
    {
      "A Captain":0,
      "A 1":1,
      "A 2":2,
      "A 3":3,
      "A 4":4,
      "B Captain":5,
      "B 1":6,
      "B 2":7,
      "B 3":8,
      "B 4":9
    };
  }

    @required Align bottomScreenMessage() {} // Join or Start buttons

    // function callback on pressing a waiting room slot
    void onPressTeamSlot(String playerID, int playerPositionIndex) {}

    // function called when back button is pressed
    void onExit() {}
    Container pinBar() {
      return new Container();
    }

    SizedBox teamSlotWidget(String playerPosition, String team) {
    var color, buttonColor, buttonText;
    double elevation = 2.0;

    String playerID = '$team $playerPosition';
    int playerPositionIndex = retrievePlayerSlotIndexDict[playerID];
    if (team == "A") {
      color = Colors.red;
    }  else if (team == "B") {
      color = Colors.green;
    }
    if (playerSlotIsOccupiedList[playerPositionIndex]) {
      buttonText = playerSlotNamesList[playerPositionIndex];
      buttonColor = Colors.grey;
      elevation = 0.0;
    } else {
      buttonText = playerID;
      buttonColor = color;
      elevation = 2.0;
    }

    // TODO
    // back button should navigate to home
    return new SizedBox(
        width: 140.0,
        height: 55,
        child:
        new StreamBuilder(
            stream: playerJoinStreamControllers[playerPositionIndex].stream,
            builder: (context, snapshot) {
              if (snapshot.data == "undoSelect") {
                playerJoinStreamControllers[playerPositionIndex].add(null);
                playerSlotIsOccupiedList[playerPositionIndex] = false;
                playerSlotNamesList[playerPositionIndex] = playerID;
                buttonColor = Colors.grey;
                buttonText = playerSlotNamesList[playerPositionIndex];
                buttonColor = color;
                buttonText = playerID;
              }
              else if (snapshot.data != null) {
                playerJoinStreamControllers[playerPositionIndex].add(null);
                playerSlotIsOccupiedList[playerPositionIndex] = true;
                playerSlotNamesList[playerPositionIndex] = snapshot.data;
                buttonColor = Colors.grey;
                buttonText = playerSlotNamesList[playerPositionIndex];
              }
              return new RaisedButton (
                elevation: elevation,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9.0),
                ),
                child: Text(
                    buttonText,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                color: buttonColor,
                textColor: Colors.white,
                onPressed: () {
                  setState(() {
                    onPressTeamSlot(playerID, playerPositionIndex);
                  });
                },
              );
            })
    );
  }

  Row playerRowWidget(String playerPosition) {
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
    return WillPopScope(
      onWillPop: () =>_exitDialog(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => _exitDialog(),
          ),
          backgroundColor: Color(0xffF8B400),
          title: Text(
            appBarText,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
          ),
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/game_back.png',),
              alignment: Alignment.bottomRight,
              fit: BoxFit.scaleDown),
        ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              pinBar(),
              Container(
                margin: EdgeInsets.only(top: 5.0),
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
              playerRowWidget("Captain"),
              playerRowWidget("1",),
              playerRowWidget("2"),
              playerRowWidget("3"),
              playerRowWidget("4"),
              Container(
                margin: EdgeInsets.only(bottom: 20.0),
                child: bottomScreenMessage(),
              ),
            ],
          ),
        ),
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
                onPressed: () {
                  setState(() {
                    playerSlotIsOccupiedList = List.generate(10, (_) => false);
                    playerSlotNamesList = List.generate(10, (_) => "");
                  });
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => MyHomePage(),),
                    ModalRoute.withName('/')
                  );
                  onExit();
                },
              ),
            ],
          );
        });
  }
}
