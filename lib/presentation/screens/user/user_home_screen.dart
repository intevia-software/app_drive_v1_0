// lib/presentation/screens/admin/admin_home_screen.dart
import 'package:flutter/material.dart';

class UserHomeScreen extends StatelessWidget {
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
              title: Text("Passer le test"),
              onTap: () => Navigator.pushNamed(context, '/test_user'),
            ),
          ],
        ),
      ),
    );
  }
}
