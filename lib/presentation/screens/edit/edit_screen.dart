import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'edit_controller.dart';
import 'package:app_drive_v1_0/core/services/globals.dart' as globals;
import 'package:getwidget/getwidget.dart';

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
    controller = Get.put(
      EditController(id: widget.id),
      tag: widget.id.toString(),
    );
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
              //color: const Color.fromARGB(255, 245, 248, 251),
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
                                    onTap: () =>
                                        controller.pickImage(context, q.id),
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.image),
                                    title: const Text('Depuis la galerie'),
                                    onTap: () => controller.pickImage(
                                      context,
                                      q.id,
                                      fromGallery: true,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },

                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blue,
                            width: 2,
                          ), // ✅ Bordure bleue
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
                                        borderRadius: BorderRadius.circular(4),
                                        child: Image.network(
                                          '${globals.domaine}/images/questions/${q.img}',
                                          height: 180,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              const Icon(
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
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        padding: const EdgeInsets.only(left: 20),
                        decoration: BoxDecoration(
                          color: Colors.grey[200], // ou une autre couleur si souhaité
                          borderRadius: BorderRadius.circular(6),
                          //border: BoxBorder.all(color: Colors.blue),
                        ),

                        child: DropdownButtonFormField<String>(
                          value: q.type,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 12.0,
                            ),
                            border: InputBorder.none,
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
                      ),
                    ),

                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        padding: const EdgeInsets.only(left: 20),
                        decoration: BoxDecoration(
                          color: Colors.grey[200], // ou une autre couleur si souhaité
                          borderRadius: BorderRadius.circular(6),
                          //border: BoxBorder.all(color: Colors.blue),
                        ),

                        child: TextFormField(
                          controller: questionCtrl,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 12.0,
                            ),
                            border: InputBorder.none,
                          ),
                          maxLines: null,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: q.response.length,
                      itemBuilder: (context, i) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Container(
                            padding: const EdgeInsets.only(left: 20),
                            decoration: BoxDecoration(
                              color:  Colors.grey[200], // ou une autre couleur si souhaité
                              borderRadius: BorderRadius.circular(6),
                              //border: BoxBorder.all(color: Colors.blue),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: responseCtrls[i],
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 8.0,
                                        horizontal: 12.0,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16),
                                Transform.scale(
                                  scale: 1.3,
                                  child: Theme(
                                    data: Theme.of(context).copyWith(
                                      unselectedWidgetColor: Colors.blue,
                                      checkboxTheme: CheckboxThemeData(
                                        shape: CircleBorder(),
                                        side: BorderSide(
                                          color: Colors.blue,
                                          width: 1,
                                        ),
                                        fillColor:
                                            MaterialStateProperty.resolveWith<
                                              Color
                                            >((states) {
                                              if (states.contains(
                                                MaterialState.selected,
                                              )) {
                                                return Colors.blue;
                                              }
                                              return Colors.transparent;
                                            }),
                                        checkColor: MaterialStateProperty.all(
                                          Colors.transparent,
                                        ),
                                      ),
                                    ),
                                    child: Checkbox(
                                      value: q.state[i],
                                      onChanged: (value) {
                                        q.state[i] = value ?? false;
                                        controller.questions.refresh();
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
