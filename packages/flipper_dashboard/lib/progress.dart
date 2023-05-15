import 'package:flutter/material.dart';

class UploadProgressWidget extends StatelessWidget {
  final Stream<double> progressStream;

  UploadProgressWidget({required this.progressStream});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: progressStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          double progress = snapshot.data!;
          return SizedBox(
            height: 4.0,
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
            ),
          );
        } else {
          return Container(); // Return an empty container while waiting for data
        }
      },
    );
  }
}
