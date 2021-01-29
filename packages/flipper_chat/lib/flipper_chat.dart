library flipper_chat;

import 'package:flutter/material.dart';

class ChatView extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that
          // was created by the App.build method, and use it to set
          // our appbar title.
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Richard",
              ),
            ],
          ),

          leading: new IconButton(
            icon: new Icon(Icons.accessibility),
            onPressed: () {},
          ),
          actions: [
            Text(
              "Calling Menu",
            ),
          ],
        ),
        body: Column(children: [
          Card(
            color: Colors.red,
            child: Text("Hello Richard"),
          ),
          Card(
            color: Colors.green,
            child: Text("Hello Aug, how are you?"),
          ),
        ]),
        bottomNavigationBar: Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.send),
                  border: const OutlineInputBorder(),
                ),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.mic),
              onPressed: () {},
            )
          ],
        ));
  }
}
