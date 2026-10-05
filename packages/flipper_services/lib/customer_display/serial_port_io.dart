import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

/// Serial ports are only driven on Windows, where the all-in-one tills are.
bool get serialPortsSupported => Platform.isWindows;

/// COM ports Windows knows about (`COM1`, `COM3`, …), lowest first.
List<String> listSerialPorts() {
  if (!serialPortsSupported) return const [];
  var size = 1 << 16;
  for (var attempt = 0; attempt < 4; attempt++) {
    final buffer = wsalloc(size);
    try {
      // With a null device name this lists every MS-DOS device name, each
      // NUL-terminated.
      final length = QueryDosDevice(nullptr, buffer, size);
      if (length == 0) {
        if (GetLastError() == ERROR_INSUFFICIENT_BUFFER) {
          size *= 2;
          continue;
        }
        return const [];
      }
      final chars = buffer.cast<Uint16>().asTypedList(length);
      final ports = <String>[];
      var start = 0;
      for (var i = 0; i < length; i++) {
        if (chars[i] != 0) continue;
        if (i > start) {
          final name = String.fromCharCodes(chars, start, i);
          if (RegExp(r'^COM\d+$').hasMatch(name)) ports.add(name);
        }
        start = i + 1;
      }
      ports.sort(
        (a, b) =>
            int.parse(a.substring(3)).compareTo(int.parse(b.substring(3))),
      );
      return ports;
    } finally {
      free(buffer);
    }
  }
  return const [];
}

/// Owns one open COM port on a background isolate.
///
/// `WriteFile` on a serial port blocks for as long as the bytes take on the
/// wire (about 50 ms per update at 2400 baud), and the till's main isolate
/// also runs Ditto and the cart, so the handle never lives there.
class SerialPortWorker {
  SerialPortWorker._(this._isolate, this._commands);

  final Isolate _isolate;
  final SendPort _commands;

  static Future<SerialPortWorker?> spawn() async {
    if (!serialPortsSupported) return null;
    final ready = ReceivePort();
    final isolate = await Isolate.spawn(
      _workerMain,
      ready.sendPort,
      debugName: 'customer-display-serial',
    );
    final commands = await ready.first as SendPort;
    return SerialPortWorker._(isolate, commands);
  }

  /// Writes [bytes] to [port], (re)opening it at [baud] when needed. Throws a
  /// [SerialPortException] when the port cannot be opened or written.
  Future<void> write(String port, int baud, Uint8List bytes) =>
      _request(['write', port, baud, bytes]);

  /// Closes the port (it reopens on the next [write]).
  Future<void> close() => _request(const ['close']);

  void dispose() => _isolate.kill(priority: Isolate.immediate);

  Future<void> _request(List<Object> command) async {
    final reply = ReceivePort();
    _commands.send([reply.sendPort, ...command]);
    final error = await reply.first;
    if (error is String) throw SerialPortException(error);
  }
}

class SerialPortException implements Exception {
  SerialPortException(this.message);
  final String message;
  @override
  String toString() => 'SerialPortException: $message';
}

void _workerMain(SendPort ready) {
  final commands = ReceivePort();
  ready.send(commands.sendPort);

  int? handle;
  String? openKey;

  void closePort() {
    if (handle != null) CloseHandle(handle!);
    handle = null;
    openKey = null;
  }

  commands.listen((message) {
    final args = message as List<Object?>;
    final reply = args[0] as SendPort;
    try {
      switch (args[1]) {
        case 'write':
          final port = args[2] as String;
          final baud = args[3] as int;
          final bytes = args[4] as Uint8List;
          final key = '$port@$baud';
          if (openKey != key) {
            closePort();
            handle = _openPort(port, baud);
            openKey = key;
          }
          try {
            _writeAll(handle!, bytes);
          } catch (_) {
            // A wedged or unplugged port: drop it so the next write reopens.
            closePort();
            rethrow;
          }
        case 'close':
          closePort();
      }
      reply.send(null);
    } catch (e) {
      reply.send(e is SerialPortException ? e.message : e.toString());
    }
  });
}

int _openPort(String port, int baud) {
  // The \\.\ prefix is required for COM10 and above, and harmless below.
  final path = '\\\\.\\$port'.toNativeUtf16();
  try {
    final handle = CreateFile(
      path,
      GENERIC_READ | GENERIC_WRITE,
      0,
      nullptr,
      OPEN_EXISTING,
      0,
      NULL,
    );
    if (handle == INVALID_HANDLE_VALUE) {
      throw SerialPortException(
        '$port could not be opened (Windows error ${GetLastError()}) — '
        'wrong port, or in use by another program',
      );
    }
    final dcb = calloc<DCB>();
    final timeouts = calloc<COMMTIMEOUTS>();
    try {
      dcb.ref.DCBlength = sizeOf<DCB>();
      if (GetCommState(handle, dcb) == 0) {
        CloseHandle(handle);
        throw SerialPortException('$port: GetCommState failed');
      }
      dcb.ref
        ..BaudRate = baud
        ..ByteSize = 8
        ..Parity = NOPARITY
        ..StopBits = ONESTOPBIT;
      var bits = dcb.ref.bitfield;
      bits |= 0x1; // fBinary
      // No hardware or XON/XOFF flow control: fOutxCtsFlow, fOutxDsrFlow,
      // fOutX, fInX. A display that never raises CTS would otherwise block
      // every write until the timeout. Also fAbortOnError (bit 14), which
      // would fail every write after one line error until ClearCommError.
      bits &= ~((1 << 2) | (1 << 3) | (1 << 8) | (1 << 9) | (1 << 14));
      // Assert DTR and RTS: some displays treat them as "host present".
      bits = (bits & ~(0x3 << 4)) | (DTR_CONTROL_ENABLE << 4);
      bits = (bits & ~(0x3 << 12)) | (RTS_CONTROL_ENABLE << 12);
      dcb.ref.bitfield = bits;
      if (SetCommState(handle, dcb) == 0) {
        CloseHandle(handle);
        throw SerialPortException('$port: cannot set $baud baud');
      }
      // Bound every write so a dead display cannot hang the worker.
      timeouts.ref
        ..WriteTotalTimeoutConstant = 1000
        ..WriteTotalTimeoutMultiplier = 10;
      SetCommTimeouts(handle, timeouts);
      return handle;
    } finally {
      free(dcb);
      free(timeouts);
    }
  } finally {
    free(path);
  }
}

void _writeAll(int handle, Uint8List bytes) {
  final buffer = calloc<Uint8>(bytes.length);
  final written = calloc<Uint32>();
  try {
    buffer.asTypedList(bytes.length).setAll(0, bytes);
    final ok = WriteFile(handle, buffer, bytes.length, written, nullptr);
    if (ok == 0 || written.value != bytes.length) {
      throw SerialPortException(
        'write failed (${written.value}/${bytes.length} bytes, '
        'Windows error ${GetLastError()})',
      );
    }
  } finally {
    free(buffer);
    free(written);
  }
}
