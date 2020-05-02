library science_bowl_portable.globals;
import 'dart:async';
import 'package:sciencebowlportable/models/User.dart';


//List<StreamController<String>> redPlayerJoinStreamController = new List.filled(5, StreamController.broadcast());
//List<StreamController<String>> greenPlayerJoinStreamController = new List.filled(5, StreamController.broadcast());

//List<StreamController<String>> playerJoinStreamControllers = new List(10);
//List<StreamController<String>> greenPlayerJoinStreamController = new List(5);
//List<StreamSubscription> redPlayerJoinStreamSubscription;
//List<StreamSubscription> greenPlayerJoinStreamSubscription;

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
  "Red 1": 0,
  "Red 2":1,
  "Red Captain":2,
  "Red 3":3,
  "Red 4":4,
  "Green 1": 5,
  "Green 2": 6,
  "Green Captain": 7,
  "Green 3":8,
  "Green 4":9
};