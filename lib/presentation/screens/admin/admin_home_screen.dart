// lib/presentation/screens/admin/admin_home_screen.dart
import 'package:flutter/material.dart';

class AdminHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin Dashboard")),
      body: Center(child: Text("Bienvenue Admin")),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(child: Text("Menu")),
            ListTile(
              title: Text("Liste des questions"),
              onTap: () => Navigator.pushNamed(context, '/show_questions'),
            ),
            ListTile(
              title: Text("Passer le test"),
              onTap: () => Navigator.pushNamed(context, '/test_admin'),
            ),
            ListTile(
              title: Text("Valider inscription"),
              onTap: () => Navigator.pushNamed(context, '/validate'),
            ),
            ListTile(
              title: Text("Ajouter une question"),
              onTap: () => Navigator.pushNamed(context, '/put_question'),
            ),
            ListTile(
              title: Text("Ajouter une reponse"),
              onTap: () => Navigator.pushNamed(context, '/put_response'),
            ),
            ListTile(
              title: Text("Déconnexion"),
              onTap: () => Navigator.pushReplacementNamed(context, '/'),
            ),
          ],
        ),
      ),
    );
  }
}
