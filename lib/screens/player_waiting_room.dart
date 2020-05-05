import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:sciencebowlportable/screens/player_buzzer.dart';
import 'package:sciencebowlportable/screens/waiting_room.dart';
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
          MaterialPageRoute(builder: (context) => Game(client, player)),
        );
      }
//      else if (data["pin"] == "what_is_pin") {
//        print("HOST ASKED: WHAT IS THE PIN??");
//
//      }
       else if (data["type"] == "waitingScreenState") {
        print("got waitingScreenState");
        playerSlotIsTakenList =
            (json.decode(data["playerSlotIsTakenList"]) as List).cast<bool>();
        playerNamesList =
            (json.decode(data["playerNamesList"]) as List).cast<String>();
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
      child: new Text(
        "Please wait for the Moderator\nto Start the Game",
        textAlign: TextAlign.center,
        style: new TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
            fontSize: 18),
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
                Navigator.popUntil(context, ModalRoute.withName('/home'));
              },
            ),
          ],
        );
      });
  }
}