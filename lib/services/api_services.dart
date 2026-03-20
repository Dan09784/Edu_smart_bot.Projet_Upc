import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServices {
  static const String baseUrl = "http://172.20.10.3000";
  static Future<List<dynamic>> getCourses() async {
    final response = await http.get(Uri.parse("$baseUrl/courses"));
    // ignore: avoid_print
    print("STATUS:  ${response.statusCode}");
    // ignore: avoid_print
    print("BODY:  ${response.body}");
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else{
      throw Exception("Erreur API");
    }
  }
}
