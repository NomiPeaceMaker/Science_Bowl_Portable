import 'package:flutter/material.dart';
import 'package:sciencebowlportable/screens/edit_account.dart';
import 'package:sciencebowlportable/screens/pin_screen.dart';
// import 'package:sciencebowlportable/screens/moderator.dart';
import 'package:sciencebowlportable/screens/match_settings.dart';
import 'package:sciencebowlportable/globals.dart';
import 'package:sciencebowlportable/utilities/sizeConfig.dart';
import 'package:sciencebowlportable/utilities/styles.dart';
import 'package:sciencebowlportable/screens/howtoplay.dart';
// import 'package:flutter/services.dart';
import 'package:move_to_background/move_to_background.dart';


enum settings { help, report }

// var name1 = 'NomiPeaceMaker';
// void MyHomePage1() => runApp(MyHomePage());

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime currentBackPressTime;
  settings _selection;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return new WillPopScope(
      
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/homeBG.png"), fit: BoxFit.cover)),
          child: Scaffold(
            drawer: Drawer(
                child: ListView(
              children: [
                DrawerHeader(
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text.rich(TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: "Welcome,\n",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    SizeConfig.safeBlockHorizontal * 6.5)),
                        TextSpan(
                            text: "${user.userName}",
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize:
                                    SizeConfig.safeBlockHorizontal * 4.5)),
                      ],
                    )),
                  ),
                ),
                ListTile(
                  leading: Image(
                    image: AssetImage('assets/a.png'),
                    // height: 250,
                    // width: 250,
                  ),
                  title: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Edit_account()),
                        );
                      },
                      child: Container(
                        child: Text(
                          "Edit Account",
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Color(0xFFF8B400),
                              fontSize: SizeConfig.safeBlockHorizontal * 4.5),
                        ),
                      )),
                ),
                ListTile(),
                ListTile(),
                ListTile(),
              ],
            )),
            appBar: AppBar(
              title: Text('SBP', style: appBarStyle),
              centerTitle: true,
              backgroundColor: Color(0xFFF8B400),
              actions: <Widget>[
                PopupMenuButton<settings>(
                  onSelected: (settings result) {
                    setState(() {
                      _selection = result;
                    });
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<settings>>[
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
            body: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        'assets/home_back.png',
                      ),
                      alignment: Alignment.bottomLeft,
                      fit: BoxFit.scaleDown),
                ),
                child: Column(children: [
                  Row(children: [
                    Padding(
                        padding: EdgeInsets.fromLTRB(
                            SizeConfig.safeBlockHorizontal * 7,
                            SizeConfig.safeBlockVertical * 5,
                            SizeConfig.safeBlockHorizontal * 5,
                            SizeConfig.safeBlockVertical * 5),
                        child: Row(children: [
                          RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  text: 'Welcome, ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Roboto',
                                    fontSize: 18.0,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: '${user.userName}!',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ])),
                        ])),
                  ]),
                  Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.safeBlockVertical * 3.5,
                          horizontal: SizeConfig.safeBlockHorizontal * 5),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45.0),
                        ),
                        child: SizedBox(
                          height: SizeConfig.blockSizeVertical * 21,
                          width: SizeConfig.blockSizeVertical * 50,
                          child: Center(
                            child: Text('HOST GAME',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 22.0)),
                          ),
                        ),
                        color: Color(0xFF20BABA),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MatchSettings()),
                          );
                        },
                      )),

                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.safeBlockVertical * 3.5,
                        horizontal: SizeConfig.safeBlockHorizontal * 5),
                      child: RaisedButton(
                        child: SizedBox(
                          height: SizeConfig.blockSizeVertical * 21,
                          width: SizeConfig.blockSizeVertical * 50,
                          child: Center(
                            child: Text('JOIN GAME',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 22.0)),
                          ),
                        ),
                        color: Color(0xFF20BABA),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45.0),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Pin()),
                          );
                        },
                      ),
                    ),
                     Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.safeBlockVertical * 3.5,
                        horizontal: SizeConfig.safeBlockHorizontal * 5),
                      child: RaisedButton(
                        child: SizedBox(
                          height: SizeConfig.blockSizeVertical * 21,
                          width: SizeConfig.blockSizeVertical * 50,
                          child: Center(
                            child: Text('HOW TO PLAY',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 22.0)),
                          ),
                        ),
                        color: Color(0xFF20BABA),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45.0),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HowToPlay()),
                          );
                        },
                      ),
                    ),
                ])),
          ),
        ),
      ),
      onWillPop:  () async {
        MoveToBackground.moveTaskToBack();
        return false;
      },
    );
  }

// Future <bool>  _exitDialog() async {
    // showDialog(
    //     context: context,
    //     barrierDismissible: true,
    //     builder: (context) {
    //       return AlertDialog(
    //         title: Text("Exit SBP"),
    //         content: Text("Are you sure you want to exit the app?"),
    //         actions: <Widget>[
    //           FlatButton(
    //             child: Text("No", style: staystyle),
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //             },
    //           ),
    //           FlatButton(
    //             child: Text("Exit", style: exitstyle),
    //             onPressed: () {SystemNavigator.pop();},
    //           ),
    //         ],
    //       );
    //     });
  // }
}
