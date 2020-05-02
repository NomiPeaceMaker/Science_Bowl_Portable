import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:sciencebowlportable/models/Client.dart';
import 'package:sciencebowlportable/models/Player.dart';
import 'package:sciencebowlportable/globals.dart';
import 'package:sciencebowlportable/screens/player_waiting_room.dart';

//void join() => Pin();
//Might need to tweak the colour scheme a bit + Red Team or Team A?
//Needs validation based on valid pins + better styling possible

class Pin extends StatefulWidget {
  @override
  _PinState createState() => _PinState();
}

class _PinState extends State<Pin> {
  String gamePin;
  Player player = Player("");
  Client client;
  bool connected = false;

  List<String> serverLogs = [];
  TextEditingController controller = TextEditingController();

  onData(Uint8List data) {
    String msg = String.fromCharCodes(data).replaceAll(new RegExp(r"\s+\b|\b\s"), "");
    print("Message Recieved from server $msg");
    socketDataStreamController.add(msg);

    if (msg == "sendPlayerID") {
      client.write(player.playerID);
    }
    if (msg == "Connected") {
      print("Coonected to server, recieved message!");
      connected = true;
    }
    setState(() {});
  }

  onError(dynamic error) {
    print(error);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xffF8B400),
        title: Text(
          "JOIN",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
        ),
        centerTitle: true,
      ),
      body: Center(
          child: Container(
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              title: Text('Enter Match PIN to join'),
              content: new Row(
                children: <Widget>[
                  new Expanded(
                    child: new TextField(
                      autofocus: true,
                      decoration: new InputDecoration(
                        labelText: 'Match PIN',
                        hintText: 'eg. AB123',
                      ),
                      onChanged: (value) {
                        gamePin = value;
                      },
                    ))
                ],
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text('Cancel'),
                  textColor: Colors.red,
                  onPressed: () {
                    Navigator.pop(context);
                  } //should go back to home page
//                  Navigator.of(context).pop(teamName);
              ),
              FlatButton(
                child: Text('Confirm'),
                  textColor: Colors.green,
                onPressed: () async {
                  // get wifi ip XXX.XXX.XXX.XXX
                  Wifi_ip = await (Connectivity().getWifiIP());
                  // remove the last bit so now you should have XXX.XXX.XXX.___ (test this just in case)
                  String subnet = Wifi_ip.substring(0, Wifi_ip.lastIndexOf('.'));

                  setState(() {
                    // subnet = subnet.substring(0,8);
                    print(subnet); // SUBNET is now the same as the "G" Character in the thing but better.
                    print(gamePin);
                    print(key2ip(gamePin,subnet));
                    client = Client(
                      hostname: key2ip(gamePin, subnet),
                      port: PORT,
                      onData: this.onData,
                      onError: this.onError,
                    );
                  });
                  if (connected) {
                    print("connected");
                  } else {
                    print("waiting for connection");
                    await client.connect();
                    print("done connecting");
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PlayerWaitingRoom(this.client)),
                  );
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}