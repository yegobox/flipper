/// How a receipt printer is reached without a Windows printer driver.
enum PrinterTransport {
  /// A COM port: a motherboard UART, or a USB-serial bridge (CH340, PL2303,
  /// FTDI) inside the till.
  serial,

  /// A USB printer-class device on Windows' inbox `usbprint.sys`.
  usb,
}

/// Where to send ESC/POS bytes.
class PrinterTarget {
  const PrinterTarget.serial(this.path, this.baud)
    : transport = PrinterTransport.serial;

  const PrinterTarget.usb(this.path)
    : transport = PrinterTransport.usb,
      baud = 0;

  final PrinterTransport transport;

  /// `COM3`, or a USB device interface path.
  final String path;

  /// Serial speed; unused for USB.
  final int baud;

  String get key => '${transport.name}|$path|$baud';

  /// Short label for settings and logs.
  String get label => transport == PrinterTransport.usb
      ? 'USB ${describeUsbPath(path)}'
      : '$path @ $baud';

  List<Object> toMessage() => [transport.name, path, baud];

  static PrinterTarget fromMessage(List<Object?> args, int start) {
    final transport = args[start] as String;
    final path = args[start + 1] as String;
    final baud = args[start + 2] as int;
    return transport == PrinterTransport.usb.name
        ? PrinterTarget.usb(path)
        : PrinterTarget.serial(path, baud);
  }

  @override
  bool operator ==(Object other) => other is PrinterTarget && other.key == key;

  @override
  int get hashCode => key.hashCode;
}

/// A COM port and what the registry says is behind it.
class SerialPortInfo {
  const SerialPortInfo({
    required this.port,
    this.driverName,
    this.vid,
    this.pid,
  });

  final String port;

  /// The `HARDWARE\DEVICEMAP\SERIALCOMM` name, e.g. `\Device\Serial0`.
  final String? driverName;
  final int? vid;
  final int? pid;

  /// serial.sys only names on-board UARTs `\Device\SerialN`.
  bool get isOnboardUart =>
      vid == null && (driverName?.startsWith(r'\Device\Serial') ?? false);

  /// A USB-serial bridge chip that all-in-one tills wire printers to.
  bool get isKnownPrinterBridge =>
      vid != null && knownSerialBridges.contains((vid!, pid));

  String get description {
    final ids = vid == null ? '' : ' (${hex4(vid!)}:${hex4(pid ?? 0)})';
    if (isOnboardUart) return '$port — on-board serial';
    return '$port — ${driverName ?? 'serial'}$ids';
  }
}

/// A USB printer-class device.
class UsbPrinterInfo {
  const UsbPrinterInfo({required this.path, this.vid, this.pid});

  final String path;
  final int? vid;
  final int? pid;

  /// Made by a receipt-printer vendor, so safe to send ESC/POS to without
  /// asking. Anything else could be an office printer.
  bool get isKnownReceiptPrinter =>
      vid != null && knownReceiptPrinterVendors.contains(vid);

  String get description => 'USB ${describeUsbPath(path)}';
}

/// USB-serial bridges seen inside POS terminals: CH340/CH341, PL2303,
/// FTDI FT232, CP210x.
const Set<(int, int?)> knownSerialBridges = {
  (0x1A86, 0x7523),
  (0x1A86, 0x5523),
  (0x067B, 0x2303),
  (0x0403, 0x6001),
  (0x10C4, 0xEA60),
};

/// USB vendor ids of receipt-printer makers and the chip vendors behind the
/// generic "POS58"/"POS80" printers.
const Set<int> knownReceiptPrinterVendors = {
  0x0416, // Winbond — most generic POS58/POS80 printers
  0x0483, // STMicro — many embedded printer boards
  0x0FE6, // ICS Advent — common in Chinese POS printers
  0x1FC9, // NXP
  0x28E9, // GigaDevice
  0x6868, // Generic POS printer boards
  0x20D1, // Rongta
  0x1504, // Bixolon
  0x0519, // Star Micronics
  0x154F, // SNBC
  0x0DD4, // Custom
  0x1D90, // Citizen
  0x04B8, // Epson (TM series)
};

/// Ports worth probing, likeliest first: known printer bridges, then on-board
/// UARTs, then the rest. [exclude] (the customer display) is dropped.
List<SerialPortInfo> orderSerialCandidates(
  List<SerialPortInfo> ports, {
  String? exclude,
}) {
  int rank(SerialPortInfo p) =>
      p.isKnownPrinterBridge ? 0 : (p.isOnboardUart ? 1 : 2);
  final candidates = [
    for (final p in ports)
      if (p.port.toUpperCase() != exclude?.toUpperCase()) p,
  ];
  // Stable: ports keep their COM order within a rank.
  final indexed = candidates.asMap().entries.toList()
    ..sort((a, b) {
      final byRank = rank(a.value).compareTo(rank(b.value));
      return byRank != 0 ? byRank : a.key.compareTo(b.key);
    });
  return [for (final e in indexed) e.value];
}

/// `VID_1A86&PID_7523`, `vid_0416&pid_5011` or `VID_0403+PID_6001+…` → ids.
({int vid, int pid})? parseVidPid(String text) {
  final match = RegExp(
    r'vid_([0-9a-f]{4})[&+]pid_([0-9a-f]{4})',
    caseSensitive: false,
  ).firstMatch(text);
  if (match == null) return null;
  return (
    vid: int.parse(match.group(1)!, radix: 16),
    pid: int.parse(match.group(2)!, radix: 16),
  );
}

String describeUsbPath(String path) {
  final ids = parseVidPid(path);
  return ids == null ? 'printer' : '${hex4(ids.vid)}:${hex4(ids.pid)}';
}

String hex4(int v) => v.toRadixString(16).toUpperCase().padLeft(4, '0');

class PrinterPortException implements Exception {
  PrinterPortException(this.message);
  final String message;
  @override
  String toString() => 'PrinterPortException: $message';
}
