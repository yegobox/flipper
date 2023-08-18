// import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'phone_input_screen.dart' as phone;

class CustomSignInPhoneWidget extends StatelessWidget {
  const CustomSignInPhoneWidget({Key? key, required this.startUpPage})
      : super(key: key);

  final Widget startUpPage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.userChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return startUpPage;
            } else {
              return phone.PhoneInputScreen(

                  countryCode: 'BU',
                  // headerBuilder: (context, constraints, shrinkOffset) {
                  //   return Padding(
                  //     padding: const EdgeInsets.all(20).copyWith(top: 40),
                  //     child: Icon(
                  //       Icons.phone,
                  //       color: Colors.blue,
                  //       size: constraints.maxWidth / 4 * (1 - shrinkOffset),
                  //     ),
                  //   );
                  // },
                  );
            }
          }),
    );
  }
}
