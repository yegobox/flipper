import 'dart:async';

import 'package:flipper_dashboard/features/bar_mode/theme/bar_tokens.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_admin_widgets.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/helpers/receipt_printer_autoselect.dart';
import 'package:flipper_services/builtin_printer/builtin_printer_service.dart';
import 'package:flipper_services/builtin_printer/escpos.dart';
import 'package:flipper_services/customer_display/customer_display_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

const String _kDefaultPrinterKey = 'defaultPrinter';

/// Receipt printer and customer (pole) display for *this till*.
///
/// Both are device hardware and stored device-locally: the sale flow prints to
/// the printer chosen here without a picker, and mirrors the cart total and
/// change to the display on the back of all-in-one tills (P70E and similar).
///
/// Shown on desktop only — phones and the web have neither.
class TillHardwareSection extends StatefulWidget {
  const TillHardwareSection({super.key});

  static bool get isAvailable =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.macOS ||
          defaultTargetPlatform == TargetPlatform.linux);

  @override
  State<TillHardwareSection> createState() => _TillHardwareSectionState();
}

class _TillHardwareSectionState extends State<TillHardwareSection> {
  final _display = CustomerDisplayService.instance;

  List<Printer>? _printers;
  String? _printerName;
  bool _printBusy = false;

  final _builtin = BuiltinPrinterService.instance;
  PrinterTarget? _builtinTarget;
  bool _builtinBusy = false;

  late CustomerDisplaySettings _displaySettings;
  List<String> _ports = const [];
  bool _displayBusy = false;

  @override
  void initState() {
    super.initState();
    _printerName = ProxyService.box.readString(key: _kDefaultPrinterKey);
    _builtinTarget = _builtin.savedTarget;
    _displaySettings = _display.settings;
    _ports = _display.availablePorts();
    unawaited(_loadPrinters());
  }

  Future<void> _loadPrinters() async {
    List<Printer> printers;
    try {
      printers = await Printing.listPrinters().timeout(
        const Duration(seconds: 10),
      );
    } catch (_) {
      printers = const [];
    }
    if (mounted) setState(() => _printers = printers);
  }

  Future<void> _setPrinter(String? name) async {
    if (name == null) {
      await ProxyService.box.remove(key: _kDefaultPrinterKey);
    } else {
      await ProxyService.box.writeString(key: _kDefaultPrinterKey, value: name);
    }
    if (mounted) setState(() => _printerName = name);
  }

  Printer? get _effectivePrinter {
    final printers = _printers ?? const <Printer>[];
    for (final p in printers) {
      if (p.name == _printerName) return p;
    }
    return pickAutoReceiptPrinter(printers);
  }

  Future<void> _testPrint() async {
    final printer = _effectivePrinter;
    if (printer == null) return;
    final l10n = context.flipperL10n;
    setState(() => _printBusy = true);
    try {
      final bytes = await _testPageBytes(printer.name);
      final accepted = await Future<bool>.value(
        Printing.directPrintPdf(printer: printer, onLayout: (_) async => bytes),
      ).timeout(const Duration(seconds: 30));
      if (!mounted) return;
      if (!accepted) throw Exception('rejected');
      showCustomSnackBarUtil(
        context,
        l10n.receiptPrinterTestSent(printer.name),
      );
    } catch (e) {
      if (!mounted) return;
      showCustomSnackBarUtil(
        context,
        l10n.receiptPrinterTestFailed(printer.name, '$e'),
        type: NotificationType.error,
      );
    } finally {
      if (mounted) setState(() => _printBusy = false);
    }
  }

