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
String username_set;
int PORT = 4040;
bool isModerator = false;
String pin;
String user_email = null;
//String name1 = 'nomi';
//User user = User('nomipeacemaker', 'nomipeacemaker@gmail.com');
User user = new User();
bool isLoggedIn = false;

StreamController<String> socketDataStreamController = StreamController.broadcast();