import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sciencebowlportable/globals.dart';
import 'package:sciencebowlportable/models/Moderator.dart';
import 'package:sciencebowlportable/screens/moderator.dart';
import 'package:sciencebowlportable/screens/waiting_room.dart';
import 'package:sciencebowlportable/models/Server.dart';
import 'package:sciencebowlportable/models/Player.dart';
import 'package:sciencebowlportable/models/Questions.dart';
import 'package:sciencebowlportable/utilities/styles.dart';

class ModeratorWaitingRoom extends waitingRoom {
  Server server;
  Moderator moderator;
  List<Question> questionSet;

  @override
  ModeratorWaitingRoom(this.server, this.moderator,this.questionSet);
  _ModeratorWaitingRoomState createState() {
    return _ModeratorWaitingRoomState(this.server, this.moderator,this.questionSet);
  }
}

class _ModeratorWaitingRoomState extends waitingRoomState<ModeratorWaitingRoom> {
  Server server;
  Moderator moderator;
  List<Question> questionSet;
  _ModeratorWaitingRoomState(this.server, this.moderator,this.questionSet);

  @override
  initState() {
    super.initState();
    Stream socketDataStream = socketDataStreamController.stream;
    socketDataStreamSubscription = socketDataStream.listen((data) {
      ///////////////////////////////////////////////////////////////////
      ///////////////////////////////////////////////////////////////////
      print("got Data");
      print(data);
      data = json.decode(data);

      Player player = Player(data["playerID"]);
      player.userName = data["userName"];
      player.email = data["email"];
      print("LISTENING AT WAITING SCREEN MODERATOR");
      if (data["type"] == "buzzer") {
        int playerPositionIndex = int.parse(data["playerPositionIndex"]);
        String previousState = data["previousState"];
        print("IS PLAYER SLOT TAKEN");
        if (!playerSlotIsTakenList[playerPositionIndex]) {
          print("SENDING data to all");
          server.sendAll(json.encode(data));
          if (previousState!="") {
            int previousStateIndex = playerPositionIndexDict[previousState];
            playerJoinStreamControllers[previousStateIndex].add("undoSelect");
          }
          playerJoinStreamControllers[playerPositionIndex].add(player.userName);
        }
      } else if (data["type"]=="newUserConnected") {
        print("New user  connected, sending it waiting rooms states");
        var waitingScreenState = {"type": "waitingScreenState"};
        waitingScreenState["playerSlotIsTakenList"] = json.encode(playerSlotIsTakenList);
        waitingScreenState["playerNamesList"] = json.encode(playerNamesList);
        print(waitingScreenState);
        server.sendAll(json.encode(waitingScreenState));
      }
      ///////////////////////////////////////////////////////////////////
      ///////////////////////////////////////////////////////////////////
    });
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
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: new Text(
              "Start Game",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)
          ),
          color: Colors.pink,
          textColor: Colors.white,
          onPressed: () => {
            socketDataStreamSubscription.cancel(),
            server.sendAll(json.encode({"type":"startGame"})),
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Host(this.server, this.moderator, this.questionSet)),
            ),
          },
        ),
      ),
    );
  }

  _captainLeftDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Text("Captains Need to Join"),
          content: Text("Both team captians need to join before we can start the game. Please ask them to join before presseing start game."),
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
  @override
  Container pinBar() {
    return new Container(
      margin: EdgeInsets.only(top: 10.0),
      child: new Align(
        alignment: Alignment.topCenter,
        child: new Row(
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
    );}
}