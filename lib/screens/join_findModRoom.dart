import 'package:flutter/material.dart';
import 'package:ping_discover_network/ping_discover_network.dart';
import 'package:sciencebowlportable/utilities/sizeConfig.dart';
import 'package:wifi/wifi.dart';
import 'dart:typed_data';
import 'package:sciencebowlportable/models/Client.dart';
import 'package:sciencebowlportable/models/Player.dart';
import 'package:sciencebowlportable/globals.dart';
import 'package:sciencebowlportable/screens/player_waiting_room.dart';

// Goal: Get device to recognize moderator join
// PLAN
// 1. Moderator starts broadcasting
// 2. Player gets WIFI ip
// 3. start pinging devices to see wassup using substr of Wifi
// 4. make list and display on screen
// 5. whatever user clicks, get them joined

class JoinStart extends StatefulWidget {
  @override
  _JoinStartState createState() => _JoinStartState();
}

class _JoinStartState extends State<JoinStart> {
  List<String> devices = [];
  String gamePin;
  Player player = Player("");
  Client client;

  List<String> serverLogs = [];
  TextEditingController controller = TextEditingController();

  onData(Uint8List data) {
    String msg = String.fromCharCodes(data);
    socketDataStreamController.add(msg);
//    if (msg == "sendPlayerID") {
//      client.write(player.playerID);
//    }
    setState(() {});
  }

  onError(dynamic error) {
    print(error);
  }

  _scanDevices() async {
    final String ip = await Wifi.ip;
    final String subnet = ip.substring(0, ip.lastIndexOf('.'));

    final stream = NetworkAnalyzer.discover2(subnet, port);
    return stream;
    // stream.listen((NetworkAddress addr) {
    //   if (addr.exists) {
    //     print('Found device: ${addr.ip}');
    //     if (devices.contains(addr.ip)) {
    //       //do nothing
    //     }
    //     else
    //     {
    //       devices.add(addr.ip);
    //     }
    //     // _joinCardTemplate(context, addr.ip);
    //   }
    // });
  }

  // Template for all the available hosts on network
  Widget _joinCardTemplate(context, String ip, {String username = 'default'}) {
    return Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        margin: EdgeInsets.symmetric(
            vertical: SizeConfig.safeBlockVertical * 2,
            horizontal: SizeConfig.safeBlockHorizontal * 2),
        child: RaisedButton(
          onPressed: () {
            showDialog(
              context: context,
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
                        setState(() {
                          print(gamePin);
                          print(key2ip(gamePin));
                          client = Client(
                            hostname: ip,
                            port: 4040,
                            onData: this.onData,
                            onError: this.onError,
                          );
                        });
                        if (client.connected) {
                          print("connected");
                        } else {
                          print("waiting for connection");
//                    await client.connect();
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PlayerWaitingRoom(this.client, this.player)),
                        );
                      }),
                ],
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.safeBlockVertical * 2),
                child: Text(username,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: SizeConfig.safeBlockHorizontal * 4)),
              ),
              SizedBox(width: SizeConfig.safeBlockHorizontal * 80)
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xffF8B400),
        title: Text(
          "JOIN",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/home_back.png',
                ),
                alignment: Alignment.bottomLeft,
                fit: BoxFit.scaleDown),
          ),
          child: FutureBuilder<NetworkAddress>(
            future: _scanDevices(),
            builder: (context, snapshot) {
              NetworkAddress addr; 
              List<Widget> children = [];
              if (snapshot.hasData) {
                addr = snapshot.data;

                if (addr.exists) {
                  print('Found device: ${addr.ip}');
                  if (!devices.contains(addr.ip)) {
                    devices.add(addr.ip);
                  for(String ip in devices){
                    children.add(_joinCardTemplate(context, ip));
                    }
                }
              }
            }
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children
              ),
          );
          // Column(children: for(final game in (await _scanDevices())) _joinCardTemplate(context, )),
          },
      )));
  }
}
