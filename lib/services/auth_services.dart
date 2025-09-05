import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final _storage = const FlutterSecureStorage();
  final String baseUrl = 'http://10.0.2.2:5294/api/authenticate';
  final String baseUrl1 = 'http://10.0.2.2:5294/api';
  String? lastError;


  //authentication
  Future<Map<String, dynamic>?> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse['IsEmailConfirmed'] == false) {
          return {'error': 'emailNotConfirmed'};
        }

        if (jsonResponse.containsKey('token')) {
          await _storage.write(key: 'jwt_token', value: jsonResponse['token']);
        }

        await _saveUsername(username);

        return jsonResponse;
      } else {
        try {
          final errorJson = jsonDecode(response.body);
          lastError = errorJson['message'] ?? 'Login failed. Please try again.';
        } catch (_) {
          lastError = response.body;
        }
        return null;
      }
    } catch (e) {
      lastError = 'Network error: ${e.toString()}';
      return null;
    }
  }

  Future<bool> signup(
      String username,
      String password,
      String email, {
        bool useFingerprint = false,
        bool useFaceId = false,
        String? biometricType,
      }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        'email': email,
        'useFingerprint': useFingerprint,
        'useFaceId': useFaceId,
        'biometricType': biometricType,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      lastError = _extractErrorMessage(response.body);
      return false;
    }
  }

  // ✅ VERIFY EMAIL
  Future<bool> verifyEmail(String username, String code) async {
    final response = await http.post(
      Uri.parse('$baseUrl/verify-email'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'code': code}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      lastError = _extractErrorMessage(response.body);
      return false;
    }
  }

  Future<Map<String, dynamic>?> loginWithBiometric(String username, String biometricType) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/Biometriclogin'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'biometricType': biometricType,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'error': 'Invalid response'};
      }
    } catch (e) {
      return {'error': e.toString()};
    }
  }


  Future<bool> requestPasswordReset(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/request-password-reset'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      lastError = _extractErrorMessage(response.body);
      return false;
    }
  }

  Future<bool> resetPassword(String email, String code, String newPassword) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reset-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'code': code,
        'newPassword': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      lastError = _extractErrorMessage(response.body);
      return false;
    }
  }

  Future<void> saveUserToken(String jwtToken, String? fcmToken) async {
    if (fcmToken == null || jwtToken.isEmpty) return;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/save-fcm-token'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode({'fcmToken': fcmToken}),
      );

      print('Save token response: ${response.statusCode} - ${response.body}');
    } catch (e) {
      print('Error saving FCM token: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/all-user-roles'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data
            .map((e) => {
          'username': e['username'],
          'roles': e['roles'],
          'biometricType': e['biometricType'],
        })
            .toList();
      } else {
        lastError = 'Failed to fetch users: ${response.statusCode}';
        return [];
      }
    } catch (e) {
      lastError = 'Error fetching users: $e';
      return [];
    }
  }

  Future<bool> assignRole(String username, String role) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/assign-role'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'role': role,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        lastError =
        'Failed to assign role: ${response.statusCode} - ${response.body}';
        return false;
      }
    } catch (e) {
      lastError = 'Error assigning role: $e';
      return false;
    }
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  Future<void> _saveUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
  }

  Future<String?> getLoggedInUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  Future<void> _saveUserRole(String? role) async {
    final prefs = await SharedPreferences.getInstance();
    if (role != null) {
      await prefs.setString('role', role);
    }
  }

  Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('role');
  }

  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('role');
  }

  String _extractErrorMessage(String body) {
    try {
      final json = jsonDecode(body);
      if (json is String) return json;
      if (json['message'] != null) return json['message'];
    } catch (_) {}
    return 'Invalid Credentials';
  }


  //categoryyy
  Future<List<Map<String, dynamic>>> getCategories({String? q}) async {
    final response = await http.get(
      Uri.parse('$baseUrl1/Category'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      lastError = 'Failed to fetch categories: ${response.body}';
      return [];
    }
  }

  Future<Map<String, dynamic>?> createCategory(String text, {
    required String name,
    String? description,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl1/Category/create'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'name': name}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      lastError = 'Failed to create category: ${response.body}';
      return null;
    }
  }

  Future<Map<String, dynamic>?> updateCategory(
      int id, {
        required String name,
      }) async {
    final token = await getToken();

    final url = Uri.parse('$baseUrl1/Category/update/$id');
    final body = jsonEncode({'id': id, 'name': name});

    print("🔵 PUT $url");
    print("🔵 Body: $body");

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    print("🔴 Response [${response.statusCode}]: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      lastError = 'Failed to update category: ${response.body}';
      return null;
    }
  }

  Future<void> deleteCategory(int id) async {
    final token = await getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl1/Category/delete/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      lastError = 'Failed to delete category: ${response.body}';
    }
  }

  // ==========================
  // 📦 PRODUCT METHODS
  // ==========================
  Future<List<Map<String, dynamic>>> getProducts({
    int? categoryId,
    String? q,
  }) async {
    final token = await getToken();
    String query = categoryId != null ? "?categoryId=$categoryId" : "";
    final response = await http.get(
      Uri.parse('$baseUrl1/Product$query'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      lastError = 'Failed to fetch products: ${response.body}';
      return [];
    }
  }

  Future<Map<String, dynamic>?> createProduct({
    required String name,
    required String description,
    required bool status,
    required int categoryId,
  }) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl1/Product/create'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'description': description,
        'status': status,
        'categoryId': categoryId,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      lastError = 'Failed to create product: ${response.body}';
      return null;
    }
  }

  Future<Map<String, dynamic>?> updateProduct(
      int id, {
        required String name,
        required String description,
        required bool status,
        required int categoryId,
      }) async {
    final token = await getToken();
    final response = await http.put(
      Uri.parse('$baseUrl1/Product/update/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'id': id,
        'name': name,
        'description': description,
        'status': status,
        'categoryId': categoryId,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      lastError = 'Failed to update product: ${response.body}';
      return null;
    }
  }

  Future<void> deleteProduct(int id) async {
    final token = await getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl1/Product/delete/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      lastError = 'Failed to delete product: ${response.body}';
    }
  }
}

