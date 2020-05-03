import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:sciencebowlportable/screens/player_buzzer.dart';
import 'package:sciencebowlportable/screens/waiting_room.dart';
import 'package:sciencebowlportable/globals.dart';
import 'package:sciencebowlportable/models/Client.dart';
import 'package:sciencebowlportable/models/Player.dart';

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
    player = Player("");
    player.userName = user.userName;
    player.email = user.email;
    Stream socketDataStream = socketDataStreamController.stream;
    socketDataStreamSubscription = socketDataStream.listen((data) {
      ///////////////////////////////////////////////////////////////////
      ///////////////////////////////////////////////////////////////////
      print(data);
      data = json.decode(data);
      if (data["type"] == "buzzer") {
        int playerPositionIndex = int.parse(data["playerPositionIndex"]);
        String userName = data["userName"];
        String previousState = data["previousState"];
        if (previousState != "") {
          int previousStateIndex = playerPositionIndexDict[previousState];
          playerJoinStreamControllers[previousStateIndex].add("undoSelect");
        }
        playerJoinStreamControllers[playerPositionIndex].add(userName);
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
      } else if (data["pin"] == "what_is_pin") {
        print("HOST ASKED: WHAT IS THE PIN??");
        
      }
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
      }
      ///////////////////////////////////////////////////////////////////
      ///////////////////////////////////////////////////////////////////
    });
  }

  @override
  void onPressTeamSlot(String playerID, int playerPositionIndex) {
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
}