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
      businessType: json['bsinessType'] ?? '',
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

class IppisService {
  final String _baseUrl = "https://ippis.rw/api";

  Future<String?> authenticate() async {
    try {
      final url = Uri.parse('$_baseUrl/authenticate');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "user": AppSecrets.ippisUser,
          "secretKey": AppSecrets.ippisSecretKey,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data['token'];
      }
      return null;
    } catch (e) {
      print("Error authenticating ippis: $e");
      return null;
    }
  }

  Future<IppisBusiness?> getBusinessDetails(String tin) async {
    try {
      final token = await authenticate();
      if (token == null) return null;

      final url = Uri.parse('$_baseUrl/raa-business-details?tin=$tin');
      final response = await http.get(
        url,
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return IppisBusiness.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        // Handle "No data found" implicitly by returning null
        return null;
      } else if (response.statusCode == 500) {
        throw Exception("Server Error");
      }
      return null;
    } catch (e) {
      if (e.toString().contains("Server Error")) {
        rethrow;
      }
      print("Error fetching business details: $e");
      return null;
    }
  }
}
