import 'package:flutter/material.dart';
import 'package:app_drive_v1_0/presentation/screens/response/response_controller.dart';

class ResponseScreen extends StatefulWidget {
  const ResponseScreen({super.key});
  @override
  _ResponseScreenState createState() => _ResponseScreenState();
}

class _ResponseScreenState extends State<ResponseScreen> {
  final Response = ResponseController();
  List<TextEditingController> _responseControllers = List.generate(
    3,
    (_) => TextEditingController(),
  );
  List<bool> _responsesChecked = [false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter une réponse')),
      body: FutureBuilder<List<dynamic>>(
        future: Response.fetchPendingUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucun utilisateur trouvé'));
          } else {
            final questions = snapshot.data!;

            return ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final question = questions[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            'https://driving.ovh/images/questions/${question['img'] ?? ''}',
                            width: double.infinity,
                            height: 180,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image, size: 60),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Type
                        Text(
                          'Type : ${question['type'] ?? 'Inconnu'}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),

                        const SizedBox(height: 6),

                        // Question
                        Text(
                          question['question'] ?? 'Pas de question',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Formulaire
                        Column(
                          children: List.generate(3, (i) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Row(
                                children: [
                                  // Champ texte
                                  Expanded(
                                    child: TextFormField(
                                      controller: _responseControllers[i],
                                      decoration: InputDecoration(
                                        
                                        labelText: 'Réponse ${i + 1}',
                                        hintText: 'Entrez votre adresse e-mail',
                                        border: OutlineInputBorder(),
                                        hintStyle: TextStyle(color: Colors.grey),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.blue,
                                            width: 1.0,
                                          ),
                                        ),
                                        labelStyle: TextStyle(color: Colors.grey),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  // Checkbox
                                  Transform.scale(
                                    scale: 1,
                                    
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.blue, width: 1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Transform.scale(
                                        scale: 1.5,
                                        
                                          child: Checkbox(
                                            value: _responsesChecked[i],
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(10.0))
                                            ),
                                            onChanged: (value) {
                                              if (value == null) return;
                                              setState(() {
                                                _responsesChecked[i] = value;
                                              });
                                            },
                                            checkColor: Colors.transparent,
                                            activeColor: Colors.blue,
                                          ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),

                          _gap(),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (states.contains(MaterialState.pressed)) {
                                      return const Color.fromARGB(255, 185, 220, 249); // Pressed color
                                    }
                                    return Colors.blue; // Default color
                                  },
                                ),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                for (int i = 0; i < _responseControllers.length; i++) {
                                  String text = _responseControllers[i].text.trim();
                                  bool isChecked = _responsesChecked[i];

                                  if (text.isNotEmpty) {
                                    try {
                                      await Response.postResponse(
                                        text,
                                        isChecked,
                                        question['id'],
                                      );
                                    } catch (e) {
                                      print('Erreur lors de l\'envoi de la réponse $i: $e');
                                    }
                                  } else {
                                    print('⚠️ La réponse $i est vide.');
                                  }
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  'Continuer',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),

                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

   Widget _gap() => const SizedBox(height: 16);
}
