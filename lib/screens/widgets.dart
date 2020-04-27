//import 'package:flutter/material.dart';
//import 'dart:async';
//import 'package:sciencebowlportable/models/Client.dart';
//import 'package:sciencebowlportable/models/Server.dart';
//
//List<StreamController<String>> redPlayerJoinStreamController = new List.filled(5, StreamController());
//List<StreamController<String>> greenPlayerJoinStreamController = new List.filled(5, StreamController());
//
//List<StreamSubscription> redPlayerJoinStreamSubscription;
//List<StreamSubscription> greenPlayerJoinStreamSubscription;
//
//
//void onPressed(String teamName, int playerNumber, Server server, Client client) {
//  if (client!=null) {
//    if (teamName == "Green") {
//      client.write("G$playerNumber");
//    } else if (teamName == "Red") {
//      client.write("R$playerNumber");
//    }
//  }
//  if (teamName=="Green") {
//    greenPlayerJoinStreamController[playerNumber-1].add("buttonPressed");
//  } else if (teamName=="Red") {
//    redPlayerJoinStreamController[playerNumber-1].add("buttonPressed");
//  }
//}
//
//Row playerRowWidget(String rNum, String gNum, {Server server, Client client}) {
//  return Row(
//    mainAxisAlignment: MainAxisAlignment.spaceAround,
//    children: <Widget>[
//      SizedBox(
//        width: 140.0,
//        height: 50,
//        child:FlatButton(
//          shape: RoundedRectangleBorder(
//            borderRadius: BorderRadius.circular(10.0),
//          ),
//          child: Text(
//              'Red $rNum',
//              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)
//          ),
//          color: Colors.red,
//          textColor: Colors.white,
//          onPressed: () => onPressed("Red", int.parse(rNum), server, client)
//        ),
//      ),
//      SizedBox(
//        width: 140.0,
//        height: 50.0,
//        child: FlatButton(
//          shape: RoundedRectangleBorder(
//            borderRadius: BorderRadius.circular(10.0),
//          ),
//          child: Text(
//              'Green $gNum',
//              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)
//          ),
//          color: Colors.green,
//          textColor: Colors.white,
//          onPressed: () => {
//            onPressed("Green", int.parse(gNum), server, client),
//          }
//        ),
//      ),
//    ],
//  );
//}