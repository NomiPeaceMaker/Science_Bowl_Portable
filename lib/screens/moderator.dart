import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'dart:async'; //for timer
//import "dart:math";
import 'package:sciencebowlportable/globals.dart';
import 'package:sciencebowlportable/models/Moderator.dart';
import 'package:sciencebowlportable/screens/login.dart';
import 'package:sciencebowlportable/screens/result.dart';
import 'package:sciencebowlportable/models/Server.dart';
import 'package:sciencebowlportable/models/Questions.dart';
//import 'package:after_layout/after_layout.dart';
//import "package:path/path.dart" show dirname;
//import 'dart:io' show Platform;

class Host extends StatefulWidget {
  Server server;
  Moderator moderator;
  List<Question> questionSet;

  Host(this.server, this.moderator,this.questionSet);

  @override
  _HostState createState() {
    return _HostState(this.server, this.moderator,this.questionSet);
  }
}

class _HostState extends State<Host> {
  Server server;
  Moderator moderator;
  List<Question> questionSet;

  _HostState(this.server, this.moderator,this.questionSet);
  bool paused = false;

  String roundName = "Toss-Up";
  String playerName= "A Captain"; //change according to player in focus
  double timeToAnswer = 2.113;
  String team ="A"; //depends on who buzzed in
//  String reading_txt = "Done Reading";
  int index=0;
//timer variables
  bool unavailable = false;
  bool isBuzzerActive = false;
  Timer _buzzTimer;
  Timer _gameTimer;
  bool doneReading=false;
  bool interrupt=true;
  int bonusTimer;
  int tossUpTimer; //5 secs for buzzer timer
  int _minutes; //customize match say aaye ga
  int _seconds = 0;
  String buf = "0";
//  moderator.userName = user.userName; //user info store
//  moderator.email = user.email; //user info store
//  moderator.gameDifficulty = "HighSchool"; //will be used for querying not for display
//  moderator.gameTime = 20; //display
//  moderator.numberOfQuestion = 25; //querying
//  moderator.subjects = ["Math", "Physics"]; //querying
//  moderator.tossUpTime = 5; //display
//  moderator.bonusTime = 20; //display

//  Future<List<Question>> questionSet=moderator.questionSet;
  initState() {
    bonusTimer=moderator.bonusTime;
    tossUpTimer = moderator.tossUpTime; //5 secs for buzzer timer
    _minutes = this.moderator.gameTime; //customize match say aaye ga
    this.moderator.bTeam.score=0;
    this.moderator.aTeam.score=0;
    this.moderator.aTeam.canAnswer=true;
    this.moderator.bTeam.canAnswer=true;
//    print(questionSet);
    _startGameTimer();
    super.initState();
    Stream socketDataStream = socketDataStreamController.stream;
//    _startGameTimer();
    socketDataStreamSubscription = socketDataStream.listen((data) {
      print("d-'$data'-d");
      data = data.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
      print("d-'$data'-d");

      if (data[0] == "R") {
        print("BUZZ IN R");
        print("Recognized");
        server.sendAll(data);
      } else if (data[0] == "G") {
        print("BUZZ IN G");
        print("Recognized");
        server.sendAll(data);
      }
      if (data == "BuzzIn") {
        print("Recognizing");
        server.sendAll("Recognized");
      }
    });
  }

  void _startBuzzTimer() {
    bonusTimer=moderator.bonusTime;
    tossUpTimer = this.moderator.tossUpTime;
    if (_buzzTimer != null) {
      _buzzTimer.cancel();
    }
    _buzzTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
//        doneReading=true;
        if (roundName=="Toss-Up") {
          if (tossUpTimer > 0) {
            tossUpTimer--;
          }
          else {
            _buzzTimer.cancel();
            setState(() {
              if (index == questionSet.length - 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Result(this.moderator)),
                );
              }
              else{
                index+=1;
                roundName="Toss-Up";
                doneReading=false;
                if (isBuzzerActive) {
                  unavailable = true;
                }
              }
            });
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
              if (index == questionSet.length - 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Result(this.moderator)),
                );
              }
              else{
                doneReading=false;
                index+=1;
                roundName="Toss-Up";
                if (isBuzzerActive) {
                  unavailable = true;
                }
              }
            });
          }
        }
      });
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
//        if (_minutes < 0) {
//          _gameTimer.cancel();
//        }
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
                builder: (context) => Result(this.moderator)),
          );
        }
      });
    });
  }
