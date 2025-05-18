import 'package:flipper_models/sync/interfaces/auth_interface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/iuser.dart';
import 'package:flipper_models/helperModels/social_token.dart';
import 'package:flipper_models/flipper_http_client.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';

mixin CapellaAuthMixin implements AuthInterface {
  Repository get repository;
  Talker get talker;
  String get apihub;

  bool _offlineLogin = false;
  bool get offlineLogin => _offlineLogin;
  set offlineLogin(bool value) => _offlineLogin = value;

  @override
  Future<List<Business>> businesses({required int userId}) async {
    throw UnimplementedError('businesses needs to be implemented for Capella');
  }

  @override
  Future<void> completeLogin(Pin thePin) {
    throw UnimplementedError(
        'completeLogin needs to be implemented for Capella');
  }

  @override
  Future<bool> firebaseLogin({String? token}) async {
    throw UnimplementedError(
        'firebaseLogin needs to be implemented for Capella');
  }

  @override
  Future<IUser> login({
    required String userPhone,
    required bool skipDefaultAppSetup,
    IUser? existingUser,
    bool stopAfterConfigure = false,
    required Pin pin,
    required HttpClientInterface flipperHttpClient,
  }) async {
    throw UnimplementedError('login needs to be implemented for Capella');
  }

  @override
  Future<http.Response> sendLoginRequest(
    String phoneNumber,
    HttpClientInterface flipperHttpClient,
    String apihub, {
    String? uid,
  }) async {
    throw UnimplementedError(
        'sendLoginRequest needs to be implemented for Capella');
  }

  @override
  Future<void> configureSystem(String userPhone, IUser user,
      {required bool offlineLogin}) async {
    throw UnimplementedError(
        'configureSystem needs to be implemented for Capella');
  }

  @override
  Future<SocialToken?> loginOnSocial({
    String? phoneNumberOrEmail,
    String? password,
  }) async {
    throw UnimplementedError(
        'loginOnSocial needs to be implemented for Capella');
  }

  @override
  Future<List<Branch>> branches(
      {required int businessId, bool? includeSelf = false}) async {
    throw UnimplementedError('branches needs to be implemented for Capella');
  }

  @override
  Future<bool> hasActiveSubscription(
      {required int businessId,
      required HttpClientInterface flipperHttpClient,
      required bool fetchRemote}) async {
    throw UnimplementedError(
        'hasActiveSubscription needs to be implemented for Capella');
  }

  @override
  Future<Map<String, dynamic>> handleLoginError(dynamic e, StackTrace s,
      {String? responseChannel}) {
    throw UnimplementedError(
        'handleLoginError needs to be implemented for Capella');
  }
}
