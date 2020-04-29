import 'package:flutter/material.dart';

class Third extends StatefulWidget {
  @override
  _ThirdState createState() => _ThirdState();
}

class _ThirdState extends State<Third> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(20),
        child: Center(
            child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            buzzInHeader(),
            Image.asset('assets/buzz_in.png'),
            buzzIn(),
            recognisedHeader(),
            Image.asset('assets/recognised.png'),
            recognised(),
            unavailableHeader(),
            Image.asset('assets/unavailable.png'),
            unavailable(),
            interruptHeader(),
            Image.asset('assets/interrupt.png'),
            interrupt(),
          ],
        )));
  }

  Container buzzIn() {
    return Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("The timer indicates the duration for which the buzzer is available.\n",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal))
          ],
        ));
  }

  Container recognised() {
    return Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Recognition by moderator is visually indicated by the buzzer going green\n\n"
                "The buzzer does not accept user input now.\n",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal))
          ],
        ));
  }
  Container unavailable() {
    return Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("The buzzer is unavailable if another user is recognized\n",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal))
          ],
        ));
  }
  Container interrupt() {
    return Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Player has interrupted and buzzer is now inactive\n",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal))
          ],
        ));
  }

  Center buzzInHeader() {
    return Center(
        child: Text("Buzzer Available",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)));
  }

  Center recognisedHeader() {
    return Center(
      child: Text(
        "Recognition",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );
  }

  Center interruptHeader() {
    return Center(
      child: Text(
        "Interrupt",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );
  }

  Center unavailableHeader() {
    return Center(
      child: Text(
        "Buzzer Unavailable",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );
  }
}
