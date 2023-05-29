import 'package:firebase_core/firebase_core.dart';

Future<void> initDb() async {
  await Firebase.initializeApp();
}

void recordBug(dynamic error, dynamic stack) {
  // throw UnimplementedError('this does not work on web');
}
