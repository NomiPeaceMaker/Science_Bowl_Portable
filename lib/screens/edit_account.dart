import 'package:flutter/material.dart';
import 'package:sciencebowlportable/utilities/sizeConfig.dart';
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
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title:  Text('Account'),
        centerTitle: true,
        backgroundColor: Color(0xFFF8B400),
      ),
      body: Container( 
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/home_back.png',
            ),
            alignment: Alignment.bottomLeft,
            fit: BoxFit.scaleDown
            ),
        ),
        child:Column(children: [
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          margin: EdgeInsets.symmetric(
              vertical: SizeConfig.safeBlockVertical * 2,
              horizontal: SizeConfig.safeBlockHorizontal * 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: SizeConfig.safeBlockVertical * 2),
                child: Text("Username: ", style: TextStyle(color: Colors.grey[500], fontSize: 18),),
              ),
              Text("${user.userName}", style: TextStyle(color: Colors.black, fontSize: 18)),
              SizedBox(width: SizeConfig.safeBlockHorizontal*45),
             GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Username()),
                      );
                    },
                    child: Text(
                      "edit",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18
                      ),
                    ),
                  ),
            ],
          ),
        )
      ]),
    ),);
  }
}
