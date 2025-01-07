import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const BASE_URL = "http://localhost:5000/api";

  static Future<Map<String, dynamic>> Register(
      String email, String password) async {
    final url = Uri.parse('$BASE_URL/auth/register');

    final response = await http.post(
      url,
      headers: {"Content-type": "application/json"},
      body: jsonEncode({"Email": email, "Password": password}),
    );

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> Login(
      String Email, String Password) async {
    final url = Uri.parse('$BASE_URL/auth/login');

    final response = await http.post(
      url,
      headers: {"Content-type": "application/json"},
      body: jsonEncode({"Email": Email, "Password": Password}),
    );

    return jsonDecode(response.body);
  }

  static Future<List<dynamic>> fetchTodos(String token) async {
    final url = Uri.parse('$BASE_URL/todos');
    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> createTodo(
      String token, String title) async {
    final url = Uri.parse('$BASE_URL/todo/createtodo');

    final response = await http.post(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    });

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> updateTodo(
      String token, String todoId, bool isCompleted) async {
    final url = Uri.parse('$BASE_URL/todos/$todoId');
    final response = await http.patch(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode({"isCompleted": isCompleted}),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> deleteTodo(
      String token, String todoId) async {
    final url = Uri.parse('$BASE_URL/todos/$todoId');
    final response = await http.delete(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    return jsonDecode(response.body);
  }
}
