import 'package:flipper_login/firebase_options.dart';
import 'package:flipper_login/landing.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipper_login/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final Future<FirebaseApp> initialization =
      Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MaterialApp(
    home: FutureBuilder(
      future: initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("Error: ${snapshot.error}"),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return const FirebaseAuthStream();
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    ),
    debugShowCheckedModeBanner: false,
  ));
}

class FirebaseAuthStream extends StatelessWidget {
  const FirebaseAuthStream({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            return const Scaffold(
                body: Landing(
              startUpPage: Center(child: Text("hello")),
            ));
          } else {
            return const HomePage();
          }
        }
        return const CircularProgressIndicator();
      },
    );
  }
}




// The bellow command were used to activate flutterfire_cli very good to use.
// dart global activate flutterfire_cli

