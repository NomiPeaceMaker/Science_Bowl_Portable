import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'dart:convert';
import 'dart:async';
import 'package:sciencebowlportable/globals.dart';
import 'package:sciencebowlportable/models/Moderator.dart';
import 'package:sciencebowlportable/screens/result.dart';
import 'package:sciencebowlportable/screens/home.dart';
import 'package:sciencebowlportable/models/Server.dart';
import 'package:sciencebowlportable/models/Team.dart';
import 'package:sciencebowlportable/models/Questions.dart';

class ModeratorQuestions extends StatefulWidget {
  Server server;
  Moderator moderator;
  List<Question> questionSet;

  ModeratorQuestions(this.server, this.moderator,this.questionSet);

  @override
  _ModeratorQuestionsState createState() {
    return _ModeratorQuestionsState(this.server, this.moderator,this.questionSet);
  }
}

class _ModeratorQuestionsState extends State<ModeratorQuestions> {
  Server server;
  Moderator moderator;
  List<Question> questionSet;

  _ModeratorQuestionsState(this.server, this.moderator,this.questionSet);
  bool paused = false;
  String roundName = "Toss-Up";
  String playerName= "A Captain"; //change according to player in focus
  double timeToAnswer = 2.113;
//  String team ="A"; //depends on who buzzed in
  int index=0;
//timer variables
  bool unavailable = false;
  bool isBuzzerActive = false;
  Timer _buzzTimer;
  Timer _gameTimer;
  bool doneReading=false;
  bool interrupt=false;
  String _gameTimeLeft;
  int bonusTimer;
  int tossUpTimer;
  int _minutes;
  int _seconds = 0;
  String buf = "0";
  bool decisionTime=false;
  bool buzzedIn=false;
  int skipsLeft=5;
  String element="";
  StreamController<String> ModeratorStreamController = StreamController.broadcast();
  initState() {
    bonusTimer = game.bonusTime;
    tossUpTimer = game.tossUpTime; //5 secs for buzzer timer
    _minutes = game.gameTime; //customize match say aaye ga
    game.bTeam.score=0;
    game.aTeam.score=0;
    game.aTeam.canAnswer=true;
    game.bTeam.canAnswer=true;
    _startGameTimer();
    super.initState();
    Stream socketDataStream = socketDataStreamController.stream; //.add
    server.sendAll(json.encode({"type": "moderatorReading", "round": "Toss-Up", "player": playerName, "Ascore": game.aTeam.score, "Bscore":  game.bTeam.score}));
    socketDataStreamSubscription = socketDataStream.listen((data) {
      print("DATA RECIEVED FROM PLAYER");
      print(data);
      data = json.decode(data);

      if (data["type"] == "pin") {
         server.sockets[data["uniqueID"]].write(
            json.encode({"type": "pinState", "pinState": "gameInProgress"})
         );
       }
      else if(data["type"] == "BuzzIn")
      {
        print("sending to controller");
        ModeratorStreamController.add(json.encode(data));
      }
      else
        {
          print("Nothing");
        }
    });
  }

