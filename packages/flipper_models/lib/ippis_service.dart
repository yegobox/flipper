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

  /// Throws [IppisUnavailableException] when the service cannot be reached or
  /// refuses our credentials.
  Future<String?> authenticate() async {
    final http.Response response;
    try {
      final url = Uri.parse('$_baseUrl/authenticate');
      response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "user": AppSecrets.ippisUser,
          "secretKey": AppSecrets.ippisSecretKey,
        }),
      );
    } catch (e) {
      print("Error authenticating ippis: $e");
      throw IppisUnavailableException("Server Error: $e");
    }

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['token'];
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
      response = await http.get(
        url,
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
      );
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
