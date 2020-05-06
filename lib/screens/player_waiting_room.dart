import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:sciencebowlportable/screens/player_buzzer_screen.dart';
import 'package:sciencebowlportable/screens/waiting_room.dart';
import 'package:sciencebowlportable/screens/join_set.dart';
import 'package:sciencebowlportable/screens/home.dart';
import 'package:sciencebowlportable/globals.dart';
import 'package:sciencebowlportable/models/Client.dart';
import 'package:sciencebowlportable/models/Player.dart';
import 'package:sciencebowlportable/utilities/styles.dart';

class PlayerWaitingRoom extends waitingRoom {
  Client client;
  PlayerWaitingRoom(this.client);

  @override
  _PlayerWaitingRoomState createState() {
    return _PlayerWaitingRoomState(this.client);
  }
}

class _PlayerWaitingRoomState extends waitingRoomState<PlayerWaitingRoom> {
  Client client;
  Player player;

  _PlayerWaitingRoomState(this.client);

  StreamSubscription socketDataStreamSubscription;

  StreamController<bool> isPlayerSlotSelectedStream = StreamController();
  bool isPlayerSlotSelected = false;

  @override
  void initState() {
    super.initState();
    appBarText = "JOIN";
    player = Player("");
    player.userName = user.userName;
    player.email = user.email;
    Stream socketDataStream = socketDataStreamController.stream;
    socketDataStreamSubscription = socketDataStream.listen((data) {
      print("player waiting room");
      print(data);
      data = json.decode(data);
      if (data["type"] == "selectSlot") {
        setState(() {
          isPlayerSlotSelected = true;
        });
        int playerPositionIndex = int.parse(data["playerPositionIndex"]);
        String userName = data["userName"];
        String previousState = userSlotsDict[data["uniqueID"]];
//        String previousState = data["previousState"];
        if (previousState != null) {
          int previousStateIndex = playerPositionIndexDict[previousState];
          playerJoinStreamControllers[previousStateIndex].add("undoSelect");
        }
        playerJoinStreamControllers[playerPositionIndex].add(userName);
        userSlotsDict[data["uniqueID"]] = data["playerID"];
        // test this out it might cause async problems
        player.playerID = data["playerID"];
      } else if (data["type"] == "startGame") {
        print("Moving on to game");
        socketDataStreamSubscription.cancel();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PlayerBuzzer(this.client, this.player)),
        );
      }
       else if (data["type"] == "waitingScreenState") {
        print("got waitingScreenState");
        playerSlotIsTakenList = (json.decode(data["playerSlotIsTakenList"]) as List).cast<bool>();
        playerNamesList = (json.decode(data["playerNamesList"]) as List).cast<String>();
        playerSlotIsTakenList
            .asMap()
            .forEach(
                (index, value) =>
            (value) ? playerJoinStreamControllers[index].add(
                playerNamesList[index]) : playerJoinStreamControllers[index]
                .add("undoSelect")
        );
      } else if (data["type"] == "moderatorLeaving") {
        client.disconnect();
        _moderatorEndedGameDialog();
      }
    });
  }

  @override
  void onPressTeamSlot(String playerID, int playerPositionIndex) {
    print("Constructing message");
    var message = {
      "type": "selectSlot",
      "userName": player.userName,
      "playerID": playerID,
      "uniqueID": player.userName,
      "playerPositionIndex": playerPositionIndex.toString(),
//      "previousState": player.playerID,
    };
    if (!playerSlotIsTakenList[playerPositionIndex]) {
      client.write(json.encode(message));
    }
  }

  @override
  Align bottomScreenMessage() {
    return new Align(
      alignment: Alignment.bottomCenter,
      child: new SizedBox(
        width: 140.0,
        height: 60.0,
        child: new FlatButton(
          shape: new RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: new Text(
              "Start Game",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)
          ),
          color: isPlayerSlotSelected ? Colors.pink : Colors.grey,
          textColor: Colors.white,
          onPressed: () => {
            if (player.playerID == "") {
              _selectAPlayerPosition(),
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => JoinSet(this.client, this.player)),
              ),
            },
          }),
      ),
    );
  }

  @override
  void onExit() {
    var message = {
      "type": "playerLeaving",
      "userName": player.userName,
      "playerID": player.playerID,
      "uniqueID": player.userName,
      "playerPositionIndex": playerPositionIndexDict[player.playerID].toString(),
    };
    client.write(json.encode(message));
  }

  _selectAPlayerPosition() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: Text("Select a Player Position"),
            content: Text("You must select a player position to proceed."),
            actions: <Widget>[
              FlatButton(
                child: Text("Okay", style: staystyle),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
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
//                Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
              },
            ),
          ],
        );
      });
  }
}