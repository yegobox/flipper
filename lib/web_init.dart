import 'package:firebase_core/firebase_core.dart';
import 'package:flipper_models/isar_api.dart';

Future<void> initDb() async {
  await IsarAPI.getDir(dbName: 'db');
  await Firebase.initializeApp();
}

void recordBug(dynamic error, dynamic stack) {
  // throw UnimplementedError('this does not work on web');
}
