import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:app_drive_v1_0/core/services/api_client.dart';
import 'package:app_drive_v1_0/core/services/storage_service.dart';

/// ✅ Modèle de données pour une question
class Question {
  final int id;
  final String? img;
  final String type;
  final String question;
  final List<String> response;
  final List<bool> state;

  Question({
    required this.id,
    required this.img,
    required this.type,
    required this.question,
    required this.response,
    required this.state,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      img: json['img'],
      type: json['type'],
      question: json['question'],
      response: List<String>.from(json['response']),
      state: List<bool>.from(json['state']),
    );
  }
}

/// ✅ Contrôleur pour l'affichage des questions avec pagination
class ShowQuestionsController extends GetxController {
  final int id; // <-- ID reçu par le contrôleur
  ShowQuestionsController({required this.id});

  var questions = <Question>[].obs;
  int page = 1;
  bool isLastPage = false;
  bool isLoadingMore = false;

  @override
  void onInit() {
    super.onInit();
    loadQuestions(); // Chargement initial
  }

  /// 📦 Charge les questions avec support de pagination
  Future<void> loadQuestions({bool loadMore = false}) async {
    if (isLoadingMore || isLastPage) return;

    try {
      isLoadingMore = true;
      final token = await StorageService.getToken();

      final response = await ApiClient.dio.get(
        '/show/questions',
        queryParameters: {
          'page': page,
          'nombre': 10,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      final data = response.data is String
          ? json.decode(response.data)
          : response.data;

      if (response.statusCode == 200 && data['success'] == true) {
        final List<Question> loadedQuestions = List<Map<String, dynamic>>.from(
          data['questions'], // ✅ ici, pas 'question'
        ).map((q) => Question.fromJson(q)).toList();

        if (loadMore) {
          questions.addAll(loadedQuestions);
        } else {
          questions.assignAll(loadedQuestions);
        }

        // ✅ Mise à jour après le traitement
        final int totalPages = data['totalPages'] ?? 1;
        isLastPage = page >= totalPages;

        page++; // Incrément à la fin
      } else {
        throw Exception('❌ Données invalides ou champ "success" manquant.');
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Erreur dans loadQuestions: $e');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      isLoadingMore = false;
    }
  }

}
