import 'package:googleapis_auth/auth_io.dart';

class SecureStorage {
  //TODOabandon the flutter_secure_storage and use box instead moving forward
  //Save Credentials
  Future saveCredentials(AccessToken token, String refreshToken) async {
    // print(token.expiry.toIso8601String());
    // await storage.write(key: "type", value: token.type);
    // await storage.write(key: "data", value: token.data);
    // await storage.write(key: "expiry", value: token.expiry.toString());
    // await storage.write(key: "refreshToken", value: refreshToken);
  }

  //Get Saved Credentials
  Future<Map<String, dynamic>?> getCredentials() async {
    // var result = await storage.readAll();
    // if (result.length == 0) return null;
    // return result;
  }
}
