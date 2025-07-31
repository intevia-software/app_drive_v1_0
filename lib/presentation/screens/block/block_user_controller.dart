// lib/presentation/screens/validate/validate_controller.dart
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:app_drive_v1_0/core/services/api_client.dart';
import 'package:app_drive_v1_0/core/services/storage_service.dart';

class BlockUserController extends ChangeNotifier {
  bool isLoading = false;
  final _token = StorageService.getToken();

  Future<List<dynamic>> fetchPendingUsers() async {

    final response = await ApiClient.dio.get(
      '/users',
      queryParameters: {
        'confirmation_is_null': true, // confirmationToken == null
        'accepted_is_null': false, // isAccepted == null
        'role_is_admin': false,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $_token',
          'Accept': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200) {
      final data = response.data;
      //print(data);
      return data; // Clé standard d’API Platform Hydra pour la liste
    } else {
      throw Exception('Erreur lors du chargement des utilisateurs');
    }
  }


  Future<void> acceptUser(String userId) async {
  try {
    final response = await ApiClient.dio.patch(
      '/users/$userId',
      data: {'confirmationToken': "block"},
      options: Options(
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/merge-patch+json',
        },
      ),
    );

    print('✅ Utilisateur accepté: ${response.data}');
  } catch (e) {
    print('❌ Erreur acceptation: $e');
    throw Exception('Erreur lors de l\'acceptation de l\'utilisateur');
  }
}
}
