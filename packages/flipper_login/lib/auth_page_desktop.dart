import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:google_fonts/google_fonts.dart';

import 'custom_phone.dart';

class AuthPageDesktop extends StatefulWidget {
  AuthPageDesktop({Key? key, required this.startUpPage}) : super(key: key);
  Widget startUpPage;

  @override
  State<AuthPageDesktop> createState() => _AuthPageDesktopState();
}

class _AuthPageDesktopState extends State<AuthPageDesktop> {
  final emailCtrl = TextEditingController();
  bool showSignUpForm = false;
  bool showLoginForm = false;
  final passwordCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AuthFlowBuilder(
      listener: (oldState, state, controller) {
        if (state is SignedIn) {
          Navigator.of(context).pushReplacementNamed('/profile');
        }
      },
      builder: (context, state, controller, _) {
        if (state is AwaitingEmailAndPassword) {
          return Form(
            key: formKey,
            child: Column(
              children: [
                if (showSignUpForm == true || showLoginForm == true)
                  SizedBox(
                    width: 368,
                    height: 68,
                    child: TextFormField(
                      autofocus: false,
                      controller: emailCtrl,
                      style:
                          const TextStyle(fontSize: 15.0, color: Colors.black),
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 29)),
                        hintText: 'Email address',
                        filled: true,
                        enabled: true,
                        labelText: "Email address",
                        labelStyle: const TextStyle(color: Colors.white),
                        hintStyle: const TextStyle(color: Colors.white),
                        contentPadding: const EdgeInsets.only(
                            left: 14.0, bottom: 6.0, top: 8.0),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                  ),
                if (showSignUpForm == true || showLoginForm == true)
                  SizedBox(
                    width: 368,
                    height: 68,
                    child: TextFormField(
                      autofocus: false,
                      controller: passwordCtrl,
                      style:
                          const TextStyle(fontSize: 15.0, color: Colors.black),
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 29)),
                        hintText: 'Password',
                        filled: true,
                        enabled: true,
                        labelText: "Password",
                        labelStyle: const TextStyle(color: Colors.white),
                        hintStyle: const TextStyle(color: Colors.white),
                        contentPadding: const EdgeInsets.only(
                            left: 14.0, bottom: 6.0, top: 8.0),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                  ),
                if (showSignUpForm == true)
                  SizedBox(
                    width: 368,
                    height: 68,
                    child: TextFormField(
                      autofocus: false,
                      style:
                          const TextStyle(fontSize: 15.0, color: Colors.black),
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 29)),
                        hintText: 'Confirm Password',
                        filled: true,
                        enabled: true,
                        labelText: "Confirm Password",
                        labelStyle: const TextStyle(color: Colors.white),
                        hintStyle: const TextStyle(color: Colors.white),
                        contentPadding: const EdgeInsets.only(
                            left: 14.0, bottom: 6.0, top: 8.0),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                  ),
                if (showSignUpForm == true)
                  Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    Container(
                        margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                        child: const Divider(
                          color: Colors.white,
                          height: 50,
                        )),
                    const Text("OR"),
                    Container(
                        margin: const EdgeInsets.only(left: 15.0, right: 10.0),
                        child: const Divider(
                          color: Colors.white,
                          height: 50,
                        )),
                  ]),
                TextButton(
                  onPressed: () {
                    setState(() {
                      showSignUpForm = false;
                      showLoginForm = false;
                    });
                    //navigate to phone screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CustomSignInPhoneWidget(
                                startUpPage: widget.startUpPage,
                              )),
                    );
                  },
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  child: const Text('Use phone number?'),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 368,
                  height: 68,
                  child: OutlinedButton(
                    style: ButtonStyle(
                      side: MaterialStateProperty.resolveWith(
                          (states) => const BorderSide(color: Colors.white)),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.transparent),
                      overlayColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.hovered)) {
                            return Colors.transparent;
                          }
                          if (states.contains(MaterialState.focused) ||
                              states.contains(MaterialState.pressed)) {
                            return Colors.transparent;
                          }
                          return null;
                        },
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        showSignUpForm = true;
                      });
                    },
                    child: Text(
                      "Create Account",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                          color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 22,
                ),
                SizedBox(
                  width: 368,
                  height: 68,
                  child: OutlinedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xffD07A2A)),
                      overlayColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.hovered)) {
                            return const Color(0xffD07A2A).withOpacity(0.04);
                          }
                          if (states.contains(MaterialState.focused) ||
                              states.contains(MaterialState.pressed)) {
                            return const Color(0xffD07A2A).withOpacity(0.12);
                          }
                          return null;
                        },
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        showSignUpForm = false;
                        showLoginForm = true;
                      });
                      //TODOcheck if the form is filled then proceed
                      // controller.setEmailAndPassword(
                      //   emailCtrl.text,
                      //   passwordCtrl.text,
                      // );
                    },
                    child: Text(
                      "Login",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                          color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          );
        } else if (state is SigningIn) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AuthFailed) {
          return ErrorText(exception: state.exception);
        }
        return const Text("Total fail");
      },
    );
  }
}
