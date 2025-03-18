import 'package:flipper_models/flipper_http_client.dart';

abstract class DeleteInterface {
  Future<bool> delete({
    required String id,
    String? endPoint,
    HttpClientInterface? flipperHttpClient,
  });
  
  Future<void> deleteTransactionItemAndResequence({required String id});
}
