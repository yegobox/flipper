import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:flipper_services/builtin_printer/printer_port_types.dart';
import 'package:flipper_services/customer_display/serial_port_io.dart'
    show listSerialPorts;
import 'package:win32/win32.dart';

export 'package:flipper_services/builtin_printer/printer_port_types.dart';

/// Raw printer ports are only driven on Windows, where the all-in-one tills are.
bool get printerPortsSupported => Platform.isWindows;

/// Every COM port Windows has, with what the registry says is behind it.
List<SerialPortInfo> describeSerialPorts() {
  if (!printerPortsSupported) return const [];
  final ports = listSerialPorts();
  if (ports.isEmpty) return const [];

  // \Device\Serial0 → COM1. serial.sys names motherboard UARTs \Device\SerialN;
  // USB bridges use their own driver's names (VCP0, USBSER000, …).
  final drivers = <String, String>{};
  _forEachValue(r'HARDWARE\DEVICEMAP\SERIALCOMM', (name, data) {
    drivers[data.toUpperCase()] = name;
  });

  // USB-serial bridges record their COM port under the device instance.
  final usb = <String, ({int vid, int pid})>{};
  for (final bus in const ['USB', 'FTDIBUS']) {
    final root = 'SYSTEM\\CurrentControlSet\\Enum\\$bus';
    for (final device in _subKeys(root)) {
      final ids = parseVidPid(device);
      if (ids == null) continue;
      for (final instance in _subKeys('$root\\$device')) {
        final port = _readString(
          '$root\\$device\\$instance\\Device Parameters',
          'PortName',
        );
        if (port != null) usb[port.toUpperCase()] = ids;
      }
    }
  }

  return [
    for (final port in ports)
      SerialPortInfo(
        port: port,
        driverName: drivers[port],
        vid: usb[port]?.vid,
        pid: usb[port]?.pid,
      ),
  ];
}

