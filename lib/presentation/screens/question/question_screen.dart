
import 'package:flutter/material.dart';
import 'package:app_drive_v1_0/presentation/screens/question/question_controller.dart';
import 'package:app_drive_v1_0/core/services/storage_service.dart';

class QuestionScreen extends StatefulWidget {
  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  String? _selectedType;
  late final QuestionController _controller;
  final _token = StorageService.getToken();

  final List<String> _types = [
    'Les règles de circulation',
    'La sécurité routière',
    'La mécanique et l’entretien',
    'Les situations pratiques',
    'Les règles spécifiques',
    'Le comportement du conducteur',
  ];

  @override
  void initState() {
    super.initState();
    _controller = QuestionController();
    _controller.addListener(() {
      setState(() {// Utilise le getter public
      });
    });
  }

  @override
  void dispose() {
    _questionController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_controller.imageFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veuillez ajouter une image.')),
        );
        return;
      }

      if (_token != null ) {
        final success = await _controller.submitQuestion(
          context: context,
          question: _questionController.text.trim(),
          type: _selectedType ?? '',
          token: _token,
        );

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Question soumise avec succès.')),
          );
          _resetForm();
        }
      }
    }
  }

  void _resetForm() {
  _formKey.currentState?.reset();
  _questionController.clear();
  _selectedType = null;
  _controller.clearImage(); // 👈 tu dois créer cette méthode dans QuestionController
  setState(() {}); // Pour forcer la mise à jour visuelle
}

  @override
  Widget build(BuildContext context) {
    final imageFile = _controller.imageFile;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter une question"),
        leading: const BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Image preview
              GestureDetector(
                onTap: () => _controller.pickImage(context),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: imageFile != null
                        ? Image.file(
                            imageFile,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          )
                        : Container(
                            color: Colors.grey[100],
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_a_photo,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "Appuyez pour ajouter une image",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Question field
              TextFormField(
                controller: _questionController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une question.';
                  }
                  if (value.length < 6) {
                    return 'La question doit contenir au moins 6 caractères.';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  labelText: 'Question',
                  hintText: 'Entrez votre question',
                  prefixIcon: Icon(Icons.question_answer, color: Colors.grey),
                  border: OutlineInputBorder(),
                  hintStyle: TextStyle(color: Colors.grey),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 1.0),
                  ),
                  labelStyle: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 16),

              // Dropdown du type de question
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  labelText: 'Type de question',
                  border: OutlineInputBorder(),
                ),
                value: _selectedType,
                items: _types.map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Veuillez sélectionner un type.' : null,
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _submitForm,
                child: const Text("Soumettre"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
