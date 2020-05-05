import 'package:flutter/material.dart';
import 'package:sciencebowlportable/utilities/sizeConfig.dart';

class Second extends StatefulWidget {
  @override
  _SecondState createState() => _SecondState();
}

class _SecondState extends State<Second> {
  
  //Widget to get images
  // Widget _imageAsset(String path) {
  //   SizeConfig().init(context);
  //   return (Image.asset(
  //     path,
  //     width: SizeConfig.safeBlockHorizontal * 70,
  //     // height: SizeConfig.safeBlockVertical * 25,
  //   ));
  // }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
//        margin: const EdgeInsets.all(20),
        child: Center(
      child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          buzzerHeader(),
          // _imageAsset('assets/donereading.png'),
          // _imageAsset('assets/buzzeropen.png'),
          Image.asset(
            'assets/donereading.png',
          ),
          Image.asset(
            'assets/buzzeropen.png',
          ),
          Image.asset(
            'assets/decisiontime.png',
          ),
          buzzer(),
          optionsHeader(),
          Image.asset(
            'assets/cip.png',
          ),
          options(),
          penaltyHeader(),
          Image.asset(
            'assets/penalties.png',
            width: 300,
            height: 300,
          ),
          penalty(),
          interruptHeader(),
          Image.asset(
            'assets/captaininterrupt.png',
            height: 90,
          ),
          interrupt(),
          summaryHeading(),
          summary(),
        ],
      ),
    ));
  }

//  Container timing() {
//    return Container(
//        margin: const EdgeInsets.all(20),
//        child: Column(
//          crossAxisAlignment: CrossAxisAlignment.start,
//          children: <Widget>[
//            Text("\n", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
//            Text("\n",style:TextStyle(fontSize: 15,fontWeight: FontWeight.normal))
//          ],
//        )
//    );
//  }
  DataTable summary() {
    return DataTable(
      columns: [
        DataColumn(label: Text("Type of Question")),
        DataColumn(label: Text("Points Awarded")),
      ],
      rows: [
        DataRow(cells: [
          DataCell(Text("Correct Toss-up (or distraction by nonplaying team)")),
          DataCell(Text("+4 points & eligible for bonus question")),
        ]),
        DataRow(cells: [
          DataCell(Text("Incorrect Toss-up")),
          DataCell(Text("+0 points")),
        ]),
        DataRow(cells: [
          DataCell(Text("Correct Bonus (or distraction by nonplaying team)")),
          DataCell(Text("+10 points")),
        ]),
        DataRow(cells: [
          DataCell(Text("Incorrect Bonus")),
          DataCell(Text("+0 points")),
        ]),
        DataRow(cells: [
          DataCell(Text("Interrupted Toss-up (Correct Answer)")),
          DataCell(Text("+4 points & eligible for bonus question")),
        ]),
        DataRow(cells: [
          DataCell(Text("Interrupted Toss-up (Incorrect Answer)")),
          DataCell(Text("+4 points to opposing team")),
        ]),
        DataRow(cells: [
          DataCell(Text("Unrecognized Toss-up (Blurt) ")),
          DataCell(Text("+4 points to opposing team")),
        ]),
        DataRow(cells: [
          DataCell(Text("Unrecognized Interrupted Toss-up (also a Blurt)")),
          DataCell(Text("+4 points to opposing team")),
        ]),
        DataRow(cells: [
          DataCell(Text(
              "Communication among players after a team member buzzes in")),
          DataCell(Text("+4 points to opposing team")),
        ]),
        DataRow(cells: [
          DataCell(Text("Answering a toss-up before a team member buzzes in")),
          DataCell(Text(
              "+0 points, but team is disqualified from answering the toss-up")),
        ]),
        DataRow(cells: [
          DataCell(Text(
              "Communication among players before a team member buzzes in ")),
          DataCell(Text(
              "+0 points, but team is disqualified from answering the toss-up")),
        ]),
      ],
    );
  }

  Container summaryHeading() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Center(
//        mainAxisAlignment: MainAxisAlignment.start,
//        crossAxisAlignment: CrossAxisAlignment.start,
        child: Text(
          "Summary\n",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
    );
  }

  Container buzzerHeader() {
    return Container(
        margin: const EdgeInsets.all(20),
        child: Center(
            child: Text("Enable Buzzer",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))));
  }

  Container buzzer() {
    return Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
                "Moderator has to press done reading once they have read the question on their screen aloud. "
                "The progression show above will then take place.\n\n"
                "The players buzzers will open once countdown is completed.\n\n"
                "Moderator can award points once it is decision time\n",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal))
          ],
        ));
  }

  Container optionsHeader() {
    return Container(
        margin: const EdgeInsets.all(20),
        child: Center(
            child: Text("Options",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))));
  }

  Container options() {
    return Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Moderator can award score using these buttons.\n",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal))
          ],
        ));
  }

  Container penaltyHeader() {
    return Container(
        margin: const EdgeInsets.all(20),
        child: Center(
            child: Text("Penalties",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))));
  }

  Container penalty() {
    return Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Moderator can hand out only one penalty at a time.\n",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal))
          ],
        ));
  }

  Container interruptHeader() {
    return Container(
        margin: const EdgeInsets.all(20),
        child: Center(
            child: Text("Interrupt",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))));
  }

  Container interrupt() {
    return Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
                "If a player buzzes in before the moderator has pressed done reading button then interrupt penalty will occur.\n",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal))
          ],
        ));
  }
}
