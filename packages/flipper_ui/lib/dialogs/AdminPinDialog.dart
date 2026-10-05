import 'dart:async';
import 'dart:math' as math;

import 'package:flipper_design_system/flipper_design_system.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/setting_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

enum AdminPinMode { set, verify }

const int _kPinLength = 4;
const int _kMaxFailedAttempts = 5;
const Duration _kLockoutDuration = Duration(seconds: 30);

const Color _kTitleText = Color(0xFF111827);
const Color _kSubtitleText = Color(0xFF6B7280);
const Color _kKeySurface = Color(0xFFF3F4F6);
const Color _kCellBorder = Color(0xFFE5E7EB);

/// Shows the administrator PIN dialog.
///
/// Resolves to `true` when the PIN was verified ([AdminPinMode.verify]) or
/// saved ([AdminPinMode.set]); `false`/`null` when the user backed out.
///
/// [onSavePin] replaces the default [SettingsService.setAdminPin] call and
/// exists so widget tests can run without the service locator.
Future<bool?> showAdminPinDialog({
  required BuildContext context,
  required AdminPinMode mode,
  String? expectedPin,
  @visibleForTesting Future<void> Function(String pin)? onSavePin,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    builder: (context) => _AdminPinDialog(
      mode: mode,
      expectedPin: expectedPin,
      onSavePin: onSavePin,
    ),
  );
}

enum _Phase { entry, saving, success }

class _AdminPinDialog extends StatefulWidget {
  const _AdminPinDialog({
    required this.mode,
    this.expectedPin,
    this.onSavePin,
  });

  final AdminPinMode mode;
  final String? expectedPin;
  final Future<void> Function(String pin)? onSavePin;

  @override
  State<_AdminPinDialog> createState() => _AdminPinDialogState();
}

