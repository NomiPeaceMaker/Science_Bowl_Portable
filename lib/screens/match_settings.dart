import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:convert';
import 'dart:io';
import 'package:sciencebowlportable/screens/home.dart';
import 'package:sciencebowlportable/globals.dart';
import 'package:sciencebowlportable/models/Moderator.dart';
import 'package:sciencebowlportable/screens/moderator_waiting_room.dart';
import 'package:sciencebowlportable/screens/loading.dart';
import 'package:sciencebowlportable/models/Server.dart';
import 'dart:typed_data';

import 'package:sciencebowlportable/utilities/styles.dart';

class MatchSettings extends StatefulWidget {
  @override
  _MatchSettingState createState() => _MatchSettingState();
}

//List<bool> isSelectedDifficulty = [false, true];
List<bool> isSelectedSubject_1 = List.generate(2, (_) => false);
List<bool> isSelectedSubject_2 = List.generate(3, (_) => false);
bool subject_selected = false;

class _MatchSettingState extends State<MatchSettings> {
  Server server;
  Moderator moderator = Moderator();

  List<String> serverLogs = [];
  TextEditingController controller = TextEditingController();

  initState() {
    super.initState();
    print("INITIALIZING STATE");
    server = Server(
      onData: this.onData,
      onError: this.onError,
    );
    Future printIps() async {
      for (var interface in await NetworkInterface.list()) {
        print('== Interface: ${interface.name} ==');
        for (var addr in interface.addresses) {
          print('${addr.address}');
          print(server.ip2key('${addr.address}'));
          moderator.gamePin = server.ip2key('${addr.address}');
        }
      }
    }

    printIps().then((value) {
      print(moderator.gamePin);
      pin = moderator.gamePin;
    }, onError: (error) {
      print(error);
    });

    moderator.userName = user.userName;
    moderator.email = user.email;
    moderator.gameDifficulty = "HighSchool";
    moderator.gameTime = 20;
    moderator.numberOfQuestion = 25;
    moderator.subjects = [];
    moderator.subjectsdict = {
      0: false,
      1: false,
      2: false,
      3: false,
      4: false,
    };
    moderator.subjects = [];
    moderator.tossUpTime = 5;
    moderator.bonusTime = 20;
    moderator.difficultyLevel = 1;
    isSelectedSubject_1 = List.generate(2, (_) => false);
    isSelectedSubject_2 = List.generate(3, (_) => false);
    subject_selected = false;
  }

  onData(Uint8List data) {
    var msg = String.fromCharCodes(data);
    socketDataStreamController.add(msg);
    setState(() {});
  }

  onError(dynamic error) {
    print(error);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amber,
        drawer: Drawer(),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.00,
          title: Text(
            "HOST",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
          ),
          centerTitle: true,
          leading: Builder(
            builder: (context) => IconButton(
              icon: new Icon(Icons.arrow_back),
              iconSize: 32,
              onPressed: () => Navigator.pop(context),
              //     onPressed: () => showDialog(
              // context: context,
              // barrierDismissible: true,
              // child: AlertDialog(
              //   title: Text("Are you sure you want to exit?"),
              //   actions: <Widget> [
              //     FlatButton(
              //       child: Text("Yes"),
              //       onPressed: () => Navigator.of(context).pop(),
              //     ),
              //     FlatButton(
              //       child: Text("No"),
              //       onPressed: () => Navigator.of(context).pop(),
              //       )
              //   ],
              // ),
              //     ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                child: Image(
                  image: AssetImage('assets/cogwheel@2x.png'),
                  height: 150,
                  width: 150,
                ),
              ),

              // Match Settings
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                child: Text(
                  "MATCH SETTINGS",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.white),
                ),
              ),

              //Time
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <
                  Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 3),
                  child: Text(
                    "Time (mins)",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 3),
                    child: SizedBox(
                        width: 65,
                        height: 40,
                        child: TextField(
                          onChanged: (text) {
                            if (text != "") {
                              var value = int.tryParse(text);
                              if (value == null) {
                                moderator.gameTime = 20;
                                setState(() {});
                                _notIntDialog();
                              }
                            }
                            moderator.gameTime = int.parse(text);
                            print(moderator.gameTime);

                            print(moderator.gameTime);
                            if (moderator.gameTime < 1) {
                              moderator.gameTime = 20;
                              setState(() {});
                              _lessThanOneDialog();
                            } else if (moderator.gameTime > 30) {
                              moderator.gameTime = 20;
                              setState(() {});
                              _gameTimeLimit();
                            }
                          },
                          controller: TextEditingController()
                            ..text = moderator.gameTime.toString(),
//                      initialValue: "20",
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "mins",
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                    width: 0, style: BorderStyle.none),
                              )),
                        )))
              ]),

              // Questions
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <
                  Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 3),
                  child: Text(
                    "Questions (#)",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 3),
                    child: SizedBox(
                        width: 65,
                        height: 40,
                        child: TextField(
                          onChanged: (text) {
                          if (text != "") {
                          var value = int.tryParse(text);
                          if (value == null) {
                          moderator.numberOfQuestion = 25;
                          setState(() {});
                          _notIntDialog();
                          }}
                            moderator.numberOfQuestion = int.parse(text);
                            if (moderator.numberOfQuestion < 1) {
                              moderator.numberOfQuestion = 25;
                              setState(() {});
                              _lessThanOneDialog();
                            } else if (moderator.numberOfQuestion > 40) {
                              moderator.numberOfQuestion = 25;
                              setState(() {});
                              _questionLimitDialog();
                            }
                          },
                          controller: TextEditingController()
                            ..text = moderator.numberOfQuestion.toString(),
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "#",
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                    width: 0, style: BorderStyle.none),
                              )),
                        )))
              ]),

              //Difficulty
