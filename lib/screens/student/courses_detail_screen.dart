import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseDetailScreen extends StatefulWidget {
  final Map<String, dynamic> course;
  
  const CourseDetailScreen({super.key, required this.course});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  
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

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Impossible d\'ouvrir le lien')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final course = widget.course;
    final title = course['name'] ?? 'Cours';
    final color = getColor(title);
    final icon = getIcon(title);
    
    // Données temporaires pour les cours (à remplacer plus tard par des données réelles)
    final description = course['description'] ?? 'Ce cours vous permettra d\'apprendre les bases de $title. Nous allons explorer les concepts fondamentaux et les mettre en pratique.';
    final content = course['content'] ?? '• Introduction\n• Concepts de base\n• Syntaxe et structure\n• Exercices pratiques\n• Projet final';
    final videoUrl = course['video_url'];
    final pdfUrl = course['pdf_url'];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // AppBar avec image de fond
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    // ignore: deprecated_member_use
                    colors: [color, color.withOpacity(0.7)],
                  ),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    size: 80,
                    color: Colors.white70,
                  ),
                ),
              ),
            ),
          ),
          
          // Contenu
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description
                  const Text(
                    '📖 Description',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  
                  // Contenu du cours
                  const Text(
                    '📚 Contenu du cours',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    content,
                    style: const TextStyle(fontSize: 16, height: 1.6),
                  ),
                  const SizedBox(height: 24),
                  
                  // Ressources
                  if (videoUrl != null || pdfUrl != null) ...[
                    const Text(
                      '📎 Ressources',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    
                    if (videoUrl != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ElevatedButton.icon(
                          onPressed: () => _launchUrl(videoUrl),
                          icon: const Icon(Icons.play_circle_filled, color: Colors.white),
                          label: const Text(
                            'Regarder la vidéo',
                            style: TextStyle(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      
                    if (pdfUrl != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ElevatedButton.icon(
                          onPressed: () => _launchUrl(pdfUrl),
                          icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                          label: const Text(
                            'Télécharger le PDF',
                            style: TextStyle(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                  ],
                  
                  // Progression
                  const Text(
                    '📊 Progression',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: 0.35,
                          minHeight: 10,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation(color),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '35%',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Continuez à apprendre pour progresser !',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}