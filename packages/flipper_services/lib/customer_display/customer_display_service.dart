import 'dart:async';
import 'dart:typed_data';

import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/customer_display/customer_display_protocol.dart';
import 'package:flipper_services/customer_display/serial_port_stub.dart'
    if (dart.library.ffi) 'package:flipper_services/customer_display/serial_port_io.dart';
import 'package:flipper_services/proxy.dart';

/// What is wired to the back of this till for the customer to read.
enum CustomerDisplayType { off, serial }

/// Device-local settings (never synced: it is this till's hardware).
class CustomerDisplaySettings {
  const CustomerDisplaySettings({
    required this.type,
    required this.port,
    required this.baud,
  });

  static const String typeKey = 'customerDisplayType';
  static const String portKey = 'customerDisplayPort';
  static const String baudKey = 'customerDisplayBaud';

  /// Rates these LED/VFD displays ship at; 2400 is the most common default.
  static const List<int> supportedBauds = [2400, 4800, 9600, 19200];
  static const int defaultBaud = 2400;

  final CustomerDisplayType type;
  final String? port;
  final int baud;

  bool get isConfigured =>
      type == CustomerDisplayType.serial && (port?.isNotEmpty ?? false);

  static CustomerDisplaySettings read() {
    final box = ProxyService.box;
    final typeName = box.readString(key: typeKey);
    return CustomerDisplaySettings(
      type: CustomerDisplayType.values.firstWhere(
        (t) => t.name == typeName,
        orElse: () => CustomerDisplayType.off,
      ),
      port: box.readString(key: portKey),
      baud: box.readInt(key: baudKey) ?? defaultBaud,
    );
  }
}

/// Shows the cart total, then the change, on the till's customer display.
///
/// Every call is fire-and-forget and cheap on the calling isolate: updates are
/// debounced, identical frames are skipped, and the port is driven from a
/// background isolate. With no display configured (or off Windows) every call
/// is a no-op.
class CustomerDisplayService {
  CustomerDisplayService._();

  static final CustomerDisplayService instance = CustomerDisplayService._();

  static const Duration _debounce = Duration(milliseconds: 120);

  /// How long the change (or amount paid) stays up after a sale.
  static const Duration saleResultHold = Duration(seconds: 8);

  CustomerDisplaySettings? _settings;
  Future<SerialPortWorker?>? _worker;
  Timer? _debounceTimer;
  Timer? _holdTimer;
  Uint8List? _pendingFrame;
  String? _lastSentKey;
  String? _initialisedFor;
  String? _lastError;

  bool get isSupported => serialPortsSupported;

  CustomerDisplaySettings get settings =>
      _settings ??= CustomerDisplaySettings.read();

  List<String> availablePorts() => listSerialPorts();

  /// Saves new settings and makes the next update reopen the port with them.
  Future<void> saveSettings(CustomerDisplaySettings next) async {
    final box = ProxyService.box;
    await box.writeString(
      key: CustomerDisplaySettings.typeKey,
      value: next.type.name,
    );
    if (next.port == null) {
      await box.remove(key: CustomerDisplaySettings.portKey);
    } else {
      await box.writeString(
        key: CustomerDisplaySettings.portKey,
        value: next.port!,
      );
    }
    await box.writeInt(key: CustomerDisplaySettings.baudKey, value: next.baud);
    final wasConfigured = settings.isConfigured;
    _settings = next;
    _resetLink();
    if (wasConfigured && !next.isConfigured) {
      // Turned off: leave the old display blank rather than frozen on a total.
      await (await _worker)?.close();
    }
  }

  /// The live cart total (TOTAL lamp). Zero blanks the display — except while
  /// a sale result is held: completing a sale empties the cart, and that must
  /// not wipe the change before the customer has read it.
  void showTotal(num total) {
    if (total.abs() < 0.005) {
      if (_holdTimer?.isActive ?? false) return;
      clear();
      return;
    }
    _holdTimer?.cancel();
    _queue(CustomerDisplayProtocol.frame(total, CustomerDisplayLamp.total));
  }

