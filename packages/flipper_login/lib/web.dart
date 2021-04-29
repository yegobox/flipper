import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class WeLogin extends StatelessWidget {
  const WeLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // keep it simple for now.
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Scan to log in v2'),
            QrImage(
              data: "1234567890",
              version: QrVersions.auto,
              size: 200.0,
            ),
          ],
        ),
      ),
    );
  }
}
