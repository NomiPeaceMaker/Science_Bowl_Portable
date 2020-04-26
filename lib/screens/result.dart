import 'package:flutter/material.dart';
import 'package:sciencebowlportable/globals.dart';
import 'package:sciencebowlportable/main.dart';

class Result extends StatefulWidget {
  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          text: 'A',
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
                            Text('A Team',
                                style: TextStyle(
                                  color: Colors.yellow,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                )),
                            Text('40',
                                style: TextStyle(
                                  color: Colors.yellow,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ))
                          ],
                        ),
                        SizedBox(width: 50.0),
                        Column(children: <Widget>[
                          Text('B Team',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                              )),
                          Text('38',
                              style: TextStyle(
                                color: Colors.blue,
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
                  Navigator.popUntil(context, ModalRoute.withName('/home'))
                
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
    );
  }
}
