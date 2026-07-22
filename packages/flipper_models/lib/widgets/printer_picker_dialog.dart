import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

const _kSaveAsPdfKey = '__save_as_pdf__';

abstract final class _PPColors {
  static const surface = Color(0xFFFFFFFF);
  static const surface2 = Color(0xFFF7F9FE);
  static const ink1 = Color(0xFF0B1220);
  static const ink2 = Color(0xFF4A5567);
  static const ink3 = Color(0xFF7E8AA0);
  static const ink4 = Color(0xFFAEB8CA);
  static const line = Color(0xFFE6ECF5);
  static const lineSoft = Color(0xFFEFF3F9);
  static const lineStrong = Color(0xFFD6DEEA);
  static const blue = Color(0xFF2563EB);
  static const blueTint = Color(0xFFEAF1FE);
  static const gain = Color(0xFF16A34A);
  static const gradBtnTop = Color(0xFF2C6BF0);
  static const gradBtnBottom = Color(0xFF1D4ED8);
  static const scrim = Color(0xFF0B1220);
}

class PrinterPickerResult {
  const PrinterPickerResult({
    this.printer,
    required this.copies,
    this.saveAsPdf = false,
  });

  final Printer? printer;
  final int copies;
  final bool saveAsPdf;
}

/// Shows the Flipper-branded printer picker modal, replacing the OS-native
/// `Printing.pickPrinter` dialog. Returns `null` if the cashier cancelled.
Future<PrinterPickerResult?> showPrinterPickerDialog({
  required BuildContext context,
  required List<Printer> printers,
  String? defaultPrinterName,
  int itemCount = 1,
  double amount = 0,
  String currency = '',
  int? invoiceNumber,
}) {
  return showGeneralDialog<PrinterPickerResult>(
    context: context,
    barrierLabel: 'Choose a printer',
    barrierDismissible: true,
    barrierColor: _PPColors.scrim.withValues(alpha: 0.46),
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (dialogContext, _, __) => _PrinterPickerDialog(
      printers: printers,
      defaultPrinterName: defaultPrinterName,
      itemCount: itemCount,
      amount: amount,
      currency: currency,
      invoiceNumber: invoiceNumber,
    ),
    transitionBuilder: (dialogContext, animation, _, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return AnimatedBuilder(
        animation: curved,
        child: child,
        builder: (context, child) => Opacity(
          opacity: curved.value.clamp(0, 1),
          child: Transform.translate(
            offset: Offset(0, (1 - curved.value) * 14),
            child: Transform.scale(
              scale: 0.98 + curved.value * 0.02,
              child: child,
            ),
          ),
        ),
      );
    },
  );
}

class _PrinterPickerDialog extends StatefulWidget {
  const _PrinterPickerDialog({
    required this.printers,
    required this.itemCount,
    required this.amount,
    required this.currency,
    this.defaultPrinterName,
    this.invoiceNumber,
  });

  final List<Printer> printers;
  final String? defaultPrinterName;
  final int itemCount;
  final double amount;
  final String currency;
  final int? invoiceNumber;

  @override
  State<_PrinterPickerDialog> createState() => _PrinterPickerDialogState();
}

class _PrinterPickerDialogState extends State<_PrinterPickerDialog> {
  late String _selectedKey;
  int _copies = 1;

  @override
  void initState() {
    super.initState();
    Printer? initial;
    if (widget.defaultPrinterName != null) {
      for (final p in widget.printers) {
        if (p.name == widget.defaultPrinterName) {
          initial = p;
          break;
        }
      }
    }
    if (initial == null) {
      for (final p in widget.printers) {
        if (p.isDefault) {
          initial = p;
          break;
        }
      }
    }
    initial ??= widget.printers.isNotEmpty ? widget.printers.first : null;
    _selectedKey = initial?.url ?? _kSaveAsPdfKey;
  }

  Printer? get _selectedPrinter {
    if (_selectedKey == _kSaveAsPdfKey) return null;
    for (final p in widget.printers) {
      if (p.url == _selectedKey) return p;
    }
    return null;
  }

  void _submit() {
    Navigator.of(context).pop(
      PrinterPickerResult(
        printer: _selectedPrinter,
        copies: _copies,
        saveAsPdf: _selectedKey == _kSaveAsPdfKey,
      ),
    );
  }

  void _cancel() => Navigator.of(context).pop();

  String _statusLabel(Printer p) {
    final detail = p.model ?? p.location ?? 'Printer';
    return '${p.isAvailable ? 'Ready' : 'Offline'} · $detail';
  }

