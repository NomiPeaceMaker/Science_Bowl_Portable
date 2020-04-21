import 'package:flutter/material.dart';
import 'screens/edit_account.dart';
import "package:science_bowl_portable/globals.dart";

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

var name1 = 'NomiPeaceMaker';

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

// class edit_account extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           title: Align( alignment: Alignment.center,
//             child: Text('Account'),
//           ),
//           backgroundColor: Color(0xFFF8B400),
//       ),
//       body: Column(
//         children: [
//           Row(children: <Widget>[
//             Text("Username: "), Text("$_name"),
//             Container(alignment: Alignment.centerRight,
//             child: Text("                           edit",style: TextStyle(color: Colors.red,),)
//             ),
//           ],
//           )
//         ]),
        
//       );
//   }
// }
