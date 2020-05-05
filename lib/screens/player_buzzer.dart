import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:async'; //for timer
import "dart:math";
import 'package:sciencebowlportable/globals.dart';
import 'package:sciencebowlportable/models/Client.dart';
import 'package:sciencebowlportable/models/Player.dart';
import 'package:sciencebowlportable/screens/result.dart';
import 'dart:convert';


class Game extends StatefulWidget {
  Client client;
  Player player;

  Game(this.client, this.player);
  @override
  _GameState createState() => _GameState(this.client, this.player);
}

class _GameState extends State<Game> {
//  double timeLeft = 300; //5 mins
  Client client;
  Player player;

//  double timeLeft = 300; //5 mins
  Color txtClr = Colors.white;
//  int aScore = 0; //should be from player or team
  String gamePin=game.gamePin;
//  int bScore = 0; //should be from player or team
  Color bzrBorder=Colors.white;
  Color buzzerClr=Color(0xFFf84b4b);
  String buzzerTxt="Buzz In!";
  String roundName="Toss-up";
  String playerName = "A Captain";
  bool isBuzzerActive=false;
  bool unavailable=true;
  String team="A"; //true for red, false for green
//  int _counter = 5;
  Timer _buzzTimer;
  Timer _gameTimer;
  var element="";


  int _minutes;
  int _seconds=0;
  String buf="0";
  int bonusTimer;
  int tossUpTimer;

