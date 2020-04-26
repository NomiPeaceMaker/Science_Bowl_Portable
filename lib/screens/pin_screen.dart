library join;
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:sciencebowlportable/models/Client.dart';
import 'package:sciencebowlportable/screens/player_buzzer.dart';

part 'package:sciencebowlportable/screens/player_waiting_room.dart';

//void join() => Pin();
//Might need to tweak the colour scheme a bit + Red Team or Team A?
//Needs validation based on valid pins + better styling possible


class Pin extends StatefulWidget {
  @override
  _PinState createState() => _PinState();
}

class _PinState extends State<Pin> {
  String gamePin;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xffF8B400),
        title: Text("Join Game"),
        centerTitle: true,
      ),
      body: Center(
          child: Container(
          child: AlertDialog(
            title: Text('Enter Match PIN to join'),
            content: new Row(
              children: <Widget>[
                new Expanded(
                    child: new TextField(
                      autofocus: true,
                      decoration: new InputDecoration(
                          labelText: 'Match PIN',
                          hintText: 'eg. AB123',),
                      onChanged: (value) {
                        gamePin = value;
                      },
                    ))
              ],
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  } //should go back to home page
//                  Navigator.of(context).pop(teamName);
              ),
              FlatButton(
                child: Text('Confirm'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => _WaitingRoom()),
                  );
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}