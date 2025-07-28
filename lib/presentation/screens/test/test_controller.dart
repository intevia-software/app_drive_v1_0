import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:app_drive_v1_0/core/services/api_client.dart';
import 'package:app_drive_v1_0/core/services/storage_service.dart';
class TestController extends ChangeNotifier {
  List<Map<String, dynamic>> res = [];
  int nbq = 40;
  int seconde = 30;
  int time = 10 * 30;

  int count = 0;
  bool first = false;
  bool second = false;
  bool third = false;

  bool dataFirst = false;
  bool dataSecond = false;
  bool dataThird = false;

  List<Map<String, dynamic>> response = [];

  int setter = 0;
  int counter = 0;

  Timer? _timer;

  Future<void> fetchQuestions(BuildContext context) async {
    try {
      final token = await StorageService.getToken();

      final response = await ApiClient.dio.get(
        '/test',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data['success'] == true && data['response'] is List) {
          res = List<Map<String, dynamic>>.from(data['response']);
          notifyListeners();
        } else {
          throw Exception("Réponse invalide du serveur.");
        }
      } else {
        Navigator.pushNamed(context, '/error_connexion');
        throw Exception('Erreur serveur : ${response.statusCode}');
      }
    } catch (e) {
      Navigator.pushNamed(context, '/error_connexion');
      throw Exception('❌ Erreur serveur : $e');
    }
  }

  void setFirst(bool? val) {
    if (val != null) {
      dataFirst = val;
      first = val;
      notifyListeners();
    }
  }

  void setSecond(bool? val) {
    if (val != null) {
      dataSecond = val;
      second = val;
      notifyListeners();
    }
  }

  void setThird(bool? val) {
    if (val != null) {
      dataThird = val;
      third = val;
      notifyListeners();
    }
  }

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      setter++;
      counter = (setter / 10).floor();

      if (setter >= time) {
        setter = 0;
        counter = 0;
        handleValid();
      }

      notifyListeners();
    });
  }

  void handleValid() {
    _timer?.cancel();
    setter = 0;
    counter = 0;

    if (count >= res.length) return;

    final result = res[count];

    final newResponse = {
      'id': result['id'],
      'idResp': result['idResp'],
      'img': result['img'],
      'question': result['question'],
      'response': result['response'],
      'state': [dataFirst, dataSecond, dataThird],
      'type': result['type']
    };

    response.add(newResponse);
    count++;

    first = false;
    second = false;
    third = false;

    notifyListeners();

    if (count >= nbq || count >= res.length) {
      score();
    } else {
      startTimer();
    }
  }

  List<dynamic> typeScore(String type) {
    int sc = 0;
    int numberQuestion = 0;

    for (var resp in response) {
      if (resp['type'] == type) {
        numberQuestion++;

        final question = res.firstWhere(
          (q) => q['id'] == resp['id'],
          orElse: () => {},
        );

        int score = 0;
        if (question.isNotEmpty) {
          for (int s = 0; s < 3; s++) {
            if (resp['state'][s] == question['state'][s]) {
              score++;
            }
          }
        }

        if (score == 3) sc++;
      }
    }

    return [type, sc, numberQuestion];
  }

  void score() {
    int sc = 0;

    for (var resp in response) {
      final question = res.firstWhere(
        (q) => q['id'] == resp['id'],
        orElse: () => {},
      );

      int score = 0;
      if (question.isNotEmpty) {
        for (int s = 0; s < 3; s++) {
          if (resp['state'][s] == question['state'][s]) {
            score++;
          }
        }
      }

      if (score == 3) sc++;
    }

    sendToResult();
  }

  void sendToResult() {
    // Navigator.pushNamed(context, '/result');
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