  IconData _iconFor(Printer p) {
    final signature = '${p.model ?? ''} ${p.location ?? ''} ${p.url}'.toLowerCase();
    if (signature.contains('bluetooth')) return Icons.bluetooth_rounded;
    if (signature.contains('network') ||
        signature.contains('wifi') ||
        signature.contains('socket') ||
        signature.contains('dnssd')) {
      return Icons.wifi_rounded;
    }
    return Icons.print_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final maxHeight = MediaQuery.sizeOf(context).height - 64;

    final rows = <Widget>[
      for (final p in widget.printers)
        _PrinterRow(
          title: p.name,
          isDefault: p.isDefault,
          available: p.isAvailable,
          subtitle: _statusLabel(p),
          selected: _selectedKey == p.url,
          icon: _iconFor(p),
          onTap: p.isAvailable ? () => setState(() => _selectedKey = p.url) : null,
        ),
      _PrinterRow(
        title: 'Save as PDF',
        isDefault: false,
        available: true,
        subtitle: 'Always available · File',
        selected: _selectedKey == _kSaveAsPdfKey,
        icon: Icons.download_rounded,
        onTap: () => setState(() => _selectedKey = _kSaveAsPdfKey),
      ),
    ];

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 440,
            maxHeight: maxHeight > 200 ? maxHeight : 200,
          ),
          child: Material(
            color: Colors.transparent,
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: _PPColors.surface,
                borderRadius: BorderRadius.circular(26),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF102040).withValues(alpha: 0.22),
                    blurRadius: 44,
                    offset: const Offset(0, 18),
                    spreadRadius: -12,
                  ),
                  BoxShadow(
                    color: const Color(0xFF102040).withValues(alpha: 0.08),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Header(textTheme: textTheme, onClose: _cancel),
                  _ReceiptChip(
                    textTheme: textTheme,
                    itemCount: widget.itemCount,
                    amount: widget.amount,
                    currency: widget.currency,
                    invoiceNumber: widget.invoiceNumber,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(26, 20, 26, 10),
                    child: Text(
                      'AVAILABLE PRINTERS',
                      style: (textTheme.labelSmall ?? const TextStyle()).copyWith(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                        color: _PPColors.ink3,
                      ),
                    ),
                  ),
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: rows.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 9),
                      itemBuilder: (_, i) => rows[i],
                    ),
                  ),
                  _Footer(
                    textTheme: textTheme,
                    copies: _copies,
                    onMinus: () => setState(() => _copies = (_copies - 1).clamp(1, 9)),
                    onPlus: () => setState(() => _copies = (_copies + 1).clamp(1, 9)),
                    onCancel: _cancel,
                    onPrint: _submit,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.textTheme, required this.onClose});

  final TextTheme textTheme;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(26, 24, 22, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: _PPColors.blueTint,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: const Icon(Icons.print_rounded, size: 13, color: _PPColors.blue),
                    ),
                    const SizedBox(width: 9),
                    Text(
                      'PRINT RECEIPT',
                      style: (textTheme.labelSmall ?? const TextStyle()).copyWith(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                        color: _PPColors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 9),
                Text(
                  'Choose a printer',
                  style: (textTheme.titleLarge ?? const TextStyle()).copyWith(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                    color: _PPColors.ink1,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Select where to send this receipt.',
                  style: (textTheme.bodyMedium ?? const TextStyle()).copyWith(
                    fontSize: 13.5,
                    color: _PPColors.ink3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Material(
            color: _PPColors.surface2,
            shape: const CircleBorder(side: BorderSide(color: _PPColors.line)),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onClose,
              child: const SizedBox(
                width: 36,
                height: 36,
                child: Icon(Icons.close_rounded, size: 16, color: _PPColors.ink2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReceiptChip extends StatelessWidget {
  const _ReceiptChip({
    required this.textTheme,
    required this.itemCount,
    required this.amount,
    required this.currency,
    required this.invoiceNumber,
  });

  final TextTheme textTheme;
  final int itemCount;
  final double amount;
  final String currency;
  final int? invoiceNumber;

  @override
  Widget build(BuildContext context) {
    final metaParts = <String>[
      currency.isNotEmpty ? '$currency ${amount.toStringAsFixed(2)}' : amount.toStringAsFixed(2),
      if (invoiceNumber != null) 'Invoice No. $invoiceNumber',
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(26, 18, 26, 0),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
      decoration: BoxDecoration(
        color: _PPColors.surface2,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _PPColors.line),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _PPColors.surface,
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: _PPColors.line),
            ),
            child: const Icon(Icons.receipt_long_rounded, size: 17, color: _PPColors.ink2),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Receipt · $itemCount item${itemCount == 1 ? '' : 's'}',
                  style: (textTheme.bodyMedium ?? const TextStyle()).copyWith(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: _PPColors.ink1,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  metaParts.join(' · '),
                  style: (textTheme.bodySmall ?? const TextStyle()).copyWith(
                    fontSize: 12,
                    color: _PPColors.ink3,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PrinterRow extends StatelessWidget {
  const _PrinterRow({
    required this.title,
    required this.isDefault,
    required this.available,
    required this.subtitle,
    required this.selected,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final bool isDefault;
  final bool available;
  final String subtitle;
  final bool selected;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final borderColor = selected ? _PPColors.blue : _PPColors.line;

    return Opacity(
      opacity: available ? 1 : 0.55,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: selected ? _PPColors.blueTint : _PPColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor, width: 1.5),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: selected ? _PPColors.blue : _PPColors.surface2,
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(color: selected ? _PPColors.blue : _PPColors.line),
                  ),
                  child: Icon(icon, size: 19, color: selected ? Colors.white : _PPColors.ink2),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              title,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: (textTheme.bodyMedium ?? const TextStyle()).copyWith(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.1,
                                color: _PPColors.ink1,
                              ),
                            ),
                          ),
                          if (isDefault) ...[
                            const SizedBox(width: 7),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: _PPColors.blue.withValues(alpha: selected ? 0.18 : 0.12),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                'DEFAULT',
                                style: (textTheme.labelSmall ?? const TextStyle()).copyWith(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.4,
                                  color: _PPColors.blue,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.only(right: 6),
                            decoration: BoxDecoration(
                              color: available ? _PPColors.gain : _PPColors.ink4,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              subtitle,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: (textTheme.bodySmall ?? const TextStyle()).copyWith(
                                fontSize: 12,
                                color: available ? _PPColors.ink3 : _PPColors.ink4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                selected
                    ? Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(color: _PPColors.blue, shape: BoxShape.circle),
                        child: const Icon(Icons.check_rounded, size: 15, color: Colors.white),
                      )
                    : Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: _PPColors.lineStrong, width: 2),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({
    required this.textTheme,
    required this.copies,
    required this.onMinus,
    required this.onPlus,
    required this.onCancel,
    required this.onPrint,
  });

  final TextTheme textTheme;
  final int copies;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final VoidCallback onCancel;
  final VoidCallback onPrint;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(26, 22, 26, 24),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: _PPColors.lineSoft)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                'Copies',
                style: (textTheme.bodyMedium ?? const TextStyle()).copyWith(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: _PPColors.ink2,
                ),
              ),
              const Spacer(),
              _Stepper(
                textTheme: textTheme,
                value: copies,
                onMinus: onMinus,
                onPlus: onPlus,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(flex: 10, child: _GhostButton(textTheme: textTheme, label: 'Cancel', onTap: onCancel)),
              const SizedBox(width: 11),
              Expanded(
                flex: 13,
                child: _PrimaryButton(textTheme: textTheme, label: 'Print receipt', onTap: onPrint),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({
    required this.textTheme,
    required this.value,
    required this.onMinus,
    required this.onPlus,
  });

  final TextTheme textTheme;
  final int value;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _PPColors.line, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _stepButton(Icons.remove_rounded, onMinus),
          Container(
            width: 38,
            alignment: Alignment.center,
            child: Text(
              '$value',
              style: (textTheme.bodyMedium ?? const TextStyle()).copyWith(
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
                color: _PPColors.ink1,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
          _stepButton(Icons.add_rounded, onPlus),
        ],
      ),
    );
  }

  Widget _stepButton(IconData icon, VoidCallback onTap) {
    return Material(
      color: _PPColors.surface2,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(width: 36, height: 38, child: Icon(icon, size: 16, color: _PPColors.blue)),
      ),
    );
  }
}

class _GhostButton extends StatelessWidget {
  const _GhostButton({required this.textTheme, required this.label, required this.onTap});

  final TextTheme textTheme;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _PPColors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _PPColors.lineStrong, width: 1.5),
          ),
          child: Text(
            label,
            style: (textTheme.bodyMedium ?? const TextStyle()).copyWith(
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.1,
              color: _PPColors.ink2,
            ),
          ),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.textTheme, required this.label, required this.onTap});

  final TextTheme textTheme;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [_PPColors.gradBtnTop, _PPColors.gradBtnBottom],
            ),
            boxShadow: [
              BoxShadow(
                color: _PPColors.blue.withValues(alpha: 0.45),
                blurRadius: 28,
                offset: const Offset(0, 12),
                spreadRadius: -8,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.print_rounded, size: 16, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                label,
                style: (textTheme.bodyMedium ?? const TextStyle()).copyWith(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.1,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
