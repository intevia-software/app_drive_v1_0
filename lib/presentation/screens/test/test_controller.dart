import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:app_drive_v1_0/core/services/api_client.dart';
import 'package:app_drive_v1_0/presentation/screens/resultat/result_screen.dart';
import 'package:app_drive_v1_0/presentation/screens/resultat/result_controller.dart';
import 'package:app_drive_v1_0/core/services/storage_service.dart';

class TestController extends ChangeNotifier {
  List<Map<String, dynamic>> res = []; // Liste des questions
  List<Map<String, dynamic>> response = []; // Réponses de l'utilisateur

  List<bool> selected = [false, false, false]; // Réponses actuelles de l'utilisateur (3 cases)

  int nbq = 40;
  int seconde = 30;
  int time = 10 * 30;

  int count = 0;
  int setter = 0;
  int counter = 0;

  Timer? _timer;

  // Fetch questions depuis l'API
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

  // Mise à jour d'une case cochée
  void setSelected(int index, bool? val) {
    if (val != null && index >= 0 && index < selected.length) {
      selected[index] = val;
      notifyListeners();
    }
  }

  // Démarrage du timer
  void startTimer(BuildContext context) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      setter++;
      counter = (setter / 10).floor();

      if (setter >= time) {
        setter = 0;
        counter = 0;
        handleValid(context);
      }

      notifyListeners();
    });
  }

  // Validation de la réponse actuelle
  void handleValid(BuildContext context) {
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
      'state': List<bool>.from(selected), // copie des réponses actuelles
      'type': result['type'],
    };

    response.add(newResponse);
    count++;

    // Réinitialise les sélections
    selected = [false, false, false];
    notifyListeners();

    if (count >= nbq || count >= res.length) {
      score(context);
    } else {
      startTimer(context);
    }
  }

  // Calcule le score total
  void score(BuildContext context) {
    int sc = 0;

    for (var resp in response) {
      final question = res.firstWhere(
        (q) => q['id'] == resp['id'],
        orElse: () => {},
      );

      if (question.isNotEmpty &&
          question.containsKey('state') &&
          resp.containsKey('state')) {
        final List<dynamic> correctAnswers = question['state'];
        final List<dynamic> userAnswers = resp['state'];

        if (correctAnswers.length == 3 && userAnswers.length == 3) {
          int correctCount = 0;
          for (int i = 0; i < 3; i++) {
            if (userAnswers[i] == correctAnswers[i]) {
              correctCount++;
            }
          }

          // Ajoute un point si toutes les réponses sont correctes
          if (correctCount == 3) {
            sc++;
          }
        }
      }
    }

    sendToResult(context, sc, response,res);
  }

  // Envoie les résultats (ou navigation)
  void sendToResult(BuildContext context, int sc, List<Map<String, dynamic>> response ,List<Map<String, dynamic>> res ) {

    Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => ResultScreen(
        controller: ResultController(
          questions: res,
          responses: response,
          score: sc,
        ),
      ),
    ),
  );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