  /// A receipt-width page with a border and a numbered ruler, so a clipped
  /// edge on narrower (58 mm) paper is obvious at a glance.
  Future<Uint8List> _testPageBytes(String printerName) {
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (_) => pw.Container(
          padding: const pw.EdgeInsets.all(6),
          decoration: pw.BoxDecoration(border: pw.Border.all(width: 1)),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Flipper test print',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(printerName),
              pw.Text(DateTime.now().toString().substring(0, 19)),
              pw.SizedBox(height: 6),
              pw.Text('1234567890' * 5, maxLines: 1),
            ],
          ),
        ),
      ),
    );
    return doc.save();
  }

  /// Runs [action] with the built-in printer controls disabled, then shows
  /// [message] (when it returns one) and refreshes the saved printer.
  Future<void> _builtinAction(
    Future<({String message, bool ok})?> Function() action,
  ) async {
    setState(() => _builtinBusy = true);
    try {
      final result = await action();
      if (!mounted) return;
      if (result != null) {
        showCustomSnackBarUtil(
          context,
          result.message,
          type: result.ok ? NotificationType.success : NotificationType.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _builtinBusy = false;
          _builtinTarget = _builtin.savedTarget;
        });
      }
    }
  }

  /// Status-query search. An explicit request, so a USB receipt printer is
  /// accepted even when Windows has a printer of its own.
  Future<void> _searchBuiltin() {
    final l10n = context.flipperL10n;
    return _builtinAction(() async {
      await _builtin.forget();
      final found = await _builtin.ensureTarget(includeUsb: true);
      return found == null
          ? (message: l10n.builtinPrinterNoneAnswered, ok: false)
          : (message: l10n.builtinPrinterFound(found.label), ok: true);
    });
  }

  /// For printers that ignore the status query: prints one line on each
  /// port × speed until the cashier confirms it came out. A port that will
  /// not open is skipped at once rather than tried at every speed.
  Future<void> _findBuiltin() {
    final l10n = context.flipperL10n;
    return _builtinAction(() async {
      String? deadPath;
      for (final target in _builtin.manualCandidates()) {
        if (target.path == deadPath) continue;
        final error = await _builtin.probePrint(target);
        if (!mounted) return null;
        if (error != null) {
          deadPath = target.path;
          continue;
        }
        final answer = await _confirmBuiltin(target);
        if (!mounted || answer == null) return null;
        if (answer) {
          await _builtin.save(target);
          return (message: l10n.builtinPrinterFound(target.label), ok: true);
        }
      }
      return (message: l10n.builtinPrinterNoneAnswered, ok: false);
    });
  }

  Future<void> _testBuiltin() {
    final l10n = context.flipperL10n;
    return _builtinAction(() async {
      final error = await _builtin.testPrint();
      return error == null
          ? (message: l10n.builtinPrinterTestSent, ok: true)
          : (
              message: l10n.receiptPrinterTestFailed(
                _builtinTarget?.label ?? '',
                error,
              ),
              ok: false,
            );
    });
  }

  /// True: it printed. False: try the next setting. Null: the cashier stopped.
  Future<bool?> _confirmBuiltin(PrinterTarget target) {
    final l10n = context.flipperL10n;
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(l10n.builtinPrinterFindPrompt(target.label)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.customerDisplayFindNo),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.customerDisplayFindYes),
          ),
        ],
      ),
    );
  }

  Future<void> _saveDisplay(CustomerDisplaySettings next) async {
    await _display.saveSettings(next);
    if (mounted) setState(() => _displaySettings = next);
  }

  CustomerDisplaySettings _withDisplay({
    CustomerDisplayType? type,
    String? port,
    int? baud,
  }) => CustomerDisplaySettings(
    type: type ?? _displaySettings.type,
    port: port ?? _displaySettings.port ?? _ports.firstOrNull,
    baud: baud ?? _displaySettings.baud,
  );

  Future<void> _testDisplay() async {
    final port = _displaySettings.port;
    if (port == null) return;
    final l10n = context.flipperL10n;
    setState(() => _displayBusy = true);
    final error = await _display.test(port: port, baud: _displaySettings.baud);
    if (error == null) {
      // Leave the eights up long enough to see, then hand the display back
      // to the cart total.
      await Future<void>.delayed(const Duration(seconds: 3));
      _display.clear();
    }
    if (!mounted) return;
    setState(() => _displayBusy = false);
    showCustomSnackBarUtil(
      context,
      error ?? l10n.customerDisplayTestSent,
      type: error == null ? NotificationType.success : NotificationType.error,
    );
  }

  /// Walks every port × speed, lighting all segments each time, until the
  /// cashier confirms the display shows them. A port that will not open is
  /// skipped at once rather than tried at every speed.
  Future<void> _findDisplay() async {
    final l10n = context.flipperL10n;
    setState(() => _displayBusy = true);
    // The last setting lit and not kept; blanked on the way out.
    ({String port, int baud})? unkept;
    try {
      for (final port in _ports) {
        for (final baud in CustomerDisplaySettings.supportedBauds) {
          final error = await _display.test(port: port, baud: baud);
          if (!mounted) return;
          if (error != null) break;
          unkept = (port: port, baud: baud);
          final answer = await _confirmLit(port, baud);
          if (!mounted || answer == null) return;
          if (answer) {
            unkept = null;
            await _saveDisplay(
              CustomerDisplaySettings(
                type: CustomerDisplayType.serial,
                port: port,
                baud: baud,
              ),
            );
            if (mounted) {
              showCustomSnackBarUtil(
                context,
                l10n.customerDisplayFound(port, '$baud'),
              );
            }
            return;
          }
        }
      }
      if (mounted) {
        showCustomSnackBarUtil(
          context,
          l10n.customerDisplayNotFound,
          type: NotificationType.warning,
        );
      }
    } finally {
      if (unkept != null) {
        await _display.blankTested(port: unkept.port, baud: unkept.baud);
      }
      if (mounted) setState(() => _displayBusy = false);
    }
  }

  /// True: lit. False: try the next setting. Null: the cashier stopped.
  Future<bool?> _confirmLit(String port, int baud) {
    final l10n = context.flipperL10n;
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(l10n.customerDisplayFindPrompt(port, '$baud')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.customerDisplayFindNo),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.customerDisplayFindYes),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!TillHardwareSection.isAvailable) return const SizedBox.shrink();
    final l10n = context.flipperL10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 28),
        BarAdminEyebrow(label: l10n.tillHardwareTitle),
        BarCard(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.tillHardwareSubtitle, style: _hintStyle),
              const SizedBox(height: 16),
              _buildPrinter(l10n),
              const Divider(height: 32, color: BarTokens.line),
              _buildBuiltinPrinter(l10n),
              const Divider(height: 32, color: BarTokens.line),
              _buildDisplay(l10n),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPrinter(FlipperAppLocalizations l10n) {
    final printers = _printers;
    final names = <String>{
      ...?printers?.map((p) => p.name),
      // Keep a saved printer that is unplugged right now selectable, so the
      // dropdown never loses (or crashes on) the stored value.
      ?_printerName,
    };
    final virtualNames = {
      for (final p in printers ?? const <Printer>[])
        if (isVirtualReceiptPrinter(p)) p.name,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.receiptPrinterLabel, style: _titleStyle),
        const SizedBox(height: 3),
        Text(l10n.receiptPrinterAuto, style: _hintStyle),
        const SizedBox(height: 12),
        if (printers == null)
          const LinearProgressIndicator(minHeight: 2)
        else if (printers.isEmpty)
          Text(l10n.receiptPrinterNoneFound, style: _hintStyle)
        else
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              DropdownButton<String?>(
                value: _printerName,
                onChanged: _printBusy ? null : _setPrinter,
                items: [
                  DropdownMenuItem<String?>(
                    value: null,
                    child: Text(_autoLabel(l10n)),
                  ),
                  for (final name in names)
                    DropdownMenuItem<String?>(
                      value: name,
                      child: Text(
                        virtualNames.contains(name)
                            ? l10n.receiptPrinterNotPaper(name)
                            : name,
                      ),
                    ),
                ],
              ),
              OutlinedButton.icon(
                onPressed: _printBusy || _effectivePrinter == null
                    ? null
                    : _testPrint,
                icon: const Icon(Icons.print_outlined, size: 18),
                label: Text(l10n.receiptPrinterTest),
              ),
            ],
          ),
      ],
    );
  }

  /// "Choose automatically (POS-58)" when the automatic pick is known.
  String _autoLabel(FlipperAppLocalizations l10n) {
    final auto = pickAutoReceiptPrinter(_printers ?? const []);
    return auto == null
        ? l10n.receiptPrinterAutomatic
        : '${l10n.receiptPrinterAutomatic} (${auto.name})';
  }

  Widget _buildBuiltinPrinter(FlipperAppLocalizations l10n) {
    final target = _builtinTarget;
    final off = !_builtin.autoDetectAllowed;
    final busy = _builtinBusy;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.builtinPrinterLabel, style: _titleStyle),
        const SizedBox(height: 3),
        Text(l10n.builtinPrinterHint, style: _hintStyle),
        const SizedBox(height: 12),
        if (!_builtin.isSupported)
          Text(l10n.builtinPrinterWindowsOnly, style: _hintStyle)
        else ...[
          Text(
            busy
                ? l10n.builtinPrinterSearching
                : off
                ? l10n.builtinPrinterOff
                : target == null
                ? l10n.builtinPrinterNotFound
                : l10n.builtinPrinterUsing(target.label),
            style: _titleStyle.copyWith(fontSize: 14),
          ),
          if (busy) ...[
            const SizedBox(height: 8),
            const LinearProgressIndicator(minHeight: 2),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (off)
                OutlinedButton(
                  onPressed: busy ? null : _searchBuiltin,
                  child: Text(l10n.builtinPrinterTurnOn),
                )
              else ...[
                OutlinedButton.icon(
                  onPressed: busy || target == null ? null : _testBuiltin,
                  icon: const Icon(Icons.print_outlined, size: 18),
                  label: Text(l10n.receiptPrinterTest),
                ),
                OutlinedButton(
                  onPressed: busy ? null : _searchBuiltin,
                  child: Text(l10n.builtinPrinterSearch),
                ),
                OutlinedButton(
                  onPressed: busy ? null : _findBuiltin,
                  child: Text(l10n.builtinPrinterFind),
                ),
                TextButton(
                  onPressed: busy
                      ? null
                      : () => _builtinAction(() async {
                          await _builtin.turnOff();
                          return null;
                        }),
                  child: Text(l10n.builtinPrinterTurnOff),
                ),
              ],
            ],
          ),
          if (!off && target != null) ...[
            const SizedBox(height: 12),
            _labelled(
              l10n.builtinPrinterQrLabel,
              DropdownButton<EscPosQrMode>(
                value: _builtin.qrMode,
                onChanged: busy
                    ? null
                    : (mode) async {
                        if (mode == null) return;
                        await _builtin.setQrMode(mode);
                        if (mounted) setState(() {});
                      },
                items: [
                  DropdownMenuItem(
                    value: EscPosQrMode.raster,
                    child: Text(l10n.builtinPrinterQrImage),
                  ),
                  DropdownMenuItem(
                    value: EscPosQrMode.native,
                    child: Text(l10n.builtinPrinterQrNative),
                  ),
                ],
              ),
            ),
          ],
        ],
      ],
    );
  }

  Widget _buildDisplay(FlipperAppLocalizations l10n) {
    final supported = _display.isSupported;
    final on = _displaySettings.type == CustomerDisplayType.serial;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.customerDisplayLabel, style: _titleStyle),
        const SizedBox(height: 3),
        Text(l10n.customerDisplayHint, style: _hintStyle),
        const SizedBox(height: 12),
        if (!supported)
          Text(l10n.customerDisplayWindowsOnly, style: _hintStyle)
        else ...[
          Wrap(
            spacing: 10,
            children: [
              ChoiceChip(
                label: Text(l10n.customerDisplayOff),
                selected: !on,
                onSelected: _displayBusy
                    ? null
                    : (_) => _saveDisplay(
                        _withDisplay(type: CustomerDisplayType.off),
                      ),
              ),
              ChoiceChip(
                label: Text(l10n.customerDisplaySerial),
                selected: on,
                onSelected: _displayBusy
                    ? null
                    : (_) => _saveDisplay(
                        _withDisplay(type: CustomerDisplayType.serial),
                      ),
              ),
            ],
          ),
          if (on) ...[
            const SizedBox(height: 12),
            if (_ports.isEmpty)
              Text(l10n.customerDisplayNoPorts, style: _hintStyle)
            else
              Wrap(
                spacing: 16,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _labelled(
                    l10n.customerDisplayPort,
                    DropdownButton<String>(
                      value: _ports.contains(_displaySettings.port)
                          ? _displaySettings.port
                          : null,
                      onChanged: _displayBusy
                          ? null
                          : (port) => _saveDisplay(_withDisplay(port: port)),
                      items: [
                        for (final port in _ports)
                          DropdownMenuItem(value: port, child: Text(port)),
                      ],
                    ),
                  ),
                  _labelled(
                    l10n.customerDisplayBaud,
                    DropdownButton<int>(
                      value: _displaySettings.baud,
                      onChanged: _displayBusy
                          ? null
                          : (baud) => _saveDisplay(_withDisplay(baud: baud)),
                      items: [
                        for (final baud in {
                          ...CustomerDisplaySettings.supportedBauds,
                          _displaySettings.baud,
                        })
                          DropdownMenuItem(value: baud, child: Text('$baud')),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: _displayBusy || _displaySettings.port == null
                        ? null
                        : _testDisplay,
                    child: Text(l10n.customerDisplayTest),
                  ),
                  OutlinedButton(
                    onPressed: _displayBusy ? null : _findDisplay,
                    child: Text(l10n.customerDisplayFind),
                  ),
                ],
              ),
          ],
        ],
      ],
    );
  }

  Widget _labelled(String label, Widget child) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text('$label: ', style: _hintStyle),
      child,
    ],
  );

  static final TextStyle _titleStyle = GoogleFonts.outfit(
    fontSize: 16.5,
    fontWeight: FontWeight.w800,
    color: BarTokens.ink1,
  );

  static final TextStyle _hintStyle = GoogleFonts.outfit(
    fontSize: 13,
    height: 1.4,
    fontWeight: FontWeight.w500,
    color: BarTokens.ink3,
  );
}
