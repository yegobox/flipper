import 'package:customappbar/customappbar.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/ui/widget/note/note_input.dart';
import 'package:flutter/material.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({Key key}) : super(key: key);

  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        onPop: () {
          ProxyService.nav.pop();
        },
        disableButton: false,
        title: 'Add Note',
      ),
      body: Column(
        // ignore: prefer_const_literals_to_create_immutables
        children: <Widget>[
          const Center(
            child: NoteInput(
              hint: 'Add Note',
            ),
          )
        ],
      ),
    );
  }
}
