import 'package:flutter/material.dart';
import '../api/client.dart';

class AuthProvider extends ChangeNotifier {
  Map<String, dynamic>? _user;
  bool _loading = true;

  Map<String, dynamic>? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get loading => _loading;

  AuthProvider() {
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final token = await ApiClient.getToken();
    if (token != null) {
      try {
        final data = await ApiClient.get('/auth/me', auth: true);
        _user = data;
      } catch {
        await ApiClient.removeToken();
      }
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    final data = await ApiClient.post('/auth/login', {'email': email, 'password': password});
    await ApiClient.setToken(data['token']);
    _user = data['user'];
    notifyListeners();
  }

  Future<void> register(String name, String email, String phone, String password) async {
    final data = await ApiClient.post('/auth/register', {
      'name': name, 'email': email, 'phone': phone, 'password': password,
    });
    await ApiClient.setToken(data['token']);
    _user = data['user'];
    notifyListeners();
  }

  Future<void> logout() async {
    try { await ApiClient.post('/auth/logout', {}, auth: true); } catch (_) {}
    await ApiClient.removeToken();
    _user = null;
    notifyListeners();
  }
}
