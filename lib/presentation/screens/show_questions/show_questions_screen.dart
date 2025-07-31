import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_drive_v1_0/presentation/screens/edit/edit_screen.dart';
import 'show_questions_controller.dart';
import 'package:app_drive_v1_0/core/services/globals.dart' as globals;
class ShowQuestionsScreen extends StatefulWidget {
  const ShowQuestionsScreen({super.key});

  @override
  State<ShowQuestionsScreen> createState() => _ShowQuestionsScreenState();
}

class _ShowQuestionsScreenState extends State<ShowQuestionsScreen> {
  late ShowQuestionsController controller;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    controller = Get.put(ShowQuestionsController(id: 1)); // ou autre ID selon besoin

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        // On arrive proche du bas => charger plus si possible
        controller.loadQuestions(loadMore: true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des questions'),
      ),
      body: Obx(() {
        if (controller.questions.isEmpty && controller.isLoadingMore) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          controller: _scrollController,
          itemCount: controller.questions.length + (controller.isLastPage ? 0 : 1),
          itemBuilder: (context, index) {
            if (index == controller.questions.length) {
              // Affiche un loader en bas pendant le chargement
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
                
              );
            }

            final q = controller.questions[index];
            return Card(
              
              elevation: 4,
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
                
              ),
              
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                
                child: Column(
                  
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    if (q.img != null && q.img!.isNotEmpty)
                    Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue, width: 2), // ✅ Bordure bleue
                            borderRadius: BorderRadius.circular(6),
                          ),

                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(1),
                        child: Image.network(
                          '${globals.domaine}/images/questions/${q.img}',
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.image_not_supported),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Question dans un container noir arrondi avec texte blanc
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      width: 1000,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Text(
                        q.question,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: q.response.length,
                      itemBuilder: (context, i) {
                        final isCorrect = q.state[i];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: isCorrect ? Colors.blue[100] :  Colors.grey[100],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isCorrect ? Icons.check_circle : Icons.circle_outlined,
                                color: isCorrect ? Colors.blue : Colors.black,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  q.response[i],
                                  style: TextStyle(
                                    color: isCorrect ? Colors.black87 : Colors.black87,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 10),

                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditScreen(
                                id: q.id,
                              ),
                            ),
                          ).then((shouldReload) {
                            if (shouldReload == true) {
                              controller.page = 1;
                              controller.isLastPage = false;
                              controller.questions.clear(); // vide l’ancienne liste
                              controller.loadQuestions();   // recharge depuis le début
                            }
                          });
                        },
                        child: const Text('Editer'),
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
