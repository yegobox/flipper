import 'dart:convert';
import 'dart:io';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/secure_storage.dart';
import 'package:googleapis/drive/v3.dart' as ga;
import 'package:flipper_models/business.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
// import 'package:path';
import 'package:flipper_routing/routes.logger.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';

FileUploaded fileUploadedFromJson(String str) =>
    FileUploaded.fromJson(json.decode(str));

String fileUploadedToJson(FileUploaded data) => json.encode(data.toJson());

class FileUploaded {
  FileUploaded({
    required this.id,
    required this.kind,
    required this.mimeType,
    required this.name,
  });

  String id;
  String kind;
  String mimeType;
  String name;

  factory FileUploaded.fromJson(Map<String, dynamic> json) => FileUploaded(
        id: json["id"],
        kind: json["kind"],
        mimeType: json["mimeType"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "kind": kind,
        "mimeType": mimeType,
        "name": name,
      };
}

// const _clientId = "";
// const _clientSecret = "";
// DriveScopes.DRIVE_METADATA_READONLY
// https://developers.google.com/drive/api/v2/about-auth
// https://developers.google.com/drive/api/v2/appdata
final _scopes = [
  ga.DriveApi.driveFileScope,
  ga.DriveApi.driveAppdataScope,
  // ga.DriveApi.driveScope,
  // ga.DriveApi.driveMetadataScope,
];

class GoogleDrive {
  final storage = SecureStorage();
  final log = getLogger('GoogleDrive');

  /// if the  var credentials = await storage.getCredentials();
  /// has some data i.e we authenticated and we have some token,
  /// the problem is that at the time of using it it might have expired
  /// then we call this method first to refresh the token
  /// for this time we use silent authentication
  /// to avoid user to be prompted for authentication again
  Future<http.Client> refreshToken() async {
    print("Token Refresh");
    final _googleSignIn = new GoogleSignIn(scopes: _scopes);
    await _googleSignIn.signInSilently();
    // New refreshed token
    var httpClient = (await _googleSignIn.authenticatedClient())!;
    //Save Credentials
    // log.i(httpClient.credentials.accessToken);
    log.i(httpClient.credentials.refreshToken);
    // TODOlearn if the refresher token is given.
    log.i(httpClient.credentials.accessToken);

    await storage.saveCredentials(httpClient.credentials.accessToken,
        httpClient.credentials.refreshToken ?? '');
    return httpClient;
  }

  /// Get Authenticated Http Client
  /// the method will check if the token is expired or not
  /// if it is expired it will call refreshToken()
  /// if is the first time it will call the authentication with normal prompt flow
  /// if the token is not expired it will return the http client
  Future<http.Client> authenticate() async {
    final _googleSignIn = new GoogleSignIn(scopes: _scopes);
    await _googleSignIn.signIn();
    var httpClient = (await _googleSignIn.authenticatedClient())!;
    log.i(httpClient.credentials.refreshToken);
    log.i(httpClient.credentials.accessToken);
    FirebaseChatCore.instance
        .logDynamicLink(httpClient.credentials.accessToken.data);
    FirebaseChatCore.instance.logDynamicLink(
        httpClient.credentials.refreshToken ??
            'No Refresh Token google sign in!');
    await storage.saveCredentials(httpClient.credentials.accessToken,
        httpClient.credentials.refreshToken ?? '');
    return httpClient;
  }

  //Upload File
  Future upload(File file) async {
    var client = await authenticate();
    var drive = ga.DriveApi(client);
    ga.File fileToUpload = ga.File();
    // https://ko.stackfinder.net/questions/68955545/flutter-how-to-backup-user-data-on-google-drive-like-whatsapp-does
    // https://developers.google.com/drive/api/v3/appdata
    fileToUpload.parents = ["appDataFolder"];
    // fileToUpload.name = basename(file.absolute.path);
    fileToUpload.name = "flipper";
    log.w("Uploading file");

    var response = await drive.files.create(
      fileToUpload,
      uploadMedia: ga.Media(
        file.openRead(),
        file.lengthSync(),
      ),
    );

    log.w("Result ${response.toJson()}");
    FileUploaded fileUploaded = FileUploaded.fromJson(response.toJson());
    //patch a business with lst backup fileId.
    Business business = ProxyService.api.getBusiness();
    business.backupFileId = fileUploaded.id;
    await ProxyService.api
        .updateBusiness(id: business.id, business: business.toJson());
    ProxyService.api.update(
        data: business.toJson(),
        endPoint: 'businesses/' + business.id.toString());
    // downloadGoogleDriveFile('data', fileUploaded.id);
  }

  // https://stackoverflow.com/questions/68955545/flutter-how-to-backup-user-data-on-google-drive-like-whatsapp-does
  Future<void> downloadGoogleDriveFile(String fName, String gdID) async {
    var client = await authenticate();

    var drive = ga.DriveApi(client);

    ga.Media file = (await drive.files
        .get(gdID, downloadOptions: ga.DownloadOptions.fullMedia)) as ga.Media;

    final dir = await getApplicationDocumentsDirectory();

    final saveFile = File(dir.path + '/db_1/$fName' + '.mdb');

    List<int> dataStore = [];

    file.stream.listen((data) {
      log.w("DataReceived: ${data.length}");
      dataStore.insertAll(dataStore.length, data);
    }, onDone: () {
      log.w("Task Done");
      saveFile.writeAsBytes(dataStore);
      log.w("File saved at ${saveFile.path}");
    }, onError: (error) {
      log.e("Some Error");
    });
  }
}
