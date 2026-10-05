import 'dart:typed_data';

/// Web build: there are no serial ports to drive.
bool get serialPortsSupported => false;

List<String> listSerialPorts() => const [];

class SerialPortWorker {
  static Future<SerialPortWorker?> spawn() async => null;

  Future<void> write(String port, int baud, Uint8List bytes) async {}

  Future<void> close() async {}

  void dispose() {}
}

class SerialPortException implements Exception {
  SerialPortException(this.message);
  final String message;
  @override
  String toString() => 'SerialPortException: $message';
}
