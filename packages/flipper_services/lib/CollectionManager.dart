import 'package:flipper_models/NetworkHelper.dart';
import 'package:dio/dio.dart';
import 'package:flipper_models/secrets.dart';
import 'package:talker_flutter/talker_flutter.dart';

class CollectionManager with NetworkHelper {
  final Dio _dio = Dio();
  final Talker _talker = Talker();

  CollectionManager() {
    // Initialize Dio headers with the Bearer Token
    _dio.options.headers = {
      'Authorization': 'Bearer ${AppSecrets.bearerToken}',
      'Content-Type': 'application/json',
    };
  }

  @override
  Dio? get dioInstance => _dio;

  @override
  Talker? get talkerInstance => _talker;

// https://cloudapi.cloud.couchbase.com/v4/organizations/{organizationId}/projects/{projectId}/clusters/{clusterId}/buckets/{bucketId}/scopes/{scopeName}/collections
  Future<Response> createCollection(
      String scopeName, String collectionName) async {
    try {
      // Construct the endpoint URL
      final String url =
          '${AppSecrets.baseUrl}/v4/organizations/${AppSecrets.organizationId}/projects/${AppSecrets.projectId}/clusters/${AppSecrets.clusterId}/buckets/${AppSecrets.bucketId}/scopes/${scopeName}/collections';

      // Define the data payload for the request
      final Map<String, dynamic> data = {'name': collectionName};

      // Send POST request to create the scope
      return await sendPostRequest(url, data);
    } catch (e) {
      rethrow;
    }
  }
}
