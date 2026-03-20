import 'dart:convert';
import 'package:edu_smart_bot/services/api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  
  // ✅ Stocker le Future pour éviter les appels multiples
  late Future<List<dynamic>> _futureCourses;

  final String apiUrl = ApiConfig.coursesEndpoint;

  Future<List<dynamic>> fetchCourses() async {
    // ignore: avoid_print
    print("=========================================");
    // ignore: avoid_print
    print("🌐 URL complète: $apiUrl");
    // ignore: avoid_print
    print("=========================================");
    
    try {
      final response = await http.get(Uri.parse(apiUrl)).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          // ignore: avoid_print
          print("⏰ TIMEOUT");
          throw Exception("Délai d'attente dépassé");
        },
      );
      
      // ignore: avoid_print
      print("📡 Status code: ${response.statusCode}");
      // ignore: avoid_print
      print("📦 Response body: ${response.body}");
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // ignore: avoid_print
        print("✅ Données décodées: $data");
        // ignore: avoid_print
        print("📊 Nombre de cours: ${data.length}");
        return data;
      } else {
        // ignore: avoid_print
        print("❌ Erreur HTTP: ${response.statusCode}");
        throw Exception("Erreur serveur: ${response.statusCode}");
      }
    } catch (e) {
      // ignore: avoid_print
      print("❌ Exception: $e");
      throw Exception("Erreur de connexion: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    // ignore: avoid_print
    print("🚀 CoursesScreen initialisée");
    // ignore: avoid_print
    print("📡 URL API configurée: $apiUrl");
    
    // ✅ Initialiser le Future une seule fois
    _futureCourses = fetchCourses();
    
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: Colors.blue.shade100,
      end: Colors.purple.shade100,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  IconData getIcon(String title) {
    switch (title.toLowerCase()) {
      case "java":
        return Icons.code;
      case "php":
        return Icons.language;
      case "sql":
        return Icons.storage;
      case "python":
        return Icons.adb;
      case "flutter":
        return Icons.phone_android;
      default:
        return Icons.school;
    }
  }

  Color getColor(String title) {
    switch (title.toLowerCase()) {
      case "java":
        return Colors.orange;
      case "php":
        return Colors.green;
      case "sql":
        return Colors.pink;
      case "python":
        return Colors.purple;
      case "flutter":
        return Colors.blue;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, _colorAnimation.value!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                )
                              ],
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.black87,
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          "Mes Cours Informatique",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    // ✅ Utiliser le Future stocké
                    child: FutureBuilder(
                      future: _futureCourses,
                      builder: (context, snapshot) {
                        // ignore: avoid_print
                        print("🔍 Snapshot state: ${snapshot.connectionState}");
                        
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 16),
                                Text("Chargement des cours..."),
                              ],
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.error, size: 48, color: Colors.red),
                                const SizedBox(height: 16),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 32),
                                  child: Text(
                                    "Erreur: ${snapshot.error}",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _futureCourses = fetchCourses();
                                    });
                                  },
                                  child: const Text("Réessayer"),
                                ),
                              ],
                            ),
                          );
                        } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
                          return const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.book, size: 48, color: Colors.grey),
                                SizedBox(height: 16),
                                Text("Aucun cours disponible"),
                              ],
                            ),
                          );
                        } else {
                          final courses = snapshot.data as List;
                          // ignore: avoid_print
                          print("🎯 Affichage de ${courses.length} cours");
                          
                          return GridView.builder(
                            padding: const EdgeInsets.all(20),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                              childAspectRatio: 0.9,
                            ),
                            itemCount: courses.length,
                            itemBuilder: (context, index) {
                              final course = courses[index];
                              final title = course["name"] ?? "Cours";
                              final progress = 0.5;
                              final icon = getIcon(title);
                              final color = getColor(title);

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => CourseDetailScreen(
                                        title: title,
                                        icon: icon,
                                        color: color,
                                      ),
                                    ),
                                  );
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 400),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        // ignore: deprecated_member_use
                                        color.withOpacity(0.8),
                                        // ignore: deprecated_member_use
                                        color.withOpacity(0.5),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        // ignore: deprecated_member_use
                                        color: color.withOpacity(0.4),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      )
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(icon, color: Colors.white, size: 32),
                                      const Spacer(),
                                      Text(
                                        title,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      LinearProgressIndicator(
                                        value: progress,
                                        backgroundColor: Colors.white30,
                                        color: Colors.white,
                                        minHeight: 6,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CourseDetailScreen extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const CourseDetailScreen({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            // ignore: deprecated_member_use
            colors: [Colors.white, color.withOpacity(0.3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            )
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.black87,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              const Center(
                child: Text(
                  "Contenu du cours bientôt disponible",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}