import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/services_gigs_screen.dart';

/// Entry for the peer-to-peer services / gigs marketplace (mobile).
///
/// Flow: provider registration → ratings → requests → accept (30m) → pay (5m) →
/// service execution → mutual confirmation → platform disbursement (MTN, ledger).
class ServicesGigsApp extends StatelessWidget {
  const ServicesGigsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ProviderScope(
      child: Material(child: ServicesGigsScreen()),
    );
  }
}