//              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <
//                  Widget>[
//                Padding(
//                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 3),
//                  child: Text(
//                    "Difficulty",
//                    textAlign: TextAlign.left,
//                    style: TextStyle(
//                        fontWeight: FontWeight.bold,
//                        fontSize: 18,
//                        color: Colors.white),
//                  ),
//                ),
//                Padding(
//                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 3),
//                    child: ToggleButtons(
//                      fillColor: Colors.white,
//                      selectedColor: Colors.amber,
//                      color: Colors.white,
//                      borderRadius: BorderRadius.circular(10.0),
//                      //                        constraints: BoxConstraints(minWidth: 65, minHeight: 40),
//                      children: <Widget>[Text("Mid"), Text("High")],
//                      onPressed: (int index) {
//                        setState(() {
//                          isSelectedDifficulty[index] =
//                              !isSelectedDifficulty[index];
//                          isSelectedDifficulty[1 - index] = false;
//                          moderator.gameDifficulty = isSelectedDifficulty[0]
//                              ? "MiddleSchool"
//                              : "HighSchool";
//                          moderator.difficultyLevel =
//                              isSelectedDifficulty[0] ? 0 : 1;
//                        });
//                      },
//                      isSelected: isSelectedDifficulty,
//                    ))
//              ]),

              // Include Subjects
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                child: Text(
                  "Include Subjects",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.white),
                ),
              ),

              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 3),
                  child: Column(
                    children: <Widget>[
                      ToggleButtons(
                        fillColor: Colors.white,
                        selectedColor: Colors.amber,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        //                        constraints: BoxConstraints(minWidth: 65, minHeight: 40),
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            //                    padding: EdgeInsets.only(left:10, right:10),
                            child: Text("Math"),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25),
                            child: Text("Earth and Space"),
                          ),
//                          Padding(
//                            padding: EdgeInsets.symmetric(horizontal: 20),
//                            child: Text("Biology"),
//                          ),
                        ],
                        onPressed: (int index) {
                          setState(() {
                            isSelectedSubject_1[index] =
                                !isSelectedSubject_1[index];
                            moderator.subjectsdict[index] =
                                !moderator.subjectsdict[index];
                            print(index);
                          });
                        },
                        isSelected: isSelectedSubject_1,
                      ),
                      ToggleButtons(
                        fillColor: Colors.white,
                        selectedColor: Colors.amber,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        //                        constraints: BoxConstraints(minWidth: 65, minHeight: 40),
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Text("Biology"),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Text("Chemistry"),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Text("Physics"),
                          ),
