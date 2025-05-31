import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../login/google_auth_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService {
  static Future<void> saveLoginData(String token, Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
    await prefs.setString('user', jsonEncode(user));
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    if (token == null) return false;

    try {
      if (JwtDecoder.isExpired(token)) return false;
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<int?> getUserId() async {
    final user = await getUser();
    if (user != null && user.containsKey('id')) {
      return user['id'] as int;
    }
    return null;
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final access_token = prefs.getString('access_token');
    return access_token;
  }

static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('user');
    if (jsonStr != null) {
      return jsonDecode(jsonStr);
    }
    return null;
  }


  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('user');
    // Sign out from Google if applicable
    try {
      await GoogleAuthService().signOut();
    } catch (e) {
      print('❌ Error signing out from Google: $e');
    }
  }
}
