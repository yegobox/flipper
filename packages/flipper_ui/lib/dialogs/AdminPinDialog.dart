import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:flipper_services/setting_service.dart';
import 'package:flipper_routing/app.locator.dart';

enum AdminPinMode { set, verify }

Future<bool?> showAdminPinDialog({
  required BuildContext context,
  required AdminPinMode mode,
  String? expectedPin,
}) {
  return WoltModalSheet.show<bool>(
    context: context,
    pageListBuilder: (context) {
      return [
        _buildPinPage(context, mode, expectedPin),
      ];
    },
    modalTypeBuilder: (context) => WoltModalType.dialog(),
  );
}

SliverWoltModalSheetPage _buildPinPage(
  BuildContext context,
  AdminPinMode mode,
  String? expectedPin,
) {
  final title =
      mode == AdminPinMode.set ? 'Setup Admin PIN' : 'Security Verification';

  return SliverWoltModalSheetPage(
    backgroundColor: Colors.white,
    pageTitle: Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF01B8E4).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.shield_outlined,
                color: Color(0xFF01B8E4), size: 24),
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: const Color(0xFF1A1C1E),
            ),
          ),
        ],
      ),
    ),
    mainContentSliversBuilder: (context) => [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: _AdminPinContent(
            mode: mode,
            expectedPin: expectedPin,
            onSuccess: (pin) async {
              Navigator.of(context).pop(true);
            },
          ),
        ),
      ),
    ],
  );
}

class _AdminPinContent extends StatefulWidget {
  final AdminPinMode mode;
  final String? expectedPin;
  final Function(String) onSuccess;

  const _AdminPinContent({
    required this.mode,
    this.expectedPin,
    required this.onSuccess,
  });

  @override
  State<_AdminPinContent> createState() => _AdminPinContentState();
}

class _AdminPinContentState extends State<_AdminPinContent> {
  final TextEditingController _pinController = TextEditingController();
  final settingsService = locator<SettingsService>();
  String _errorText = '';
  String? _firstPin;
  bool _isConfirming = false;
  bool _canSave = false;
  bool _isLoading = false;

  String get _subtitle {
    if (widget.mode == AdminPinMode.verify) {
      return 'Please enter your 4-digit administrator PIN to proceed.';
    }
    if (_isConfirming) {
      return 'Confirm your new 4-digit PIN to save.';
    }
    return 'Create a 4-digit PIN to protect sensitive actions.';
  }

  void _onKeyPress(String value) {
    if (_pinController.text.length < 4) {
      setState(() {
        _pinController.text += value;
        _errorText = '';
      });
      if (_pinController.text.length == 4) {
        _handlePinEntry();
      }
    }
  }

  void _onBackspace() {
    if (_pinController.text.isNotEmpty) {
      setState(() {
        _pinController.text =
            _pinController.text.substring(0, _pinController.text.length - 1);
        _errorText = '';
        _canSave = false;
      });
    }
  }

  void _handlePinEntry() {
    if (widget.mode == AdminPinMode.verify) {
      if (_pinController.text == widget.expectedPin) {
        widget.onSuccess(_pinController.text);
      } else {
        setState(() {
          _errorText = 'Incorrect PIN. Please try again.';
          _pinController.clear();
        });
      }
    } else {
      // Set Mode
      if (!_isConfirming) {
        setState(() {
          _firstPin = _pinController.text;
          _isConfirming = true;
          _pinController.clear();
        });
      } else {
        if (_pinController.text == _firstPin) {
          setState(() {
            _canSave = true;
          });
        } else {
          setState(() {
            _errorText = 'PINs do not match. Start over.';
            _pinController.clear();
            _firstPin = null;
            _isConfirming = false;
          });
        }
      }
    }
  }

  Future<void> _savePin() async {
    if (_canSave && _pinController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
        _errorText = '';
      });
      try {
        await settingsService.setAdminPin(
          pin: _pinController.text,
          businessId: ProxyService.box.getBusinessId()!,
        );
        widget.onSuccess(_pinController.text);
      } catch (e) {
        setState(() {
          _errorText = 'Failed to save PIN. Please try again.';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _subtitle,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (index) {
            final isFilled = _pinController.text.length > index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 12),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isFilled ? const Color(0xFF01B8E4) : Colors.transparent,
                border: Border.all(
                  color: isFilled ? const Color(0xFF01B8E4) : Colors.grey[300]!,
                  width: 2,
                ),
                boxShadow: isFilled
                    ? [
                        BoxShadow(
                          color: const Color(0xFF01B8E4).withValues(alpha: 0.3),
                          blurRadius: 8,
                          spreadRadius: 2,
                        )
                      ]
                    : [],
              ),
            );
          }),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 20,
          child: _errorText.isNotEmpty
              ? Text(
                  _errorText,
                  style: GoogleFonts.poppins(
                    color: Colors.redAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : null,
        ),
        const SizedBox(height: 32),
        _buildNumericKeyboard(),
        const SizedBox(height: 40),
        if (widget.mode == AdminPinMode.set)
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: (_canSave && !_isLoading) ? _savePin : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF01B8E4),
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey[200],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'Save PIN',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
      ],
    );
  }

  Widget _buildNumericKeyboard() {
    return Column(
      children: [
        for (var i = 0; i < 3; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (var j = 1; j <= 3; j++) _buildKey((i * 3 + j).toString()),
              ],
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(width: 72),
            _buildKey('0'),
            _buildBackspaceKey(),
          ],
        ),
      ],
    );
  }

  Widget _buildKey(String value) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onKeyPress(value),
        borderRadius: BorderRadius.circular(36),
        child: Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey[100]!, width: 1),
          ),
          alignment: Alignment.center,
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1A1C1E),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackspaceKey() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _onBackspace,
        borderRadius: BorderRadius.circular(36),
        child: Container(
          width: 72,
          height: 72,
          alignment: Alignment.center,
          child: const Icon(Icons.backspace_outlined,
              color: Color(0xFF1A1C1E), size: 24),
        ),
      ),
    );
  }
}
