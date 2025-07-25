import 'package:flutter/material.dart';
import 'login_controller.dart';
import 'package:provider/provider.dart';


class LoginScreen extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<LoginController>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _emailController, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: _passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
            const SizedBox(height: 20),
            if (controller.isLoading)
              CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: () => controller.login(
                  _emailController.text,
                  _passwordController.text,
                ),
                child: Text('Login'),
              ),
            if (controller.error != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(controller.error!, style: TextStyle(color: Colors.red)),
              ),
          ],
        ),
      ),
    );
  }
}