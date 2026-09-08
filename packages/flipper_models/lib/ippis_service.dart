import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flipper_models/secrets.dart';

class IppisBusiness {
  final String tin;
  final String taxPayerName;
  final String registrationDate;
  final String isicName;
  final int numberOfEmployees;
  final int numberOfFemaleEmployees;
  final int numberOfMaleEmployees;
  final String businessType;
  final String province;
  final String district;
  final String sector;
  final String cell;
  final String village;
  final String phoneNumber;
  final String email;
  final String stateOfEstablishment;
  final String taxAccountStatus;
  final String statusEffectiveDate;
  final String categoryOfEstablishment;
  final String registrationAuthority;
  final String managingDirectorId;

  IppisBusiness({
    required this.tin,
    required this.taxPayerName,
    required this.registrationDate,
    required this.isicName,
    required this.numberOfEmployees,
    required this.numberOfFemaleEmployees,
    required this.numberOfMaleEmployees,
    required this.businessType,
    required this.province,
    required this.district,
    required this.sector,
    required this.cell,
    required this.village,
    required this.phoneNumber,
    required this.email,
    required this.stateOfEstablishment,
    required this.taxAccountStatus,
    required this.statusEffectiveDate,
    required this.categoryOfEstablishment,
    required this.registrationAuthority,
    required this.managingDirectorId,
  });

  factory IppisBusiness.fromJson(Map<String, dynamic> json) {
    return IppisBusiness(
      tin: json['tin'] ?? '',
      taxPayerName: json['taxPayerName'] ?? '',
      registrationDate: json['registrationDate'] ?? '',
      isicName: json['isicName'] ?? '',
      numberOfEmployees: json['numberOfEmployees'] ?? 0,
      numberOfFemaleEmployees: json['numberOfFemaleEmployees'] ?? 0,
      numberOfMaleEmployees: json['numberOfMaleEmployees'] ?? 0,
      businessType: json['businessType'] ?? '',
      province: json['province'] ?? '',
      district: json['district'] ?? '',
      sector: json['sector'] ?? '',
      cell: json['cell'] ?? '',
      village: json['village'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'] ?? '',
      stateOfEstablishment: json['stateOfEstablishment'] ?? '',
      taxAccountStatus: json['taxAccountStatus'] ?? '',
      statusEffectiveDate: json['statusEffectiveDate'] ?? '',
      categoryOfEstablishment: json['categoryOfEstablishment'] ?? '',
      registrationAuthority: json['registrationAuthority'] ?? '',
      managingDirectorId: json['managingDirectorId'] ?? '',
    );
  }
}

/// Thrown when IPPIS itself could not answer: unreachable, rejected our
/// credentials, blocked the request (the service sends no CORS headers, so
/// every call from Flutter web fails this way) or returned a 5xx.
///
/// Callers must treat this as "validation unavailable" and relax the TIN
/// check — the same thing the mobile signup form does — instead of telling the
/// user their TIN is unknown. A TIN IPPIS genuinely does not know still comes
/// back as `null` from [IppisService.getBusinessDetails].
///
/// The message keeps the literal "Server Error" wording the mobile
/// `TinInputField` matches on.
class IppisUnavailableException implements Exception {
  IppisUnavailableException([this.message = 'Server Error']);

  final String message;

  @override
  String toString() => 'IppisUnavailableException: $message';
}

class IppisService {
  final String _baseUrl = "https://ippis.rw/api";

  /// IPPIS answers slowly, and from Flutter web the CORS preflight can hang
  /// outright. Without a bound the TIN field spins forever instead of falling
  /// back to the relaxed check.
  static const Duration _timeout = Duration(seconds: 20);

  /// Sends [request] without following redirects.
  ///
  /// A 3xx from IPPIS would otherwise replay our credentials — including the
  /// bearer token on the lookup — at whatever host the redirect names. These
  /// are fixed API endpoints, so a redirect is a failure, not a hop.
  /// (Browsers follow redirects themselves, so on web this is advisory.)
  Future<http.Response> _send(http.Request request) async {
    final client = http.Client();
    try {
      request.followRedirects = false;
      final streamed = await client.send(request).timeout(_timeout);
      return await http.Response.fromStream(streamed).timeout(_timeout);
    } finally {
      client.close();
    }
  }

  /// Throws [IppisUnavailableException] when the service cannot be reached or
  /// refuses our credentials.
  Future<String?> authenticate() async {
    final http.Response response;
    try {
      final request =
          http.Request('POST', Uri.parse('$_baseUrl/authenticate'))
            ..headers['Content-Type'] = 'application/json'
            ..body = jsonEncode({
              "user": AppSecrets.ippisUser,
              "secretKey": AppSecrets.ippisSecretKey,
            });
      response = await _send(request);
    } catch (e) {
      print("Error authenticating ippis: $e");
      throw IppisUnavailableException("Server Error: $e");
    }

    if (response.statusCode == 200) {
      // A 200 carrying something other than `{"token": "..."}` means IPPIS is
      // not answering the question we asked (a captive portal or an error page
      // both do this), so it is unavailable rather than a valid empty answer.
      final String? token;
      try {
        final decoded = jsonDecode(response.body);
        token = decoded is Map<String, dynamic> ? decoded['token'] as String? : null;
      } catch (e) {
        print("Error parsing ippis authenticate response: $e");
        throw IppisUnavailableException(
          "Server Error: malformed authenticate response",
        );
      }
      if (token == null || token.isEmpty) {
        throw IppisUnavailableException("Server Error: no token returned");
      }
      return token;
    }

    print("Error authenticating ippis: ${response.statusCode}");
    throw IppisUnavailableException(
      "Server Error: authenticate returned ${response.statusCode}",
    );
  }

  /// Returns the business behind [tin], or `null` when IPPIS has no record of
  /// it. Throws [IppisUnavailableException] when the lookup could not be
  /// performed at all.
  Future<IppisBusiness?> getBusinessDetails(String tin) async {
    final token = await authenticate();
    if (token == null) {
      throw IppisUnavailableException("Server Error: no token returned");
    }

    final http.Response response;
    try {
      final url = Uri.parse('$_baseUrl/raa-business-details?tin=$tin');
      final request = http.Request('GET', url)
        ..headers.addAll({
          'Authorization': token,
          'Content-Type': 'application/json',
        });
      response = await _send(request);
    } catch (e) {
      print("Error fetching business details: $e");
      throw IppisUnavailableException("Server Error: $e");
    }

    if (response.statusCode == 200) {
      try {
        return IppisBusiness.fromJson(jsonDecode(response.body));
      } catch (e) {
        print("Error parsing business details: $e");
        throw IppisUnavailableException("Server Error: malformed response");
      }
    }
    if (response.statusCode == 404) {
      // IPPIS answered and has no record of this TIN.
      return null;
    }
    throw IppisUnavailableException(
      "Server Error: lookup returned ${response.statusCode}",
    );
  }
}
