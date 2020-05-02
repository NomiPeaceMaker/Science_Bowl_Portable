import 'package:sciencebowlportable/models/User.dart';
import 'package:sciencebowlportable/models/Team.dart';
import 'package:sciencebowlportable/models/Questions.dart';
import 'package:sciencebowlportable/globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Moderator extends User {
  String gameDifficulty, gamePin;
  int numberOfQuestion, tossUpTime, bonusTime, gameTime;
  var subjects;

  //change directory to wherever json files are:
//  Future<List<Question>> questionSet=parser("C:/Users/Zohair/Desktop/Anusheh's Documents/Software Engineering/Development/Science_Bowl_Portable/jsonQuestions/");

//  Team redTeam = Team("red");
//  Team greenTeam = Team("green");

  Team aTeam = Team("A");
  Team bTeam = Team("B");

  int difficultyLevel;
  var subjectsdict;

  Future<List<Question>> questionSet() {
    return retrieveQuestions(
        this.subjects, this.numberOfQuestion, this.difficultyLevel);
  }


}

//void main()
//{
//  Moderator mod=new Moderator();
//  mod.questionSet.then((List<Question> qs)
//  {
//    print("in callback");
//    for (int i=0; i<25; i++)
//    {
//      print(qs[i].subjectType);
//    }
//
//  });
//}