//import 'package:flutter/material.dart';
//import 'package:sciencebowlportable/globals.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sciencebowlportable/models/Moderator.dart';

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

Future<List<Question>> retrieveQuestions(
    var subjects, int numberofQuestions, int difficultyLevel) async {
  print("in questions.dart");
  print(subjects);
  List<Question> questions = new List<Question>();
//  List<DocumentSnapshot> documents;
  Map decoder;
  Question temp = new Question();
  final QuerySnapshot result = await Firestore.instance
      .collection('Question')
      .where('subjectType', whereIn: subjects)
      .where('difficultyLevel', isEqualTo: difficultyLevel)
      .limit(numberofQuestions + 5)
      .getDocuments();
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

    temp.bonusAnswer =
        decoder["bonus_answer"].substring(8); //removed ANSWER: from start
    temp.bonusImageURL = decoder["bonus_image"];

    questions.add(temp);
    temp = new Question();
  }

//  for (int i =0; i<questions.length; i++)
//    {
//      print(questions[i].bonusAnswer);
//      print(questions[i].tossupAnswer);
//    }
  print('${questions.length} is length of questions');

  return questions;
}
