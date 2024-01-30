
import 'dart:async';

class NotificationStream {
  // Create a stream controller
  final StreamController<String> _streamController = StreamController<String>.broadcast();

  // Expose the stream to subscribe
  Stream<String> get stream => _streamController.stream;

  // Function to send data to the stream
  void  sendData(String data) {
    _streamController.add(data);
  }

  // Close the stream controller when it's no longer needed
  void dispose() {
    _streamController.close();
  }
}
