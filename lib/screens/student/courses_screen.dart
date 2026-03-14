import 'package:flutter/material.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  final List<Map<String, dynamic>> courses = const [

    {
      "title": "Algorithmes",
      "icon": Icons.functions,
      "color": Color(0xFF4A90E2),
      "progress": 0.4
    },

    {
      "title": "Java",
      "icon": Icons.code,
      "color": Color(0xFFFF8C42),
      "progress": 0.6
    },

    {
      "title": "PHP",
      "icon": Icons.language,
      "color": Color(0xFF4CAF50),
      "progress": 0.2
    },

    {
      "title": "SQL",
      "icon": Icons.storage,
      "color": Color(0xFFE91E63),
      "progress": 0.3
    },

    {
      "title": "Langage C",
      "icon": Icons.memory,
      "color": Color(0xFFFFC107),
      "progress": 0.5
    },

    {
      "title": "Statistiques",
      "icon": Icons.bar_chart,
      "color": Color(0xFF009688),
      "progress": 0.4
    },

    {
      "title": "MERISE",
      "icon": Icons.account_tree,
      "color": Color(0xFF673AB7),
      "progress": 0.3
    },

    {
      "title": "Système d'exploitation",
      "icon": Icons.computer,
      "color": Color(0xFF2196F3),
      "progress": 0.2
    },

  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF4F6FA),

      appBar: AppBar(
        title: const Text("Mes Cours"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),

      body: GridView.builder(

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

              child: Container(

                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(

                  color: Colors.white,

                  borderRadius: BorderRadius.circular(20),

                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                    )
                  ],
                ),

                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    Container(

                      padding: const EdgeInsets.all(12),

                      decoration: BoxDecoration(
                        color: course["color"].withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),

                      child: Icon(
                        course["icon"],
                        color: course["color"],
                        size: 30,
                      ),
                    ),

                    const Spacer(),

                    Text(
                      course["title"],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    LinearProgressIndicator(
                      value: course["progress"],
                      backgroundColor: Colors.grey.shade200,
                      color: course["color"],
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "${(course["progress"] * 100).toInt()}%",
                      style: const TextStyle(fontSize: 12),
                    ),

                  ],
                ),
              ),
            ),
          );
        },
      ),
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

      body: Column(

        children: [

          Hero(

            tag: title,

            child: Container(

              width: double.infinity,

              padding: const EdgeInsets.fromLTRB(10, 60, 20, 30),

              decoration: BoxDecoration(

                color: color,

                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),

              child: Row(

                children: [

                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),

                  const SizedBox(width: 10),

                  Icon(
                    icon,
                    color: Colors.white,
                    size: 35,
                  ),

                  const SizedBox(width: 10),

                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),

          const Padding(

            padding: EdgeInsets.all(20),

            child: Text(

              "Bienvenue dans ce cours. Ici vous pourrez apprendre les bases, suivre les chapitres et tester vos connaissances avec des quiz.",

              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),

          ElevatedButton(

            onPressed: () {},

            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 15,
              ),
            ),

            child: const Text("Commencer le cours"),

          )
        ],
      ),
    );
  }
}