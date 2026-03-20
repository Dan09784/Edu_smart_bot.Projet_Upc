import 'package:http/http.dart' as http show get;

class ApiConfig {
  // Liste des URLs à essayer (la première qui fonctionne sera utilisée)
  static const List<String> possibleUrls = [
    'http://127.0.0.1:3000',
    'http://localhost:3000',
    'http://192.168.56.1:3000',
    'http://192.168.56.2:3000',
  ];
  
  static String baseUrl = possibleUrls[0];
  
  static Future<void> detectWorkingUrl() async {
    for (final url in possibleUrls) {
      try {
        final response = await http.get(Uri.parse('$url/courses'));
        if (response.statusCode == 200) {
          baseUrl = url;
          // ignore: avoid_print
          print("✅ URL fonctionnelle trouvée: $baseUrl");
          return;
        }
      } catch (e) {
        // ignore: avoid_print
        print("❌ URL $url ne fonctionne pas: $e");
      }
    }
    // ignore: avoid_print
    print("⚠️ Aucune URL fonctionnelle trouvée !");
  }
  
  static String get loginEndpoint => '$baseUrl/login';
  static String get coursesEndpoint => '$baseUrl/courses';
  static String get complaintsEndpoint => '$baseUrl/complaints';
  static String get studentsEndpoint => '$baseUrl/students';
  static String get teachersEndpoint => '$baseUrl/teachers';
}