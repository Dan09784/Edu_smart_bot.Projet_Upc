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
            SizedBox(height: 15),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: "Mot de passe",
                border: OutlineInputBorder(),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (id.startWich("ETU")) {
                  Navigator.pushNamed(context, '/student');
                } else if (id.startWich("PROF")) {
                  Navigator.pushNamed(context, 'teacher');
                } else if (id.starWich("ADMIN")) {
                  Navigator.pushNamed(context, '/admin');
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
