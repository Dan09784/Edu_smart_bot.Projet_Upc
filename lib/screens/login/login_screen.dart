import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController matriculeController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "EduSmartBot",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            TextField(
              controller: matriculeController,
              decoration: const InputDecoration(
                labelText: "Matricule / Email",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Mot de passe",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                final id = matriculeController.text.trim();

                if (id.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Veuillez entrer un identifiant")),
                  );
                  return;
                }

                if (id.startsWith("ETU")) {
                  Navigator.pushReplacementNamed(context, '/student');
                } 
                else if (id.startsWith("PROF")) {
                  Navigator.pushReplacementNamed(context, '/teacher');
                } 
                else if (id.startsWith("ADMIN")) {
                  Navigator.pushReplacementNamed(context, '/admin');
                } 
                else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Identifiant invalide")),
                  );
                }
              },
              child: const Text("Se connecter"),
            ),
          ],
        ),
      ),
    );
  }
}