  /// After Pay: the change to hand back (CHANGE lamp), or the amount paid
  /// (COLLECT lamp) when there is none. Blanks after [saleResultHold] unless
  /// the next sale starts first.
  void showSaleResult({required num total, num? tendered}) {
    if (!settings.isConfigured) return;
    final change = (tendered ?? total) - total;
    _queue(
      change > 0.005
          ? CustomerDisplayProtocol.frame(change, CustomerDisplayLamp.change)
          : CustomerDisplayProtocol.frame(total, CustomerDisplayLamp.collect),
    );
    _holdTimer?.cancel();
    _holdTimer = Timer(saleResultHold, clear);
  }

  void clear() {
    _holdTimer?.cancel();
    _queue(
      Uint8List.fromList([
        ...CustomerDisplayProtocol.lamp(CustomerDisplayLamp.off),
        ...CustomerDisplayProtocol.clear(),
      ]),
    );
  }

  /// Lights every segment on [port] at [baud], for finding the right pair on
  /// site. Returns null when the bytes went out (the cashier still has to
  /// confirm the display lit up), else why they did not.
  Future<String?> test({required String port, required int baud}) async {
    final worker = await (_worker ??= SerialPortWorker.spawn());
    if (worker == null)
      return 'Customer displays are only supported on Windows';
    try {
      await worker.write(
        port,
        baud,
        Uint8List.fromList([
          ...CustomerDisplayProtocol.init(),
          ...CustomerDisplayProtocol.lamp(CustomerDisplayLamp.total),
          ...CustomerDisplayProtocol.show('8.8.8.8.8.8.8.8'),
        ]),
      );
      // The worker now holds the tested port open; drop it so the configured
      // one is reopened (and re-initialised) on the next real update.
      _resetLink();
      return null;
    } on SerialPortException catch (e) {
      _resetLink();
      return e.message;
    }
  }

  /// Blanks [port] after a [test] the cashier did not keep, so a display on
  /// the wrong setting is not left lit with eights. Best effort.
  Future<void> blankTested({required String port, required int baud}) async {
    final worker = await _worker;
    if (worker == null) return;
    try {
      await worker.write(
        port,
        baud,
        Uint8List.fromList([
          ...CustomerDisplayProtocol.lamp(CustomerDisplayLamp.off),
          ...CustomerDisplayProtocol.clear(),
        ]),
      );
      await worker.close();
    } on SerialPortException {
      // Nothing listening there; nothing to blank.
    }
    _resetLink();
  }

  void _queue(Uint8List frame) {
    if (!settings.isConfigured || !isSupported) return;
    _pendingFrame = frame;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounce, () => unawaited(_flush()));
  }

  Future<void> _flush() async {
    final frame = _pendingFrame;
    _pendingFrame = null;
    final config = settings;
    if (frame == null || !config.isConfigured) return;
    final key = frame.join(',');
    if (key == _lastSentKey) return;

    final link = '${config.port}@${config.baud}';
    final needsInit = _initialisedFor != link;
    final bytes = needsInit
        ? Uint8List.fromList([...CustomerDisplayProtocol.init(), ...frame])
        : frame;
    try {
      final worker = await (_worker ??= SerialPortWorker.spawn());
      if (worker == null) return;
      await worker.write(config.port!, config.baud, bytes);
      _lastSentKey = key;
      _initialisedFor = link;
      if (_lastError != null) {
        talker.info('[customer_display] $link is answering again');
        _lastError = null;
      }
    } catch (e) {
      _resetLink();
      final message = e is SerialPortException ? e.message : '$e';
      // Logged once per distinct failure: a dead display would otherwise log
      // on every cart tap.
      if (message != _lastError) {
        talker.warning('[customer_display] $link: $message');
        _lastError = message;
      }
    }
  }

  void _resetLink() {
    _lastSentKey = null;
    _initialisedFor = null;
  }
}
