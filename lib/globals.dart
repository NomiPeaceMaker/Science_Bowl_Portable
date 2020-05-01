library science_bowl_portable.globals;
import 'dart:async';

import 'package:sciencebowlportable/models/User.dart';

List<StreamController<String>> redPlayerJoinStreamController = new List.filled(5, StreamController());
List<StreamController<String>> greenPlayerJoinStreamController = new List.filled(5, StreamController());

List<StreamSubscription> redPlayerJoinStreamSubscription;
List<StreamSubscription> greenPlayerJoinStreamSubscription;

String Wifi_ip = "none";

bool isModerator = false;
String pin = "0000";
//String name1 = 'nomi';
//User user = User('nomipeacemaker', 'nomipeacemaker@gmail.com');
User user = new User();
bool isLoggedIn = false;
StreamController<String> socketDataStreamController = StreamController.broadcast();