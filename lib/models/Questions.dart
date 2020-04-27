//import 'package:flutter/material.dart';
//import 'package:sciencebowlportable/globals.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';

class Question{
  int id, difficultyLevel;
  String subjectType, tossupQuestion, tossupAnswer, tossupImageURL, bonusQuestion, bonusAnswer, bonusImageURL;
  bool tossupIsShortAns, bonusIsShortAns;
  List<String> tossupMCQOptions= new List<String>(4);
  List<String> bonusMCQOptions= new List<String>(4);
}

//directory will be based on where the parsed json files are stored in the local device --- might have to add this to assets
Future <List<Question>> parser(String directory) async
{
  Directory dir = Directory(directory);
  List<FileSystemEntity> files = dir.listSync(recursive: false).toList(); //list of json files
  List<Question> questions= new List<Question>(files.length);
  Map decoder;
  Question temp=new Question();
  for (int i=0; i< files.length ; i++)
    {
      decoder= json.decode(await new File(files[i].path).readAsString());
      temp.id=decoder["id"];
      temp.difficultyLevel=decoder["difficultyLevel"];
      temp.subjectType=decoder["subjectType"];
      temp.tossupQuestion=decoder["tossup_question"];
      temp.tossupIsShortAns=decoder["tossup_isShortAns"];
      if (decoder["tossup_MCQoptions"]!=null)
        {
          List tossupOptions=decoder["tossup_MCQoptions"].split("\n");
          for (int j=0; j< tossupOptions.length; j++)
            {
              temp.tossupMCQOptions[j]=tossupOptions[j];
            }
        }
      temp.tossupAnswer=decoder["tossup_answer"];
      temp.tossupImageURL=decoder["tossup_imageURL"];
      temp.bonusQuestion=decoder["bonus_question"];
      temp.bonusIsShortAns=decoder["bonus_isShortAns"];
      if (decoder["bonus_MCQoptions"]!=null)
      {
        List bonusOptions=decoder["bonus_MCQoptions"].split("\n");
        for (int j=0; j< bonusOptions.length; j++)
        {
          temp.bonusMCQOptions[j]=bonusOptions[j];
        }
      }
      questions[i]=(temp);
      temp=new Question();
    }
  temp.bonusAnswer=decoder["bonus_answer"];
  temp.bonusImageURL=decoder["bonus_image"];
  return questions;

}
