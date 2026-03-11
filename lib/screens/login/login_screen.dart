import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {

  final TextEditingController matriculeController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  bool obscure = true;

  late AnimationController floatController;
  late Animation<double> floatAnimation;

  late AnimationController appearController;
  late Animation<double> fade;
  late Animation<Offset> slide;

  /// TA LOGIQUE LOGIN (inchangée)
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Rôle inconnu: $role")),
            );
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
  void initState() {
    super.initState();

    /// animation logo flottant
    floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    floatAnimation = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: floatController, curve: Curves.easeInOut),
    );

    /// animation apparition écran
    appearController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    fade = Tween<double>(begin: 0, end: 1).animate(appearController);

    slide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: appearController,
      curve: Curves.easeOut,
    ));

    appearController.forward();
  }

  @override
  void dispose() {
    floatController.dispose();
    appearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [

          /// IMAGE DE FOND
          Positioned.fill(
            child: Image.asset(
              'lib/assets/lottie/InscripBack.JPG',
              fit: BoxFit.cover,
            ),
          ),

          /// OVERLAY SOMBRE
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  // ignore: deprecated_member_use
                  Colors.black.withOpacity(0.65),
                  // ignore: deprecated_member_use
                  Colors.black.withOpacity(0.2),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),

          /// LOGIN CARD
          Center(
            child: FadeTransition(
              opacity: fade,
              child: SlideTransition(
                position: slide,
                child: Padding(
                  padding: const EdgeInsets.all(25),

                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),

                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),

                      child: Container(
                        width: 360,
                        padding: const EdgeInsets.all(28),

                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            // ignore: deprecated_member_use
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),

                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            /// LOGO FLOTTANT
                            AnimatedBuilder(
                              animation: floatAnimation,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(0, floatAnimation.value),
                                  child: child,
                                );
                              },
                              child: Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(22),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xffFF416C),
                                      Color(0xffFF4B2B),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      // ignore: deprecated_member_use
                                      color: Colors.red.withOpacity(0.4),
                                      blurRadius: 25,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.school,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            Text(
                              "EduSmartBot",
                              style: GoogleFonts.poppins(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(height: 30),

                            /// EMAIL
                            TextField(
                              controller: matriculeController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                filled: true,
                                // ignore: deprecated_member_use
                                fillColor: Colors.white.withOpacity(0.08),
                                prefixIcon: const Icon(Icons.person, color: Colors.white),
                                hintText: "Matricule / Email",
                                hintStyle: const TextStyle(color: Colors.white54),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),

                            const SizedBox(height: 18),

                            /// PASSWORD
                            TextField(
                              controller: passwordController,
                              obscureText: obscure,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                filled: true,
                                // ignore: deprecated_member_use
                                fillColor: Colors.white.withOpacity(0.08),
                                prefixIcon: const Icon(Icons.lock, color: Colors.white),

                                suffixIcon: IconButton(
                                  icon: Icon(
                                    obscure ? Icons.visibility : Icons.visibility_off,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      obscure = !obscure;
                                    });
                                  },
                                ),

                                hintText: "Mot de passe",
                                hintStyle: const TextStyle(color: Colors.white54),

                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),

                            const SizedBox(height: 25),

                            /// BOUTON LOGIN
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: login,

                                style: ElevatedButton.styleFrom(
                                  elevation: 10,
                                  // ignore: deprecated_member_use
                                  shadowColor: Colors.red.withOpacity(0.5),
                                  backgroundColor: const Color(0xffFF416C),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),

                                child: isLoading
                                    ? const CircularProgressIndicator(color: Colors.white)
                                    : const Text(
                                        "Se connecter",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          letterSpacing: 1,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}