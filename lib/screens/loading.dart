import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sciencebowlportable/models/Moderator.dart';
import 'package:sciencebowlportable/models/Server.dart';
import 'package:sciencebowlportable/models/Questions.dart';
import 'package:sciencebowlportable/screens/moderator_waiting_room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Loading extends StatefulWidget {
  Server server;
  Moderator moderator;
  List<Question> questionSet;

  @override
  Loading(this.server, this.moderator);

  LoadingState createState() {
    return LoadingState(this.server, this.moderator, this.questionSet);
  }
}

class LoadingState extends State<Loading> {
  Server server;
  Moderator moderator;
  List<Question> questionSet;

  LoadingState(this.server, this.moderator, this.questionSet);

  Stream result;

  Future<QuerySnapshot> retrievingQuestions() async {
//    final QuerySnapshot result = await Firestore.instance.collection('Question').where('subject',arrayContains: moderator.subjects).limit(moderator.numberOfQuestion+5).getDocuments();
//  result.listen((QuerySnapshot querySnapshot){
//    querySnapshot.documents.forEach((document) => documents.add(document));});
//  print("DOCUMENTS");
//  print(documents);
//    await retrieveQuestions(moderator.subjects,moderator.numberOfQuestion,).then()
    await moderator.questionSet().then((list) {
      questionSet = list;
      print(list);
//      print("retrieved questions");
    });

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ModeratorWaitingRoom(
                this.server, this.moderator, this.questionSet)));
  }

  @override
  void initState() {
    super.initState();
    retrievingQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color(0xFFF8B400),
      body: Center(
        child: SpinKitWave(
          color: Colors.white,
          size: 80,
        ),
      ),
    );
  }
}
