import 'package:flutter/material.dart';
import './FirstPage.dart' as first;
import './SecondPage.dart' as second;
import './ThirdPage.dart' as third;
import 'package:sciencebowlportable/utilities/styles.dart';

//Navigates between general, moderator and player tabs
class HowToPlay extends StatefulWidget {
  @override
  HowToPlayState createState() => new HowToPlayState();
}

class HowToPlayState extends State<HowToPlay>
    with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = new TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: new Text("HOW TO PLAY", style: appBarStyle),
            centerTitle: true,
            backgroundColor: Color(0xFFF8B400),
            bottom: new TabBar(controller: controller, tabs: <Tab>[
              new Tab(text: "GENERAL"),
              new Tab(text: "MODERATOR"),
              new Tab(text: "PLAYER"),
            ])),
        body: new TabBarView(controller: controller, children: <Widget>[
          new first.First(),
          new second.Second(),
          new third.Third()
        ]));
  }
}
