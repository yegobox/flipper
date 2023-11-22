import 'abstractions/printer.dart';

class WindowsBlueToothPrinterService implements Printer {
  @override
  Future<bool> connect() async {
    // TODO: implement connect
    // throw UnimplementedError();
    return false;
  }

  @override
  Future<List?> blueTooths() async {
    return null;

    // TODO: implement getBluetooths
    // throw UnimplementedError();
  }

  @override
  Future sendToPrinter() async {
    // TODO: implement sendToPrinter
    // throw UnimplementedError();
  }
}
