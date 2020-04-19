import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Color.fromARGB(200, 255, 255, 255),
        
      ),
        
        // This is the theme of your applsication.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        brightness: Brightness.light,
        primaryColor: Color(0xFFF8B400),
        accentColor: Colors.cyan[600],
        primarySwatch: Colors.lightGreen,
        fontFamily: 'Georgia',
      ),
      home: MyHomePage(title: 'Science Bowl Portable!'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum settings {
  help, report
}

var _name = 'NomiPeaceMaker';

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
                      TextSpan(text: "$_name",style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20)),
                    ],
                    
                  )
                ),
              ),
            ),
            ListTile( leading:Image(
              image: AssetImage('a.png'),
              ),
              title: GestureDetector(
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => edit_account()),
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
              // Text(
              // 'Edit Account',
              
              // textAlign: TextAlign.left,
              // overflow: TextOverflow.ellipsis,
              // style: TextStyle(fontWeight: FontWeight.normal, color: Color(0xFFF8B400)),
              // )
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
                      "Welcome $_name!"
                    )]
                    ),
                    Column(children: [Text(
                      "View Reports"
                    )]
                    ),
                  ]
                ),
                Center(
                  child: Container(
                    width: 250.0,
                    padding: new EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 40.0),
                    color: Color(0xFF20BABA),
                    child: Text("HOST GAME",style: TextStyle(color: Colors.white,),),
                  ),
                ),
                Center(
                  child: Container(
                    width: 250.0,
                    padding: new EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 40.0),
                    color: Color(0xFF20BABA),
                    child: Text("JOIN GAME",style: TextStyle(color: Colors.white,),),
                  ),
                ),
                Center(
                  child: Container(
                    width: 250.0,
                    padding: new EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 40.0),
                    color: Color(0xFF20BABA),
                    child: Text("HOW TO PLAY",style: TextStyle(color: Colors.white,),),
                  ),
                ),
              ]
            )
        ),
      ),
    );
  }
}

class edit_account extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Align( alignment: Alignment.center,
            child: Text('Account'),
          ),
          backgroundColor: Color(0xFFF8B400),
      ),
      body: Column(
        children: [
          Row(children: <Widget>[
            Text("Username: "), Text("$_name"),
            Container(alignment: Alignment.centerRight,
            child: Text("                           edit",style: TextStyle(color: Colors.red,),)
            ),
          ],
          )
        ]),
        
      );
  }
}
  // Widget build(BuildContext context) {
  //   // This method is rerun every time setState is called, for instance as done
  //   // by the _incrementCounter method above.
  //   //
  //   // The Flutter framework has been optimized to make rerunning build methods
  //   // fast, so that you can just rebuild anything that needs updating rather
  //   // than having to individually change instances of widgets.
  //   return Scaffold(
  //     // appBar: AppBar(
  //     //   // Here we take the value from the MyHomePage object that was created by
  //     //   // the App.build method, and use it to set our appbar title.
  //     //   title: Text(widget.title),
  //     // ),
  //     body: Align(
  //       alignment: Alignment.center,
  //       // Center is a layout widget. It takes a single child and positions it
  //       // in the middle of the parent.
  //       child: Column(
  //         // Column is also a layout widget. It takes a list of children and
  //         // arranges them vertically. By default, it sizes itself to fit its
  //         // children horizontally, and tries to be as tall as its parent.
  //         //
  //         // Invoke "debug painting" (press "p" in the console, choose the
  //         // "Toggle Debug Paint" action from the Flutter Inspector in Android
  //         // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
  //         // to see the wireframe for each widget.
  //         //
  //         // Column has various properties to control how it sizes itself and
  //         // how it positions its children. Here we use mainAxisAlignment to
  //         // center the children vertically; the main axis here is the vertical
  //         // axis because Columns are vertical (the cross axis would be
  //         // horizontal).
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         children: <Widget>[
  //           Text(
  //             'Press here to start the game!',
  //           ),
  //           Text(
  //             '$_counter',
  //             style: Theme.of(context).textTheme.display1,
  //           ),
  //         ],
  //       ),
  //     ),
  //     floatingActionButton: FloatingActionButton(
  //       onPressed: _incrementCounter,
  //       tooltip: 'Press to start game!',
  //       child: Icon(Icons.apps),
  //     ), // This trailing comma makes auto-formatting nicer for build methods.
  //   );
  // }

