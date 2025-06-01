import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/player.dart'; 
import '../models/category.dart';
import '../models/question.dart'; 

class ApiService {
  final String baseUrl;
  final String? token;

  ApiService({required this.baseUrl, required this.token});

  Future<Player> getCurrentUser() async {
    final url = Uri.parse('$baseUrl/users/me');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Player.fromJson(data);
    } else {
      throw Exception('Failed to load user profile: ${response.statusCode} ${response.reasonPhrase}');
    }
  }

  // Add other API methods here (e.g., updateProfile, fetchLeaderboard, etc.)
  Future<Map<String, dynamic>> register({
    required String email,
    required String name,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/auth/register');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'name': name,
        'password': password,
      }),
    );

    print('❌ Register response: ${response.statusCode} ${response.body}');

    if (response.statusCode == 201) {
      // Trả về JWT token
      final data = jsonDecode(response.body);
      return data; 
    } else if (response.statusCode == 409) {
      throw Exception("Email đã được sử dụng");
    } else {
      throw Exception("Đăng ký thất bại: ${response.statusCode} ${response.reasonPhrase}");
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/auth/login');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    print('🔐 Login response: ${response.statusCode} ${response.body}');

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data; 
    } else if (response.statusCode == 401) {
      throw Exception("Sai email hoặc mật khẩu");
    } else {
      throw Exception("Đăng nhập thất bại: ${response.statusCode} ${response.reasonPhrase}");
    }
  }

  Future<List<Category>> getCategories() async {
    final url = Uri.parse('$baseUrl/categories');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    print('📦 Categories response: ${response.statusCode} ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories: ${response.statusCode} ${response.reasonPhrase}');
    }
  }

  Future<List<Question>> getQuestions({
    required String category,
    required int total,
  }) async {
    final url = Uri.parse('$baseUrl/gemini/getQuestion');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'category': category,
        'total': total,
      }),
    );

    if (response.statusCode == 201) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Question.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load questions: ${response.statusCode} ${response.reasonPhrase}');
    }
  }
}
