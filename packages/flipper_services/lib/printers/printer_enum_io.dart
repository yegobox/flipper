import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';

import 'package:ffi/ffi.dart';
import 'package:printing/printing.dart';
import 'package:win32/win32.dart';

// winspool.h status bits; package:win32 does not export them.
const _kPrinterStatusPaused = 0x00000001;
const _kPrinterStatusError = 0x00000002;
const _kPrinterStatusOffline = 0x00000080;
const _kPrinterStatusNotAvailable = 0x00001000;
const _kPrinterUnavailableMask =
    _kPrinterStatusNotAvailable |
    _kPrinterStatusError |
    _kPrinterStatusOffline |
    _kPrinterStatusPaused;

/// Printers the OS knows about, enumerated off the UI thread, or null when this
/// platform has no native path (the caller then uses the printing plugin).
///
/// On Windows the printing plugin runs `EnumPrinters` on the platform thread,
/// which is the UI thread on desktop. Level 2 with connections asks every
/// network printer for its status, so one unreachable printer froze the till
/// with the OS busy cursor. Here the same call runs in a background isolate.
Future<List<Printer>?> enumerateNativePrinters() async {
  if (!Platform.isWindows) return null;
  return Isolate.run(_enumerateWindowsPrinters, debugName: 'printer-enum');
}

/// Same flags, level and fields as the plugin's `PrintJob::listPrinters`, so
/// [Printer.url] is still the name `directPrintPdf` expects.
List<Printer> _enumerateWindowsPrinters() {
  const flags = PRINTER_ENUM_LOCAL | PRINTER_ENUM_CONNECTIONS;
  final needed = calloc<Uint32>();
  final returned = calloc<Uint32>();
  try {
    EnumPrinters(flags, nullptr, 2, nullptr, 0, needed, returned);
    if (needed.value == 0) return const [];
    final buffer = calloc<Uint8>(needed.value);
    try {
      final ok = EnumPrinters(
        flags,
        nullptr,
        2,
        buffer,
        needed.value,
        needed,
        returned,
      );
      if (ok == 0) return const [];
      final defaultName = _defaultPrinterName();
      final infos = buffer.cast<PRINTER_INFO_2>();
      final printers = <Printer>[];
      for (var i = 0; i < returned.value; i++) {
        final info = (infos + i).ref;
        final name = _string(info.pPrinterName);
        if (name == null) continue;
        printers.add(
          Printer(
            url: name,
            name: name,
            model: _string(info.pDriverName),
            location: _string(info.pLocation),
            comment: _string(info.pComment),
            isDefault: name == defaultName,
            isAvailable: (info.Status & _kPrinterUnavailableMask) == 0,
          ),
        );
      }
      return printers;
    } finally {
      free(buffer);
    }
  } finally {
    free(needed);
    free(returned);
  }
}

String? _defaultPrinterName() {
  final size = calloc<Uint32>();
  try {
    GetDefaultPrinter(nullptr, size);
    if (size.value == 0) return null;
    final buffer = wsalloc(size.value);
    try {
      if (GetDefaultPrinter(buffer, size) == 0) return null;
      return buffer.toDartString();
    } finally {
      free(buffer);
    }
  } finally {
    free(size);
  }
}

String? _string(Pointer<Utf16> pointer) =>
    pointer == nullptr ? null : pointer.toDartString();
