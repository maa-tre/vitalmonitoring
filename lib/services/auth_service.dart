import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _keyEmail = 'user_email';
  static const String _keyRole = 'user_role';

  // Save user login info
  static Future<void> saveLogin(String email, String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyEmail, email);
    await prefs.setString(_keyRole, role);
  }

  // Get user login info
  static Future<Map<String, String?>?> getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_keyEmail);
    final role = prefs.getString(_keyRole);
    
    if (email != null && role != null) {
      return {'email': email, 'role': role};
    }
    return null;
  }

  // Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyEmail);
    await prefs.remove(_keyRole);
  }
}
