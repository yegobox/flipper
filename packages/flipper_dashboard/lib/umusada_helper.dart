import 'package:flipper_models/umusada_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:supabase_models/brick/models/integration_config.model.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:google_fonts/google_fonts.dart';

class UmusadaHelper {
  // Brand colors
  static const _kPrimary = Color(0xFF01B8E4);
  static const _kTextPrimary = Color(0xFF1A1C1E);
  static const _kTextSecondary = Color(0xFF42474E);
  static const _kTextTertiary = Color(0xFF72787F);

  /// Entry point for Ordering Flow
  static Future<void> handleOrderingFlow(
    BuildContext context,
    VoidCallback onContinue,
  ) async {
    await _ensureUmusadaConnection(
      context,
      onConnected: onContinue,
      onDecline: onContinue,
    );
  }

  static Future<void> _ensureUmusadaConnection(
    BuildContext context, {
    required VoidCallback onConnected,
    required VoidCallback onDecline,
  }) async {
    final repo = Repository();
    final service = UmusadaService(repository: repo);
    final businessId = ProxyService.box.getBusinessId();

    if (businessId == null) {
      onDecline();
      return;
    }

    final config = await service.getConfig(businessId);

    if (config != null && config.token != null) {
      onConnected();
    } else {
      _showJoinDialog(context, service, businessId, onConnected, onDecline);
    }
  }

  // ───────────────────────────── Join Dialog ─────────────────────────────

  static void _showJoinDialog(
    BuildContext context,
    UmusadaService service,
    String businessId,
    VoidCallback onSuccess,
    VoidCallback onDecline,
  ) {
    WoltModalSheet.show(
      context: context,
      pageListBuilder: (context) {
        return [
          SliverWoltModalSheetPage(
            backgroundColor: Colors.white,
            pageTitle: Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 8.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _kPrimary.withAlpha(15),
                          _kPrimary.withAlpha(5),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_rounded,
                      color: _kPrimary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Umusada',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: _kTextPrimary,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Business Financing',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: _kTextTertiary,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            mainContentSliversBuilder: (_) => [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ─── Hero banner ───
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF01B8E4), Color(0xFF0078A8)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.trending_up_rounded,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              'Unlock Business Loans',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: Colors.white,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Get financing based on your order history',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.white.withOpacity(0.85),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ─── Benefits ───
                      Text(
                        'How it works',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: _kTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 14),

                      _BenefitTile(
                        icon: Icons.sync_rounded,
                        color: const Color(0xFF4CAF50),
                        title: 'Auto Sync',
                        subtitle:
                            'Your order data syncs securely to build your profile.',
                      ),
                      const SizedBox(height: 10),
                      _BenefitTile(
                        icon: Icons.assessment_rounded,
                        color: const Color(0xFFF57C00),
                        title: 'Credit Score',
                        subtitle:
                            'Umusada evaluates your history to set a loan limit.',
                      ),
                      const SizedBox(height: 10),
                      _BenefitTile(
                        icon: Icons.bolt_rounded,
                        color: const Color(0xFF7C4DFF),
                        title: 'Instant Loans',
                        subtitle:
                            'Access funds quickly when you need them most.',
                      ),

                      // Bottom spacing for sticky bar
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
            stickyActionBar: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _performAutoLogin(
                            context,
                            service,
                            businessId,
                            onSuccess,
                            onDecline,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _kPrimary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          'Join Umusada',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          onDecline();
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: _kTextTertiary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          'Maybe later',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ];
      },
      modalTypeBuilder: (context) => WoltModalType.dialog(),
    );
  }

  // ──────────────────────────── Auto Login ────────────────────────────

  static Future<void> _performAutoLogin(
    BuildContext context,
    UmusadaService service,
    String businessId,
    VoidCallback onSuccess,
    VoidCallback onFailure,
  ) async {
    // Show branded loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(_kPrimary),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Connecting…',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: _kTextSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    try {
      // 1. Login
      final loginResponse = await service.login(
        'beastar457@gmail.com',
        'arsPkt6B',
      );

      final otpToken = loginResponse['otpToken'];
      final otp = loginResponse['otp'];

      if (otpToken == null || otp == null) {
        throw Exception('Failed to retrieve OTP details from login response.');
      }

      // 2. Verify OTP
      final verifyResponse = await service.verifyOtp(otpToken, otp);
      final token = verifyResponse['token'];
      final refreshToken = verifyResponse['refreshToken'];
      final expiresAtStr = verifyResponse['expiresAt'] as String?;
      final expiresAt = expiresAtStr != null
          ? DateTime.tryParse(expiresAtStr)
          : null;

      if (token == null) {
        throw Exception('Failed to retrieve token from verification response.');
      }

      // 3. Register Business
      try {
        final business = ProxyService.app.business;
        final businessData = {
          "id": 0,
          "name": business.name ?? "Unknown Business",
          "businessTin": business.tinNumber?.toString() ?? "000000000",
          "category": "MANUFACTURER",
          "status": true,
          "email": business.email ?? "info@yegobox.com",
          "phoneNumber": business.phoneNumber ?? "",
          "location": business.adrs?.toString() ?? "Kigali",
          "registrationCode": "",
          "valueChain": "string",
          "aggregatorId": 9763,
          "classificationId": 0,
          "canSale": true,
          "canPurchase": true,
          "notifications": <Map<String, String>>[],
        };
        await service.registerBusiness(token, businessData);
      } catch (e) {
        debugPrint('Business registration warning: $e');
      }

      // 4. Save Configuration
      await service.saveConfig(
        IntegrationConfig(
          businessId: businessId,
          provider: 'umusada',
          token: token,
          refreshToken: refreshToken,
          expiresAt: expiresAt,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          config: '{"refreshToken": "$refreshToken"}',
        ),
      );

      // Dismiss loading
      if (context.mounted) Navigator.of(context).pop();

      onSuccess();
    } catch (e) {
      if (context.mounted) Navigator.of(context).pop();

      if (context.mounted) {
        _showErrorDialog(context, e.toString(), onFailure);
      }
    }
  }

  // ────────────────────────── Error Dialog ──────────────────────────

  static void _showErrorDialog(
    BuildContext context,
    String message,
    VoidCallback onClose,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: Color(0xFFE53935),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Connection Failed',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 17,
                color: _kTextPrimary,
              ),
            ),
          ],
        ),
        content: Text(
          'Could not connect to Umusada. Please try again later.',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: _kTextSecondary,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onClose();
            },
            style: TextButton.styleFrom(
              foregroundColor: _kPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Close',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════ Benefit Tile Widget ══════════════════════════

class _BenefitTile extends StatelessWidget {
  const _BenefitTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8ECF0), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: const Color(0xFF1A1C1E),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: const Color(0xFF72787F),
                    height: 1.4,
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
