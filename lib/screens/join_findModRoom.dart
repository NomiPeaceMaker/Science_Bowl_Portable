import 'package:flutter/material.dart';
import 'package:ping_discover_network/ping_discover_network.dart';
import 'package:sciencebowlportable/utilities/sizeConfig.dart';
import 'package:wifi/wifi.dart';
import 'package:sciencebowlportable/globals.dart';

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

  Future<void> _scanDevices(context) async {
    
    final String ip = await Wifi.ip;
    final String subnet = ip.substring(0, ip.lastIndexOf('.'));

    final stream = NetworkAnalyzer.discover2(subnet, port);
    stream.listen((NetworkAddress addr) {
      if (addr.exists) {
        print('Found device: ${addr.ip}');
        devices.add(addr.ip);
        // _joinCardTemplate(context, addr.ip);
      }
    });

  }

  // Template for all the available hosts on network
  Widget _joinCardTemplate(context, String ip, {String username = 'default'}) {
    SizeConfig().init(context);
    return Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        margin: EdgeInsets.symmetric(
            vertical: SizeConfig.safeBlockVertical * 2,
            horizontal: SizeConfig.safeBlockHorizontal * 2),
        child: RaisedButton(
          onPressed: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.safeBlockVertical * 2),
                child: Text(username,
                    style: TextStyle(color: Colors.black, fontSize: SizeConfig.safeBlockHorizontal * 4)),
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
        child: RefreshIndicator(
          onRefresh: () {},
          child: Flex(
            crossAxisAlignment: CrossAxisAlignment.start,
            direction: Axis.vertical,
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: devices.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _joinCardTemplate(context, devices[index]);
                  },
                ),
                )
            ],
          )
        )
        // Column(children: for(final game in (await _scanDevices())) _joinCardTemplate(context, )),
      ),
    );
  }
}
