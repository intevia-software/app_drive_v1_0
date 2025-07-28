import 'package:flutter/material.dart';

class ConnexionErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Inscription réussie.")),
      body:  Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Card(
            elevation: 16,
            child: Container(
              padding: const EdgeInsets.all(32.0),
              constraints: const BoxConstraints(maxWidth: 350),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Image.asset(
                      'assets/images/logo.png',
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    
                     _gap(),
                    Center(
                      child: Text(
                        "Problème de connexion au serveur, il est probable que la connexion Internet soit interrompue.",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
        
              ] )
              )
            )
          )
        
        
        
    

        ),
      ),
    );
  }

   Widget _gap() => const SizedBox(height: 16);
}