//
  StreamSubscription socketDataStreamSubscription;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            Container(
              height: 55.0,
              color: Color(0xffF8B400),
              child: Center(
                child: Text(
                  "Settings",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.offline_pin, color: Color(0xffF8B400)),
              title: Text(
                "Game PIN:\n $pin",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            ListTile(
              title: GestureDetector(
                  child: Text(
                    "Exit Game",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    Navigator.popUntil(context, ModalRoute.withName('/home'));
                  }),
              leading: Icon(
                Icons.exit_to_app,
                color: Color(0xffF8B400),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(
          (!paused)? "HOST" : "Paused",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
        ),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: new Icon(Icons.settings),
            iconSize: 32,
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(
              icon: paused
                  ? new Icon(Icons.play_circle_outline)
                  : new Icon(Icons.pause_circle_outline),
              iconSize: 40.0,
              onPressed: () {
                if (paused) {
                  setState(() {
                    paused = false;
                    _startGameTimer();
                    if(doneReading)
                    {
                      _startBuzzTimer();
                    }
                  });
                }
                else {
                  setState(() {
                    paused = true;
                    _gameTimer.cancel();
                    if (doneReading)
                    {
                      _buzzTimer.cancel();
                    }
                  });
                }
              },
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                        "Team A",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            fontSize: 18)
                    ),
                    Text(
                      this.moderator.aTeam.score.toString(),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 18),),
                  ],
                ),
                Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    margin: EdgeInsets.all(15),
                    elevation: 10.0,
                    child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 35.0, vertical: 10.0),
                        child: Text(
                          "Time Left\n" +
                              _minutes.toString() +
                              ":" +
                              buf +
                              _seconds.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.purple,
                              fontSize: 18),
                        ))),
                Column(
                  children: <Widget>[
                    Text(
                        "Team B",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.lightGreen,
                            fontSize: 18)
                    ),
                    Text(
                      this.moderator.bTeam.score.toString(),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.lightGreen,
                          fontSize: 18),),
                  ],
                ),
              ],
            ),
            Card(
                color: Colors.yellow[50],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                elevation: 10.0,
                child: Column(
                  //              mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        roundName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          questionSet[index].subjectType,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(
                          (roundName=="Toss-Up" && questionSet[index].tossupIsShortAns) ? "Short Answer" : (roundName=="Toss-Up" && !questionSet[index].tossupIsShortAns)? "MCQ"
                              : (roundName=="Bonus" && questionSet[index].bonusIsShortAns) ? "Short Answer": "MCQ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        (roundName=="Toss-Up")?"Q"+(index+1).toString()+"."+questionSet[index].tossupQuestion : "Q"+(index+1).toString()+"."+questionSet[index].bonusQuestion,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child:
                      (roundName=="Toss-Up" && !questionSet[index].tossupIsShortAns) ?
                      Text(
                        questionSet[index].tossupMCQOptions[0]+"\n"+questionSet[index].tossupMCQOptions[1]+"\n"+questionSet[index].tossupMCQOptions[2]+"\n"+questionSet[index].tossupMCQOptions[3],
                        style: TextStyle(fontSize: 16),
                      )
                          : (roundName=="Bonus" && !questionSet[index].bonusIsShortAns) ?
                      Text(
                        questionSet[index].bonusMCQOptions[0]+"\n"+questionSet[index].bonusMCQOptions[1]+"\n"+questionSet[index].bonusMCQOptions[2]+"\n"+questionSet[index].bonusMCQOptions[3],
                        style: TextStyle(fontSize: 16),
                      ):
                      Container(width: 0.0, height: 0.0,),
                    ),
//                    ((roundName=="Toss-Up") && !questionSet[index].tossupIsShortAns) || ((roundName=="Bonus") && !questionSet[index].bonusIsShortAns) ?
//                    ListView(
//                      children: ((roundName=="Toss-Up") && !questionSet[index].tossupIsShortAns)? <Widget>[
//                        Text(questionSet[index].tossupMCQOptions[0]),
//                        Text(questionSet[index].tossupMCQOptions[1]),
//                        Text(questionSet[index].tossupMCQOptions[2]),
//                        Text(questionSet[index].tossupMCQOptions[3])
//                      ] : <Widget>[
//
//                        Text(questionSet[index].bonusMCQOptions[0]),
//                        Text(questionSet[index].bonusMCQOptions[1]),
//                        Text(questionSet[index].bonusMCQOptions[2]),
//                        Text(questionSet[index].bonusMCQOptions[3])
//                      ]
//                    ) : Container(width: 0, height: 0),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        (roundName=="Toss-Up")?"Ans. " + questionSet[index].tossupAnswer : "Ans. " + questionSet[index].bonusAnswer,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "Skip Question",
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                            ),
                          ),
                          IconButton(
                            icon: new Icon(Icons.navigate_next),
                            alignment: Alignment.bottomRight,
                            iconSize: 32,
                            color: Colors.green,
                            onPressed: () {
                              setState(() {
                                if (!paused) {
                                  if (index == questionSet.length - 1) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Result(this.moderator)),
                                    );
                                  }
                                  else {
                                    index += 1;
                                    roundName = "Toss-Up";
                                    interrupt=false;
                                    doneReading=false;
                                  }
                                }
                              });
                            }, //next qs
                          ),
                        ],
                      ),
                    )
                  ],
                )),
            //          Card(
            //            margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
            //            color: BuzzerOpen ? Colors.grey : Colors.lightGreen,
            //            shape: RoundedRectangleBorder(
            //              borderRadius: BorderRadius.circular(10.0),
            //            ),
            //            child: BuzzerOpen ?
            //              Row(
            //                mainAxisAlignment: MainAxisAlignment.spaceAround,
            //                children: <Widget>[
            //                  new Icon(Icons.fiber_manual_record, color: Colors.white, size: 50),
            //                  Text("Buzzer Open", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
            //                  Text(timeToAnswer.toStringAsFixed(2), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
            //                ]):
            //              new Icon(Icons.check, color: Colors.white, size: 50)
            //          ),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
              color: doneReading ? Colors.grey : Colors.lightGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  (interrupt)? playerName + " interrupted!":
                  (doneReading && roundName=="Toss-Up")
                      ? "Buzzer Open: " + tossUpTimer.toString():
                  (doneReading && roundName=="Bonus")? "Buzzer Open: " + bonusTimer.toString():
                  "Done Reading",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                padding: EdgeInsets.all(20.0),
                color: interrupt ? Colors.brown :doneReading ? Colors.grey : Colors.lightGreen,
                textColor: Colors.white,
                onPressed: () {
                  setState(() {
                    if (!doneReading && !paused)
                    {
                      server.sendAll("BuzzerAvailable");
                      doneReading=true;
                      _startBuzzTimer();
                    }
                  });
                },
              ),
