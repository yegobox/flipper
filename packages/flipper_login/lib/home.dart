import 'package:flipper_login/landing.dart';
import 'package:flipper_login/signinpage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  //final User user;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to Flipper'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    Landing(startUpPage: Center(child: Text("hello"))),
              ),
            );
          },
          child: Text('Sign Out'),
        ),
      ),
    );
  }
}
