import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app_drive_v1_0/core/services/api_client.dart';

class QuestionController extends ChangeNotifier {
  File? _imageFile;
  File? get imageFile => _imageFile;

  Future<File> compressImage(File file) async {
    final bytes = await file.readAsBytes();
    final image = img.decodeImage(bytes);
    if (image == null) return file; // Au cas où ça échoue, renvoie l'original

    final resized = img.copyResize(image, width: 800); // largeur max 800px

    final compressedBytes = img.encodeJpg(
      resized,
      quality: 85,
    ); // qualité à 85%

    final compressedFile = await file.writeAsBytes(compressedBytes);

    return compressedFile;
  }

  Future<void> pickImage(BuildContext context) async {
    final picker = ImagePicker();

    final pickedFile = await showModalBottomSheet<XFile?>(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Prendre une photo"),
              onTap: () async {
                final picked = await picker.pickImage(
                  source: ImageSource.camera,
                );
                Navigator.pop(context, picked);
              },
            ),
            ListTile(
              leading: const Icon(Icons.folder),
              title: const Text("Importer depuis la galerie"),
              onTap: () async {
                final picked = await picker.pickImage(
                  source: ImageSource.gallery,
                );
                Navigator.pop(context, picked);
              },
            ),
          ],
        ),
      ),
    );

    if (pickedFile != null) {
      File file = File(pickedFile.path);
      file = await compressImage(file); // compresse l'image avant assignation
      _imageFile = file;
      notifyListeners();
    }
  }


  void clearImage() {
    _imageFile = null;
    notifyListeners();
  }


  Future<bool> submitQuestion({
    required BuildContext context,
    required String question,
    required String type,
    required String token,
  }) async {
    if (_imageFile == null) {
      print('❌ Erreur : aucune image sélectionnée.');
      return false;
    }

    print('✅ Image sélectionnée.');

    try {
      final formData = FormData.fromMap({
        'question': question,
        'type': type,
        'imageFile': await MultipartFile.fromFile(
          _imageFile!.path,
          filename: _imageFile!.path.split('/').last,
        ),
      });

      final response = await ApiClient.dio.post(
        '/questions/put/question',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
          contentType: 'multipart/form-data',
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Question soumise avec succès.');
        return true;
      } else {

        Navigator.pushNamed(context, '/error_connexion');
        print('❌ Erreur serveur : ${response.statusCode}');
        return false;
      }
    } catch (e) {
      Navigator.pushNamed(context, '/error_connexion');
      print('❌ Exception lors de l\'envoi de la question : $e');
      return false;
    }
  }

}
