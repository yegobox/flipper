// import 'dart:async';
// import 'dart:io';

// import 'package:flipper_models/box/objectbox.dart';
// import 'package:flipper_models/realm_model_export.dart';
// import 'package:flipper_routing/routes.logger.dart';
// import 'package:flipper_services/dio_client.dart';
// import 'package:flipper_services/mobile_upload.dart';
// import 'package:flipper_services/proxy.dart';
// import 'package:flutter/foundation.dart' as f;
// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';

// import 'abstractions/api.dart';

// late Store store;

// class ExtendedClient extends http.BaseClient {
//   final http.Client _inner;
//   // ignore: sort_constructors_first
//   ExtendedClient(this._inner);
//   final log = getLogger('ExtendedClient');
//   @override
//   Future<http.StreamedResponse> send(http.BaseRequest request) {
//     String? token = ProxyService.box.read(key: 'bearerToken');
//
//     request.headers['Authorization'] = token ?? '';
//     request.headers['userId'] = userId ?? '';
//     request.headers['Content-Type'] = 'application/json';
//     // request.headers['Connection'] = "Keep-Alive";
//     // request.headers['Keep-Alive'] = "timeout=5, max=1000";
//     return _inner.send(request);
//   }
// }

// class ObjectBoxApi extends MobileUpload implements Api {
//   ExtendedClient client = ExtendedClient(http.Client());

//   String flipperApi = "https://flipper.yegobox.com";
//   late DioClient dioClient;
//   // String apihub = "https://turbo.yegobox.com";
//   String apihub = "https://apihub.yegobox.com";
//   // ignore: annotate_overrides, overridden_fields
//   final log = getLogger('ObjectBoxAPi');
//   // late
//   static getDir({required String dbName}) async {
//     Directory dir = await getApplicationDocumentsDirectory();
//     // final log = getLogger('ObjectBoxAPi');
//     // log.i('Path' + dir.path + '/$dbName');
//     store = Store(getObjectBoxModel(), directory: dir.path + '/$dbName');
//     ProxyService.isar.migrateToSync();
//     SyncClient syncClient = Sync.client(
//       store,
//       'ws://sync.yegobox.com:908', // wss for SSL, ws for unencrypted traffic
//       SyncCredentials.sharedSecretString("!@2022aurora"),
//     );
//     if (!f.kDebugMode &&
//         Sync.isAvailable() &&
//         await ProxyService.billing.activeSubscription()) {
//       syncClient.setRequestUpdatesMode(SyncRequestUpdatesMode.auto);
//       final print = getLogger('ObjectBoxAPi');
//       syncClient.requestUpdates(subscribeForFuturePushes: true);
//       syncClient.start();
//       syncClient.loginEvents.listen((event) {
//         if (event == SyncLoginEvent.loggedIn) print.d('sync fully');
//       });
//     } else if (f.kDebugMode) {
//       syncClient.setRequestUpdatesMode(SyncRequestUpdatesMode.auto);
//       final print = getLogger('ObjectBoxAPi');
//       syncClient.requestUpdates(subscribeForFuturePushes: true);
//       syncClient.start();
//       syncClient.loginEvents.listen((event) {
//         if (event == SyncLoginEvent.loggedIn) print.d('sync fully');
//       });
//     } else {
//       syncClient.setRequestUpdatesMode(SyncRequestUpdatesMode.auto);
//       final print = getLogger('ObjectBoxAPi');
//       syncClient.requestUpdates(subscribeForFuturePushes: true);
//       syncClient.stop();
//       syncClient.loginEvents.listen((event) {
//         // if (event == SyncLoginEvent.loggedIn) print.d('sync fully');
//       });
//     }
//   }

//   ObjectBoxApi({String? dbName, Directory? dir}) {
//     dioClient = DioClient(apihub, interceptors: []);

//     if (dbName != null) {
//       getDir(dbName: dbName);
//     }
//   }

//   @override
//   Future<List<Business>> getOnlineBusiness({required String userId}) {
//     // TODO: implement getOnlineBusiness
//     throw UnimplementedError();
//   }
//   // @override
//   // Future<List<Business>> getOnlineBusiness({required String userId}) async {
//   //   final response =
//   //       await client.get(Uri.parse("$apihub/v2/api/businessUserId/$userId"));
//   //   List<Business> businesses = [];
//   //   if (response.statusCode == 401) {
//   //     throw SessionException(term: "session expired");
//   //   }
//   //   if (response.statusCode == 404) {
//   //     throw BusinessNotFoundException(term: "Business not found");
//   //   } else if (response.statusCode == 500) {
//   //     throw InternalServerException(term: "Business not found");
//   //   }
//   //   final box = store.box<Business>();
//   //   // Business? business = box.get(sbusinessFromJson(response.body).id);
//   //   // if (business == null) {
//   //   //   box.put(fromJson(response.body), mode: PutMode.put);

//   //   return store
//   //       .box<Business>()
//   //       .getAll()
//   //       .where((business) => business.userId == userId)
//   //       .toList();
//   // }

//   // businesses.add(fromJson(response.body));
//   // return businesses;
//   // }
// }
