import 'package:shared_preferences/shared_preferences.dart';

class JwtService {
  static final JwtService _singleton = JwtService._internal();

  factory JwtService() {
    return _singleton;
  }

  JwtService._internal();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<String?> getToken() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('jwt_token');
  }

  Future<void> setToken(String token) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('jwt_token', token);
  }

  Future<void> removeToken() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.remove('jwt_token');
  }
}
