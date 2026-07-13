import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/bar_mode/theme/bar_tokens.dart';
import 'package:google_fonts/google_fonts.dart';

class BarToast extends StatefulWidget {
  const BarToast({
    super.key,
    required this.message,
    required this.onDone,
    this.mobile = false,
  });

  final String message;
  final VoidCallback onDone;
  final bool mobile;

  @override
  State<BarToast> createState() => _BarToastState();
}

class _BarToastState extends State<BarToast> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 3200), widget.onDone);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.mobile ? 16 : 0,
      right: widget.mobile ? 16 : 0,
      bottom: widget.mobile ? 44 : 36,
      child: widget.mobile
          ? _toastPill()
          : Center(child: _toastPill()),
    );
  }

  Widget _toastPill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: BarTokens.toastBg,
        borderRadius: BorderRadius.circular(999),
        boxShadow: BarTokens.shadow2,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, color: BarTokens.toastCheck, size: 20),
          const SizedBox(width: 10),
          Text(
            widget.message,
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
