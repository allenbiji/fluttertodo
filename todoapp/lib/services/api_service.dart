import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const BASE_URL = "";

  static Future<Map<String, dynamic>> Register(
      String Email, String Password) async {
    final url = Uri.parse('$BASE_URL/auth/register');

    final response = await http.post(
      url,
      headers: {"Content-type": "application/json"},
      body: jsonEncode({"Email": Email, "Password": Password}),
    );

    return jsonDecode(response.body);
  }
}