/// LPT ports Windows has (`LPT1`, …), lowest first. Only real parallel
/// hardware (`parport.sys`) creates these DOS names.
List<String> listParallelPorts() {
  if (!printerPortsSupported) return const [];
  var size = 1 << 16;
  for (var attempt = 0; attempt < 4; attempt++) {
    final buffer = wsalloc(size);
    try {
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
          if (RegExp(r'^LPT\d+$').hasMatch(name)) ports.add(name);
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

/// `GUID_DEVINTERFACE_USBPRINT`: devices bound to Windows' inbox
/// `usbprint.sys` ("USB Printing Support"). Needs no vendor driver.
const _usbPrintInterface = '{28d78fad-5a12-11d1-ae5b-0000f803a8c2}';

/// USB printer-class devices that are plugged in, by device path.
List<UsbPrinterInfo> listUsbPrinters() {
  if (!printerPortsSupported) return const [];
  final found = <UsbPrinterInfo>[];
  using((arena) {
    final guid = GUIDFromString(_usbPrintInterface, allocator: arena);
    final set = SetupDiGetClassDevs(
      guid,
      nullptr,
      NULL,
      DIGCF_PRESENT | DIGCF_DEVICEINTERFACE,
    );
    if (set == INVALID_HANDLE_VALUE) return;
    try {
      final iface = arena<SP_DEVICE_INTERFACE_DATA>();
      iface.ref.cbSize = sizeOf<SP_DEVICE_INTERFACE_DATA>();
      final required = arena<Uint32>();
      for (var i = 0; ; i++) {
        if (SetupDiEnumDeviceInterfaces(set, nullptr, guid, i, iface) == 0) {
          break;
        }
        SetupDiGetDeviceInterfaceDetail(
          set,
          iface,
          nullptr,
          0,
          required,
          nullptr,
        );
        if (required.value == 0) continue;
        final detail = arena<Uint8>(
          required.value,
        ).cast<SP_DEVICE_INTERFACE_DETAIL_DATA_>();
        // cbSize is the fixed header: 8 on 64-bit builds, 6 on 32-bit.
        detail.ref.cbSize = sizeOf<IntPtr>() == 8 ? 8 : 6;
        if (SetupDiGetDeviceInterfaceDetail(
              set,
              iface,
              detail,
              required.value,
              nullptr,
              nullptr,
            ) ==
            0) {
          continue;
        }
        // DevicePath starts 4 bytes in (after the DWORD cbSize).
        final path = Pointer<Utf16>.fromAddress(
          detail.address + 4,
        ).toDartString();
        final ids = parseVidPid(path);
        found.add(UsbPrinterInfo(path: path, vid: ids?.vid, pid: ids?.pid));
      }
    } finally {
      SetupDiDestroyDeviceInfoList(set);
    }
  });
  return found;
}

/// Owns the open printer handle on a background isolate.
///
/// A receipt with a logo is several KB; at 9600 baud that is seconds of
/// blocking `WriteFile`, and the till's main isolate also runs Ditto and the
/// cart, so the handle never lives there.
class PrinterPortWorker {
  PrinterPortWorker._(this._isolate, this._commands);

  final Isolate _isolate;
  final SendPort _commands;

  static Future<PrinterPortWorker?> spawn() async {
    if (!printerPortsSupported) return null;
    final ready = ReceivePort();
    final isolate = await Isolate.spawn(
      _workerMain,
      ready.sendPort,
      debugName: 'builtin-printer-port',
    );
    final commands = await ready.first as SendPort;
    return PrinterPortWorker._(isolate, commands);
  }

  /// Sends [bytes] to [target]. Throws [PrinterPortException] on failure.
  Future<void> write(PrinterTarget target, Uint8List bytes) =>
      _request(['write', ...target.toMessage(), bytes]);

  /// Sends [bytes] to a serial [target] and returns the first byte that comes
  /// back within [timeoutMs], or null when nothing answers.
  Future<int?> query(
    PrinterTarget target,
    Uint8List bytes, {
    int timeoutMs = 400,
  }) async {
    final reply = await _request([
      'query',
      ...target.toMessage(),
      bytes,
      timeoutMs,
    ]);
    return reply as int?;
  }

  /// The status byte of a parallel [target] (see [ParallelStatus]); prints
  /// nothing.
  Future<ParallelStatus> parallelStatus(PrinterTarget target) async {
    final bits = await _request(['status', ...target.toMessage()]);
    return ParallelStatus(bits as int);
  }

  /// Closes the handle (it reopens on the next call).
  Future<void> close() => _request(const ['close']);

  void dispose() => _isolate.kill(priority: Isolate.immediate);

  Future<Object?> _request(List<Object> command) async {
    final reply = ReceivePort();
    _commands.send([reply.sendPort, ...command]);
    final result = await reply.first as List<Object?>;
    if (result[0] == 'err') throw PrinterPortException(result[1] as String);
    return result[1];
  }
}

void _workerMain(SendPort ready) {
  final commands = ReceivePort();
  ready.send(commands.sendPort);

  int? handle;
  String? openKey;
  var ctsFlow = false;

  void closePort() {
    if (handle != null) CloseHandle(handle!);
    handle = null;
    openKey = null;
  }

  int ensureOpen(PrinterTarget target) {
    final key = target.key;
    if (openKey != key) {
      closePort();
      if (target.transport == PrinterTransport.usb) {
        handle = _openUsb(target.path);
        ctsFlow = false;
      } else if (target.transport == PrinterTransport.parallel) {
        handle = _openParallel(target.path);
        ctsFlow = false;
      } else {
        final opened = _openSerial(target.path, target.baud);
        handle = opened.handle;
        ctsFlow = opened.ctsFlow;
      }
      openKey = key;
    }
    return handle!;
  }

  commands.listen((message) {
    final args = message as List<Object?>;
    final reply = args[0] as SendPort;
    try {
      switch (args[1]) {
        case 'write':
          final target = PrinterTarget.fromMessage(args, 2);
          final bytes = args[5] as Uint8List;
          final h = ensureOpen(target);
          try {
            if (target.transport == PrinterTransport.parallel) {
              // Fail fast on no paper / cover open / powered off. parport.sys
              // on Windows 10 often has no status IOCTL at all (error 1):
              // then write anyway.
              ParallelStatus? status;
              try {
                status = ParallelStatus(_parallelStatus(h));
              } on PrinterPortException {
                status = null;
              }
              final problem = status?.problem;
              if (problem != null) throw PrinterPortException(problem);
            }
            _writeAll(
              h,
              bytes,
              // USB and LPT writes have no COMMTIMEOUTS: bound each chunk
              // with overlapped I/O and cancel it if the printer stalls.
              overlapped: target.transport != PrinterTransport.serial,
              // With CTS flow control the printer paces us; otherwise pause
              // between chunks at high speeds so a small buffer cannot overrun.
              pauseMs:
                  target.transport == PrinterTransport.serial &&
                      !ctsFlow &&
                      target.baud >= 38400
                  ? 15
                  : 0,
            );
          } catch (_) {
            closePort();
            rethrow;
          }
          // An LPT port is opened exclusively: release it between jobs so a
          // Windows queue on the same port still works.
          if (target.transport == PrinterTransport.parallel) closePort();
          reply.send(const ['ok', null]);
        case 'status':
          final target = PrinterTarget.fromMessage(args, 2);
          try {
            final bits = _parallelStatus(ensureOpen(target));
            reply.send(['ok', bits]);
          } finally {
            closePort();
          }
        case 'query':
          final target = PrinterTarget.fromMessage(args, 2);
          final bytes = args[5] as Uint8List;
          final timeoutMs = args[6] as int;
          final h = ensureOpen(target);
          int? answer;
          try {
            PurgeComm(h, PURGE_RXCLEAR | PURGE_TXCLEAR);
            _writeAll(h, bytes, pauseMs: 0);
            answer = _readByte(h, timeoutMs);
          } catch (_) {
            closePort();
            rethrow;
          }
          reply.send(['ok', answer]);
        case 'close':
          closePort();
          reply.send(const ['ok', null]);
      }
    } catch (e) {
      reply.send(['err', e is PrinterPortException ? e.message : e.toString()]);
    }
  });
}

int _openParallel(String port) {
  final path = '\\\\.\\$port'.toNativeUtf16();
  try {
    final handle = CreateFile(
      path,
      GENERIC_READ | GENERIC_WRITE,
      0,
      nullptr,
      OPEN_EXISTING,
      FILE_FLAG_OVERLAPPED,
      NULL,
    );
    if (handle == INVALID_HANDLE_VALUE) {
      throw PrinterPortException(
        '$port could not be opened (Windows error ${GetLastError()}) — '
        'no parallel port, or in use by another program',
      );
    }
    return handle;
  } finally {
    free(path);
  }
}

/// `IOCTL_PAR_QUERY_INFORMATION`: CTL_CODE(FILE_DEVICE_PARALLEL_PORT, 1,
/// METHOD_BUFFERED, FILE_ANY_ACCESS).
const _ioctlParQueryInformation = 0x00160004;

int _parallelStatus(int handle) {
  final out = calloc<Uint8>();
  try {
    final n = _overlappedIo(
      handle,
      2000,
      'parallel port status',
      (ov) => DeviceIoControl(
        handle,
        _ioctlParQueryInformation,
        nullptr,
        0,
        out,
        1,
        nullptr,
        ov,
      ),
    );
    if (n != 1) {
      throw PrinterPortException('parallel port status unavailable');
    }
    return out.value;
  } finally {
    free(out);
  }
}

/// How long one chunk may take before the printer counts as stalled.
const _chunkTimeoutMs = 10000;

/// Runs one overlapped I/O request on [handle] and waits up to [timeoutMs].
/// On timeout the request is cancelled with `CancelIoEx` (supported by
/// usbprint.sys and parport.sys) and the cancellation awaited, so the worker
/// stays responsive and the handle can be closed safely. Returns the bytes
/// transferred.
int _overlappedIo(
  int handle,
  int timeoutMs,
  String what,
  int Function(Pointer<OVERLAPPED> ov) start,
) {
  final event = CreateEvent(nullptr, TRUE, FALSE, nullptr);
  if (event == 0) {
    throw PrinterPortException('$what: CreateEvent failed');
  }
  final ov = calloc<OVERLAPPED>();
  final done = calloc<Uint32>();
  try {
    ov.ref.hEvent = event;
    if (start(ov) == 0) {
      final error = GetLastError();
      if (error != ERROR_IO_PENDING) {
        throw PrinterPortException('$what failed (Windows error $error)');
      }
      if (WaitForSingleObject(event, timeoutMs) == WAIT_TIMEOUT) {
        CancelIoEx(handle, ov);
        // Wait for the cancel to land before the OVERLAPPED is freed.
        GetOverlappedResult(handle, ov, done, TRUE);
        throw PrinterPortException('$what timed out — printer not taking data');
      }
    }
    if (GetOverlappedResult(handle, ov, done, FALSE) == 0) {
      throw PrinterPortException(
        '$what failed (Windows error ${GetLastError()})',
      );
    }
    return done.value;
  } finally {
    CloseHandle(event);
    free(ov);
    free(done);
  }
}

int _openUsb(String devicePath) {
  final path = devicePath.toNativeUtf16();
  try {
    final handle = CreateFile(
      path,
      GENERIC_READ | GENERIC_WRITE,
      FILE_SHARE_READ | FILE_SHARE_WRITE,
      nullptr,
      OPEN_EXISTING,
      FILE_FLAG_OVERLAPPED,
      NULL,
    );
    if (handle == INVALID_HANDLE_VALUE) {
      throw PrinterPortException(
        'USB printer could not be opened (Windows error ${GetLastError()})',
      );
    }
    return handle;
  } finally {
    free(path);
  }
}

({int handle, bool ctsFlow}) _openSerial(String port, int baud) {
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
      throw PrinterPortException(
        '$port could not be opened (Windows error ${GetLastError()}) — '
        'wrong port, or in use by another program',
      );
    }
    final dcb = calloc<DCB>();
    final timeouts = calloc<COMMTIMEOUTS>();
    final modem = calloc<Uint32>();
    try {
      dcb.ref.DCBlength = sizeOf<DCB>();
      if (GetCommState(handle, dcb) == 0) {
        CloseHandle(handle);
        throw PrinterPortException('$port: GetCommState failed');
      }
      dcb.ref
        ..BaudRate = baud
        ..ByteSize = 8
        ..Parity = NOPARITY
        ..StopBits = ONESTOPBIT;
      var bits = dcb.ref.bitfield;
      bits |= 0x1; // fBinary
      // Start with no flow control (fOutxCtsFlow, fOutxDsrFlow, fOutX, fInX)
      // and without fAbortOnError (bit 14). Assert DTR and RTS: printers read
      // them as "host ready".
      bits &= ~((1 << 2) | (1 << 3) | (1 << 8) | (1 << 9) | (1 << 14));
      bits = (bits & ~(0x3 << 4)) | (DTR_CONTROL_ENABLE << 4);
      bits = (bits & ~(0x3 << 12)) | (RTS_CONTROL_ENABLE << 12);
      dcb.ref.bitfield = bits;
      if (SetCommState(handle, dcb) == 0) {
        CloseHandle(handle);
        throw PrinterPortException('$port: cannot set $baud baud');
      }

      // A printer that holds CTS up is offering hardware flow control: use
      // it, so it can pause us while it burns a logo. One that leaves CTS
      // down (or a bridge with the pin unwired) would block every write.
      var ctsFlow = false;
      if (GetCommModemStatus(handle, modem) != 0 &&
          modem.value & MS_CTS_ON != 0) {
        dcb.ref.bitfield = dcb.ref.bitfield | (1 << 2);
        ctsFlow = SetCommState(handle, dcb) != 0;
      }

      // Generous write bound (a busy printer may hold CTS while it prints),
      // short read bound: status replies come back within milliseconds.
      timeouts.ref
        ..ReadIntervalTimeout = 50
        ..ReadTotalTimeoutConstant = 400
        ..ReadTotalTimeoutMultiplier = 0
        ..WriteTotalTimeoutConstant = 5000
        ..WriteTotalTimeoutMultiplier = 2;
      SetCommTimeouts(handle, timeouts);
      return (handle: handle, ctsFlow: ctsFlow);
    } finally {
      free(dcb);
      free(timeouts);
      free(modem);
    }
  } finally {
    free(path);
  }
}

const _chunk = 1024;

void _writeAll(
  int handle,
  Uint8List bytes, {
  required int pauseMs,
  bool overlapped = false,
}) {
  final buffer = calloc<Uint8>(_chunk);
  final written = calloc<Uint32>();
  try {
    for (var offset = 0; offset < bytes.length; offset += _chunk) {
      final end = (offset + _chunk).clamp(0, bytes.length);
      final n = end - offset;
      buffer.asTypedList(n).setRange(0, n, bytes, offset);
      if (overlapped) {
        final sent = _overlappedIo(
          handle,
          _chunkTimeoutMs,
          'write at byte $offset',
          (ov) => WriteFile(handle, buffer, n, nullptr, ov),
        );
        if (sent != n) {
          throw PrinterPortException(
            'write stopped at byte ${offset + sent} — printer offline or out '
            'of paper?',
          );
        }
        continue;
      }
      final ok = WriteFile(handle, buffer, n, written, nullptr);
      if (ok == 0 || written.value != n) {
        throw PrinterPortException(
          'write failed at byte $offset (${written.value}/$n, '
          'Windows error ${GetLastError()}) — printer offline or out of paper?',
        );
      }
      if (pauseMs > 0 && end < bytes.length)
        sleep(Duration(milliseconds: pauseMs));
    }
  } finally {
    free(buffer);
    free(written);
  }
}

int? _readByte(int handle, int timeoutMs) {
  final timeouts = calloc<COMMTIMEOUTS>();
  final buffer = calloc<Uint8>();
  final read = calloc<Uint32>();
  try {
    GetCommTimeouts(handle, timeouts);
    timeouts.ref
      ..ReadIntervalTimeout = 0
      ..ReadTotalTimeoutMultiplier = 0
      ..ReadTotalTimeoutConstant = timeoutMs;
    SetCommTimeouts(handle, timeouts);
    if (ReadFile(handle, buffer, 1, read, nullptr) == 0) return null;
    return read.value == 1 ? buffer.value : null;
  } finally {
    free(timeouts);
    free(buffer);
    free(read);
  }
}

// ── Registry helpers ──────────────────────────────────────────────────────

int? _openKey(String path) {
  final sub = path.toNativeUtf16();
  final out = calloc<IntPtr>();
  try {
    final rc = RegOpenKeyEx(HKEY_LOCAL_MACHINE, sub, 0, KEY_READ, out);
    return rc == ERROR_SUCCESS ? out.value : null;
  } finally {
    free(sub);
    free(out);
  }
}

List<String> _subKeys(String path) {
  final key = _openKey(path);
  if (key == null) return const [];
  final names = <String>[];
  final name = wsalloc(256);
  final len = calloc<Uint32>();
  try {
    for (var i = 0; ; i++) {
      len.value = 256;
      final rc = RegEnumKeyEx(
        key,
        i,
        name,
        len,
        nullptr,
        nullptr,
        nullptr,
        nullptr,
      );
      if (rc != ERROR_SUCCESS) break;
      names.add(name.toDartString(length: len.value));
    }
  } finally {
    free(name);
    free(len);
    RegCloseKey(key);
  }
  return names;
}

String? _readString(String path, String value) {
  final key = _openKey(path);
  if (key == null) return null;
  final name = value.toNativeUtf16();
  final type = calloc<Uint32>();
  final size = calloc<Uint32>()..value = 512;
  final data = calloc<Uint8>(512);
  try {
    final rc = RegQueryValueEx(key, name, nullptr, type, data, size);
    if (rc != ERROR_SUCCESS || type.value != REG_SZ) return null;
    return data.cast<Utf16>().toDartString();
  } finally {
    free(name);
    free(type);
    free(size);
    free(data);
    RegCloseKey(key);
  }
}

void _forEachValue(String path, void Function(String name, String data) f) {
  final key = _openKey(path);
  if (key == null) return;
  final name = wsalloc(256);
  final nameLen = calloc<Uint32>();
  final type = calloc<Uint32>();
  final data = calloc<Uint8>(512);
  final dataLen = calloc<Uint32>();
  try {
    for (var i = 0; ; i++) {
      nameLen.value = 256;
      dataLen.value = 512;
      final rc = RegEnumValue(
        key,
        i,
        name,
        nameLen,
        nullptr,
        type,
        data,
        dataLen,
      );
      if (rc != ERROR_SUCCESS) break;
      if (type.value != REG_SZ) continue;
      f(
        name.toDartString(length: nameLen.value),
        data.cast<Utf16>().toDartString(),
      );
    }
  } finally {
    free(name);
    free(nameLen);
    free(type);
    free(data);
    free(dataLen);
    RegCloseKey(key);
  }
}