  void _startBuzzTimer() {
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
            server.sendAll(json.encode({"type": "Unavailable", "round":"Toss-Up", "player": playerName, "Ascore": game.aTeam.score, "Bscore":  game.bTeam.score})); //to all
            decisionTime=true;
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
              if ((index+1-(5-skipsLeft))== questionSet.length - 5) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Result()),
                );
              }
              else{
                server.sendAll(json.encode({"type": "Unavailable", "round":"Bonus", "player": playerName, "Ascore": game.aTeam.score, "Bscore":  game.bTeam.score}));
                _buzzTimer.cancel();
                bonusTimer=game.bonusTime;
                decisionTime=true;
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
//
  StreamSubscription socketDataStreamSubscription;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            ListTile(
              leading: Icon(Icons.fiber_pin),
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
                    socketDataStreamSubscription.cancel();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) => MyHomePage(),),
                        ModalRoute.withName('/')
                    );
                  }),
              leading: Icon(
                Icons.exit_to_app,
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(
          (!paused)? "Science Bowl Portable" : "Paused",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/game_back.png',),
              alignment: Alignment.bottomRight,
              fit: BoxFit.scaleDown),
        ),
        child: SingleChildScrollView(
          child: StreamBuilder(
                    stream: ModeratorStreamController.stream,
                    builder: (context, snapshot) {
//                    element=(snapshot.data==null) ? "" : snapshot.data;
                    if(snapshot.data!=null)
                    {
                      print("In controller");
                    var element=json.decode(snapshot.data);
                    if(element["type"]=="BuzzIn")
                      {
//                        print("In controller");
                        playerName=element["playerID"];
//                        print("done reading");
//                        print(doneReading);
                      _buzzTimer.cancel();
                        if(!doneReading)
                          {
                            server.sendAll(json.encode({"type": "Interrupt", "player": playerName, "Ascore": game.aTeam.score, "Bscore":  game.bTeam.score}));
                            print("Interrupt");
                            buzzedIn=false;
                            interrupt=true;
                          }
                        else
                          {
                            server.sendAll(json.encode({"type": "Recognized","player": playerName, "Ascore": game.aTeam.score, "Bscore":  game.bTeam.score}));
                            print("Valid Buzz");
                            buzzedIn=true;
                            interrupt=false;
                          }
                        decisionTime=false;
                        doneReading = false;
                      }
                    }
                    ModeratorStreamController.add(null);
                    return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  teamScore(game.aTeam),
                  Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
                      margin: EdgeInsets.all(15),
                      elevation: 10.0,
                      child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 35.0, vertical: 10.0),
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
                  teamScore(game.bTeam),
                ],
              ),
              Card(
                  color: Colors.yellow[50],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
                  margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                  elevation: 10.0,

//                  child: StreamBuilder(
//                    stream: ModeratorStreamController.stream,
//                    builder: (context, snapshot) {
//                    element=(snapshot.data==null) ? "" : snapshot.data;
//                    if(snapshot.data!=null)
//                    {
//                    var element=json.decode(snapshot.data);
//                    }
//                    ModeratorStreamController.add(null);
//                    return
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
                            questionSet[index].questionType(roundName),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          (roundName=="Toss-Up")?"Q"+(index+1-(5-skipsLeft)).toString()+"."+questionSet[index].tossupQuestion : "Q"+(index+1-(5-skipsLeft)).toString()+"."+questionSet[index].bonusQuestion,
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
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          (roundName=="Toss-Up")?"Ans. " + questionSet[index].tossupAnswer : "Ans. " + questionSet[index].bonusAnswer,
                          textAlign: TextAlign.center,
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
                              child: (roundName=="Toss-Up")?Text(
                                "Skip Question   "+skipsLeft.toString()+"/5",

                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                              ): Container(width: 0.0, height: 0.0,),
                            ),
                            (roundName=="Toss-Up")?
                            IconButton(
                              icon: new Icon(Icons.navigate_next),
                              alignment: Alignment.bottomRight,
                              iconSize: 32,
                              color: Colors.grey,
                              onPressed: () {
                                setState(() {
                                  if (!paused && skipsLeft>0 && roundName=="Toss-Up") {
                                    if ((index+1-(5-skipsLeft)) == questionSet.length - 5) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Result()),
                       );
                                    }
                                    else {
                                      server.sendAll(json.encode({"type": "Skip", "round": "Toss-Up"}));
                                      index += 1;
                                      skipsLeft-=1;
                                      buzzedIn=false;
                                      roundName = "Toss-Up";
                                      decisionTime=false;
                                      interrupt=false;
                                      doneReading=false;
                                    }
                                  }
                                });
                              }, //next qs
                            ): Container(width: 0.0, height: 0.0,),
                          ],
                        ),
                      )
                    ],
                  )),
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                  color: doneReading ? Colors.grey : Colors.lightGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: RaisedButton(
                    elevation: (decisionTime || (!doneReading && !paused && !buzzedIn && !interrupt))?10.0 :0,
                    shape: RoundedRectangleBorder(
//                    side: BorderSide(color: Colors.white, width: 3.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      (buzzedIn)? playerName + " buzzed in":
                      (decisionTime)? "       TIME!\n Next Question":
                      (interrupt)? playerName + " interrupted!":
                      (doneReading && roundName=="Toss-Up")
                          ? "Buzzer Open: " + tossUpTimer.toString():
                      (doneReading && roundName=="Bonus")? "Buzzer Open: " + bonusTimer.toString():
                      "Done Reading",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    padding: EdgeInsets.all(20.0),
                    color: (decisionTime) ? Color(0xFF20BABA) : Colors.lightGreen,
                    textColor: Colors.white,
                    disabledTextColor: Colors.white,
                    disabledColor: Colors.grey,
                    onPressed: (!doneReading && !paused && !buzzedIn && !interrupt)?() {
                      setState(() {
                        //pressed done reading
                        print("Not dec time");
                        server.sendAll(json.encode({"type": "Available"}));
                        doneReading=true;
                        _startBuzzTimer();
                      });
                    }:(decisionTime) ? (){
                      print("DECISION TIME");
                      if(!paused){
//                            server.sendAll(json.encode({"type": ""}));;
                        game.aTeam.canAnswer=true;
                        game.bTeam.canAnswer=true;
                        if (roundName=="Toss-Up")
                        {
                          server.sendAll(json.encode({"type": "moderatorReading", "round": "Bonus", "player": playerName, "Ascore": game.aTeam.score, "Bscore":  game.bTeam.score}));
                          buzzedIn=false;
                          roundName="Bonus";
                          decisionTime=false;
                          interrupt=false;
                          doneReading=false;

                        }
                        else
                        {
                          if ((index+1-(5-skipsLeft))== questionSet.length - 5) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Result()),
                            );
                          }
                          else{
                            server.sendAll(json.encode({"type": "moderatorReading", "round": "Toss-Up", "player": playerName, "Ascore": game.aTeam.score, "Bscore":  game.bTeam.score}));
                            index+=1;
                            buzzedIn=false;
                            roundName="Toss-Up";
                            decisionTime=false;
                            interrupt=false;
                            doneReading=false;
                          }
                        }
                      }
                    }: null,
                  ),
                ),
