import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:sciencebowlportable/screens/home.dart';
import 'package:sciencebowlportable/globals.dart';
import 'package:sciencebowlportable/models/Moderator.dart';
import 'package:sciencebowlportable/screens/moderator.dart';

class MatchSettings extends StatefulWidget {
  @override
  _MatchSettingState createState() => _MatchSettingState();
}

List<bool> isSelectedDifficulty = List.generate(2, (_) => false);
List<bool> isSelectedSubject_1 = List.generate(3, (_) => false);
List<bool> isSelectedSubject_2 = List.generate(3, (_) => false);

class _MatchSettingState extends State<MatchSettings> {
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
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
        ),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: new Icon(Icons.cancel),
            iconSize: 32,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyHomePage()),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Image(
                image: AssetImage(
                    'assets/settings.png'
                ),
                height: 150,
                width: 150,
              ),
            ),

            // Match Settings
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              child: Text(
                "MACTH SETTINGS",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
              ),
            ),

            //Time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 3),
                  child: Text(
                    "Time",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 3),
                  child: SizedBox(
                    width: 65,
                    height: 40,
                    child: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "mins",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(width: 0, style: BorderStyle.none),
                        )
                      ),
                    )
                  )
                )
              ]
            ),

            // Questions
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 3),
                    child: Text(
                      "Questions",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 3),
                      child: SizedBox(
                          width: 65,
                          height: 40,
                          child: TextField(
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: "#",
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(width: 0, style: BorderStyle.none),
                                )
                            ),
                          )
                      )
                  )
                ]
             ),

            //Difficulty
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 3),
                    child: Text(
                      "Difficulty",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 3),
                      child: ToggleButtons(
                          fillColor: Colors.white,
                          selectedColor: Colors.amber,
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
  //                        constraints: BoxConstraints(minWidth: 65, minHeight: 40),
                          children: <Widget>[
                            Text("Mid"),
                            Text("High")
                          ],
                          onPressed: (int index) {
                            setState(() {
                              isSelectedDifficulty[index] = !isSelectedDifficulty[index];
                              isSelectedDifficulty[1-index] = false;
                            });
                          },
                        isSelected: isSelectedDifficulty,
                        )
                  )
                ]
              ),

            // Include Subjects
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              child: Text(
                "Include Subjects",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
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
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          //                    padding: EdgeInsets.only(left:10, right:10),
                          child: Text("Math"),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text("Earth&Space"),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text("Biology"),
                        ),
                      ],
                      onPressed: (int index) {
                        setState(() {
                          isSelectedSubject_1[index] = !isSelectedSubject_1[index];
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
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text("Chemistry"),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text("Physics"),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text("Energy"),
                        ),
                      ],
                      onPressed: (int index) {
                        setState(() {
                          isSelectedSubject_2[index] = !isSelectedSubject_2[index];
                        });
                      },
                      isSelected: isSelectedSubject_2,
                    )
                  ],
                )
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              child: Text(
                "ANSWER TIME",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
              ),
            ),

            //Toss-Up
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 3),
                    child: Text(
                      "Toss-Up",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 3),
                      child: SizedBox(
                          width: 65,
                          height: 40,
                          child: TextField(
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: "secs",
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(width: 0, style: BorderStyle.none),
                                )
                            ),
                          )
                      )
                  )
                ]
            ),

            // Bonus
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 3),
                    child: Text(
                      "Bonus",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 3),
                      child: SizedBox(
                          width: 65,
                          height: 40,
                          child: TextField(
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: "secs",
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(width: 0, style: BorderStyle.none),
                                )
                            ),
                          )
                      )
                  )
                ]
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    child: Text (
                      "Set to Default",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.red),
                    ),
                    color: Colors.transparent,
                    textColor: Colors.red,
                    onPressed: () => {},
                  ),
                  IconButton(
                    icon: Icon(Icons.navigate_next),
                    color: Colors.red,
                    iconSize: 30,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Host()),
                      );
                    }
                  )
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}