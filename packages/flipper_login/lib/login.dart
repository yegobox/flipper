library flipper_login;
import 'package:flutter/material.dart';

import 'helpers/style.dart';
import 'providers/auth.dart';
import 'widgets/custom_button.dart';
import 'widgets/custom_text.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController number = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = new AuthProvider();
    return SafeArea(
      child: Scaffold(
        backgroundColor: white,
        body: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "assets/cell.png",
                  width: 160,
                  package: 'flipper_login',
                ),
              ],
            ),
            SizedBox(height: 10),
            CustomText(text: "Flipper", size: 28, weight: FontWeight.bold),
            SizedBox(height: 5),
            RichText(
                text: TextSpan(children: [
              TextSpan(text: "Welcome to"),
              TextSpan(text: " Flipper", style: TextStyle(color: Colors.blue.shade900)),
              TextSpan(text: " app"),
            ], style: TextStyle(color: black))),
            SizedBox(height: 10),
            CustomText(text: auth.errorMessage ?? "", color: red,),
            Padding(
              padding: const EdgeInsets.only(left:12, right: 12, bottom: 12),
              child: Container(
                decoration: BoxDecoration(
                    color: white,
                    border: Border.all(color: black, width: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: grey.withOpacity(0.3),
                          offset: Offset(2, 1),
                          blurRadius: 2
                      )
                    ]
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left:8.0),
                  child: TextField(
                    keyboardType: TextInputType.phone,
                    controller: number,
                    decoration: InputDecoration(
                        icon: Icon(Icons.phone_android, color: grey),
                        border: InputBorder.none,
                        hintText: "+250 788 3658",
                        hintStyle: TextStyle(
                            color: grey,
                            fontFamily: "Sen",
                            fontSize: 18
                        )
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("After entering your phone number, click on verify to authenticate yourself! Then wait up to 20 seconds to get th OTP and procede", textAlign: TextAlign.center, style: TextStyle(color: grey),),
            ),
            SizedBox(height: 10),
            CustomButton(msg: "Verify", onTap: (){
              auth.verifyPhone(context, number.text);
            })
          ]),
        ),
      ),
    );
  }
}
