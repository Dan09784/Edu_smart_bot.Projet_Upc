import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServices {
  static const String baseUrl = 'https://localhost:3000';
  // authentification

  static Future login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),

      headers: {'Content-Type': 'application/json'},

      body: jsonEncode({'email': email, 'password': password}),
    );
    return jsonDecode(response.body);
  }

  // GEt etudiants
  static Future getStudents() async {
    final response = await http.get(Uri.parse('$baseUrl/students'));

    return jsonDecode(response.body);
  }
}
