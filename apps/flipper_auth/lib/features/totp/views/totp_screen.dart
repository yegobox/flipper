// lib/features/totp/views/totp_screen.dart
import 'dart:async';
import 'dart:math' as math;

import 'package:flipper_auth/auth_scanner_actions.dart';
import 'package:flipper_auth/features/totp/providers/providers/totp_notifier.dart';
import 'package:flipper_scanner/scanner_view.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final clockProvider = StreamProvider.autoDispose((ref) {
  return Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now());
});

class TotpAccount {
  final String issuer;
  final String accountName;
  final String secret;

  TotpAccount({
    required this.issuer,
    required this.accountName,
    required this.secret,
  });

  factory TotpAccount.fromMap(Map<String, dynamic> map) {
    return TotpAccount(
      issuer: map['issuer'] as String? ?? 'Unknown Issuer',
      accountName: map['account_name'] as String? ?? '',
      secret: map['secret'] as String? ?? '',
    );
  }
}

class TOTPScreen extends ConsumerStatefulWidget {
  const TOTPScreen({super.key});

  @override
  ConsumerState<TOTPScreen> createState() => _TOTPScreenState();
}

class _TOTPScreenState extends ConsumerState<TOTPScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(totpNotifierProvider.notifier).loadAccounts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final totpState = ref.watch(totpNotifierProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF2F2F7),
      appBar: AppBar(
        title: const Text(
          'Authenticator',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: isDark ? const Color(0xFF2C2C2E) : Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Add menu functionality
            },
          ),
        ],
      ),
      body: totpState.isLoading
          ? const Center(
              child: CircularProgressIndicator(
                strokeWidth: 3,
              ),
            )
          : totpState.error != null
              ? _buildErrorState(totpState.error!)
              : totpState.accounts.isEmpty
                  ? _buildEmptyState(context)
                  : _buildAccountsList(totpState.accounts, isDark),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: FloatingActionButton.extended(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScannView(
                intent: LOGIN,
                scannerActions: AuthScannerActions(context, ref),
              ),
            ),
          ),
          backgroundColor: const Color(0xFF0066CC),
          foregroundColor: Colors.white,
          elevation: 8,
          icon: const Icon(Icons.add, size: 20),
          label: const Text(
            'Add account',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.red[400],
              ),
            ),
            const SizedBox(height: 8),
            if (kDebugMode)
              Text(
                error,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              )
            else
              const Text(
                'An unexpected error occurred. Please try again.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ref.read(totpNotifierProvider.notifier).loadAccounts();
              },
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
                borderRadius: BorderRadius.circular(60),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.security,
                size: 48,
                color: Color(0xFF0066CC),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'No accounts added',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Add your first account to start\ngenerating verification codes',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountsList(List<dynamic> accounts, bool isDark) {
    final validAccounts = accounts
        .map((account) {
          if (account is Map<String, dynamic>) {
            final secret = account['secret'] as String?;
            if (secret != null && secret.isNotEmpty) {
              return TotpAccount.fromMap(account);
            }
          }
          return null;
        })
        .whereType<TotpAccount>()
        .toList();

    if (validAccounts.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: validAccounts.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final account = validAccounts[index];
        return ModernTOTPCard(
          issuer: account.issuer,
          accountName: account.accountName,
          secret: account.secret,
          isDark: isDark,
        );
      },
    );
  }
}

class ModernTOTPCard extends ConsumerStatefulWidget {
  final String issuer;
  final String accountName;
  final String secret;
  final bool isDark;

  const ModernTOTPCard({
    super.key,
    required this.issuer,
    required this.accountName,
    required this.secret,
    required this.isDark,
  });

  @override
  ConsumerState<ModernTOTPCard> createState() => _ModernTOTPCardState();
}

class _ModernTOTPCardState extends ConsumerState<ModernTOTPCard> {
  String _currentCode = '';
  int _lastTimeWindow = 0;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _updateCodeIfNeeded(rebuild: false);
  }

  void _updateCodeIfNeeded({bool rebuild = true}) {
    final timeWindow = DateTime.now().millisecondsSinceEpoch ~/ 30000;
    if (timeWindow != _lastTimeWindow) {
      final newCode =
          ref.read(totpNotifierProvider.notifier).generateCode(widget.secret);
      if (rebuild) {
        if (mounted) {
          setState(() {
            _currentCode = newCode;
            _lastTimeWindow = timeWindow;
          });
        }
      } else {
        _currentCode = newCode;
        _lastTimeWindow = timeWindow;
      }
    }
  }

  void _copyToClipboard() {
    if (_currentCode.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _currentCode));
      HapticFeedback.lightImpact();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Code copied to clipboard'),
          backgroundColor: const Color(0xFF0066CC),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Color _getProgressColor(int remaining) {
    if (remaining > 10) {
      return const Color(0xFF34C759);
    } else if (remaining > 5) {
      return const Color(0xFFFF9500);
    } else {
      return const Color(0xFFFF3B30);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(clockProvider);
    _updateCodeIfNeeded();

    final now = DateTime.now();
    final remainingSeconds = 30 - (now.second % 30);
    final progress = (30.0 - remainingSeconds) / 30.0;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: widget.isDark ? const Color(0xFF2C2C2E) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(widget.isDark ? 0.3 : 0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0066CC).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.account_circle,
                      color: Color(0xFF0066CC),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.issuer,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color:
                                widget.isDark ? Colors.white : Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.accountName,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Add more options menu
                    },
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.grey[600],
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _copyToClipboard,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _formatCode(_currentCode),
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'monospace',
                              color:
                                  widget.isDark ? Colors.white : Colors.black87,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _getProgressColor(remainingSeconds)
                                      .withOpacity(0.2),
                                ),
                                child: CustomPaint(
                                  size: const Size(16, 16),
                                  painter: CircularProgressPainter(
                                    progress: progress,
                                    color: _getProgressColor(remainingSeconds),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${remainingSeconds}s',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: _getProgressColor(remainingSeconds),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0066CC).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.copy,
                        color: Color(0xFF0066CC),
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatCode(String code) {
    if (code.length == 6) {
      return '${code.substring(0, 3)} ${code.substring(3)}';
    }
    return code;
  }
}

class CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;

  CircularProgressPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 2) / 2;

    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
