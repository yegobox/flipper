import 'package:flipper_dashboard/features/services_gigs/models/service_gig_provider.dart';
import 'package:flipper_dashboard/features/services_gigs/screens/customer_my_requests_screen.dart';
import 'package:flipper_dashboard/features/services_gigs/screens/provider_browse_screen.dart';
import 'package:flipper_dashboard/features/services_gigs/screens/provider_inbox_screen.dart';
import 'package:flipper_dashboard/features/services_gigs/screens/provider_registration_screen.dart';
import 'package:flipper_dashboard/features/services_gigs/services/service_gig_provider_repository.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Product shell for the services marketplace. Backend, MTN charge/disbursement
/// endpoints, and real-time timers will plug in here later.
class ServicesGigsScreen extends StatefulWidget {
  const ServicesGigsScreen({Key? key}) : super(key: key);

  @override
  State<ServicesGigsScreen> createState() => _ServicesGigsScreenState();
}

class _ServicesGigsScreenState extends State<ServicesGigsScreen> {
  final _repo = ServiceGigProviderRepository();
  ServiceGigProvider? _provider;
  bool _loadingProfile = true;

  @override
  void initState() {
    super.initState();
    _refreshProfile();
  }

  Future<void> _refreshProfile() async {
    final userId = ProxyService.box.getUserId();
    final profile =
        userId != null ? await _repo.load(userId) : null;
    if (mounted) {
      setState(() {
        _provider = profile;
        _loadingProfile = false;
      });
    }
  }

  Future<void> _openRegistration() async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => ProviderRegistrationScreen(
          initialProfile: _provider,
        ),
      ),
    );
    if (changed == true && mounted) await _refreshProfile();
  }

  void _openBrowseProviders() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ProviderBrowseScreen(),
      ),
    );
  }

  void _openProviderInbox() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ProviderInboxScreen(),
      ),
    );
  }

  void _openMyRequests() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CustomerMyRequestsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'Services hub',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        backgroundColor: const Color(0xFF0D9488),
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          Text(
            'Offer skills, request help, and pay safely through the platform.',
            style: GoogleFonts.poppins(
              fontSize: 15,
              height: 1.45,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _openBrowseProviders,
            icon: const Icon(Icons.search),
            label: const Text('Find providers'),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF0F766E),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: _openProviderInbox,
            icon: const Icon(Icons.inbox_outlined),
            label: const Text('Incoming requests'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF0F766E),
              side: const BorderSide(color: Color(0xFF0F766E)),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: _openMyRequests,
            icon: const Icon(Icons.receipt_long_outlined),
            label: const Text('My requests'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF0F766E),
              side: const BorderSide(color: Color(0xFF0F766E)),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            ),
          ),
          const SizedBox(height: 12),
          if (_loadingProfile)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_provider != null)
            _RegisteredProviderCard(
              profile: _provider!,
              onEdit: _openRegistration,
            )
          else
            _BecomeProviderCallout(onRegister: _openRegistration),
          const SizedBox(height: 20),
          _SectionCard(
            icon: Icons.person_add_alt_1_outlined,
            title: 'Providers',
            body:
                'Workers register and list the services they can perform for others.',
          ),
          _SectionCard(
            icon: Icons.star_outline_rounded,
            title: 'Ratings',
            body:
                'We assign and update ratings from our verification and client feedback.',
          ),
          _SectionCard(
            icon: Icons.send_outlined,
            title: 'Requests',
            body:
                'Customers send a service request to a chosen provider. The provider must accept or decline within 30 minutes.',
            highlight: '30 min to accept',
          ),
          _SectionCard(
            icon: Icons.payments_outlined,
            title: 'Payment window',
            body:
                'After acceptance, the customer completes payment within 5 minutes so the job is confirmed and funded.',
            highlight: '5 min to pay',
          ),
          _SectionCard(
            icon: Icons.route_outlined,
            title: 'Execution',
            body:
                'Once paid, the worker can contact the customer and perform the service.',
          ),
          _SectionCard(
            icon: Icons.account_balance_wallet_outlined,
            title: 'Escrow & payout',
            body:
                'We collect funds via MTN (and dedicated charge APIs). Money is released after both sides confirm completion; ledgers track balances, commission, and who is owed what.',
          ),
        ],
      ),
    );
  }
}

class _BecomeProviderCallout extends StatelessWidget {
  final VoidCallback onRegister;

  const _BecomeProviderCallout({required this.onRegister});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: const Color(0xFF0D9488).withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: const Color(0xFF0D9488).withValues(alpha: 0.35)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Earn on Services hub',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.grey.shade900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Register the services you offer so customers can find and book you.',
              style: GoogleFonts.poppins(
                fontSize: 13,
                height: 1.4,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: onRegister,
              icon: const Icon(Icons.how_to_reg_outlined),
              label: const Text('Become a provider'),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF0D9488),
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RegisteredProviderCard extends StatelessWidget {
  final ServiceGigProvider profile;
  final VoidCallback onEdit;

  const _RegisteredProviderCard({
    required this.profile,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final preview = profile.services.isEmpty
        ? 'No services listed yet'
        : profile.services.take(4).join(' · ');
    final more = profile.services.length > 4
        ? ' +${profile.services.length - 4} more'
        : '';

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D9488).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.verified_outlined,
                  color: Color(0xFF0D9488),
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.displayName,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$preview$more',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        height: 1.35,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap to edit profile',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: const Color(0xFF0D9488),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  final String? highlight;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.body,
    this.highlight,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF0D9488).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF0D9488), size: 22),
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
                      fontSize: 15,
                    ),
                  ),
                  if (highlight != null) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.amber.shade200),
                      ),
                      child: Text(
                        highlight!,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.amber.shade900,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    body,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      height: 1.4,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