class _AdminPinDialogState extends State<_AdminPinDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shake = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  );

  String _pin = '';
  String? _firstPin;
  String _error = '';
  _Phase _phase = _Phase.entry;
  int _failedAttempts = 0;
  int _lockoutSecondsLeft = 0;
  Timer? _lockoutTimer;

  bool get _isSetMode => widget.mode == AdminPinMode.set;
  bool get _isConfirming => _isSetMode && _firstPin != null;

  bool get _isLockedOut => _lockoutSecondsLeft > 0;

  bool get _inputEnabled => _phase == _Phase.entry && !_isLockedOut;

  @override
  void dispose() {
    _lockoutTimer?.cancel();
    _shake.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Input
  // ---------------------------------------------------------------------------

  void _onDigit(String digit) {
    if (!_inputEnabled || _pin.length >= _kPinLength) return;
    setState(() {
      _pin += digit;
      _error = '';
    });
    if (_pin.length == _kPinLength) _onPinComplete();
  }

  void _onBackspace() {
    if (!_inputEnabled || _pin.isEmpty) return;
    setState(() {
      _pin = _pin.substring(0, _pin.length - 1);
      _error = '';
    });
  }

  void _onClear() {
    if (!_inputEnabled || _pin.isEmpty) return;
    setState(() {
      _pin = '';
      _error = '';
    });
  }

  void _startOver() {
    setState(() {
      _pin = '';
      _firstPin = null;
      _error = '';
    });
  }

  void _cancel() => Navigator.of(context).pop(false);

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.escape) {
      _cancel();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.backspace ||
        key == LogicalKeyboardKey.delete) {
      _onBackspace();
      return KeyEventResult.handled;
    }
    final digit = _digitForKey[key];
    if (digit != null && event is KeyDownEvent) {
      _onDigit(digit);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  static final Map<LogicalKeyboardKey, String> _digitForKey = {
    LogicalKeyboardKey.digit0: '0',
    LogicalKeyboardKey.digit1: '1',
    LogicalKeyboardKey.digit2: '2',
    LogicalKeyboardKey.digit3: '3',
    LogicalKeyboardKey.digit4: '4',
    LogicalKeyboardKey.digit5: '5',
    LogicalKeyboardKey.digit6: '6',
    LogicalKeyboardKey.digit7: '7',
    LogicalKeyboardKey.digit8: '8',
    LogicalKeyboardKey.digit9: '9',
    LogicalKeyboardKey.numpad0: '0',
    LogicalKeyboardKey.numpad1: '1',
    LogicalKeyboardKey.numpad2: '2',
    LogicalKeyboardKey.numpad3: '3',
    LogicalKeyboardKey.numpad4: '4',
    LogicalKeyboardKey.numpad5: '5',
    LogicalKeyboardKey.numpad6: '6',
    LogicalKeyboardKey.numpad7: '7',
    LogicalKeyboardKey.numpad8: '8',
    LogicalKeyboardKey.numpad9: '9',
  };

  // ---------------------------------------------------------------------------
  // Flow
  // ---------------------------------------------------------------------------

  void _onPinComplete() {
    if (_isSetMode) {
      _handleSetEntry();
    } else {
      _handleVerifyEntry();
    }
  }

  void _handleSetEntry() {
    if (_firstPin == null) {
      setState(() {
        _firstPin = _pin;
        _pin = '';
      });
      return;
    }
    if (_pin == _firstPin) {
      _save(_pin);
    } else {
      _reject(context.flipperL10n.uiAdminPinMismatch);
      setState(() => _firstPin = null);
    }
  }

  void _handleVerifyEntry() {
    if (_pin == widget.expectedPin) {
      Navigator.of(context).pop(true);
      return;
    }
    _failedAttempts++;
    if (_failedAttempts >= _kMaxFailedAttempts) {
      _failedAttempts = 0;
      _startLockout();
      _reject('');
    } else {
      final left = _kMaxFailedAttempts - _failedAttempts;
      _reject(context.flipperL10n.uiAdminPinIncorrect(left));
    }
  }

  void _reject(String message) {
    HapticFeedback.mediumImpact();
    setState(() {
      _pin = '';
      _error = message;
    });
    _shake.forward(from: 0);
  }

  void _startLockout() {
    _lockoutSecondsLeft = _kLockoutDuration.inSeconds;
    _lockoutTimer?.cancel();
    // Only ticks while locked out; cancels itself when the countdown ends.
    _lockoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() => _lockoutSecondsLeft--);
      if (!_isLockedOut) {
        timer.cancel();
        _lockoutTimer = null;
      }
    });
  }

  Future<void> _save(String pin) async {
    setState(() {
      _phase = _Phase.saving;
      _error = '';
    });
    try {
      final save = widget.onSavePin ??
          (String pin) => locator<SettingsService>().setAdminPin(
                pin: pin,
                businessId: ProxyService.box.getBusinessId()!,
              );
      await save(pin);
      if (!mounted) return;
      setState(() => _phase = _Phase.success);
      await Future<void>.delayed(const Duration(milliseconds: 450));
      if (mounted) Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _phase = _Phase.entry;
        _pin = '';
        _error = context.flipperL10n.uiAdminPinSaveFailed;
      });
    }
  }

  // ---------------------------------------------------------------------------
  // Copy
  // ---------------------------------------------------------------------------

  String get _title {
    final l10n = context.flipperL10n;
    if (_phase == _Phase.success) return l10n.uiAdminPinSaved;
    if (!_isSetMode) return l10n.uiAdminPinEnter;
    return _isConfirming ? l10n.uiAdminPinConfirm : l10n.uiAdminPinSetUp;
  }

  String get _subtitle {
    final l10n = context.flipperL10n;
    if (_phase == _Phase.success) {
      return l10n.uiAdminPinSavedSubtitle;
    }
    if (!_isSetMode) {
      return l10n.uiAdminPinVerifySubtitle;
    }
    return _isConfirming
        ? l10n.uiAdminPinConfirmSubtitle
        : l10n.uiAdminPinSetSubtitle;
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: FlipperColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Focus(
          autofocus: true,
          onKeyEvent: _onKeyEvent,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: _phase == _Phase.saving ? null : _cancel,
                    icon: const Icon(Icons.close_rounded, size: 20),
                    color: _kSubtitleText,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
                _buildBadge(),
                const SizedBox(height: 16),
                Text(
                  _title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: _kTitleText,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _subtitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    height: 1.4,
                    color: _kSubtitleText,
                  ),
                ),
                if (_isSetMode && _phase != _Phase.success) ...[
                  const SizedBox(height: 14),
                  _buildStepPill(),
                ],
                const SizedBox(height: 24),
                _buildPinCells(),
                const SizedBox(height: 12),
                _buildMessage(),
                const SizedBox(height: 16),
                _buildKeypad(),
                const SizedBox(height: 8),
                _buildFooter(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge() {
    final success = _phase == _Phase.success;
    final color = success ? FlipperColors.success : FlipperColors.primary;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, animation) =>
            ScaleTransition(scale: animation, child: child),
        child: Icon(
          success
              ? Icons.check_rounded
              : (_isLockedOut
                  ? Icons.lock_clock_outlined
                  : Icons.shield_outlined),
          key: ValueKey('${success}_$_isLockedOut'),
          color: color,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildStepPill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: FlipperColors.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        context.flipperL10n.signupStepOf(_isConfirming ? '2' : '1', '2'),
        style: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF0891B2),
        ),
      ),
    );
  }

  Widget _buildPinCells() {
    if (_phase == _Phase.saving) {
      return const SizedBox(
        height: 64,
        child: Center(
          child: SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: FlipperColors.primary,
            ),
          ),
        ),
      );
    }

    final hasError = _error.isNotEmpty;
    final cells = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_kPinLength, (index) {
        final filled = index < _pin.length;
        final active = _inputEnabled && index == _pin.length;
        final Color border;
        if (_phase == _Phase.success) {
          border = FlipperColors.success;
        } else if (hasError) {
          border = FlipperColors.error;
        } else if (active) {
          border = FlipperColors.primary;
        } else if (filled) {
          border = FlipperColors.primary.withValues(alpha: 0.5);
        } else {
          border = _kCellBorder;
        }
        return AnimatedContainer(
          key: ValueKey('admin_pin_cell_$index'),
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: 56,
          height: 64,
          decoration: BoxDecoration(
            color: _isLockedOut ? _kKeySurface : FlipperColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border, width: active ? 2 : 1.5),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: FlipperColors.primary.withValues(alpha: 0.18),
                      blurRadius: 0,
                      spreadRadius: 3,
                    ),
                  ]
                : const [],
          ),
          alignment: Alignment.center,
          child: AnimatedScale(
            duration: const Duration(milliseconds: 150),
            scale: filled || _phase == _Phase.success ? 1 : 0,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: _phase == _Phase.success
                    ? FlipperColors.success
                    : _kTitleText,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      }),
    );

    return Semantics(
      label: context.flipperL10n
          .uiAdminPinDigitsSemantic('${_pin.length}', '$_kPinLength'),
      child: AnimatedBuilder(
        animation: _shake,
        builder: (context, child) {
          final t = _shake.value;
          final dx = math.sin(t * math.pi * 6) * 10 * (1 - t);
          return Transform.translate(offset: Offset(dx, 0), child: child);
        },
        child: cells,
      ),
    );
  }

  Widget _buildMessage() {
    if (_isLockedOut) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: FlipperColors.error.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const Icon(Icons.timer_outlined,
                size: 18, color: FlipperColors.error),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                context.flipperL10n.uiAdminPinLockout('$_lockoutSecondsLeft'),
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: FlipperColors.error,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return SizedBox(
      height: 20,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 150),
        child: Text(
          _error,
          key: ValueKey(_error),
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: FlipperColors.error,
          ),
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    const rows = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
    ];
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: _inputEnabled ? 1 : 0.4,
      child: Column(
        children: [
          for (final row in rows)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  for (var i = 0; i < row.length; i++) ...[
                    if (i > 0) const SizedBox(width: 10),
                    Expanded(child: _digitKey(row[i])),
                  ],
                ],
              ),
            ),
          Row(
            children: [
              const Expanded(child: SizedBox(height: 60)),
              const SizedBox(width: 10),
              Expanded(child: _digitKey('0')),
              const SizedBox(width: 10),
              Expanded(
                child: _KeypadKey(
                  semanticsLabel: context.flipperL10n.delete,
                  onTap: _inputEnabled ? _onBackspace : null,
                  onLongPress: _inputEnabled ? _onClear : null,
                  background: Colors.transparent,
                  child: const Icon(
                    Icons.backspace_outlined,
                    size: 22,
                    color: _kTitleText,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _digitKey(String digit) {
    return _KeypadKey(
      key: ValueKey('admin_pin_key_$digit'),
      semanticsLabel: digit,
      onTap: _inputEnabled ? () => _onDigit(digit) : null,
      background: _kKeySurface,
      child: Text(
        digit,
        style: GoogleFonts.outfit(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: _kTitleText,
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final saving = _phase != _Phase.entry;
    final textStyle = GoogleFonts.outfit(
      fontSize: 14,
      fontWeight: FontWeight.w600,
    );
    return Row(
      children: [
        if (_isConfirming && !saving)
          TextButton(
            onPressed: _startOver,
            style: TextButton.styleFrom(foregroundColor: _kSubtitleText),
            child:
                Text(context.flipperL10n.uiAdminPinStartOver, style: textStyle),
          ),
        const Spacer(),
        TextButton(
          onPressed: saving ? null : _cancel,
          style: TextButton.styleFrom(foregroundColor: _kSubtitleText),
          child: Text(context.flipperL10n.cancel, style: textStyle),
        ),
      ],
    );
  }
}

class _KeypadKey extends StatelessWidget {
  const _KeypadKey({
    super.key,
    required this.semanticsLabel,
    required this.child,
    required this.background,
    this.onTap,
    this.onLongPress,
  });

  final String semanticsLabel;
  final Widget child;
  final Color background;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(14);
    return Semantics(
      button: true,
      label: semanticsLabel,
      excludeSemantics: true,
      child: Material(
        color: background,
        borderRadius: radius,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: radius,
          canRequestFocus: false,
          splashColor: FlipperColors.primary.withValues(alpha: 0.16),
          highlightColor: FlipperColors.primary.withValues(alpha: 0.08),
          hoverColor: Colors.black.withValues(alpha: 0.04),
          child: SizedBox(height: 60, child: Center(child: child)),
        ),
      ),
    );
  }
}
