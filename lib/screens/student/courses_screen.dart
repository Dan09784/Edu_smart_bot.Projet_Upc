import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Roboto'),
      home: const CoursesScreen(),
    );
  }
}

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  final List<Map<String, dynamic>> courses = const [
    {"title": "Algorithmes", "icon": Icons.functions, "color": Color(0xFF4A90E2), "progress": 0.4},
    {"title": "Java", "icon": Icons.code, "color": Color(0xFFFF8C42), "progress": 0.6},
    {"title": "PHP", "icon": Icons.language, "color": Color(0xFF4CAF50), "progress": 0.2},
    {"title": "SQL", "icon": Icons.storage, "color": Color(0xFFE91E63), "progress": 0.3},
    {"title": "Langage C", "icon": Icons.memory, "color": Color(0xFFFFC107), "progress": 0.5},
    {"title": "Statistiques", "icon": Icons.bar_chart, "color": Color(0xFF009688), "progress": 0.4},
    {"title": "Python", "icon": Icons.adb, "color": Color(0xFF6A1B9A), "progress": 0.7},
    {"title": "Flutter", "icon": Icons.phone_android, "color": Color(0xFF42A5F5), "progress": 0.5},
    {"title": "Dart", "icon": Icons.code_off, "color": Color(0xFF00BFA5), "progress": 0.3},
    {"title": "JavaScript", "icon": Icons.web, "color": Color(0xFFFFD600), "progress": 0.6},
    {"title": "React", "icon": Icons.blur_circular, "color": Color(0xFF61DAFB), "progress": 0.4},
    {"title": "Node.js", "icon": Icons.storage_outlined, "color": Color(0xFF8BC34A), "progress": 0.3},
    {"title": "Machine Learning", "icon": Icons.memory, "color": Color(0xFF673AB7), "progress": 0.2},
    {"title": "IA", "icon": Icons.smart_toy, "color": Color(0xFF00BCD4), "progress": 0.1},
    {"title": "Cybersecurity", "icon": Icons.security, "color": Color(0xFFD32F2F), "progress": 0.4},
    {"title": "Blockchain", "icon": Icons.account_balance, "color": Color(0xFF795548), "progress": 0.3},
  ];

  @override
  void initState() {
    super.initState();
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
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "Mes Cours Informatique",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
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
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CourseDetailScreen(
                                  title: course["title"],
                                  icon: course["icon"],
                                  color: course["color"],
                                ),
                              ),
                            );
                          },
                          child: Hero(
                            tag: course["title"],
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    course["color"].withOpacity(0.7),
                                    course["color"].withOpacity(0.4)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: course["color"].withOpacity(0.5),
                                    blurRadius: 15,
                                    offset: const Offset(0, 10),
                                  )
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 10, sigmaY: 10),
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        color:
                                            // ignore: deprecated_member_use
                                            Colors.white.withOpacity(0.2),
                                        child: Icon(
                                          course["icon"],
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    course["title"],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  LinearProgressIndicator(
                                    value: course["progress"],
                                    backgroundColor:
                                        // ignore: deprecated_member_use
                                        Colors.white.withOpacity(0.3),
                                    color: Colors.white,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${(course["progress"] * 100).toInt()}%",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
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

  const CourseDetailScreen(
      {super.key, required this.title, required this.icon, required this.color});

  final List<String> chapters = const [
    "Introduction",
    "Variables",
    "Conditions",
    "Boucles",
    "Tableaux",
    "Fonctions",
    "Exercices pratiques",
    "Résumé"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Hero(
            tag: title,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(10, 60, 20, 30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  // ignore: deprecated_member_use
                  colors: [color, color.withOpacity(0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context)),
                  const SizedBox(width: 10),
                  Icon(icon, color: Colors.white, size: 35),
                  const SizedBox(width: 10),
                  Text(title,
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              "Chapitres du cours",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: chapters.length,
              itemBuilder: (context, index) => ListTile(
                leading: const Icon(Icons.play_circle, color: Colors.black87),
                title: Text(chapters[index]),
                onTap: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}