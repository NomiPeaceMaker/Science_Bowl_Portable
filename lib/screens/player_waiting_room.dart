part of pin_screen;

class _WaitingRoom extends StatefulWidget {
  @override
  Client client;
  _WaitingRoom(this.client);

  _WaitingRoomState createState() {
    return _WaitingRoomState(this.client);
  }
}

class _WaitingRoomState extends State<_WaitingRoom> {
  Client client;
  _WaitingRoomState(this.client);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Pin()),
          ),
        ),
        backgroundColor: Color(0xffF8B400),
        title: Text("Waiting Room"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                "Slots Available",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0xffCC0066), fontSize: 22
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                "Red Team",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.red, fontSize: 18
                ),
              ),
              Text(
                "Green Team",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.green, fontSize: 18
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox(
                width: 140.0,
                height: 50,
                child:FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                      "Red 1",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)
                  ),
                  color: Colors.red,
                  textColor: Colors.white,
                  onPressed: () => {},
                ),
              ),
              SizedBox(
                width: 140.0,
                height: 50.0,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                      "Green 1",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)
                  ),
                  color: Colors.green,
                  textColor: Colors.white,
                  onPressed: () => {},
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox(
                width: 140.0,
                height: 50,
                child:FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                      "Red 2",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)
                  ),
                  color: Colors.red,
                  textColor: Colors.white,
                  onPressed: () => {},
                ),
              ),
              SizedBox(
                width: 140.0,
                height: 50.0,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                      "Green 2",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)
                  ),
                  color: Colors.green,
                  textColor: Colors.white,
                  onPressed: () => {},
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox(
                width: 140.0,
                height: 50,
                child:FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: Text(
                        "Red Captain",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                    ),
                  ),
                  color: Colors.red,
                  textColor: Colors.white,
                  onPressed: () => {},
                ),
              ),
              SizedBox(
                width: 140.0,
                height: 50.0,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                      "Green Captain",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                  ),
                  color: Colors.green,
                  textColor: Colors.white,
                  onPressed: () => {},
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox(
                width: 140.0,
                height: 50,
                child:FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                      "Red 3",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)
                  ),
                  color: Colors.red,
                  textColor: Colors.white,
                  onPressed: () => {},
                ),
              ),
              SizedBox(
                width: 140.0,
                height: 50.0,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                      "Green 3",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)
                  ),
                  color: Colors.green,
                  textColor: Colors.white,
                  onPressed: () => {},
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox(
                width: 140.0,
                height: 50,
                child:FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                      "Red 4",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)
                  ),
                  color: Colors.red,
                  textColor: Colors.white,
                  onPressed: () => {},
                ),
              ),
              SizedBox(
                width: 140.0,
                height: 50.0,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                      "Green 4",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)
                  ),
                  color: Colors.green,
                  textColor: Colors.white,
                  onPressed: () => {},
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: 140.0,
                height: 60.0,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Text(
                      "Confirm",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)
                  ),
                  color: Color(0xffF8B400),
                  textColor: Colors.white,
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Game()),
                    ),
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}