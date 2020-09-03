import 'package:firebase_core/firebase_core.dart';
import 'package:flipper/flipper_app.dart';
import 'package:flipper/util/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  
  configureLogger();
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  //   statusBarColor: Colors.black,
  //   statusBarIconBrightness: Brightness.dark,
  //   systemNavigationBarColor: Colors.white,
  //   systemNavigationBarIconBrightness: Brightness.light,
  //   systemNavigationBarDividerColor: Colors.transparent,
  // ));
 
  await Firebase.initializeApp();
  runApp(FlipperApp());
}



