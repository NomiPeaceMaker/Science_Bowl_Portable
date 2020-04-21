import 'package:flutter/material.dart';
import 'package:science_bowl_portable/globals.dart';

class edit_account extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Align( alignment: Alignment.center,
            child: Text('Account'),
          ),
          backgroundColor: Color(0xFFF8B400),
      ),
      body: Column(
        children: [
          Row(children: <Widget>[
            Text("Username: "), Text("$name1"),
            Container(alignment: Alignment.centerRight,
            child: Text("                           edit",style: TextStyle(color: Colors.red,),)
            ),
          ],
          )
        ]),
        
      );
  }
}