//              Row(
//                mainAxisSize: MainAxisSize.min,
//                  mainAxisAlignment: MainAxisAlignment.spaceAround,
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: <Widget>[
//                    new IconButton(
//                      icon: new Icon(Icons.fiber_manual_record, color: Colors.white, size: 50,),
//                      alignment: Alignment.bottomRight,
//                      onPressed: () {
//                        setState(() {
//                              if (!BuzzerOpen)
//                                {
//                                  BuzzerOpen=true;
//                                  _startBuzzTimer();
//                                }
//                            }
//                            );
//                          }
//                    ),
//                    Text(BuzzerOpen ? "Buzzer Open: "+_counter.toString() : "Done Reading", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
////                    new Icon(Icons.cancel, color: Colors.white, size: 25)
//                  ],
//              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      "Correct",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    padding: EdgeInsets.all(20.0),
                    color: Colors.lightBlue,
                    textColor: Colors.white,
                    onPressed: () {
                      setState(() {
                        if(!paused){
                          server.sendAll("Correct");
                          if (roundName=="Toss-Up")
                          {
                            roundName="Bonus";
                            interrupt=false;
                            doneReading=false;
                            if(team=="A")
                            {
                              this.moderator.aTeam.score+=4;
                            }
                            else
                            {
                              this.moderator.bTeam.score+=4;
                            }
                          }
                          else
                          {
                            if (index == questionSet.length - 1) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Result(this.moderator)),
                              );
                              }
                            else{
                              index+=1;
                              roundName="Toss-Up";
                              interrupt=false;
                              doneReading=false;
                              if(team=="A")
                              {
                                this.moderator.aTeam.score+=10;
                              }
                              else
                              {
                                this.moderator.bTeam.score+=10;
                              }
                            }
                          }
                        }
                      }
                      );
                    },
                  ),
                  FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text("Incorrect",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    padding: EdgeInsets.all(20.0),
                    color: Colors.amber,
                    textColor: Colors.white,
                    onPressed: () => {
                      setState(() {
                        if(!paused) {
                          server.sendAll("Incorrect"); //should tell which team answered correctly? so incorrect team cant answer again
                          if(team=="A")
                            {
                              if(interrupt)
                                {
                                  this.moderator.bTeam.score+=4;
                                }
                              this.moderator.aTeam.canAnswer=false;
//                              team="B";
                            }
                          else
                            {
                              if(interrupt)
                              {
                                this.moderator.aTeam.score+=4;
                              }
                              this.moderator.bTeam.canAnswer=false;
                            }
                          if(this.moderator.bTeam.canAnswer || this.moderator.aTeam.canAnswer)
                            {
                              if (this.moderator.bTeam.canAnswer ) //notify mod?
                                {
                                  print("Team A cannot answer now");
                                }
                              else
                                {
                                  print("Team B cannot answer now");
                                }
                              print("here");
                              interrupt=false;
                              doneReading=false;
//                              Scaffold.of(context).showSnackBar(
//                                SnackBar(
////                                  content: Text(
////                                      (this.moderator.aTeam.canAnswer)? ,
////                                  ),
//                                  content: Icon(Icons.pan_tool),
//                                  backgroundColor: Colors.yellowAccent,
////                                  animation: ,
//                                  duration: Duration(seconds: 2),
//                                ),
//                              );
                            }
                          else { //next question
                            if (index == questionSet.length - 1) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Result(this.moderator)),
                              );
                            }
                            else {
                              index += 1;
                              roundName = "Toss-Up";
                              interrupt=false;
                              doneReading = false;
                              this.moderator.aTeam.canAnswer=true;
                              this.moderator.bTeam.canAnswer=true;
                            }
                          }
                        }
                      }
                      ),
                    },
                  ),
                  FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      "Penalty",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    padding: EdgeInsets.all(20.0),
                    color: Colors.red,
                    textColor: Colors.white,
                    onPressed: () =>
                    {
                      if(!paused){
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
//                                backgroundColor: Colors.whi,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(20.0)),
                                //this right here
                                child: Container(
//                                  color: Colors.greenAccent,
                                  height: (roundName=="Toss-Up")? 450 : 380,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        Align(
                                          child: Icon(
                                            Icons.outlined_flag,
                                            size: 60.0,
                                            color: Colors.black,
                                          ),
                                          alignment: Alignment.center,
                                        ),
                                        Align(
                                          child: Text(
                                            "Select a Penalty:",
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26, color: Colors.black),
                                          ),
                                          alignment: Alignment.center,
                                        ),
                                        SizedBox(
                                          width: 320.0,
                                          height: 60.0,
                                          child: RaisedButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                if (!paused) {
                                                  server.sendAll("Interrupt");
                                                  //need to do more work here
                                                  if (team == "A") {
                                                    this.moderator.bTeam.score += 4;
                                                  }
                                                  else {
                                                    this.moderator.aTeam.score += 4;
                                                  }
                                                }
                                              });
                                              Navigator.of(context, rootNavigator: true).pop('dialog');
                                            },
                                            child: Text(
                                              "Interrupt!",
                                              style: TextStyle(fontSize: 20,
                                                  color: Colors.white),
                                            ),
