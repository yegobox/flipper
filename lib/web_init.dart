import 'package:firebase_core/firebase_core.dart';
import 'package:universal_platform/universal_platform.dart';

final isAndroid = UniversalPlatform.isAndroid;
Future<void> initDb() async {
  await Firebase.initializeApp();
}

void recordBug(dynamic error, dynamic stack) {
  // throw UnimplementedError('this does not work on web');
}
