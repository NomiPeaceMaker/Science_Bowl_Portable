import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:async'; //for timer
import "dart:math";
import 'package:flutter/material.dart';
import 'package:sciencebowlportable/globals.dart';
import 'package:sciencebowlportable/models/Client.dart';
import 'package:sciencebowlportable/models/Player.dart';
import 'package:sciencebowlportable/screens/result.dart';
import 'dart:convert';

class PlayerBuzzer extends StatefulWidget {
  Client client;
  Player player;

  PlayerBuzzer(this.client, this.player);
  @override
  _PlayerBuzzerState createState() => _PlayerBuzzerState(this.client, this.player);
}

class _PlayerBuzzerState extends State<PlayerBuzzer> {
//  double timeLeft = 300; //5 mins
  Client client;
  Player player;
  bool paused=false;
//  double timeLeft = 300; //5 mins
  Color txtClr = Colors.white;
  String gamePin=game.gamePin;
  Color bzrBorder=Colors.white;
  Color buzzerClr=Color(0xFFf84b4b);
  String buzzerTxt="Buzz In!";
  String roundName="Toss-up";
  String playerName = "A Captain";
  bool isBuzzerActive=false;
  bool unavailable=true;
//  String team="A"; //true for red, false for green
//  int _counter = 5;
//  Timer _buzzTimer;
  Timer _gameTimer;
  var element="";

  int _minutes;
  int _seconds=0;
  String buf="0";
//  int bonusTimer;
//  int tossUpTimer;

