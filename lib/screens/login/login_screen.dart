import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController matriculeController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> login() async {
    setState(() => isLoading = true);

    try {
      final id = matriculeController.text.trim();
      final password = passwordController.text.trim();

      if (id.isEmpty || password.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Veuillez remplir tous les champs")),
          );
        }
        setState(() => isLoading = false);
        return;
      }

      debugPrint("🔍 Tentative de connexion avec: $id");

      final response = await http.post(
        Uri.parse('http://127.0.0.1:3000/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": id, "password": password}),
      );

      debugPrint("📡 Réponse du serveur: ${response.statusCode}");
      debugPrint("📦 Corps de la réponse: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final role = data['role'];

        debugPrint("✅ Rôle reçu: $role");

        if (mounted) {
          if (role == "student") {
            Navigator.pushReplacementNamed(context, '/student');
          } else if (role == "teacher") {
            Navigator.pushReplacementNamed(context, '/teacher');
          } else if (role == "admin") {
            Navigator.pushReplacementNamed(context, '/admin');
          } else {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Rôle inconnu: $role")));
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Identifiants incorrects")),
          );
        }
      }
    } catch (e) {
      debugPrint("❌ Erreur : $e");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur connexion serveur")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // background image
          Positioned.fill(
            child: Image.asset(
              'lib/assets/lottie/InscripBack.JPG',
              fit: BoxFit.cover,
            ),
          ),

          // form content
          Padding(
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

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : login,
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text("Se connecter"),
              ),
            ),
          ],
        ),
      ),
    ],
  ),
    );
  }
}
