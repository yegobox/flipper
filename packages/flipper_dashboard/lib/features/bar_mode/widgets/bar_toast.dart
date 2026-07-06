import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/bar_mode/theme/bar_tokens.dart';
import 'package:google_fonts/google_fonts.dart';

class BarToast extends StatefulWidget {
  const BarToast({
    super.key,
    required this.message,
    required this.onDone,
  });

  final String message;
  final VoidCallback onDone;

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
      left: 0,
      right: 0,
      bottom: 36,
      child: Center(
        child: Container(
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
        ),
      ),
    );
  }
}
