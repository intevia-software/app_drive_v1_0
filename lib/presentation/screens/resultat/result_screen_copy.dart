import 'package:flutter/material.dart';
import 'result_controller.dart';
import 'package:app_drive_v1_0/core/services/globals.dart' as globals;

class ResultTestScreen extends StatelessWidget {
  const ResultTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Score : 10/40'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all( 10),
        child: Container(
          padding: const EdgeInsets.all( 10),
          decoration: BoxDecoration(
            color: Colors.blue, // ou une autre couleur si souhaité
            borderRadius: BorderRadius.circular(6),
            //border: BoxBorder.all(color: Colors.blue),
          ),
          child: Row(
            children: [
              Text(
                "Les règles de circulation : ",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              Spacer(),
              Text(
                " 10 / 10",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
