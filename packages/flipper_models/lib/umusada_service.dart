import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_models/brick/models/integration_config.model.dart';
import 'package:supabase_models/brick/repository.dart';

class UmusadaService {
  final Repository? repository;

  static const String _baseUrl =
      'https://dev-master-apis.umusada.com/umusada-master-service';
  static const String _salesBaseUrl =
      'http://umusada-master.umusada.com/umusada-master-service';

  UmusadaService({this.repository});

  Future<IntegrationConfig?> getConfig(String businessId) async {
    if (repository == null) {
      throw Exception('Repository not initialized');
    }
    final configs = await repository!.get<IntegrationConfig>(
      query: Query(
        where: [
          Where('businessId').isExactly(businessId),
          Where('provider').isExactly('umusada'),
        ],
      ),
    );
    return configs.isNotEmpty ? configs.first : null;
  }

  Future<void> saveConfig(IntegrationConfig config) async {
    if (repository == null) {
      throw Exception('Repository not initialized');
    }
    await repository!.upsert<IntegrationConfig>(config);
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$username:$password'))}',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> verifyOtp(String otpToken, String otp) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login-auth2'),
      headers: {
        'Authorization': 'Bearer $otpToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'code': otp}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to verify OTP: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> registerBusiness(
    String token,
    Map<String, dynamic> businessData,
  ) async {
    final response = await http.post(
      Uri.parse('$_salesBaseUrl/business/save'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(businessData),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to register business: ${response.body}');
    }
  }

  Future<void> syncSales(
    String token,
    List<Map<String, dynamic>> salesData,
  ) async {
    for (var sale in salesData) {
      final response = await http.post(
        Uri.parse('$_salesBaseUrl/sales/save'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(sale),
      );
      if (response.statusCode != 200) {
        // Log error but continue? or throw?
        // For now, let's catch upstream
        throw Exception('Failed to sync sale: ${response.body}');
      }
    }
  }

  /// Refreshes the session using the stored refresh token.
  /// Returns a map with new `token`, `refreshToken`, and `expiresAt`.
  Future<Map<String, dynamic>> refreshSession(String refreshToken) async {
    final response = await http.post(
      Uri.parse('$_salesBaseUrl/auth/refresh'),
      headers: {'Authorization': 'Bearer $refreshToken'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to refresh token: ${response.body}');
    }
  }
}
