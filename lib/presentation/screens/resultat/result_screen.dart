import 'package:flutter/material.dart';
import 'result_controller.dart';

class ResultScreen extends StatelessWidget {
  final ResultController controller;

  const ResultScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    // === Calcule score par type ===
    final Map<String, int> totalByType = {};
    final Map<String, int> correctByType = {};

    for (var item in controller.correctedResponses) {
      final type = item['type'] ?? 'Autre';

      totalByType[type] = (totalByType[type] ?? 0) + 1;

      final correctState = List<bool>.from(item['correctState']);
      final userState = List<bool>.from(item['state']);

      bool isCorrect = true;
      for (int i = 0; i < correctState.length; i++) {
        if (correctState[i] != userState[i]) {
          isCorrect = false;
          break;
        }
      }

      if (isCorrect) {
        correctByType[type] = (correctByType[type] ?? 0) + 1;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Score : ${controller.score}/${controller.responses.length}'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // ==== Résumé des scores par type ====
          ...totalByType.keys.map((type) {
            final correct = correctByType[type] ?? 0;
            final total = totalByType[type]!;
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                "$type : $correct / $total",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.blueGrey,
                ),
              ),
            );
          }),
          const Divider(thickness: 1.5, height: 32),
          // ==== Questions + réponses corrigées ====
          ...controller.correctedResponses.map((item) {
            final question = item['question'];
            final responses = item['response'];
            final userState = List<bool>.from(item['state']);
            final correctState = List<bool>.from(item['correctState']);
            final image = item['img'];

            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (image != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          "https://driving.ovh/images/questions/$image",
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                        ),
                      ),
                    const SizedBox(height: 10),
                    Text(
                      question,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: responses.length,
                      itemBuilder: (context, i) {
                        final answer = responses[i];
                        final userSelected = userState[i];
                        final correct = correctState[i];

                        Color tileColor;
                        if (correct && userSelected) {
                          tileColor = Colors.green[300]!;
                        } else if (!correct && userSelected) {
                          tileColor = Colors.red[300]!;
                        } else if (correct && !userSelected) {
                          tileColor = Colors.yellow[300]!;
                        } else {
                          tileColor = Colors.grey[200]!;
                        }

                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: tileColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                correct
                                    ? Icons.check_circle
                                    : userSelected
                                        ? Icons.cancel
                                        : Icons.radio_button_unchecked,
                                color: correct
                                    ? Colors.green
                                    : userSelected
                                        ? Colors.red
                                        : Colors.grey,
                              ),
                              const SizedBox(width: 10),
                              Expanded(child: Text(answer)),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
