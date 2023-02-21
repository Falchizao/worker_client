import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class JwtService {
  static final JwtService _singleton = JwtService._internal();

  factory JwtService() {
    return _singleton;
  }

  JwtService._internal();

  final _storage = const FlutterSecureStorage();
  final _key = 'jwt_token';

  Future<String?> getToken() async {
    final token = await _storage.read(key: _key);
    return token;
  }

  Future<void> saveToken(String token) async {
    await _storage.write(key: _key, value: token);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _key);
  }

  bool hasToken() {
    final token = _storage.read(key: _key);
    return token != null;
  }
}
