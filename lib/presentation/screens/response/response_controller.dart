// lib/presentation/screens/Response/Response_controller.dart
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:app_drive_v1_0/core/services/api_client.dart';
import 'package:app_drive_v1_0/core/services/storage_service.dart';

class ResponseController extends ChangeNotifier {
  bool isLoading = false;
  final _token = StorageService.getToken();

  Future<List<dynamic>> fetchPendingUsers() async {
    final response = await ApiClient.dio.get(
      '/questions/without/responses',

      options: Options(
        headers: {
          'Authorization': 'Bearer $_token',
          'Accept': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200) {
      final data = response.data;
      return data; // Clé standard d’API Platform Hydra pour la liste
    } else {
      throw Exception('Erreur lors du chargement des utilisateurs');
    }
  }

 Future<void> postResponse(String text, bool isValid, int questionId) async {
    try {
      final response = await ApiClient.dio.post(
        '/responses/put/response',
        data: {
          'response': text,
          'isValid': isValid,
          'question': questionId, // Clé étrangère au format JSON:API ou API Platform
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $_token',
            'Content-Type': 'application/json',
          },
        ),
      );

      print('✅ Réponse envoyée: ${response.data}');
    } catch (e) {
      print('❌ Erreur envoi réponse: $e');
      throw Exception('Erreur lors de l\'envoi de la réponse');
    }
  }

}
