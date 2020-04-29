import 'package:flutter/material.dart';

class Second extends StatefulWidget {
  @override
  _SecondState createState() => _SecondState();
}

class _SecondState extends State<Second> {
  @override
  Widget build(BuildContext context) {
    return Container(
//        margin: const EdgeInsets.all(20),
        child:Center(
          child: ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              summary(),
            ],
          ),
        )
    );
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
  DataTable summary(){
    return DataTable(
      columns: [
        DataColumn(label:Text("Type of Question")),DataColumn(label:Text("Points Awarded")),
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
          DataCell(Text("Communication among players after a team member buzzes in")),
          DataCell(Text("+4 points to opposing team")),
        ]),
        DataRow(cells: [
          DataCell(Text("Answering a toss-up before a team member buzzes in")),
          DataCell(Text("+0 points, but team is disqualified from answering the toss-up")),
        ]),
        DataRow(cells: [
          DataCell(Text("Communication among players before a team member buzzes in ")),
          DataCell(Text("+0 points, but team is disqualified from answering the toss-up")),
        ]),
      ],

    );
  }
}

