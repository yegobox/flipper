import 'package:flipper_models/helperModels/iuser.dart';
import 'package:flipper_models/helperModels/social_token.dart';
import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:http/http.dart' as http;

abstract class AuthInterface {
  Future<bool> firebaseLogin({String? token});
  Future<bool> logOut();
  Future<IUser> login({
    required String userPhone,
    required bool skipDefaultAppSetup,
    bool stopAfterConfigure = false,
    required Pin pin,
    required HttpClientInterface flipperHttpClient,
    IUser? existingUser,
  });

  Future<void> completeLogin(Pin thePin);

  Future<void> configureSystem(String userPhone, IUser user,
      {required bool offlineLogin});

  Future<SocialToken?> loginOnSocial({
    String? phoneNumberOrEmail,
    String? password,
  });

  Future<bool> hasActiveSubscription(
      {required String businessId,
      required HttpClientInterface flipperHttpClient,
      required bool fetchRemote});

  Future<http.Response> sendLoginRequest(
    String phoneNumber,
    HttpClientInterface flipperHttpClient,
    String apihub, {
    String? uid,
  });

  // Required methods that should be provided by other mixins
  Future<List<Business>> businesses({required int userId});
  Future<List<Branch>> branches({required int serverId});

  Future<Map<String, dynamic>> handleLoginError(dynamic e, StackTrace s,
      {String? responseChannel});

  Future<void> supabaseAuth();
}
