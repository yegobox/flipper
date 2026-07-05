import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flipper_dashboard/features/bar_mode/theme/bar_tokens.dart';
import 'package:flipper_models/sync/utils/bar_mode_utils.dart';
import 'package:google_fonts/google_fonts.dart';

typedef PinSubmitCallback = void Function(String pin);
typedef PinVerifyCallback = FutureOr<bool> Function(String pin);

class BarKeypad extends StatefulWidget {
  const BarKeypad({
    super.key,
    required this.title,
    required this.hint,
    required this.onSubmit,
    this.verifyPin,
    this.errorText = 'Wrong PIN — try again',
    this.managerErrorText = 'Not a manager PIN',
    this.enabled = true,
    this.tight = false,
    this.avatarLabel,
    this.avatarColor,
  });

  final String title;
  final String hint;
  final PinSubmitCallback onSubmit;
  final PinVerifyCallback? verifyPin;
  final String errorText;
  final String managerErrorText;
  final bool enabled;
  final bool tight;
  final String? avatarLabel;
  final Color? avatarColor;

  @override
  State<BarKeypad> createState() => _BarKeypadState();
}

class _BarKeypadState extends State<BarKeypad>
    with SingleTickerProviderStateMixin {
  final _digits = <String>[];
  bool _error = false;
  bool _verifying = false;
  String? _inlineError;
  late final AnimationController _shake;

  @override
  void initState() {
    super.initState();
    _shake = AnimationController(vsync: this, duration: BarTokens.pinShake);
    HardwareKeyboard.instance.addHandler(_onKey);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onKey);
    _shake.dispose();
    super.dispose();
  }

  bool _onKey(KeyEvent event) {
    if (!widget.enabled || event is! KeyDownEvent) return false;
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.backspace) {
      _backspace();
      return true;
    }
    final label = key.keyLabel;
    if (label.length == 1 && RegExp(r'[0-9]').hasMatch(label)) {
      _tapDigit(label);
      return true;
    }
    return false;
  }

  void _tapDigit(String d) {
    if (!widget.enabled || _verifying || _digits.length >= barPinCellCount) {
      return;
    }
    setState(() {
      _error = false;
      _inlineError = null;
      _digits.add(d);
    });
    if (_digits.length == barPinCellCount) {
      Future.delayed(const Duration(milliseconds: 90), _submit);
    }
  }

  void _clear() => setState(() {
        _digits.clear();
        _error = false;
        _inlineError = null;
      });

  void _backspace() {
    if (_digits.isEmpty) return;
    setState(() {
      _digits.removeLast();
      _error = false;
      _inlineError = null;
    });
  }

  Future<void> _submit() async {
    final pin = _digits.join();
    if (widget.verifyPin != null) {
      setState(() => _verifying = true);
      final ok = await widget.verifyPin!(pin);
      if (!mounted) return;
      setState(() => _verifying = false);
      if (!ok) {
        setState(() {
          _error = true;
          _inlineError = widget.errorText;
        });
        _shake.forward(from: 0);
        Future.delayed(const Duration(milliseconds: 380), _clear);
        return;
      }
    }
    widget.onSubmit(pin);
    _clear();
  }

  @override
  Widget build(BuildContext context) {
    final keySize = widget.tight ? 76.0 : 88.0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.avatarLabel != null) ...[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _avatar(widget.avatarLabel!, widget.avatarColor ?? BarTokens.blue),
              const SizedBox(width: 11),
              Text(
                widget.title,
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: BarTokens.ink1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
        ] else
          Text(
            widget.title,
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: BarTokens.ink1,
            ),
          ),
        const SizedBox(height: 4),
        Text(
          widget.enabled ? widget.hint : 'Select your name',
          style: GoogleFonts.outfit(fontSize: 13.5, color: BarTokens.ink3),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        AnimatedBuilder(
          animation: _shake,
          builder: (context, child) {
            final t = _shake.value;
            final dx = _error ? math.sin(t * math.pi * 5) * 9 * (1 - t) : 0.0;
            return Transform.translate(offset: Offset(dx, 0), child: child);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(barPinCellCount, (i) {
              final filled = i < _digits.length;
              return Container(
                width: 16,
                height: 16,
                margin: const EdgeInsets.symmetric(horizontal: 7.5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _error
                      ? const Color(0xFFDC2626)
                      : (filled ? BarTokens.blue : Colors.transparent),
                  border: Border.all(
                    color: _error
                        ? const Color(0xFFDC2626)
                        : BarTokens.lineStrong,
                    width: 2,
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 24),
        Opacity(
          opacity: widget.enabled && !_verifying ? 1 : 0.45,
          child: IgnorePointer(
            ignoring: !widget.enabled || _verifying,
            child: SizedBox(
              width: keySize * 3 + 24,
              child: GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1,
                children: [
                  for (var n = 1; n <= 9; n++)
                    _keyButton('$n', () => _tapDigit('$n')),
                  _keyButton('Clear', _clear, util: true),
                  _keyButton('0', () => _tapDigit('0')),
                  _keyButton('⌫', _backspace, util: true),
                ],
              ),
            ),
          ),
        ),
        if (_inlineError != null) ...[
          const SizedBox(height: 12),
          Text(
            _inlineError!,
            style: GoogleFonts.outfit(
              fontSize: 13,
              color: const Color(0xFFDC2626),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }

  Widget _keyButton(String label, VoidCallback onTap, {bool util = false}) {
    return Material(
      color: util ? BarTokens.surface2 : BarTokens.surface,
      borderRadius: BorderRadius.circular(BarTokens.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(BarTokens.radiusMd),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(BarTokens.radiusMd),
            border: Border.all(color: BarTokens.line),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: util ? 13 : 22,
              fontWeight: FontWeight.w700,
              color: BarTokens.ink1,
            ),
          ),
        ),
      ),
    );
  }

  Widget _avatar(String label, Color color) {
    return Container(
      width: 34,
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: GoogleFonts.outfit(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 13,
        ),
      ),
    );
  }
}
