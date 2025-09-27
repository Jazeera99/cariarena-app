import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../models/user_model.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final _storage = const FlutterSecureStorage();

  User? _user;
  String? _token;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get token => _token;

  // Cek token saat aplikasi dimulai
  Future<void> checkAuthentication() async {
    _isLoading = true;
    notifyListeners();
    _token = await _storage.read(key: 'auth_token');
    if (_token != null) {
      // Panggil API untuk validasi token atau dapatkan data user
      await fetchUserData();
    }
    _isLoading = false;
    notifyListeners();
  }

  // For demo purposes - will be replaced with actual auth service
  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await ApiService.login(email, password);
      _token = data['token'];
      _user = User.fromJson(data['user']);
      await _storage.write(key: 'auth_token', value: _token!);
    } catch (e) {
      throw Exception('Gagal login: ${e.toString()}');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> register(
    String name,
    String email,
    String phone,
    String password,
    String passwordConfirmation,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await ApiService.register(
        name,
        email,
        phone,
        password,
        passwordConfirmation,
      );
      _token = data['token'];
      _user = User.fromJson(data['user']);
      await _storage.write(key: 'auth_token', value: _token!);
    } catch (e) {
      throw Exception('Gagal registrasi: ${e.toString()}');
    }
    _isLoading = false;
    notifyListeners();
  }

  // API yang membutuhkan token
  Future<void> fetchUserData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final userProfileData = await ApiService.fetchUserProfileAndStats(
        _token!,
      );
      final userData = userProfileData['data']['user'];
      _user = User.fromJson(userData);
    } catch (e) {
      await logout();
      throw Exception(e.toString());
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
    _user = null;
    _token = null;
    notifyListeners();
  }
}