//              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      elevation: (decisionTime || interrupt || buzzedIn)?10.0: 0,
                      shape: RoundedRectangleBorder(
//                        side: BorderSide(color: Colors.white, width: 3.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        "Correct",
                        style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      padding: EdgeInsets.all(20.0),
                      disabledColor: Colors.grey,
                      disabledTextColor: Colors.white,
                      color: (decisionTime || interrupt || buzzedIn) ? Colors.lightGreen : Colors.grey,
                      textColor: Colors.white,
                      onPressed: (decisionTime || interrupt || buzzedIn) ? () {
                        setState(() {
                          if(!paused){
//                            server.sendAll(json.encode({"type": "Correct", r}));;
                            game.aTeam.canAnswer=true;
                            game.bTeam.canAnswer=true;
                            if (roundName=="Toss-Up")
                            {
                              buzzedIn=false;
                              roundName="Bonus";
                              decisionTime=false;
                              interrupt=false;
                              doneReading=false;
                              if(playerName[0]=="A")
                              {
                                game.aTeam.score+=4;
                              }
                              else
                              {
                                game.bTeam.score+=4;
                              }
                              server.sendAll(json.encode({"type": "Correct",  "round": "Bonus", "player": playerName, "Ascore": game.aTeam.score, "Bscore":  game.bTeam.score}));
                            }
                            else
                            {
                              if ((index+1-(5-skipsLeft))== questionSet.length - 5) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Result()),
                                );
                                }
                              else{
                                index+=1;
                                buzzedIn=false;
                                roundName="Toss-Up";
                                decisionTime=false;
                                interrupt=false;
                                doneReading=false;
                                if(playerName[0]=="A")
                                {
                                  game.aTeam.score+=10;
                                }
                                else
                                {
                                  game.bTeam.score+=10;
                                }
                                server.sendAll(json.encode({"type": "Correct",  "round": "Toss-Up", "player": playerName, "Ascore": game.aTeam.score, "Bscore":  game.bTeam.score}));
                              }
                            }
                          }
                        }
                        );
                      } : null,
                    ),
                    RaisedButton(
                      elevation: (decisionTime || interrupt || buzzedIn)?10.0: 0,
                      shape: RoundedRectangleBorder(
//                        side: BorderSide(color: Colors.white, width: 3.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text("Incorrect",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                      padding: EdgeInsets.all(20.0),
                      disabledColor: Colors.grey,
                      disabledTextColor: Colors.white,
                      color: (decisionTime || interrupt || buzzedIn) ? Colors.amber: Colors.grey,
                      textColor: Colors.white,
                      onPressed: (decisionTime || interrupt || buzzedIn) ? () {
                        setState(() {
                          if(!paused) {
//                            server.sendAll(json.encode({"type": "Incorrect"})); //should tell which team answered correctly? so incorrect team cant answer again
                            if (game.aTeam.canAnswer && game.bTeam.canAnswer && roundName=="Toss-Up") {
                              if (playerName[0] == "A") {
                                if (interrupt) {
                                  game.bTeam.score += 4;
                                }
                                game.aTeam.canAnswer = false;
                                //                              team="B";
                              }
                              else {
                                if (interrupt) {
                                  game.aTeam.score += 4;
                                }
                                game.bTeam.canAnswer = false;
                              }
                              server.sendAll(json.encode({"type": "Incorrect", "round": "Toss-Up", "player": playerName, "Ascore": game.aTeam.score, "Bscore":  game.bTeam.score}));
                              buzzedIn=false;
                              decisionTime=false;
                              interrupt=false;
                              doneReading = false;
                            }
                            else if(((game.bTeam.canAnswer && !game.aTeam.canAnswer) ||(!game.bTeam.canAnswer && game.aTeam.canAnswer))&&roundName=="Toss-Up")
                              {
                                if (game.bTeam.canAnswer ) //notify mod?
                                  {
                                    if (interrupt) { //add team ="A"
                                      game.bTeam.score += 4;
                                    }
                                    print("Team A cannot answer now");
                                  }
                                else
                                  {
                                    if (interrupt) {
                                      game.aTeam.score += 4;
                                    }
                                    print("Team B cannot answer now");
                                  }
                                print("here");
                                if ((index+1-(5-skipsLeft)) == questionSet.length - 5) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Result()),
                                  );
                                }
                                else {
                                  server.sendAll(json.encode({"type": "Incorrect", "round": "Toss-Up", "player": playerName, "Ascore": game.aTeam.score, "Bscore":  game.bTeam.score}));
                                  index += 1;
                                  buzzedIn=false;
                                  roundName = "Toss-Up";
                                  decisionTime=false;
                                  interrupt=false;
                                  doneReading = false;
                                  game.aTeam.canAnswer=true;
                                  game.bTeam.canAnswer=true;
                                }
                              }
                            if(roundName=="Bonus")
                            {
                              if ((index+1-(5-skipsLeft)) == questionSet.length - 5) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Result()),
                                );
                              }
                              else {
                                server.sendAll(json.encode({"type": "Incorrect", "round": "Toss-Up", "player": playerName, "Ascore": game.aTeam.score, "Bscore":  game.bTeam.score}));
//                                server.sendAll(json.encode({"type": "moderatorReading", "round": "Toss-Up"}));
                                index += 1;
                                buzzedIn=false;
                                roundName = "Toss-Up";
                                decisionTime=false;
                                interrupt=false;
                                doneReading = false;
                                game.aTeam.canAnswer=true;
                                game.bTeam.canAnswer=true;
                              }
                            }
                        }
                        }
                        );
                      }: null,
                    ),
                    RaisedButton(
                      elevation: (decisionTime || interrupt || buzzedIn)?10.0: 0,
                      shape: RoundedRectangleBorder(
//                        side: BorderSide(color: Colors.white, width: 3.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        "Penalty",
                        style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      padding: EdgeInsets.all(20.0),
                      disabledColor: Colors.grey,
                      disabledTextColor: Colors.white,
                      color: (decisionTime || interrupt || buzzedIn) ? Colors.red: Colors.grey,
                      textColor: Colors.white,
                      onPressed: (decisionTime || interrupt || buzzedIn) ? () {
                        if(!paused){
//                        _buzzTimer.cancel();
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
                                    height: (roundName=="Toss-Up")? 400 : 310,
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
//                                                    server.sendAll(json.encode({"type": "Blurt"}));;
                                                    //need to do more work here
                                                    if (playerName[0] == "A") {
                                                      game.bTeam.score += 4;
                                                    }
                                                    else {
                                                      game.aTeam.score += 4;
                                                    }
                                                  }
                                                  server.sendAll(json.encode({"type": "Blurt", "round": "Toss-Up", "player": playerName, "Ascore": game.aTeam.score, "Bscore":  game.bTeam.score}));
                                                });
                                                Navigator.of(context, rootNavigator: true).pop('dialog');
                                                if ((index+1-(5-skipsLeft)) == questionSet.length - 5) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => Result()),
                                                  );
                                                }
                                                else {
                                                  server.sendAll(json.encode({"type": "Blurt", "round": "Toss-Up", "player": playerName, "Ascore": game.aTeam.score, "Bscore":  game.bTeam.score}));
                                                  index += 1;
                                                  buzzedIn=false;
                                                  roundName = "Toss-Up";
                                                  decisionTime=false;
                                                  interrupt=false;
                                                  doneReading = false;
                                                  game.aTeam.canAnswer=true;
                                                  game.bTeam.canAnswer=true;
                                                }
                                              },
                                              child: Text(
                                                "Blurt",
                                                style: TextStyle(fontSize: 20,
                                                    color: Colors.white),
                                              ),
                                              color: Colors.red,
                                            ),
                                          ),
                                          (roundName=="Toss-Up") ? Spacer() : Container(height:0, width:0),
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
                                                    if (playerName[0] == "A") {
                                                      game.bTeam.score += 4;
                                                    }
                                                    else {
                                                      game.aTeam.score += 4;
                                                    }
                                                    server.sendAll(json.encode({"type": "Consultation", "round": "Toss-Up", "player": playerName, "Ascore": game.aTeam.score, "Bscore":  game.bTeam.score}));
                                                  }
                                                });
                                                Navigator.of(context, rootNavigator: true).pop('dialog');
                                                if ((index+1-(5-skipsLeft))== questionSet.length - 5) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => Result()),
                                                  );
                                                }
                                                else {
                                                  server.sendAll(json.encode({"type": "Consultation", "round": "Toss-Up", "player": playerName, "Ascore": game.aTeam.score, "Bscore":  game.bTeam.score}));
                                                  index += 1;
                                                  buzzedIn=false;
                                                  roundName = "Toss-Up";
                                                  decisionTime=false;
                                                  interrupt=false;
                                                  doneReading = false;
                                                  game.aTeam.canAnswer=true;
                                                  game.bTeam.canAnswer=true;
                                                }
                                              },
                                              child: Text(
                                                "Consultation",
                                                style: TextStyle(fontSize: 20,
                                                    color: Colors.white),
                                              ),
                                              color: Colors.red,
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
                                                    if (game.aTeam.canAnswer && game.bTeam.canAnswer && roundName=="Toss-Up") {
                                                      if (playerName[0] == "A") {
//                                                        server.sendAll(json.encode({"type": "Disqualify", "team": "A"}));
                                                        game.aTeam.canAnswer = false;
                                                        //                              team="B";
                                                      }
                                                      else {
//                                                        server.sendAll(json.encode({"type": "Disqualify", "team": "B"}));
                                                        game.bTeam.canAnswer = false;
                                                      }
//                                                      server.sendAll(json.encode({"type": "Disqualify", "team":"B", "round": "Toss-Up"}));
                                                      buzzedIn=false;
                                                      decisionTime=false;
                                                      interrupt=false;
                                                      doneReading = false;
                                                    }
                                                    else if(((game.bTeam.canAnswer && !game.aTeam.canAnswer) ||(!game.bTeam.canAnswer && game.aTeam.canAnswer))&&roundName=="Toss-Up")
                                                    {
                                                      if (game.bTeam.canAnswer ) //notify mod?
                                                          {
                                                        if (interrupt) { //add team ="A"
                                                          game.bTeam.score += 4;
                                                        }
                                                        print("Team A cannot answer now");
                                                      }
                                                      else
                                                      {
                                                        if (interrupt) {
                                                          game.aTeam.score += 4;
                                                        }
                                                        print("Team B cannot answer now");
                                                      }
                                                      server.sendAll(json.encode({"type": "Disqualify", "round": "Toss-Up", "player": playerName, "Ascore": game.aTeam.score, "Bscore":  game.bTeam.score}));
                                                      print("here");
                                                      if ((index+1-(5-skipsLeft)) == questionSet.length - 5) {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => Result()),
                                                        );
                                                      }
                                                      else {
                                                        server.sendAll(json.encode({"type": "Blurt", "Disqualify": "Toss-Up", "player": playerName, "Ascore": game.aTeam.score, "Bscore":  game.bTeam.score}));
//                                                        server.sendAll(json.encode({"type": "moderatorReading", "round": "Toss-Up"}));
                                                        index += 1;
                                                        buzzedIn=false;
                                                        roundName = "Toss-Up";
                                                        decisionTime=false;
                                                        interrupt=false;
                                                        doneReading = false;
                                                        game.aTeam.canAnswer=true;
                                                        game.bTeam.canAnswer=true;
                                                      }
                                                    }
                                                    if(roundName=="Bonus")
                                                    {
                                                      if ((index+1-(5-skipsLeft)) == questionSet.length - 5) {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => Result()),
                                                        );
                                                      }
                                                      else {
//                                                        server.sendAll(json.encode({"type": "Disqualify", "round": "Toss-Up", "player": playerName, "Ascore": game.aTeam.score, "Bscore":  game.bTeam.score}));
//                                                        server.sendAll(json.encode({"type": "moderatorReading", "round": "Toss-Up"}));
                                                        index += 1;
                                                        buzzedIn=false;
                                                        roundName = "Toss-Up";
                                                        decisionTime=false;
                                                        interrupt=false;
                                                        doneReading = false;
                                                        game.aTeam.canAnswer=true;
                                                        game.bTeam.canAnswer=true;
                                                      }
                                                    }
                                                  }
                                                });
                                                Navigator.of(context, rootNavigator: true).pop('dialog');
                                              },
                                              child: Text(
                                                "Disqualify",
                                                style: TextStyle(fontSize: 20,
                                                    color: Colors.white),
                                              ),
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
                                                  if(!paused){
//                                                    server.sendAll(json.encode({"type": "Distraction"}));
                                                    if (roundName=="Toss-Up")
                                                    {
//                                                      server.sendAll(json.encode({"type": "moderatorReading", "round": "Bonus"}));
                                                      roundName="Bonus";
                                                      buzzedIn=false;
                                                      interrupt=false;
                                                      decisionTime=false;
                                                      doneReading=false;
                                                      game.aTeam.canAnswer=true;
                                                      game.bTeam.canAnswer=true;
                                                      if(playerName[0]=="A")
                                                      {
                                                        game.aTeam.score+=4;
                                                      }
                                                      else
                                                      {
                                                        game.bTeam.score+=4;
                                                      }
                                                      server.sendAll(json.encode({"type": "Distraction", "round": "Bonus", "player": playerName, "Ascore": game.aTeam.score, "Bscore":  game.bTeam.score}));
                                                    }
                                                    else
                                                    {
                                                      if ((index+1-(5-skipsLeft))== questionSet.length - 5) {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => Result()),
                                                        );
                                                      }
                                                      else{
//                                                        server.sendAll(json.encode({"type": "moderatorReading", "round": "Toss-Up"}));
                                                        index+=1;
                                                        roundName="Toss-Up";
                                                        buzzedIn=false;
                                                        interrupt=false;
                                                        decisionTime=false;
                                                        doneReading=false;
                                                        game.aTeam.canAnswer=true;
                                                        game.bTeam.canAnswer=true;
                                                        if(playerName[0]=="A")
                                                        {
                                                          game.aTeam.score+=10;
                                                        }
                                                        else
                                                        {
                                                          game.bTeam.score+=10;
                                                        }
                                                        server.sendAll(json.encode({"type": "Distraction", "round": "Toss-Up", "player": playerName, "Ascore": game.aTeam.score, "Bscore":  game.bTeam.score}));

                                                      }
                                                    }
                                                  }
                                                });
                                                Navigator.of(context, rootNavigator: true).pop('dialog');
                                              },
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    "Distraction",
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
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        }
                      } : null,
                    ),
                  ],
                ),
              ),
            ],
          );
  },
  ),
        ),
      ),
    );
  }
}

Column teamScore(Team team) {
  return new Column(
    children: <Widget>[
      Text(
        "Team ${team.teamName}",
        textAlign: TextAlign.right,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: (team.teamName == "A") ? Colors.red : Colors.green,
            fontSize: 18)
      ),
      Text(
        team.score.toString(),
        textAlign: TextAlign.right,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: (team.teamName == "A") ? Colors.red : Colors.green,
            fontSize: 18),),
    ],
  );
}

