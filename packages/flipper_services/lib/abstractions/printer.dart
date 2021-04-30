abstract class Printer {
  Future sendToPrinter();
  Future<List?> getBluetooths();
  Future<bool> connect({required String mac});
}
