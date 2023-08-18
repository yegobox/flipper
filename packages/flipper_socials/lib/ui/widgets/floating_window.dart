import 'package:flutter/material.dart';

class FloatingWindow extends StatelessWidget {
  const FloatingWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text('This is the background page!'),
              const Text(
                  'If you tap on the floating screen, it stops floating.'),
              const Text('Navigation works as expected.'),
              MaterialButton(
                color: Theme.of(context).primaryColor,
                child: const Text('Push to navigation'),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
