// Timer code taken from https://github.com/immacoder/flutter_tutorials/blob/master/timer_app/lib/main.dart

//Timer should start when moderator is done reading
import 'package:flutter/material.dart';
import 'dart:async'; //for timer
import "dart:math";
import 'package:sciencebowlportable/screens/result.dart';
import 'package:sciencebowlportable/screens/home.dart';
import 'package:sciencebowlportable/globals.dart';

 //for random
void join() => Pin();
//Might need to tweak the colour scheme a bit + Red Team or Team A?
class _WaitingRoom extends StatefulWidget {
  @override
  _WaitingRoomState createState() => _WaitingRoomState();
}

class _WaitingRoomState extends State<_WaitingRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Pin()),
                  ),
        ),
        backgroundColor: Color(0xffF8B400),
        title: Text("Waiting Room"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                "Slots Available",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0xffCC0066), fontSize: 22
                ),
              ),
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
                      "Confirm",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)
                  ),
                  color: Color(0xffF8B400),
                  textColor: Colors.white,
                  onPressed: () => {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Game()),
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


//Needs validation based on valid pins + better styling possible
class Pin extends StatefulWidget {
  @override
  _PinState createState() => _PinState();
}

class _PinState extends State<Pin> {
  // String pin;
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }
  
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
                      controller: myController,
                      autofocus: true,
                      decoration: new InputDecoration(
                          labelText: 'Match PIN',
                          hintText: 'eg. AB123',),
                      onChanged: (value) {
                        pin = value;
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
                  pin = myController.text;
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


class Game extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  double timeLeft = 3.444;
  Color txtClr = Colors.white;
  int redScore = 0;
  String gamePin= pin;
  int greenScore = 0;
  Color bzrBorder=Colors.white;
  Color buzzerClr=Color(0xFFf84b4b);
  String buzzerTxt="Buzz In!";
  String roundName="Toss-up";
  String playerName = "Red Captain";
  bool flip=false;
  bool unavailable=false;
  bool team=true; //true for red, false for green
  int _counter = 5;
  Timer _timer;
  var element="";
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

  void _startTimer() {
    _counter = 5;
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_counter > 0) {
          _counter--;
        } else {
          _timer.cancel();
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
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.offline_pin, color: Color(0xffF8B400)),
              title: Text("Game PIN:\n $gamePin",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),
              ),
            ),
            ListTile(
              title: GestureDetector(
                child: Text("Exit Game",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),
              ),
                onTap: (){
                  Navigator.popUntil(context, ModalRoute.withName('/home'));
                }
              ),

                
              leading: Icon(Icons.exit_to_app, color: Color(0xffF8B400),),
              
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
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 25),
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
                        style: TextStyle(fontWeight: FontWeight.bold, color:Colors.purple , fontSize: 25),
                      )
                  )
              ),
              Padding(
                  padding: EdgeInsets.all(13),
                  child: Text(
                    "Green\n"+greenScore.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.lightGreen, fontSize: 25),
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
                                  content: Icon(Icons.thumb_up),
                                  backgroundColor: Colors.lightGreen,
//                                  animation: ,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Result()),
                              );
                            }
                        }
                        else
                          {
                            buzzerTxt="Buzz In!";
                            buzzerClr=Color(0xFFf84b4b);
                            _startTimer();
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


























//class MyApp extends StatelessWidget {
//  // This widget is the root of your application.
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: 'Flutter Demo',
//      theme: ThemeData(
//        // This is the theme of your application.
//        //
//        // Try running your application with "flutter run". You'll see the
//        // application has a blue toolbar. Then, without quitting the app, try
//        // changing the primarySwatch below to Colors.green and then invoke
//        // "hot reload" (press "r" in the console where you ran "flutter run",
//        // or simply save your changes to "hot reload" in a Flutter IDE).
//        // Notice that the counter didn't reset back to zero; the application
//        // is not restarted.
//        primarySwatch: Colors.blue,
//        // This makes the visual density adapt to the platform that you run
//        // the app on. For desktop platforms, the controls will be smaller and
//        // closer together (more dense) than on mobile platforms.
//        visualDensity: VisualDensity.adaptivePlatformDensity,
//      ),
//      home: MyHomePage(title: 'Flutter Demo Home Page'),
//    );
//  }
//}
//
//class MyHomePage extends StatefulWidget {
//  MyHomePage({Key key, this.title}) : super(key: key);
//
//  // This widget is the home page of your application. It is stateful, meaning
//  // that it has a State object (defined below) that contains fields that affect
//  // how it looks.
//
//  // This class is the configuration for the state. It holds the values (in this
//  // case the title) provided by the parent (in this case the App widget) and
//  // used by the build method of the State. Fields in a Widget subclass are
//  // always marked "final".
//
//  final String title;
//
//  @override
//  _MyHomePageState createState() => _MyHomePageState();
//}
//
//class _MyHomePageState extends State<MyHomePage> {
//  int _counter = 0;
//
//  void _incrementCounter() {
//    setState(() {
//      // This call to setState tells the Flutter framework that something has
//      // changed in this State, which causes it to rerun the build method below
//      // so that the display can reflect the updated values. If we changed
//      // _counter without calling setState(), then the build method would not be
//      // called again, and so nothing would appear to happen.
//      _counter++;
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    // This method is rerun every time setState is called, for instance as done
//    // by the _incrementCounter method above.
//    //
//    // The Flutter framework has been optimized to make rerunning build methods
//    // fast, so that you can just rebuild anything that needs updating rather
//    // than having to individually change instances of widgets.
//    return Scaffold(
//      appBar: AppBar(
//        // Here we take the value from the MyHomePage object that was created by
//        // the App.build method, and use it to set our appbar title.
//        title: Text(widget.title),
//      ),
//      body: Center(
//        // Center is a layout widget. It takes a single child and positions it
//        // in the middle of the parent.
//        child: Column(
//          // Column is also a layout widget. It takes a list of children and
//          // arranges them vertically. By default, it sizes itself to fit its
//          // children horizontally, and tries to be as tall as its parent.
//          //
//          // Invoke "debug painting" (press "p" in the console, choose the
//          // "Toggle Debug Paint" action from the Flutter Inspector in Android
//          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
//          // to see the wireframe for each widget.
//          //
//          // Column has various properties to control how it sizes itself and
//          // how it positions its children. Here we use mainAxisAlignment to
//          // center the children vertically; the main axis here is the vertical
//          // axis because Columns are vertical (the cross axis would be
//          // horizontal).
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            Text(
//              'You have pushed the button this many times:',
//            ),
//            Text(
//              '$_counter',
//              style: Theme.of(context).textTheme.headline4,
//            ),
//          ],
//        ),
//      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: _incrementCounter,
//        tooltip: 'Increment',
//        child: Icon(Icons.add),
//      ), // This trailing comma makes auto-formatting nicer for build methods.
//    );
//  }
//}
