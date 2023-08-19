import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class WebDesktopLogin extends StatelessWidget {
  const WebDesktopLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // keep it simple for now.
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Scan to log in v2'),
            QrImageView(
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