  _PlayerBuzzerState(this.client, this.player){
//    _startBuzzTimer();
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


  StreamController<String> BuzzerStreamController = StreamController.broadcast();
  StreamSubscription socketDataStreamSubscription;

  @override
  void initState() {
    game.aTeam.score=0;
    game.bTeam.score=0;
    super.initState();
//    BuzzerStreamController.add("Blurt");
//    BuzzerStreamController = StreamController.broadcast();
    game.aTeam.score=0;
    game.bTeam.score=0;
//    bonusTimer=20;//game.bonusTime;
//    tossUpTimer = 5;//game.tossUpTime; //5 secs for buzzer timer
    _minutes = game.gameTime;
    game.aTeam.canAnswer=true;
    game.bTeam.canAnswer=true;
    Stream socketDataStream = socketDataStreamController.stream;
    socketDataStreamSubscription = socketDataStream.listen((data){
      print("DATA RECIEVED FROM MODERATOR");
      print(data);
//      data = json.decode(data);
      BuzzerStreamController.add(data);
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
            MaterialPageRoute(builder: (context) => Result()),
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
                      player.playerID,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold, color: (player.playerID[0]=="A") ? Colors.red : Colors.green, fontSize: 18),
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
//                  element=(snapshot.data==null) ? "" : snapshot.data;
                  if(snapshot.data!=null)
                    {
                      print("Recived this from mod");
                      print(snapshot.data);
                      var element=json.decode(snapshot.data);
                      if (element["type"]=="Available") {
                        print("making buzzer available");
//                  buzzerClr = Colors.red;
                        unavailable = false;
                        buzzerTxt="Buzz In!";
                        bzrBorder=Colors.white;
                        buzzerClr=Color(0xFFf84b4b);
//                        _startBuzzTimer();
                      }
                      else if (element["type"]=="Incorrect") {
                        print("Incorrect");
                        roundName=element["round"];
                        game.aTeam.score=element["Ascore"];
                        game.bTeam.score=element["Bscore"];
                        buzzerClr = Color(0xFFf84b4b);
                        buzzerTxt = "Moderator Reading...";
                        unavailable = false;
                        bzrBorder=Colors.white;
                      }

                      else if (element["type"]=="Correct") {
                        print("correct");
                        unavailable = false;
                        buzzerClr = Color(0xFFf84b4b);
                        buzzerTxt = "Moderator Reading...";
                        bzrBorder=Colors.white;
                      if(roundName=="Bonus")
                        {
                          if (playerName==element["player"][0] && playerName.substring(2)=="Captain") //you are captain of correct answering team
                            {
                              unavailable = false;
                              buzzerClr = Color(0xFFf84b4b);
                              buzzerTxt = "Moderator Reading...";
                              bzrBorder=Colors.white;
                              roundName=element["round"];
                            }
                          else
                            {
                              unavailable = true;
                              bzrBorder=Colors.white;
                              buzzerClr = Colors.grey;
                              buzzerTxt = "Unavailable";
                            }
                        }
                        roundName=element["round"];
                        game.aTeam.score=element["Ascore"];
                        game.bTeam.score=element["Bscore"];
                      }
                      else if (element["type"]=="Recognized") {
                        print("recognized");
                        unavailable = true;
                        if(element["player"]==player.playerID)
                          {
                            buzzerClr = Colors.lightGreen;
                            bzrBorder=Colors.white;
                            buzzerTxt = "You're Recognized!";
                          }
                        else
                          {
                            buzzerClr = Colors.grey;
                            bzrBorder=Colors.white;
                            buzzerTxt = element["player"]+" Recognized!";
                          }
                      }

                      else if (element["type"]=="Interrupt") { //on grey buzzer
                        print("Interrupt");
                        unavailable = true;
                        if(element["player"]==player.playerID)
                        {
                          bzrBorder=Colors.white;
                          buzzerClr = Colors.grey;
                          buzzerTxt = "You Interrupted!";
                        }
                        else
                        {
                          bzrBorder=Colors.white;
                          buzzerClr = Colors.grey;
                          buzzerTxt = element["player"]+" Interrupted!";
                        }
                      }
                      else if (element["type"]=="Blurt") { //snackbar
                        unavailable = true;
                        roundName=element["round"];
                        game.aTeam.score=element["Ascore"];
                        game.bTeam.score=element["Bscore"];
                        unavailable = false;
                        buzzerClr = Color(0xFFf84b4b);
                        buzzerTxt = "Moderator Reading...";
                        bzrBorder=Colors.white;
                        print("Blurt");
                      }
                      else if (element["type"]=="Consultation") {
                        roundName=element["round"];
                        game.aTeam.score=element["Ascore"];
                        game.bTeam.score=element["Bscore"];
                        unavailable = true;
                        unavailable = false;
                        buzzerClr = Color(0xFFf84b4b);
                        buzzerTxt = "Moderator Reading...";
                        bzrBorder=Colors.white;
                        print("Consultation");
                      }
                      else if (element["type"]=="Disqualify") {
                        unavailable = true;
                        roundName=element["round"];
                        game.aTeam.score=element["Ascore"];
                        game.bTeam.score=element["Bscore"];
                        print("Disqualify");
                        if(playerName==element["player"][0] &&roundName=="Toss-Up") //belogn to disqualified team
                          {
                          unavailable = true;
                          bzrBorder=Colors.white;
                          buzzerClr = Colors.grey;
                          buzzerTxt = "Disqualified";
                          }
                        else
                          {
                            unavailable = false;
                            buzzerClr = Color(0xFFf84b4b);
                            buzzerTxt = "Moderator Reading...";
                            bzrBorder=Colors.white;
                          }
//                  Scaffold.of(context).showSnackBar(
//                    SnackBar(
//                      content: Icon(Icons.pan_tool),
//                      backgroundColor: Colors.grey[900],
//                      //                                  animation: ,
//                      duration: Duration(seconds: 2),
//                    ),
//                  );
//                        bzrBorder=Colors.grey[900];
                      }
                      else if (element["type"]=="Distraction") {
                        unavailable = true;
                        roundName=element["round"];
                        game.aTeam.score=element["Ascore"];
                        game.bTeam.score=element["Bscore"];
                        print("Distraction");
                        unavailable = false;
                        buzzerClr = Color(0xFFf84b4b);
                        buzzerTxt = "Moderator Reading...";
                        bzrBorder=Colors.white;
                      }
                      else if (element["type"]=="moderatorReading") { //red no text
                        print("MOD READING");
                        unavailable = false;
                        buzzerClr = Color(0xFFf84b4b);
                        buzzerTxt = "Moderator Reading...";
                        bzrBorder=Colors.white;
                      }
                      else if (element["type"]=="Unavailable") {
                        unavailable = true;
                        bzrBorder=Colors.white;
                        buzzerClr = Colors.grey;
                        buzzerTxt = "Unavailable";
//                        print("Pass for now"); //sync
                      }
                      else if (element["type"]=="Skip") {
//                        print("Pass for now"); //sync
                        roundName=element["round"];
                        unavailable = false;
                        buzzerClr = Color(0xFFf84b4b);
                        buzzerTxt = "Moderator Reading...";
                        bzrBorder=Colors.white;
                      }
                      else if (element["type"]=="Pause") {
                        _gameTimer.cancel();
                        paused=true;
                        _minutes= element["minutes"];
                        _seconds=  element["seconds"];

                      }
                      else if (element["type"]=="Resume") {
                        paused=false;
                        _minutes= element["minutes"];
                        _seconds = element["seconds"];
                        _startGameTimer();
                      }
                      else if (element["type"]=="End Game") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Result()),
                        );
                      }
                      else if (element["type"]=="moderatorLeaving") {
                        client.disconnect();
                        moderatorLeftGameDialog();
                      }
                    }
                  BuzzerStreamController.add(null);

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
                      ],
                    ),
                    disabledColor: Colors.white,
                    disabledTextColor: Colors.grey,
                    color: buzzerClr,
                    onPressed: (){ //fix condition
                    if(!paused && !unavailable)
                      {
                        setState(() {
                          client.write(json.encode({"type":"BuzzIn", "playerID":player.playerID}));
                        }
                        );
                      }
                    },
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