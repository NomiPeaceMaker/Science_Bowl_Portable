import 'package:flutter/material.dart';
import 'package:sciencebowlportable/globals.dart';
import 'package:sciencebowlportable/screens/username.dart';



class Edit_account extends StatefulWidget {
  Edit_account({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _Edit_account createState() => _Edit_account();
}

class _Edit_account extends State<Edit_account> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Align( alignment: Alignment.center,
            child: 
            Text('Account'),
          ),
          backgroundColor: Color(0xFFF8B400),
      ),
      body: Column(
        children: [
          Row(children: <Widget>[
            Padding(padding: const EdgeInsets.all(20),
            child:
            Text("Username: "),), Text("${user.userName}"),
            Container(alignment: Alignment.centerRight,
            child:GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Username()),
                  );
                },
                child: Text("            edit",style: TextStyle(color: Colors.red,),),
            )
            ),
          ],
          )
        ]),
        
      );
  }
}