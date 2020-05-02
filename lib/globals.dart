library science_bowl_portable.globals;
import 'dart:async';
import 'package:sciencebowlportable/models/User.dart';


//List<StreamController<String>> redPlayerJoinStreamController = new List.filled(5, StreamController.broadcast());
//List<StreamController<String>> greenPlayerJoinStreamController = new List.filled(5, StreamController.broadcast());

//List<StreamController<String>> playerJoinStreamControllers = new List(10);
//List<StreamController<String>> greenPlayerJoinStreamController = new List(5);
//List<StreamSubscription> redPlayerJoinStreamSubscription;
//List<StreamSubscription> greenPlayerJoinStreamSubscription;

String Wifi_ip = "none";

int PORT = 4040;
bool isModerator = false;
String pin = "0000";
//String name1 = 'nomi';
//User user = User('nomipeacemaker', 'nomipeacemaker@gmail.com');
User user = new User();
bool isLoggedIn = false;

StreamController<String> socketDataStreamController = StreamController.broadcast();

var playerPositionIndexDict =
{
  "A 1": 0,
  "A 2":1,
  "A Captain":2,
  "A 3":3,
  "A 4":4,
  "B 1": 5,
  "B 2": 6,
  "B Captain": 7,
  "B 3":8,
  "B 4":9
};