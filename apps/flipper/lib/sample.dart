import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<LogicalKeyboardKey> keys = [];
  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event) {
        final key = event.logicalKey;

        if (event is RawKeyDownEvent) {
          if (keys.contains(key)) return;
          if (event.isKeyPressed(LogicalKeyboardKey.controlLeft)) {
            // log("control is pressed");
          }
          setState(() {
            keys.add(key);
          });
        } else {
          setState(() {
            keys.remove(key);
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Image on Top of Dialog'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {},
            child: const Text('Show Dialog with Image on Top'),
          ),
        ),
      ),
    );
  }
}
