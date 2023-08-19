import 'package:flutter/material.dart';

class UploadProgressWidget extends StatelessWidget {
  final Stream<double> progressStream;

  UploadProgressWidget({required this.progressStream});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: progressStream,
      builder: (context, AsyncSnapshot<double> snapshot) {
        final progress = snapshot.data ?? 0;
        return progress < 100
            ? SizedBox(
                height: 4.0,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              )
            : Container();
      },
    );
  }
}
