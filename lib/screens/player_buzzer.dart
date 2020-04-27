
import 'package:flutter/material.dart';
import 'dart:async'; //for timer
import "dart:math";

class Game extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
//  double timeLeft = 300; //5 mins
  int _minutes=5;
  int _seconds=0;
  Color txtClr = Colors.white;
  int redScore = 0;
  String gamePin="NP5629";
  int greenScore = 0;
  Color bzrBorder=Colors.white;
  Color buzzerClr=Color(0xFFf84b4b);
  String buzzerTxt="Buzz In!";
  String roundName="Toss-up";
  String playerName = "Red Captain";
  bool flip=false;
  String buf="0";
  bool unavailable=false;
  bool team=true; //true for red, false for green
  int _counter = 5;
  Timer _buzzTimer;
  Timer _gameTimer;
  var element="";

  _GameState(){
    _startBuzzTimer();
    _startGameTimer();
  }
  void evaluate(){
    //random evaluation rn
    setState(() {
      var pathOptions = new List();
      if (roundName=="Toss-up"){
        pathOptions=["Correct", "Incorrect", "Blurt", "Consultation", "Interrupt"];
      }
      else //bonus
          {
        pathOptions=["Correct", "Incorrect", "Blurt", "Interrupt"];
      }
      final _random = new Random();
      element = pathOptions[_random.nextInt(pathOptions.length)];
      print(element);
      if (element=="Correct")
      {
        if (team)
        {
          redScore+=4;
        }
        else
        {
          greenScore+=4;
        }
      }
      else if (element=="Incorrect")
      {
        print("pass for now");
      }
      else if(element=="Blurt")
      {
        print("pass for now");
      }
      else if(element=="Consulation")
      {
        print("pass for now");
      }
      else //interrupt
          {
        print("pass for now");
      }
    });
  }

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
            if (flip){
              unavailable=true;
              txtClr=Color(0xffAEAEAE);
              buzzerTxt="Unavailable";
              buzzerClr=Colors.white;
              bzrBorder=Color(0xffAEAEAE);
            }});
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
        if (_minutes<0)
        {
          _gameTimer.cancel();
        }
        if (_seconds > 0) {
          _seconds--;
          if(_seconds<10)
          {
            buf="0";
          }
          else
          {
            buf="";
          }
        }
        else {
          buf="";
          _seconds=59;
          _minutes-=1;
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
            Container(
              height: 55.0,
              color: Color(0xffF8B400),
              child: Center(
                child: Text("Settings",
//                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.offline_pin, color: Color(0xffF8B400)),
              title: Text("Game PIN:\n $gamePin",
//              textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),
              ),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app, color: Color(0xffF8B400),),
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
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    "Red\n"+redScore.toString(),
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
                    "Green\n"+greenScore.toString(),
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
          Container(
            margin: EdgeInsets.only(left: 20.0, right: 20.0),
            child: SizedBox(
              width: 300.0,
              height: 200.0,
              child: Card(
                elevation: 10.0,
                color: Colors.yellow[50],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          Container(
            height: 30.0,
            width: 300.0,
//            color: Colors.
            child: Card(
              child: Text(
                '$playerName',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 18),
              ),
              elevation: 10.0,
              color: Colors.yellow[50],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)
              ),
            ),
          ),
          SizedBox(
            width:150.0,
            height:150.0,
            child:  Builder(
              builder: (context) => RaisedButton(
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
                    (_counter > 0 && flip)
                        ? Text('$_counter',
                      style: TextStyle(fontSize: 15.0, color: Colors.white),
                      textAlign: TextAlign.center,
                    )
                        : Text(
                      '',
                    )
                  ],
                ),
                onPressed: (){
                  setState(() {
                    if (!unavailable){
                      if (flip)
                      {
                        buzzerTxt="Recognized!";
                        buzzerClr=Colors.green;
                        evaluate();
                        if (element=="Correct")
                        {
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Icon(Icons.done),
                              backgroundColor: Colors.lightGreen,
//                                  animation: ,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                        else if (element=="Incorrect")
                        {
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Icon(Icons.not_interested),
                              backgroundColor: Colors.red,
//                                  animation: ,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                        else //penalty
                            {
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Icon(Icons.pan_tool),
                              backgroundColor: Colors.grey[900],
//                                  animation: ,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      }
                      else
                      {
                        buzzerTxt="Buzz In!";
                        buzzerClr=Color(0xFFf84b4b);
                        _startBuzzTimer();
                      }
                      flip=!flip;
                    }
                  }
                  );
                },
                color: buzzerClr,
              ),
            ),
          ),
        ],
      ),
    );
  }
}