//                                            color: const Color(0xFF1BC0C5),
                                            color: Colors.red,
                                          ),
                                        ),
                                        Spacer(),
                                        SizedBox(
                                          width: 320.0,
                                          height: 60.0,
                                          child: RaisedButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                if (!paused) {
                                                  server.sendAll("Blurt");
                                                  //need to do more work here
                                                  if (team == "A") {
                                                    this.moderator.bTeam.score += 4;
                                                  }
                                                  else {
                                                    this.moderator.aTeam.score += 4;
                                                  }
                                                }
                                              });
                                              Navigator.of(context, rootNavigator: true).pop('dialog');
                                            },
                                            child: Text(
                                              "Blurt!",
                                              style: TextStyle(fontSize: 20,
                                                  color: Colors.white),
                                            ),
                                            color: Colors.red,
//                                            color: const Color(0xFF1BC0C5),
                                          ),
                                        ),
                                        Spacer(),
                                        (roundName=="Toss-Up")?
                                        SizedBox(
                                          width: 320.0,
                                          height: 60.0,
                                          child: RaisedButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                if (!paused) {
                                                  server.sendAll("Consultation");
                                                  //need to do more work here
                                                  if (team == "A") {
                                                    this.moderator.bTeam.score += 4;
                                                  }
                                                  else {
                                                    this.moderator.aTeam.score += 4;
                                                  }
                                                }
                                              });
                                              Navigator.of(context, rootNavigator: true).pop('dialog');
                                            },
                                            child: Text(
                                              "Consultation!",
                                              style: TextStyle(fontSize: 20,
                                                  color: Colors.white),
                                            ),
                                            color: Colors.red,
