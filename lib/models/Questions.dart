//import 'package:flutter/material.dart';
//import 'package:sciencebowlportable/globals.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  int id, difficultyLevel;
  String subjectType,
      tossupQuestion,
      tossupAnswer,
      tossupImageURL,
      bonusQuestion,
      bonusAnswer,
      bonusImageURL;
  bool tossupIsShortAns, bonusIsShortAns;
  List<String> tossupMCQOptions = new List<String>(4);
  List<String> bonusMCQOptions = new List<String>(4);
}

//directory will be based on where the parsed json files are stored in the local device --- might have to add this to assets
//Future <List<Question>> parser(String directory) async
//{
//  Directory dir = Directory(directory);
//  List<FileSystemEntity> files = dir.listSync(recursive: false).toList(); //list of json files
//  List<Question> questions= new List<Question>(files.length);
//  Map decoder;
//  Question temp=new Question();
//  for (int i=0; i< files.length ; i++)
//    {
//      decoder= json.decode(await new File(files[i].path).readAsString());
//      temp.id=decoder["id"];
//      temp.difficultyLevel=decoder["difficultyLevel"];
//      temp.subjectType=decoder["subjectType"];
//      temp.tossupQuestion=decoder["tossup_question"];
//      temp.tossupIsShortAns=decoder["tossup_isShortAns"];
//      if (decoder["tossup_MCQoptions"]!=null)
//        {
//          List tossupOptions=decoder["tossup_MCQoptions"].split("\n");
//          for (int j=0; j< tossupOptions.length; j++)
//            {
//              temp.tossupMCQOptions[j]=tossupOptions[j];
//            }
//        }
//      temp.tossupAnswer=decoder["tossup_answer"];
//      temp.tossupImageURL=decoder["tossup_imageURL"];
//      temp.bonusQuestion=decoder["bonus_question"];
//      temp.bonusIsShortAns=decoder["bonus_isShortAns"];
//      if (decoder["bonus_MCQoptions"]!=null)
//      {
//        List bonusOptions=decoder["bonus_MCQoptions"].split("\n");
//        for (int j=0; j< bonusOptions.length; j++)
//        {
//          temp.bonusMCQOptions[j]=bonusOptions[j];
//        }
//      }
//      questions[i]=(temp);
//      temp=new Question();
//    }
//  temp.bonusAnswer=decoder["bonus_answer"];
//  temp.bonusImageURL=decoder["bonus_image"];
//  return questions;
//
//}

Future<List<Question>> retrieveQuestions() async {
  List<Question> questions = new List<Question>();
  Map decoder;
  Question temp = new Question();
  final QuerySnapshot result =
      await Firestore.instance.collection('Question').getDocuments();
  final List<DocumentSnapshot> documents = result.documents;
  for (int i = 0; i < documents.length; i++) {
    decoder = documents[i].data;
    temp.id = decoder["id"];
    temp.difficultyLevel = decoder["difficultyLevel"];
    if (decoder["subjectType"]=="Earth_and_Space")
      {
        List splits=decoder["tossup_question"].split(" ");
        temp.tossupQuestion = splits.sublist(4).join(" ");
        splits=decoder["bonus_question"].split(" ");
        temp.bonusQuestion = splits.sublist(4).join(" ");
        temp.subjectType = "Earth and Space";
      }
    else
      {
        List splits=decoder["tossup_question"].split(" ");
        temp.tossupQuestion = splits.sublist(2).join(" ");
        splits=decoder["bonus_question"].split(" ");
        temp.bonusQuestion = splits.sublist(2).join(" ");
        temp.subjectType = decoder["subjectType"];
      }
    temp.tossupIsShortAns = decoder["tossup_isShortAns"];
    if (decoder["tossup_MCQoptions"] != null) {
      List<String> tossupOptions = decoder["tossup_MCQoptions"].split("\n");
      for (int j = 0; j < tossupOptions.length; j++) {
        temp.tossupMCQOptions[j] = tossupOptions[j];
      }
    }
    temp.tossupAnswer = decoder["tossup_answer"].substring(8); //removed answer
    temp.tossupImageURL = decoder["tossup_imageURL"];
    temp.bonusIsShortAns = decoder["bonus_isShortAns"];
    if (decoder["bonus_MCQoptions"] != null) {
      List bonusOptions = decoder["bonus_MCQoptions"].split("\n");
      for (int j = 0; j < bonusOptions.length; j++) {
        temp.bonusMCQOptions[j] = bonusOptions[j];
      }
    }
    temp.bonusAnswer = decoder["bonus_answer"].substring(8); //removed ANSWER: from start
    temp.bonusImageURL = decoder["bonus_image"];

//    print("PRINTING QUESTIONSSSS");
//    print(temp);
    questions.add(temp);
    temp = new Question();
  }

  for (int i =0; i<questions.length; i++)
    {
      print(questions[i].bonusAnswer);
      print(questions[i].tossupAnswer);
    }
  return questions;
}
