import 'dart:io';
import 'package:app_drive_v1_0/presentation/screens/show_questions/show_questions_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'edit_controller.dart';
import 'package:app_drive_v1_0/core/services/globals.dart' as globals;

class EditScreen extends StatefulWidget {
  final int id;

  const EditScreen({Key? key, required this.id}) : super(key: key);

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late EditController controller;

  @override
  void initState() {
    super.initState();
    // Crée ou récupère le controller en le taggant par l'id pour éviter conflits
    controller = Get.put(EditController(id: widget.id), tag: widget.id.toString());
  }

  @override
  void dispose() {
    // Supprime proprement le controller quand la page est détruite
    Get.delete<EditController>(tag: widget.id.toString());
    super.dispose();
  }

  final ImagePicker picker = ImagePicker();

  final List<String> _types = [
    'Les règles de circulation',
    'La sécurité routière',
    'La mécanique et l’entretien',
    'Les situations pratiques',
    'Les règles spécifiques',
    'Le comportement du conducteur',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modifier les questions')),
      body: Obx(() {
        if (controller.questions.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: controller.questions.length,
          itemBuilder: (context, index) {
            final q = controller.questions[index];

            // Initialisation des TextEditingControllers persistants
            controller.initControllers(q);

            final questionCtrl = controller.questionCtrls[q.id]!;
            final responseCtrls = controller.responseCtrls[q.id]!;

            return Card(
              color:const Color.fromARGB(255, 245, 248, 251),
              elevation: 4,
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final source = await showModalBottomSheet<ImageSource>(
                          context: context,
                          builder: (_) {
                            return SafeArea(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.camera_alt),
                                    title: const Text('Prendre une photo'),
                                    onTap: () => controller.pickImage(context, q.id),
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.image),
                                    title: const Text('Depuis la galerie'),
                                    onTap: () => controller.pickImage(context, q.id, fromGallery: true),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },

                       child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue, width: 2), // ✅ Bordure bleue
                            borderRadius: BorderRadius.circular(6),
                          ),
                        child: Obx(() {
                          final file = controller.imageFiles[q.id];
                          
                          return file != null
                              ? Image.file(
                                  file,
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                )
                              : (q.img != null && q.img!.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(1),
                                      child: Image.network(
                                        '${globals.domaine}/images/questions/${q.img}',
                                        height: 180,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => const Icon(
                                          Icons.image_not_supported,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      height: 180,
                                      color: Colors.grey[200],
                                      child: const Center(
                                        child: Icon(Icons.image, size: 60),
                                      ),
                                    ));
                        
                        }),
                       ),
                    ),

                    const SizedBox(height: 30),

                    DropdownButtonFormField<String>(
                      value: q.type,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                        labelText: 'Type de question',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 1.0,
                          ),
                        ),
                      ),
                      items: _types.map((String type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          q.type = value;
                          controller.questions.refresh();
                        }
                      },
                    ),

                    const SizedBox(height: 10),

                    TextFormField(
                      controller: questionCtrl,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                        labelText: 'Question',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 1.0,
                          ),
                        ),
                      ),
                      maxLines: null,
                      
                    ),

                    const SizedBox(height: 30),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: q.response.length,
                      itemBuilder: (context, i) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: responseCtrls[i],
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                                    labelText: 'Réponse ${i + 1}',
                                    border: const OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.blue,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                               Transform.scale(
                                    scale: 1,
                                    
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.blue, width: 1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Transform.scale(
                                        scale: 1.5,
                                        child: Transform.scale(
                                          scale: 1.5,
                                          child: Checkbox(
                                            value: q.state[i],
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(10.0))
                                            ),
                                            onChanged: (value) {
                                              q.state[i] = value ?? false;
                                              controller.questions.refresh();
                                            },
                                             checkColor: Colors.transparent,
                                            activeColor: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                             
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 12),

                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.save),
                        label: const Text('Sauvegarder'),
                        onPressed: () async {
                          final success = await controller.saveQuestion(q);

                          if (success == true) {
                           Navigator.pop(context, true);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
