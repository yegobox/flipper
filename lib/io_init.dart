import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flipper_services/objectbox_api.dart';

Future<void> initDb() async {
  await ObjectBoxApi.getDir(dbName: 'db_1');
  if (Platform.isWindows) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: 'AIzaSyCpnbw9i23T0237jgd2ladtPgsGYbmioqA',
      appId: '1:672237316015:web:e289bfb5c92506c1c2715a',
      messagingSenderId: 'G-88GKL70K3K',
      projectId: 'yegobox-2ee43',
    ));
  } else {
    await Firebase.initializeApp();
  }
}
