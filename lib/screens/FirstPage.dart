import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class First extends StatefulWidget {
  @override
  _FirstState createState() => _FirstState();
}

class _FirstState extends State<First> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Container(
            child: ListView(
      scrollDirection: Axis.vertical,
      children: <Widget>[
        YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          onReady: () {
            print("player is ready");
          },
        ),
        introduction(),
        questions(),
        subjects(),
        timing(),
        penalties(),
        summaryHeading(),
        summary(),
      ],
    )));
  }

  YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: 'DaTMdL4Id5I',
    flags: YoutubePlayerFlags(
      autoPlay: false,
      mute: false,
    ),
  );

  Container introduction() {
    return Container(
      margin: const EdgeInsets.all(20.0),
      child: Column(
//      mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("\nWhat is the Science Bowl?\n",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          Text(
            "The science bowl is a science trivial game were players can play each other in teams A and B.\n\n"
            "Each competing team consists of 4 or 5 student members\n\n"
            "You can play either as moderator or as a player.",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
          )
        ],
      ),
    );
  }

  Container questions() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
//        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Questions\n",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Text(
              "Two types of questions will be used:\n"
              "• toss-up questions - 4 points\n"
              "• bonus questions - 10 points\n\n"
              "A toss-up question may be answered by any of the 4 members of either "
              "team that are actively competing.\n\n"
              "A team answering a toss-up question correctly will always get a chance to answer a bonus question;"
              " the other team is ineligible.\n\n"
              "No communication among team members is allowed on toss-up questions, but communication is allowed on bonus questions.\n\n"
              "Only the Team Captain must give the final answer in bonus questions\n\n"
              "Questions are either multiple-choice or short-answer.\n",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal)),
        ],
      ),
    );
  }

  Container subjects() {
    return Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Subjects\n",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text("The following are the subject options:\n",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal)),
            Text(
                "• Biology\n"
                "• Chemistry\n"
                "• Earth and Space Science\n"
                "• Mathematics\n"
                "• Physics\n",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal)),
          ],
        ));
  }

  Container timing() {
    return Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Timing\n",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
                "The match is played until either the time expires or all of the toss-up questions (and earned bonuses for correct toss-ups) have been read.\n\n"
                "The player who buzzes fastest in toss-up gets to answer after their number has been called out by the moderator.\n",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal)),
            Text("Type of Question - Time Allowed\n",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            Text(
                "Toss-up - Teams have 5 seconds to buzz\n"
                "Bonus - Team gets 20 seconds to discuss\n",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal))
          ],
        ));
  }

  Container penalties() {
    return Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Penalties\n",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text("There are five penalties:\n",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal)),
            Text("1. Blurt\n",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            Text(
                "If the student answers before they are recognized (called out) by the moderator a blurt penalty of 4 points isawarded to the other team.\n\n",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal)),
            Text("2. Interrupt\n",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            Text(
                "There is a 4 point penalty awarded to the other team for interrupting the moderator and giving an incorrect answer.\n",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal)),
            Text("3. Consultation\n",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            Text(
                "Team members can only consult each other during bonus question before team captain buzzes in.\n",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal)),
            Text("4. Distraction\n",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            Text(
                "There is a 4 point penalty awarded to the team answering if a distraction by non-playing team occurs.\n",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal)),
            Text("5. Disqualify\n",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            Text(
                "Moderator can disqaulify team from answering the toss-up. No points are lost.\n",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal)),
          ],
        ));
  }

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
              "Communication among players before a team member buzzes in")),
          DataCell(Text(
              "+0 points, but team is disqualified from answering the toss-up")),
        ]),
      ],
    );
  }

  Container summaryHeading() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Column(
//        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Summary\n",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ],
      ),
    );
  }
}
