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
import 'package:after_layout/after_layout.dart';
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

class _HostState extends State<Host> with AfterLayoutMixin<Host> {
  Server server;
  Moderator moderator;
  List<Question> questionSet;

  _HostState(this.server, this.moderator,this.questionSet);

  bool paused = true;
  int redScore = 0;
  int greenScore = 0;

  String roundName = "Toss-Up";
  String Qsubject = "Biology";
  String Qtype = "Short Answer";
  String Q =
      "What is the most common term used in genetics to decribe the observable physical charactersitics of an organism casued by the expression of a gene or a set of genes?";
  String A = "PHENOTYPE";
  bool BuzzerOpen = false;
  double timeToAnswer = 2.113;

  String reading_txt = "Done Reading";

//timer variables
  bool unavailable = false;
  bool isBuzzerActive = false;
  int _counter = 5; //5 secs for buzzer timer
  int _minutes = 5; //customize match say aaye ga
  int _seconds = 0;
  String buf = "0";
  Timer _buzzTimer;
  Timer _gameTimer;

//  Future<List<Question>> questionSet=moderator.questionSet;

  void _startBuzzTimer() {
    _counter = 5;
    if (_buzzTimer != null) {
      _buzzTimer.cancel();
    }
    _buzzTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_counter > 0) {
          _counter--;
        } else {
          _buzzTimer.cancel();
          setState(() {
            if (isBuzzerActive) {
              unavailable = true;
//              txtClr=Color(0xffAEAEAE);
//              buzzerTxt="Unavailable";
//              buzzerClr=Colors.white;
//              bzrBorder=Color(0xffAEAEAE);
            }
          });
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
        if (_minutes < 0) {
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
      });
    });
  }
//
  StreamSubscription socketDataStreamSubscription;
  initState() {
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
        print("Recongizing");
        server.sendAll("Recognized");
      }
    });
  }

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
          "HOST",
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
                  });
                } else {
                  setState(() {
                    paused = true;
                  });
                }
                ;
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
                Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      "Red\n" + redScore.toString(),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 18),
                    )),
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
                Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      "Green\n" + greenScore.toString(),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.lightGreen,
                          fontSize: 18),
                    ))
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
                    questionSet[1].subjectType,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(
                          Qtype,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(30),
                      child: Text(
                        "Q: " + Q,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        "A: " + A,
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
                              "Skip Question:",
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                            ),
                          ),
                          IconButton(
                            icon: new Icon(Icons.navigate_next),
                            alignment: Alignment.bottomRight,
                            iconSize: 32,
                            color: Colors.green,
                            onPressed: () {}, //next qs
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
              color: BuzzerOpen ? Colors.grey : Colors.lightGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  BuzzerOpen
                      ? "Buzzer Open: " + _counter.toString()
                      : "Done Reading",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                padding: EdgeInsets.all(20.0),
                color: BuzzerOpen ? Colors.grey : Colors.lightGreen,
                textColor: Colors.white,
                onPressed: () {
                  setState(() {
                    if (!BuzzerOpen)
                    {
                      server.sendAll("BuzzerAvailable");
                      BuzzerOpen=true;
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
                        server.sendAll("Correct");
                        redScore+=4;
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
                          server.sendAll("Incorrect");
                        }
                      ),
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Result()),
                      )
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
                    onPressed: () => {
                      setState(() {
                        server.sendAll("Penalty");
                      }),
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

  @override
  void afterFirstLayout(BuildContext context) {
    _startGameTimer();
//    moderator.questionSet.then((list){
//      questionSet=list;
//      print("Retrieved questions");
//    });
  }
//  Future getlist()async{
//    print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
//    var allquestions=await moderator.questionSet;
//    print(allquestions);
//  }

}
