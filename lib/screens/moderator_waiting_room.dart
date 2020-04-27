import 'package:flutter/material.dart';
import 'package:sciencebowlportable/globals.dart';
import 'package:sciencebowlportable/models/Moderator.dart';
import 'package:sciencebowlportable/screens/moderator.dart';
import 'package:sciencebowlportable/models/Server.dart';

class ModeratorWaitingRoom extends StatefulWidget {
  Server server;
  Moderator moderator;

  @override
  ModeratorWaitingRoom(this.server, this.moderator);

  _ModeratorWaitingRoomState createState() {
    return _ModeratorWaitingRoomState(this.server, this.moderator);
  }
}

class _ModeratorWaitingRoomState extends State<ModeratorWaitingRoom> {
  Server server;
  Moderator moderator;

  _ModeratorWaitingRoomState(this.server, this.moderator);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
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
          Row(
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
                      "Red 1",
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
                      "Green 1",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)
                  ),
                  color: Colors.green,
                  textColor: Colors.white,
                  onPressed: () => {},
                ),
              ),
            ],
          ),
          Row(
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
                      "Red 2",
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
                      "Green 2",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)
                  ),
                  color: Colors.green,
                  textColor: Colors.white,
                  onPressed: () => {},
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox(
                width: 140.0,
                height: 50,
                child:FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: Text(
                        "Red Captain",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                    ),
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
                      "Green Captain",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                  ),
                  color: Colors.green,
                  textColor: Colors.white,
                  onPressed: () => {},
                ),
              ),
            ],
          ),
          Row(
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
                      "Red 3",
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
                      "Green 3",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)
                  ),
                  color: Colors.green,
                  textColor: Colors.white,
                  onPressed: () => {},
                ),
              ),
            ],
          ),
          Row(
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
                      "Red 4",
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
                      "Green 4",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)
                  ),
                  color: Colors.green,
                  textColor: Colors.white,
                  onPressed: () => {},
                ),
              ),
            ],
          ),
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
                    server.broadCast("sendPlayerID"),
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Host(this.server, this.moderator)),
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
}