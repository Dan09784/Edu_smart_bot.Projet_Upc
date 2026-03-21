// ignore_for_file: deprecated_member_use, avoid_print

import 'dart:convert';
import 'package:edu_smart_bot/services/api_config.dart';
import 'package:edu_smart_bot/screens/student/courses_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StudentHome extends StatefulWidget {
  final Map<String, dynamic> user;
  
  const StudentHome({super.key, required this.user});

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  int _currentIndex = 0;
  int _totalCourses = 0;
  double _globalProgress = 0.0;
  bool _isLoading = true;
  String _studentName = "";

  @override
  void initState() {
    super.initState();
    
    // AFFICHER LES DONNÉES REÇUES
    print("=========================================");
    print("📦 Données utilisateur reçues: ${widget.user}");
    print("👤 Nom: ${widget.user['name']}");
    print("🆔 ID: ${widget.user['id']}");
    print("👔 Rôle: ${widget.user['role']}");
    print("=========================================");
    
    // Récupérer le nom
    _studentName = widget.user['name'] ?? "Étudiant";
    
    // Si le nom est null ou vide, essayer d'autres clés possibles
    if (_studentName == "Étudiant" && widget.user['fullname'] != null) {
      _studentName = widget.user['fullname'];
    }
    if (_studentName == "Étudiant" && widget.user['full_name'] != null) {
      _studentName = widget.user['full_name'];
    }
    
    print("✅ Nom final utilisé: $_studentName");
    
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    try {
      // Récupérer le nombre total de cours
      final coursesResponse = await http.get(
        Uri.parse(ApiConfig.coursesEndpoint),
      );
      
      if (coursesResponse.statusCode == 200) {
        final courses = jsonDecode(coursesResponse.body);
        _totalCourses = courses.length;
      }

      // Récupérer la progression de l'étudiant
      final studentId = widget.user['id'];
      final progressResponse = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/progress/student/$studentId'),
      );
      
      if (progressResponse.statusCode == 200) {
        final progressData = jsonDecode(progressResponse.body);
        if (progressData.isNotEmpty) {
          double totalProgress = 0;
          for (var p in progressData) {
            totalProgress += p['percentage'] ?? 0;
          }
          _globalProgress = totalProgress / progressData.length;
        }
      }
    } catch (e) {
      print("❌ Erreur chargement dashboard: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          "EduSmartBot",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.blue.shade100,
            child: Text(
              _studentName.isNotEmpty ? _studentName[0].toUpperCase() : "?",
              style: TextStyle(
                color: Colors.blue.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),

      body: Column(
        children: [
          /// HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3A7BFF), Color(0xFF6A9CFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(35),
                bottomRight: Radius.circular(35),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Bonjour $_studentName 👋",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Prêt à apprendre aujourd'hui ?",
                  style: TextStyle(color: Colors.white70, fontSize: 15),
                ),
                const SizedBox(height: 22),

                /// PROGRESSION
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Progression globale",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (_isLoading)
                        const LinearProgressIndicator(
                          backgroundColor: Colors.white30,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      else
                        LinearProgressIndicator(
                          value: _globalProgress,
                          minHeight: 8,
                          backgroundColor: Colors.white30,
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      const SizedBox(height: 8),
                      Text(
                        _isLoading 
                            ? "Chargement..." 
                            : "${(_globalProgress * 100).toInt()}% des cours terminés",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          /// STATS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _statCard(
                  title: "$_totalCourses",
                  subtitle: "Cours disponibles",
                  icon: Icons.book,
                  color: const Color(0xFF3A7BFF),
                ),
                const SizedBox(width: 16),
                _statCard(
                  title: "${(_globalProgress * 100).toInt()}%",
                  subtitle: "Progression",
                  icon: Icons.trending_up,
                  color: Colors.green,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// GRID DASHBOARD
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                children: [
                  dashboardCard(
                    icon: Icons.school,
                    title: "Mes cours",
                    color: const Color(0xFF3A7BFF),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CoursesScreen(),
                        ),
                      );
                    },
                  ),
                  dashboardCard(
                    icon: Icons.quiz,
                    title: "Quiz",
                    color: Colors.orange,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Quiz bientôt disponible")),
                      );
                    },
                  ),
                  dashboardCard(
                    icon: Icons.smart_toy,
                    title: "Chat IA",
                    color: Colors.purple,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Chat IA bientôt disponible")),
                      );
                    },
                  ),
                  dashboardCard(
                    icon: Icons.person,
                    title: "Profil",
                    color: Colors.green,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Profil bientôt disponible")),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: const Color(0xFF3A7BFF),
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CoursesScreen()),
              );
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil"),
            BottomNavigationBarItem(icon: Icon(Icons.book), label: "Cours"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
          ],
        ),
      ),
    );
  }

  Widget _statCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dashboardCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.9, end: 1),
      duration: const Duration(milliseconds: 400),
      builder: (context, double value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: Material(
        borderRadius: BorderRadius.circular(22),
        elevation: 8,
        shadowColor: Colors.black12,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        // ignore: deprecated_member_use
                        color.withOpacity(0.3),
                        // ignore: deprecated_member_use
                        color.withOpacity(0.1),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 32, color: color),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}