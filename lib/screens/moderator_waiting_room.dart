import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sciencebowlportable/globals.dart';
import 'package:sciencebowlportable/models/Moderator.dart';
import 'package:sciencebowlportable/screens/moderator_game_screen.dart';
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
    appBarText = "HOST";
    Stream socketDataStream = socketDataStreamController.stream;
    socketDataStreamSubscription = socketDataStream.listen((data) {
      print("got Data");
      print(data);
      data = json.decode(data);
      Player player = Player(data["playerID"]);
      player.userName = data["userName"];
      player.email = data["email"];
      print("LISTENING AT WAITING SCREEN MODERATOR");
      if (data["type"] == "pin") {
        if (data["pin"] == pin) {
          print("moderator accepts pin");
          server.sockets[data["uniqueID"]].write(
              json.encode({"type": "pinState", "pinState": "Accepted", "moderatorName": user.userName})
          );
        } else {
          server.sockets[data["uniqueID"]].write(
              json.encode({"type": "pinState", "pinState": "Rejected"})
          );
        }
      } else if (data["type"] == "movingToWaitingRoom") {
        userSlotsDict[data["uniqueID"]] = null;
        var waitingScreenState = {"type": "waitingScreenState"};
        waitingScreenState["playerSlotIsTakenList"] = json.encode(playerSlotIsTakenList);
        waitingScreenState["playerNamesList"] = json.encode(playerNamesList);
        print(waitingScreenState);
        server.sendAll(json.encode(waitingScreenState));
      } else if (data["type"] == "selectSlot") {
        print(playerSlotIsTakenList);
        String previousState = userSlotsDict[data["uniqueID"]];
        int playerPositionIndex = int.parse(data["playerPositionIndex"]);
        if (!playerSlotIsTakenList[playerPositionIndex]) {
          server.sendAll(json.encode(data));
          if (previousState!=null) {
            int previousStateIndex = playerPositionIndexDict[previousState];
            playerJoinStreamControllers[previousStateIndex].add("undoSelect");
          }
          playerJoinStreamControllers[playerPositionIndex].add(player.userName);
          userSlotsDict[data["uniqueID"]] = data["playerID"];
        }
      } else if (data["type"] == "playerLeaving") {
        var uniqueID = data["uniqueID"];
        server.sockets[uniqueID].close();
        server.sockets.removeWhere((key, _) => key == uniqueID);
        socketDataStreamController.add(json.encode({"type": "newUserConnected"}));
        int playerPositionIndex = int.parse(data["playerPositionIndex"]);
        playerJoinStreamControllers[playerPositionIndex].add("undoSelect");
      }
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
            if (playerSlotIsTakenList[2] && playerSlotIsTakenList[7]) {
              socketDataStreamSubscription.cancel(),
              server.sendAll(json.encode({"type":"startGame"})),
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ModeratorQuestions(this.server, this.moderator, this.questionSet)),
              ),
            } else {
              _captainLeftDialog(),
              /////////// for testing /////////////////////////////////
              ////////// comment this out for real game ///////////////
              socketDataStreamSubscription.cancel(),
              server.sendAll(json.encode({"type":"startGame"})),
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ModeratorQuestions(this.server, this.moderator, this.questionSet)),
              ),
              ////////////////////////////////////////////////////////
              ///////////////////////////////////////////////////////
            }
          },
        ),
      ),
    );
  }

  @override
  Container pinBar() {
    pin = game.gamePin;
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
              "Game Pin:\n${game.gamePin}",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey, fontSize: 18),
            ),
          ],
        )
      ),
    );}

  @override
  void onExit() {
    server.sendAll(json.encode({"type": "moderatorLeaving"}));
    server.stop();
  }

  _captainLeftDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog (
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

}