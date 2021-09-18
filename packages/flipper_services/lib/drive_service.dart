import 'dart:io';
import 'package:flipper_services/secure_storage.dart';
import 'package:googleapis/drive/v3.dart' as ga;
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:flipper_routing/routes.logger.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';

// const _clientId = "";
// const _clientSecret = "";
final _scopes = [ga.DriveApi.driveFileScope];

class GoogleDrive {
  final storage = SecureStorage();
  final log = getLogger('GoogleDrive');
  //Get Authenticated Http Client
  Future<http.Client> getHttpClient() async {
    //Get Credentials
    var credentials = await storage.getCredentials();
    if (credentials == null) {
      //Needs user authentication
      // var authClient = await clientViaUserConsent(
      //     ClientId(_clientId, _clientSecret), _scopes, (url) {
      //   //Open Url in Browser
      //   launch(url);
      // });
      final _googleSignIn = new GoogleSignIn(scopes: _scopes);
      await _googleSignIn.signIn();
      var httpClient = (await _googleSignIn.authenticatedClient())!;
      //Save Credentials
      // log.i(httpClient.credentials.accessToken);
      log.i(httpClient.credentials.refreshToken);
      await storage.saveCredentials(httpClient.credentials.accessToken,
          httpClient.credentials.refreshToken ?? '');
      return httpClient;
    } else {
      log.i(credentials["expiry"]);
      log.i(credentials["data"]);
      log.i(credentials["type"]);
      //Already authenticated
      return authenticatedClient(
          http.Client(),
          AccessCredentials(
              AccessToken(credentials["type"], credentials["data"],
                  DateTime.tryParse(credentials["expiry"])!),
              // credentials["refreshToken"],
              null, // refreshToken can be null as it was not returned when logging in
              _scopes));
    }
  }

  //Upload File
  Future upload(File file) async {
    var client = await getHttpClient();
    var drive = ga.DriveApi(client);
    log.w("Uploading file");
    var response = await drive.files.create(
        ga.File()..name = p.basename(file.absolute.path),
        uploadMedia: ga.Media(file.openRead(), file.lengthSync()));

    log.w("Result ${response.toJson()}");
  }
}
