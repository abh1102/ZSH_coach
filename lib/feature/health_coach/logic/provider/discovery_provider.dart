import 'package:flutter/material.dart';
import 'package:zanadu_coach/feature/health_coach/data/model/question_model.dart';

class QuestionProvider extends ChangeNotifier {
  
  List<Question> questions = [
    Question('What is the level of your concentration during theday?',
        ['Low', 'Normal', 'High', 'Extreme'], 'Low'),
    Question('What is the level of your morale?',
        ['Low', 'Normal', 'High', 'Extreme'], 'Low'),
    Question('What is the level of your physical activity?',
        ['Low', 'Normal', 'High', 'Extreme'], 'Low'),
    Question('What is the level of your physical activity?',
        ['Low', 'Normal', 'High', 'Extreme'], 'Low'),
    Question('What is the level of your physical activity?',
        ['Low', 'Normal', 'High', 'Extreme'], 'Low'),
    Question('What is the level of your physical activity?',
        ['Low', 'Normal', 'High', 'Extreme'], 'Low'),
    Question('What is the level of your physical activity?',
        ['Low', 'Normal', 'High', 'Extreme'], 'Low'),
    Question('What is the level of your physical activity?',
        ['Low', 'Normal', 'High', 'Extreme'], 'Low'),
    Question('What is the level of your physical activity?',
        ['Low', 'Normal', 'High', 'Extreme'], 'Low'),
    Question('What is the level of your physical activity?',
        ['Low', 'Normal', 'High', 'Extreme'], 'Low'),
    // Add more questions here
  ];

  bool isCoachSelected = false;

  void changeCoachSelectedStatus(bool mybool) {
    isCoachSelected = mybool;
    notifyListeners();
  }

  void updateAnswer(int index, String answer) {
    questions[index].selectedOption = answer;
    notifyListeners();
  }
}
