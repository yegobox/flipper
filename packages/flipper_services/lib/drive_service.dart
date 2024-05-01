import 'dart:convert';
import 'dart:io';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/secure_storage.dart';
import 'package:googleapis/drive/v3.dart' as ga;
import 'package:flipper_models/isar_models.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'extension_google_sign_in_as_googleapis_auth.dart';

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

final List<String> _scopes = [
  ga.DriveApi.driveFileScope,
  ga.DriveApi.driveAppdataScope,
];

class GoogleDrive {
  final storage = SecureStorage();

  /// if the  var credentials = await storage.getCredentials();
  /// has some data i.e we authenticated and we have some token,
  /// the problem is that at the time of using it it might have expired
  /// then we call this method first to refresh the token
  /// for this time we use silent authentication
  /// to avoid user to be prompted for authentication again
  /// because there is known issue https://stackoverflow.com/questions/27890737/firebase-google-auth-offline-access-type-in-order-to-get-a-token-refresh
  /// we silently authenticate and get the token using the silent authentication
  /// for the second time
  Future<http.Client?> silentLogin() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: _scopes);

    if (ProxyService.box.hasSignedInForAutoBackup()) {
      GoogleSignInAccount? auth = await _googleSignIn.signInSilently();
      if (auth != null) {
        //we couldn't sign in the user using silent sign in, now use a prompt.
        await _googleSignIn.signIn();
        ProxyService.box
            .writeBool(key: 'hasSignedInForAutoBackup', value: true);
      } else {
        return null;
      }
    } else {
      //this is the first time sign in use prompt to sign in.
      GoogleSignInAccount? auth = await _googleSignIn.signIn();
      if (auth != null) {
        ProxyService.box
            .writeBool(key: 'hasSignedInForAutoBackup', value: true);
      } else {
        return null;
      }
    }
    // TODOwe can silently refresh the token if we know it has expired, but we have no way to know
    //therefore the above code is used as it will prompt the user for authentication as  _googleSignIn.authenticatedClient() will be null
    // await _googleSignIn.signInSilently();
    // New refreshed token
    AuthClient httpClient = (await _googleSignIn.authenticatedClient())!;
    //Save Credentials
    // log.i(httpClient.credentials.accessToken);

    await storage.saveCredentials(httpClient.credentials.accessToken,
        httpClient.credentials.refreshToken ?? '');
    return httpClient;
  }

  /// Get Authenticated Http Client
  /// the method will check if the token is expired or not
  /// if it is expired it will call refreshToken()
  /// if is the first time it will call the authentication with normal prompt flow
  /// if the token is not expired it will return the http client

  Future<void> updateBusiness(IBusiness business) async {
    business.backUpEnabled = true;
    business.lastDbBackup = DateTime.now().toIso8601String();

    /// notify the online that user has enabled the backup
    /// also update the property locally.
    await ProxyService.isar.update(data: business);
  }

  /// Upload File to user's Google Drive appData folder
  /// https://developers.google.com/drive/api/v3/appdata
  /// before that we first silently authenticate the user
  /// because the first login will prompt the user to login
  /// and the second login will not prompt the user to login
  Future upload() async {
    // download files first before uploading
    final dir = ProxyService.isar.dbPath();
    // ProxyService.isarApi
    File file = File(path.context.canonicalize(dir + '/mdbx.dat'));
    // end of download
    http.Client? client = await silentLogin();
    Future.delayed(const Duration(seconds: 20));
    if (client == null) return;
    ga.DriveApi drive = ga.DriveApi(client);
    ga.File fileToUpload = ga.File();
    // https://ko.stackfinder.net/questions/68955545/flutter-how-to-backup-user-data-on-google-drive-like-whatsapp-does
    // https://developers.google.com/drive/api/v3/appdata
    fileToUpload.parents = ["appDataFolder"];

    fileToUpload.name = path.basename(file.absolute.path);

    ga.File response = await drive.files.create(
      fileToUpload,
      uploadMedia: ga.Media(
        file.openRead(),
        file.lengthSync(),
      ),
    );

    FileUploaded fileUploaded = FileUploaded.fromJson(response.toJson());
    IBusiness? business = await ProxyService.isar.getBusiness();
    business!.backupFileId = fileUploaded.id;
    await ProxyService.isar.update(data: business);
    ProxyService.isar.update(data: business);
    ProxyService.box.writeString(key: 'gdID', value: fileUploaded.id);
  }

  /// file stream will always be available if the dgId is not null
  /// and if it is not null the function will continue and download the remote version which might have updated data
  ///
  // https://stackoverflow.com/questions/68955545/flutter-how-to-backup-user-data-on-google-drive-like-whatsapp-does
  Future<void> downloadGoogleDriveFile(String fName, String? gdID) async {
    if (gdID == null) return;
    var client = await silentLogin();
    // delay a bit to avoid concuracy issues.
    Future.delayed(const Duration(seconds: 20));
    if (client == null) return;
    var drive = ga.DriveApi(client);

    ga.Media file = (await drive.files
        .get(gdID, downloadOptions: ga.DownloadOptions.fullMedia)) as ga.Media;

    final dir = ProxyService.isar.dbPath();

    final saveFile = File(dir + '/$fName');

    List<int> dataStore = [];

    file.stream.listen((data) {
      // log.w("DataReceived: ${data.length}");
      dataStore.insertAll(dataStore.length, data);
    }, onDone: () async {
      // log.w("Task Done");
      await saveFile.writeAsBytes(dataStore);
      // changeFileNameOnlySync(file, 'mdbx.dat');
    }, onError: (error) {});
  }

  File changeFileNameOnlySync(File file, String newFileName) {
    String path = file.path;
    int lastSeparator = path.lastIndexOf(Platform.pathSeparator);
    String newPath = path.substring(0, lastSeparator + 1) + newFileName;
    return file.renameSync(newPath);
  }
}