//                          Padding(
//                            padding: EdgeInsets.symmetric(horizontal: 20),
//                            child: Text("Energy"),
//                          ),
                        ],
                        onPressed: (int index) {
                          setState(() {
                            isSelectedSubject_2[index] =
                                !isSelectedSubject_2[index];
                            moderator.subjectsdict[index + 2] =
                                !moderator.subjectsdict[index + 2];
                            print(index + 2);
                          });
                        },
                        isSelected: isSelectedSubject_2,
                      )
                    ],
                  )),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                child: Text(
                  "ANSWER TIME",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.white),
                ),
              ),

              //Toss-Up
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <
                  Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 3),
                  child: Text(
                    "Toss-Up (secs)",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 3),
                    child: SizedBox(
                        width: 65,
                        height: 40,
                        child: TextField(
                          onChanged: (text) {
                            if (text != "") {
                            var value = int.tryParse(text);
                            if (value == null) {
                            moderator.tossUpTime = 5;
                            setState(() {});
                            _notIntDialog();
                            }}
                            moderator.tossUpTime = int.parse(text);
                            if (moderator.tossUpTime < 1) {
                              moderator.tossUpTime = 5;
                              setState(() {});
                              _lessThanOneDialog();
                            } else if (moderator.tossUpTime > 59) {
                              moderator.tossUpTime = 5;
                              setState(() {});
                              _secondsLimit();
                            }
                          },
                          controller: TextEditingController()
                            ..text = moderator.tossUpTime.toString(),
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "secs",
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                    width: 0, style: BorderStyle.none),
                              )),
                        )))
              ]),

              // Bonus
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <
                  Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 3),
                  child: Text(
                    "Bonus (secs)",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 3),
                    child: SizedBox(
                        width: 65,
                        height: 40,
                        child: TextField(
                          onChanged: (text) {
                            if (text != "") {
                              var value = int.tryParse(text);
                              if (value == null) {
                                moderator.bonusTime = 20;
                                setState(() {});
                                _notIntDialog();
                              }}
                            moderator.bonusTime = int.parse(text);
                               if (moderator.bonusTime < 1) {
                              moderator.bonusTime = 20;
                              setState(() {});
                              _lessThanOneDialog();
                            } else if (moderator.bonusTime > 59) {
                              moderator.bonusTime = 20;
                              setState(() {});
                              _secondsLimit();
                            }
                          },
                          controller: TextEditingController()
                            ..text = moderator.bonusTime.toString(),
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "secs",
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                    width: 0, style: BorderStyle.none),
                              )),
                        )))
              ]),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FlatButton(
                      child: Text(
                        "Set to Default",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.red),
                      ),
                      color: Colors.transparent,
                      textColor: Colors.red,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MatchSettings()),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.navigate_next),
                      color: Colors.red,
                      iconSize: 30,
                      onPressed: () async {
                        moderator.subjectsdict.forEach((key, value) {
//                          print(key);
                          if (value == true) {
                            if (key == 0)
                              moderator.subjects.add("Math");
                            else if (key == 1)
                              moderator.subjects.add("Earth_and_Space");
                            else if (key == 2)
                              moderator.subjects.add("Biology");
                            else if (key == 3)
                              moderator.subjects.add(
                                "Chemistry",
                              );
                            else if (key == 4)
                              moderator.subjects.add("Physics");
                          }
                        });

                        await server.start();
                        subjectValidation();
                        print(moderator.gameTime);
                        print(moderator.numberOfQuestion);
                        print(moderator.tossUpTime);
                        print(moderator.bonusTime);
//                        bool validInputs = validations();
                        if (subject_selected == true) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Loading(this.server, this.moderator)),
                          );
                        }
                        else
                          _chooseSubjectDialog();
                        setState(() {});
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  void subjectValidation() {
    moderator.subjectsdict.forEach((key, value) {
      if (value == true) {
        subject_selected = true;
        return;
      }
    });
  }

//  bool validations() {
//    if (moderator.bonusTime <= 0 ||
//        moderator.gameTime <= 0 ||
//        moderator.tossUpTime <= 0 ||
//        moderator.numberOfQuestion <= 0) {
//      _lessThanOneDialog();
//      return false;
//    } else if (subject_selected == false) {
//      _chooseSubjectDialog();
//      return false;
//    }
//
//    return true;
//  }

  _chooseSubjectDialog() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: Text("Subject not selected"),
            content: Text(
                "You have to pick minimum one subject in order to proceed"),
            actions: <Widget>[
              FlatButton(
                child: Text("Okay"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  _lessThanOneDialog() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: Text("Invalid Input"),
            content: Text("Input can not be less than 1"),
            actions: <Widget>[
              FlatButton(
                child: Text("Okay"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  _gameTimeLimit() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: Text("Time Limit"),
            content: Text("Match can not be longer than 30 minutes"),
            actions: <Widget>[
              FlatButton(
                child: Text("Okay"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  _questionLimitDialog() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: Text("Question Limit"),
            content: Text("Can not choose more than 40 questions"),
            actions: <Widget>[
              FlatButton(
                child: Text("Okay"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  _notIntDialog() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: Text("Invalid Input"),
            content: Text("Enter an integer"),
            actions: <Widget>[
              FlatButton(
                child: Text("Okay"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  _secondsLimit() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: Text("Time Limit"),
            content: Text("Can not be a minute long"),
            actions: <Widget>[
              FlatButton(
                child: Text("Okay"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
