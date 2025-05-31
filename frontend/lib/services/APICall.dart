// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/player.dart'; // Adjust to your file path

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
}
