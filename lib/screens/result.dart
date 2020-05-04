import 'package:flutter/material.dart';
import 'package:sciencebowlportable/globals.dart';
import 'package:sciencebowlportable/main.dart';
import 'package:sciencebowlportable/screens/home.dart';
import 'package:sciencebowlportable/models/Moderator.dart';

class Result extends StatefulWidget {
//  Moderator moderator;
  Result();

  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
//  Moderator moderator;

  _ResultState();
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
    onWillPop: () async {
        Navigator.pushAndRemoveUntil(context, 
                  MaterialPageRoute(builder: (BuildContext context) => MyHomePage(),
                  ),
                  ModalRoute.withName('/home'));
        return false;
      },
    child: Scaffold(
      backgroundColor: const Color(0xFFF8B400),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20.0, 80.0, 20.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Image(
                image: AssetImage('assets/result.png'),
                height: 120.0,
                width: 120.0,
              ),
            ),
            RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: 'Congrats ',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                      fontSize: 32.0,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: (game.aTeam.score>game.bTeam.score)?"A" :(game.aTeam.score<game.bTeam.score)?"B": "A and B! \nIt's a Tie" ,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            // foreground: Paint()
                            //   ..style = PaintingStyle.stroke
                            //   ..strokeWidth = 1
                            //   ..color = Colors.black,
                          )),
                      TextSpan(
                        text: '!',
                        // style: TextStyle(color: Colors.red[400])
                      )
                    ])),
            SizedBox(height: 10.0),
            Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0,20,0.0,20.0),
                      child: Text('Final Scores',
                          style: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500,
                            fontSize: 24.0,
                          )),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text("Team A",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                )),
                            Text(game.aTeam.score.toString(),
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ))
                          ],
                        ),
                        SizedBox(width: 50.0),
                        Column(children: <Widget>[
                          Text('Team B',
                              style: TextStyle(
                                color: Colors.lightGreen,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                              )),
                          Text(game.bTeam.score.toString(),
                              style: TextStyle(
                                color: Colors.lightGreen,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                              ))
                        ]),
                      ],
                    ),
                    SizedBox(height: 20.0),
                  ],
                )),
            SizedBox(height: 40.0),
            ButtonTheme(
              height: 60.0,
              minWidth: 200.0,
              child: RaisedButton(
                elevation: 2.0,
                onPressed: () => {
                  // Navigator.popUntil(context, ModalRoute.withName('/home'))
                  Navigator.pushAndRemoveUntil(context, 
                  MaterialPageRoute(builder: (BuildContext context) => MyHomePage(),
                  ),
                  ModalRoute.withName('/')),
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  'Finish',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ),
    );
  }
}
