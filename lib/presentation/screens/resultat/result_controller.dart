import 'package:flutter/material.dart';

class ResultController extends ChangeNotifier {
  final List<Map<String, dynamic>> questions;
  final List<Map<String, dynamic>> responses;
  final int score;

  ResultController({
    required this.questions,
    required this.responses,
    required this.score,
  });

  Map<String, dynamic>? getQuestionById(int id) {
    return questions.firstWhere((q) => q['id'] == id, orElse: () => {});
  }

  List<Map<String, dynamic>> get correctedResponses {
    return responses.map((resp) {
      final original = getQuestionById(resp['id']);
      return {
        ...resp,
        'correctState': original != null ? original['state'] : [false, false, false],
      };
    }).toList();
  }
}
