import 'package:flutter/material.dart';
import 'package:sciencebowlportable/screens/edit_account.dart';
import 'package:sciencebowlportable/screens/join.dart';
import 'package:sciencebowlportable/screens/moderator.dart';

enum settings {
  help, report
}

var name1 = 'NomiPeaceMaker';

// void MyHomePage1() => runApp(MyHomePage());

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  settings _selection;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text.rich(
                  TextSpan(
                    children: <TextSpan>[
                      TextSpan(text: "Welcome,\n",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 44)),
                      TextSpan(text: "$name1",style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20)),
                    ],
                    
                  )
                ),
              ),
            ),
            ListTile(
              leading:Image(
                image: AssetImage(
                  'assets/a.png'
                ),
                // height: 250,
                // width: 250,
              ),
              title: GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Edit_account()),
                  );
                },
                child: Container(
                  child: Text("Edit Account",
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.normal, color: Color(0xFFF8B400)),
                  ),
                )
              ),
            ),
              ListTile(),
              ListTile(),
              ListTile(),
          ],
        )
      ),
        appBar: AppBar(
          title: Align( alignment: Alignment.center,
            child: const Text('SBP'),
          ),
          backgroundColor: Color(0xFFF8B400),
          actions: <Widget>[
            PopupMenuButton<settings>(
              onSelected:(settings result) {
                setState(() {
                  _selection = result;
                });
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry <settings>> [
                PopupMenuItem(
                  value: settings.report,
                  child: Text('Report'),
                  ),
              ],
              ),
          ],
        ),
        // THIS IS WHERE THE MAIN PAGE OF THE APP STARTS
        backgroundColor: Colors.white,
        body: Align( alignment: Alignment.center,
            child: Column(
              children: [
                Row(
                  children: [
                    Column(children: [Text(
                      "Welcome $name1!"
                    )]
                    ),
                    Column(children: [Text(
                      "View Reports"
                    )]
                    ),
                  ]
                ),
                Center(
                  child: RaisedButton(
                  child: Text('HOST GAME',style: TextStyle(color: Colors.white,fontSize: 30.0)),
                  color: Color(0xFF20BABA),
                  padding: new EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 40.0),
                  onPressed: (){
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Host()),
                  );
                  },
                ),
                ),

                RaisedButton(
                  child: Text('JOIN GAME',style: TextStyle(color: Colors.white,fontSize: 30.0)),
                  color: Color(0xFF20BABA),
                  padding: new EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 40.0),
                  onPressed: (){
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Pin()),
                  );
                  },
                ),
                // Center(
                //   child: Container(
                //     width: 250.0,
                //     padding: new EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 40.0),
                //     color: Color(0xFF20BABA),
                //     child: Text("JOIN GAME",style: TextStyle(color: Colors.white,),
                // ),
                    
                //   ),
                // ),
                Center(
                  child: RaisedButton(
                  child: Text('HOW TO PLAY',style: TextStyle(color: Colors.white,fontSize: 30.0)),
                  color: Color(0xFF20BABA),
                  padding: new EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 40.0),
                  onPressed: (){
                    // HOW TO PLAY SCREEN GOES HERE!
                    //NAVIGATION WAALI CHEEZ KARO
                  },
                ),
                ),
              ]
            )
        ),
      ),
    );
  }
}

class _WaitingRoom {
}