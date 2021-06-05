import 'package:chat/flat_widgets/flat_info_page_wrapper.dart';
import 'package:chat/flat_widgets/flat_primary_button.dart';
import 'package:chat/screens/homepage.dart';
import 'package:flutter/material.dart';

class Aboutpage extends StatefulWidget {
  static final String id = "Aboutpage";

  @override
  _AboutpageState createState() => _AboutpageState();
}

class _AboutpageState extends State<Aboutpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlatInfoPageWrapper(
        heading: "About Flipper social",
        subHeading: "Because we like fun!",
        body: Container(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "Flipper social is built interely on top of flipper business so you can manage your business in style!",
            style: TextStyle(
              fontSize: 14.0,
              color: Theme.of(context).primaryColorDark.withOpacity(0.54),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        footer: Container(
          margin: EdgeInsets.symmetric(
            vertical: 16.0,
          ),
          child: FlatPrimaryButton(
            onPressed: () {
              Navigator.pushNamed(context, Homepage.id);
            },
            prefixIcon: Icons.arrow_back,
            textAlign: TextAlign.right,
            text: "Back to Flipper Social",
          ),
        ),
      ),
    );
  }
}
