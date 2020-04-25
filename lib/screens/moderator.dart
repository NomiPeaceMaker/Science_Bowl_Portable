import 'package:flutter/material.dart';
import 'package:sciencebowlportable/globals.dart';
import 'package:sciencebowlportable/models/Moderator.dart';

class Host extends StatefulWidget {
  @override
  _HostState createState() => _HostState();
}

class _HostState extends State<Host> {
  bool paused = true;
  double timeLeft = 3.444;
  int redScore = 24;
  int greenScore = 14;
  String roundName = "Toss-Up";
  String Qsubject = "Biology";
  String Qtype = "Short Answer";
  String Q = "What is the most common term used in genetics to decribe the observable physical charactersitics of an organism casued by the expression of a gene or a set of genes?";
  String A = "PHENOTYPE";
  bool BuzzerOpen = true;
  double timeToAnswer = 2.113;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
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
              icon: paused ? new Icon(Icons.play_circle_outline) : new Icon(Icons.pause_circle_outline),
              iconSize: 40.0,
              onPressed: (){
                if (paused) {
                  setState(() {
                    paused = false;
                  });
                } else {
                  setState(() {
                    paused = true;
                  });
                };
              },
            ),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                    "Red\n"+redScore.toString(),
                    textAlign: TextAlign.right,
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
                      "Time Left\n"+timeLeft.toStringAsFixed(2),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold, color:Colors.purple , fontSize: 18),
                  )
                )
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  "Green\n"+greenScore.toString(),
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.lightGreen, fontSize: 18),
                )
              )
            ],
          ),
          Card(
            color: Colors.yellow[50],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
            elevation: 2.0,
            child: Column(
//              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    roundName,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      Qsubject,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Text(
                      Qtype,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(30),
                  child: Text(
                    "Q: "+Q,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    "A: "+A,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                IconButton(
                  icon: new Icon(Icons.navigate_next),
                  alignment: Alignment.bottomRight,
                  iconSize: 32,
                  onPressed: () {},
                )
              ],
            )
          ),
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
            color: BuzzerOpen ? Colors.lightBlue : Colors.lightGreen,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  new Icon(Icons.fiber_manual_record, color: Colors.white, size: 50),
                  Text("B Captain (Interrupt)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                  new Icon(Icons.cancel, color: Colors.white, size: 25)
                ]
            )
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
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  padding: EdgeInsets.all(20.0),
                  color: Colors.lightGreen,
                  textColor: Colors.white,
                  onPressed: () => {},
                ),
                FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                      "Incorrect",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
                  ),
                  padding: EdgeInsets.all(20.0),
                  color: Colors.amber,
                  textColor: Colors.white,
                  onPressed: () => {},
                ),
                FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    "Penalty",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  padding: EdgeInsets.all(20.0),
                  color: Colors.red,
                  textColor: Colors.white,
                  onPressed: () => {},
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}