import 'package:flutter/material.dart';
import 'dart:async';

List<StreamController<String>> redPlayerJoinStreamController = new List.filled(5, StreamController());
List<StreamController<String>> greenPlayerJoinStreamController = new List.filled(5, StreamController());

Row playerRowWidget(String rNum, String gNum) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: <Widget>[
      SizedBox(
        width: 140.0,
        height: 50,
        child:FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Text(
              'Red $rNum',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)
          ),
          color: Colors.red,
          textColor: Colors.white,
          onPressed: () => {},
        ),
      ),
      SizedBox(
        width: 140.0,
        height: 50.0,
        child: FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Text(
              'Green $gNum',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)
          ),
          color: Colors.green,
          textColor: Colors.white,
          onPressed: () => {},
        ),
      ),
    ],
  );
}