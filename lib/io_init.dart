import 'package:flipper_services/objectbox_api.dart';

Future<void> initDb() async {
  await ObjectBoxApi.getDir(dbName: 'db_1');
}