  _GameState(this.client, this.player){
    _startBuzzTimer();
    _startGameTimer();
  }
  moderatorLeftGameDialog() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: Text("Moderator has left the match"),
            content: Text("Return to home screen"),
            actions: <Widget>[
              FlatButton(
                child: Text("Okay"),
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName('/home'));
                },
              ),
            ],
          );
        });
  }

  void _startBuzzTimer() {
//    bonusTimer=game.bonusTime;
//    tossUpTimer = game.tossUpTime;
    if (_buzzTimer != null) {
      _buzzTimer.cancel();
    }
    _buzzTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (roundName=="Toss-Up") {
          if (tossUpTimer > 0) {
            tossUpTimer--;
          }
          else {
            _buzzTimer.cancel();
//            decisionTime=true;
            tossUpTimer = game.tossUpTime;
          }
        }
        else
        {
          if (bonusTimer > 0) {
            bonusTimer--;
          }
          else {
            _buzzTimer.cancel();
            setState(() {
//              if ((index+1-(5-skipsLeft))== questionSet.length - 5) {
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                      builder: (context) => Result()),
//                );
//              }
//              else{
                _buzzTimer.cancel();
                bonusTimer=game.bonusTime;
//                decisionTime=true;
                if (isBuzzerActive) {
                  unavailable = true;
                }
//              }
            });
          }
        }
      });
    });
  }

  StreamController<String> BuzzerStreamController = StreamController.broadcast();
  StreamSubscription socketDataStreamSubscription;

  @override
  void initState() {
    super.initState();
//    BuzzerStreamController.add("Blurt");
//    BuzzerStreamController = StreamController.broadcast();
    game.aTeam.score=0;
    game.bTeam.score=0;
    bonusTimer=20;//game.bonusTime;
    tossUpTimer = 5;//game.tossUpTime; //5 secs for buzzer timer
    _minutes = 5; //game.gameTime;
    game.aTeam.canAnswer=true;
    game.bTeam.canAnswer=true;
    Stream socketDataStream = socketDataStreamController.stream;
    socketDataStreamSubscription = socketDataStream.listen((data){
      print("DATA RECIEVED FROM MODERATOR");
      print(data);
      data = json.decode(data);

      if (data["type"] == "Recognized") {
        print("Server: Player has been officially recognised.");
        BuzzerStreamController.add("Recognized");
      }
      else if (data["type"] == "BuzzerAvailable") {
        print("BUZZERR AVAIALEKLEKJF");
        unavailable = false;
        BuzzerStreamController.add("Available");
      }
      else if (data["type"] == "Incorrect") {
        BuzzerStreamController.add("Incorrect");
      }
      else if (data["type"] == "Correct") {
        BuzzerStreamController.add("Correct");
      }
      else if (data["type"] == "moderatorReading") {
        BuzzerStreamController.add("moderatorReading");
      }
      else if (data["type"] == "Blurt") {
        BuzzerStreamController.add("Blurt");
      }
      else if (data["type"] == "Consultation") {
        BuzzerStreamController.add("Consultation");
      }
      else if (data["type"] == "Disqualify") {
        BuzzerStreamController.add("Disqualify");
      }
      else if (data["type"] == "Distraction") {
        BuzzerStreamController.add("Distraction");
      }
      else if (data["type"] == "Interrupt") {
        BuzzerStreamController.add("Interrupt");
      }
      else if(data["type"]=="moderatorLeaving") {
        client.disconnect();
        moderatorLeftGameDialog();
      }
    });
  }


  void _startGameTimer() {
    if (_gameTimer != null) {
      _gameTimer.cancel();
    }

    _gameTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds==1 &&_minutes==0)
        {
          _gameTimer.cancel();
        }
        if (_seconds > 0) {
          _seconds--;
          if (_seconds < 10) {
            buf = "0";
          } else {
            buf = "";
          }
        } else {
          buf = "";
          _seconds = 59;
          _minutes -= 1;
        }
        if(_seconds==0 && _minutes==0)
        {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Result()),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.dehaze),
              title: Text(
                "Settings",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
//            ListTile(
//              leading: Icon(Icons.offline_pin, color: Color(0xffF8B400)),
//              title: Text("Game PIN:\n $gamePin",
////              textAlign: TextAlign.center,
//                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),
//              ),
//            ),
            ListTile(
              leading: Icon(Icons.exit_to_app,),
              title: GestureDetector(
                  child: Text("Exit Game",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),
                  ),
                  onTap: (){
                    Navigator.popUntil(context, ModalRoute.withName('/home'));
                  }
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Color(0xffF8B400),
        title: Text("Science Bowl Portable"),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: new Icon(Icons.settings),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        'assets/game_back.png',
                      ),
                      alignment: Alignment.bottomRight,
                      fit: BoxFit.scaleDown),),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      "Team A\n"+game.aTeam.score.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 18),
                    )
                ),
                Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    margin: EdgeInsets.all(15),
                    elevation: 2.0,
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 35.0, vertical: 10.0),
                        child: Text(
                          "Time Left\n"+_minutes.toString()+":"+buf+_seconds.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold, color:Colors.purple , fontSize: 18),
                        )
                    )
                ),
                Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      "Team B\n"+game.bTeam.score.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.lightGreen, fontSize: 18),
                    )
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0.0),
              child: Text(
                roundName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0),
              child: Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width*0.7,
                    height: MediaQuery.of(context).size.height*0.3,
                    child: Card(
                      elevation: 10.0,
                      color: Colors.yellow[50],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Center(
                          child: Text(
                            "Question pictures will be displayed here.",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      )
                    ),
                  ),
                ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0),
              child: Container(
//              height: 30.0,
                height: MediaQuery.of(context).size.height*0.1,
                width: MediaQuery.of(context).size.width*0.7,
                //            color: Colors.
                child: Card(
                  child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
                      child: Text(
                      '$playerName',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold, color: (team=="A") ? Colors.red : Colors.green, fontSize: 18),
                    ),
                  ),
                  elevation: 10.0,
                  color: Colors.yellow[50],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                ),
              ),
            ),

            SizedBox(
              width:MediaQuery.of(context).size.height*0.25,
              height:MediaQuery.of(context).size.height*0.25,

              child:  StreamBuilder(
                stream: BuzzerStreamController.stream,
                builder: (context, snapshot) {
                  element=(snapshot.data==null) ? "" : snapshot.data;
                  print(snapshot.data);
                  BuzzerStreamController.add(null);
                  if (element=="Available") {
                    print("making buzzer available");
//                  buzzerClr = Colors.red;
                    unavailable = false;
                    buzzerTxt="Buzz In!";
                    bzrBorder=Colors.white;
                    buzzerClr=Color(0xFFf84b4b);
                    _startBuzzTimer();
                  }
                  else if (element=="Incorrect") {
                    print("Incorrect");
//                  buzzerClr = Colors.red;
//
//                 buzzerTxt = "Incorrect";

//                  Scaffold.of(context).showSnackBar(
//                    SnackBar(
//                      content: Icon(Icons.not_interested),
//                      backgroundColor: Colors.red,
//                      //                                  animation: ,
//                      duration: Duration(seconds: 2),
//                    ),
//                  );
                  }

                  else if (element=="Correct") {
                    print("correct");
//                  Scaffold.of(context).showSnackBar(
//                    SnackBar(
//                      content: Icon(Icons.done),
//                      backgroundColor: Colors.lightGreen,
////                                  animation: ,
//                      duration: Duration(seconds: 2),
//                    ),
//                  );
                    if(roundName=="Toss-Up")
                      {
                        if (team=="A")
                          {
                            game.aTeam.score+=4;
                          }
                        else{
                          game.bTeam.score+=4;
                        }
                      }
                    else
                      {
                        if (team=="A")
                        {
                          game.aTeam.score+=10;
                        }
                        else{
                          game.bTeam.score+=10;
                        }
                      }
//                  buzzerClr = Colors.lightGreen;
//                  buzzerTxt = "Correct!";
                  }
                  else if (element=="Recognized") {
                    print("recognized");
                    buzzerClr = Colors.lightGreen;
                    bzrBorder=Colors.white;
                    buzzerTxt = "You're Recognized!";
                  }

                  else if (element=="Interrupt") { //on grey buzzer
                    print("adding penalty");
                    bzrBorder=Colors.white;
                    buzzerClr = Colors.grey[900];
                    buzzerTxt = "You Interrupted!";
                  }
                  else if (element=="Blurt") { //snackbar
                    print("Blurt");
//                  Scaffold.of(context).showSnackBar(
//                    SnackBar(
//                      content: Icon(Icons.pan_tool),
//                      backgroundColor: Colors.grey[900],
//                      //                                  animation: ,
//                      duration: Duration(seconds: 2),
//                    ),
//                  );
                    if (team=="A")
                      {
                        game.aTeam.score+=4;
                      }
                    else{
                      game.aTeam.score+=4;
                    }
                  }
                  else if (element=="Consultation") {
                    print("Consultation");
//                  Scaffold.of(context).showSnackBar(
//                    SnackBar(
//                      content: Icon(Icons.pan_tool),
//                      backgroundColor: Colors.grey[900],
//                      //                                  animation: ,
//                      duration: Duration(seconds: 2),
//                    ),
//                  );
                    if (team=="A")
                    {
                      game.aTeam.score+=4;
                    }
                    else{
                      game.aTeam.score+=4;
                    }
                  }
                  else if (element=="Disqualify") {
                    print("Disqualify");
//                  Scaffold.of(context).showSnackBar(
//                    SnackBar(
//                      content: Icon(Icons.pan_tool),
//                      backgroundColor: Colors.grey[900],
//                      //                                  animation: ,
//                      duration: Duration(seconds: 2),
//                    ),
//                  );
                    bzrBorder=Colors.grey[900];

                  }
                  else if (element=="Distraction") {
                    print("Distraction");
//                  Scaffold.of(context).showSnackBar(
//                    SnackBar(
//                      content: Icon(Icons.pan_tool),
//                      backgroundColor: Colors.grey[900],
//                      //                                  animation: ,
//                      duration: Duration(seconds: 2),
//                    ),
//                  );
                    if (roundName=="Toss-Up")
                      {
                        if(team=="A")
                          {
                            game.aTeam.score+=4;
                          }
                        else
                          {
                            game.bTeam.score+=4;
                          }
                      }
                    else{
                      if(team=="A")
                      {
                        game.aTeam.score+=10;
                      }
                      else
                      {
                        game.bTeam.score+=10;
                      }
                    }
                  }
                  else if (element=="moderatorReading") { //red no text
                    print("adding penalty");
                    buzzerClr = Color(0xFFf84b4b);
                    buzzerTxt = "";
                    bzrBorder=Colors.white;
                  }

                return RaisedButton(
                  shape: CircleBorder(side: BorderSide(color: bzrBorder, width: 8.0)),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          buzzerTxt,
                          style: TextStyle(fontSize: 20.0, color: txtClr),
                          textAlign: TextAlign.center,
                        ),
                        (roundName=="Toss-Up")?
                        (tossUpTimer > 0 && element=="Available")
                            ? Text(tossUpTimer.toString(),
                          style: TextStyle(fontSize: 15.0, color: Colors.white),
                          textAlign: TextAlign.center,
                        )
                            : Text(
                          '',
                        ):
                        (bonusTimer > 0 && element=="Available")
                            ? Text(bonusTimer.toString(),
                          style: TextStyle(fontSize: 15.0, color: Colors.white),
                          textAlign: TextAlign.center,
                        )
                            : Text(
                          '',
                        )
                      ],
                    ),
                    disabledColor: Colors.white,
                    disabledTextColor: Colors.grey[900],
                    color: buzzerClr,
                    onPressed: (element!="Disqualify") ? (){
                      setState(() {
                        client.write(json.encode({"type":"BuzzIn", "playerID":player.playerID}));
                      }
                      );
                    } : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}