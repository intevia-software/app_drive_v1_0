import 'package:app_drive_v1_0/domain/entities/question.dart';

class QuestionModel extends Question {
  QuestionModel({
    required int id,
    required int idResp,
    required String img,
    required String question,
    required List<String> response,
    required List<bool> state,
    required String type,
  }) : super(
          id: id,
          idResp: idResp,
          img: img,
          question: question,
          response: response,
          state: state,
          type: type,
        );

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'],
      idResp: json['idResp'],
      img: json['img'],
      question: json['question'],
      response: List<String>.from(json['response']),
      state: List<bool>.from(json['state']),
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idResp': idResp,
      'img': img,
      'question': question,
      'response': response,
      'state': state,
      'type': type,
    };
  }
}