//                                            color: const Color(0xFF1BC0C5),
                                          ),
                                        ) : Container(height:0, width:0),
                                        Spacer(),
                                        SizedBox(
                                          width: 320.0,
                                          height: 60.0,
                                          child: RaisedButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                if (!paused) {
                                                  //need to do more work here
                                                  if (team == "A") {
                                                    server.sendAll("Disqualify A"); //answering before buzzing in or communication before buzzing in
//                                                    this.moderator.bTeam.score += 4;
                                                  }
                                                  else {
                                                    server.sendAll("Disqualify B");
//                                                    this.moderator.aTeam.score += 4;
                                                  }
                                                }
                                              });
                                              Navigator.of(context, rootNavigator: true).pop('dialog');
                                            },
                                            child: Text(
                                              "Disqualify!",
                                              style: TextStyle(fontSize: 20,
                                                  color: Colors.white),
                                            ),
                                            color: Colors.red,
//                                            color: const Color(0xFF1BC0C5),
                                          ),
                                        ),
                                        Spacer(),
                                        SizedBox(
                                          width: 320.0,
                                          height: 60.0,
                                          child: RaisedButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                if(!paused){
                                                  server.sendAll("Correct");
                                                  if (roundName=="Toss-Up")
                                                  {
                                                    roundName="Bonus";
                                                    doneReading=false;
                                                    if(team=="A")
                                                    {
                                                      this.moderator.aTeam.score+=4;
                                                    }
                                                    else
                                                    {
                                                      this.moderator.bTeam.score+=4;
                                                    }
                                                  }
                                                  else
                                                  {
                                                    if (index == questionSet.length - 1) {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => Result(this.moderator)),
                                                      );
                                                    }
                                                    else{
                                                      index+=1;
                                                      roundName="Toss-Up";
                                                      doneReading=false;
                                                      if(team=="A")
                                                      {
                                                        this.moderator.aTeam.score+=10;
                                                      }
                                                      else
                                                      {
                                                        this.moderator.bTeam.score+=10;
                                                      }
                                                    }
                                                  }
                                                }
//                                                if (!paused) {
//                                                  server.sendAll("Distraction");
//                                                  //need to do more work here
//                                                  if (team == "A") {
//                                                    this.moderator.bTeam.score += 4;
//                                                  }
//                                                  else {
//                                                    this.moderator.aTeam.score += 4;
//                                                  }
//                                                }
                                              });
                                              Navigator.of(context, rootNavigator: true).pop('dialog');
                                            },
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  "Distraction!",
                                                  style: TextStyle(fontSize: 20,
                                                      color: Colors.white),
                                                ),
                                                Text(
                                                  "(by non playing team)",
                                                  style: TextStyle(fontSize: 10,
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                            color: Colors.red,
//                                            color: const Color(0xFF1BC0C5),
                                          ),
                                        ),
//                                        Spacer(),
//                                        SizedBox(
//                                          width: 320.0,
//                                          child: RaisedButton(
//                                            shape: RoundedRectangleBorder(
//                                              borderRadius: BorderRadius.circular(10.0),
//                                            ),
//                                            onPressed: () {
//                                              Navigator.of(context, rootNavigator: true).pop('dialog');
//                                            },
//                                            child: Text(
//                                              "Cancel",
//                                              style: TextStyle(
//                                                  color: Colors.white),
//                                            ),
//                                          color: Colors.red,
//                                          ),
//                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      },
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
