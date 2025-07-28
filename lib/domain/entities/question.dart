class Question {
  final int id;
  final int idResp;
  final String img;
  final String question;
  final List<String> response;
  final List<bool> state;
  final String type;

  Question({
    required this.id,
    required this.idResp,
    required this.img,
    required this.question,
    required this.response,
    required this.state,
    required this.type,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] ?? 0,
      idResp: json['idResp'] ?? 0,
      img: json['img'] ?? '',
      question: json['question'] ?? '',
      response: List<String>.from(json['response'] ?? []),
      state: List<bool>.from(json['state'] ?? []),
      type: json['type'] ?? '',
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
