import 'package:customappbar/customappbar.dart';
import 'package:flipper/home/widget/note_input.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flutter/material.dart';

class AddNoteScreen extends StatefulWidget {
  AddNoteScreen({Key key}) : super(key: key);

  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        onPop: () {
          Router.navigator.pop();
        },
        disableButton: false,
        title: "Add Note",
      ),
      body: Column(
        children: <Widget>[
          Center(
            child: NoteInput(
              hint: "Add Note",
            ),
          )
        ],
      ),
    );
  }
}
