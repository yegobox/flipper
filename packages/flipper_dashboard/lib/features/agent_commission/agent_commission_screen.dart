import 'package:flipper_models/helpers/agent_session_helper.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked_services/stacked_services.dart';

/// Commission-only shell for agents without full business dashboard login.
class AgentCommissionScreen extends StatelessWidget {
  const AgentCommissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final businessId = ProxyService.box.getBusinessId();
    final branchId = ProxyService.box.getBranchId();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Agent commission',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF111827),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await setCommissionOnlySession(false);
              await ProxyService.strategy.logOut();
              if (context.mounted) {
                locator<RouterService>().clearStackAndShow(LoginRoute());
              }
            },
            child: Text(
              'Sign out',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w600,
                color: const Color(0xff006AFE),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Commission details coming soon',
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'You are signed in for this business in commission-only mode. '
              'Your hiring business can enable full dashboard access from User Management.',
              style: GoogleFonts.outfit(
                fontSize: 15,
                height: 1.45,
                color: Colors.grey[700],
              ),
            ),
            if (businessId != null || branchId != null) ...[
              const SizedBox(height: 24),
              if (businessId != null)
                Text(
                  'Business: $businessId',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              if (branchId != null)
                Text(
                  'Branch: $branchId',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
