import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;

import 'package:app_drive_v1_0/core/services/api_client.dart';
import 'package:app_drive_v1_0/core/services/storage_service.dart';

/// ✅ Modèle de données pour une question
class Question {
  int id;
  String? img;
  String type;
  String question;
  List<String> response;
  List<bool> state;
  List<int> idResp;

  Question({
    required this.id,
    required this.img,
    required this.type,
    required this.question,
    required this.response,
    required this.state,
    required this.idResp,
  });

  /// 🔄 Créer un objet Question à partir d’un JSON
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      img: json['img'],
      type: json['type'],
      question: json['question'],
      response: List<String>.from(json['response']),
      state: List<bool>.from(json['state']),
      idResp: List<int>.from(json['idResp']),
    );
  }

  /// 🔄 Convertir un objet Question en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'img': img,
      'type': type,
      'question': question,
      'response': response,
      'state': state,
      'idResp': idResp,
    };
  }
}

/// ✅ Contrôleur GetX pour l’édition des questions
class EditController extends GetxController {
  final int id;



  EditController({required this.id});

  /// Liste des questions chargées
  var questions = <Question>[].obs;

  /// Contrôleurs de texte pour les champs des questions
  Map<int, TextEditingController> questionCtrls = {};

  /// Contrôleurs de texte pour les réponses par question
  Map<int, List<TextEditingController>> responseCtrls = {};

  /// Fichiers image sélectionnés pour les questions
  RxMap<int, File> imageFiles = <int, File>{}.obs;

  /// Chargement initial à l'ouverture du contrôleur
  @override
  void onInit() {
    super.onInit();
    loadQuestions();
  }

  /// 🔧 Initialise les TextEditingControllers pour chaque question
  void initControllers(Question q) {
    if (!questionCtrls.containsKey(q.id)) {
      // Contrôleur pour le champ "question"
      final questionController = TextEditingController(text: q.question);
      questionController.addListener(() {
        q.question = questionController.text;
      });
      questionCtrls[q.id] = questionController;

      // Contrôleurs pour les champs "réponses"
      final responseControllers = List.generate(q.response.length, (i) {
        final ctrl = TextEditingController(text: q.response[i]);
        ctrl.addListener(() {
          q.response[i] = ctrl.text;
        });
        return ctrl;
      });

      responseCtrls[q.id] = responseControllers;
    }
  }

  /// 📦 Charge les questions depuis l'API backend
  Future<void> loadQuestions() async {
    try {
      final token = await StorageService.getToken();

      final response = await ApiClient.dio.post(
        '/edit/question',
        queryParameters: {'id': id},
        options: dio.Options(
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
          data['question'],
        ).map((q) => Question.fromJson(q)).toList();

        questions.assignAll(loadedQuestions);
      } else {
        throw Exception('❌ Données invalides ou champ "success" manquant.');
      }
    } catch (e, stackTrace) {
      debugPrint('Erreur dans loadQuestions: $e');
      debugPrintStack(stackTrace: stackTrace);
      throw Exception('❌ Erreur lors du chargement des questions.');
    }
  }

  /// 📸 Sélectionne une image via la caméra ou la galerie
  Future<void> pickImage(
    BuildContext context,
    int qId, {
    bool fromGallery = false,
  }) async {
    final picker = ImagePicker();
    final source = fromGallery ? ImageSource.gallery : ImageSource.camera;
    final picked = await picker.pickImage(source: source);

    if (picked != null) {
      imageFiles[qId] = File(picked.path);
    }
  }

  /// 📉 Compresse une image avant envoi (JPEG 85%)
  Future<File> compressImage(File file) async {
    final bytes = await file.readAsBytes();
    final decodedImage = img.decodeImage(bytes);

    if (decodedImage == null) return file;

    final resized = img.copyResize(decodedImage, width: 800);
    final compressedBytes = img.encodeJpg(resized, quality: 85);
    return await file.writeAsBytes(compressedBytes);
  }

  /// 💾 Envoie la question modifiée à l’API pour sauvegarde
  Future<bool?> saveQuestion(Question q) async {
    try {
      final token = await StorageService.getToken();

        File? fileToSend;
        if (imageFiles[q.id] != null) {
          fileToSend = await compressImage(imageFiles[q.id]!);
        }

      final formData = dio.FormData.fromMap({
        'id': q.id,
        'type': q.type,
        'question': q.question,
        'response': jsonEncode(q.response),
        'state': jsonEncode(q.state),
        'idResp': jsonEncode(q.idResp),
        if (fileToSend != null)
        'image': await dio.MultipartFile.fromFile(
          fileToSend.path,
          filename: 'question_${q.id}.jpg',
        ),
      });

      final response = await ApiClient.dio.post(
        '/update/question',
        data: formData,
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint('❌ Erreur lors de l’enregistrement de la question : $e');
      return false;
    }
  }
}
