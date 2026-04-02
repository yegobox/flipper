import 'package:flipper_dashboard/features/services_gigs/models/service_gig_provider.dart';
import 'package:flipper_dashboard/features/services_gigs/services/service_gig_provider_repository.dart';
import 'package:flipper_dashboard/features/services_gigs/widgets/request_service_sheet.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Full provider profile: verification, portfolio, reviews, book CTA.
class ProviderDetailScreen extends StatefulWidget {
  final ServiceGigProvider provider;

  const ProviderDetailScreen({Key? key, required this.provider}) : super(key: key);

  @override
  State<ProviderDetailScreen> createState() => _ProviderDetailScreenState();
}

class _ProviderDetailScreenState extends State<ProviderDetailScreen> {
  final _repo = ServiceGigProviderRepository();
  ServiceGigProvider? _profile;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    setState(() => _loading = true);
    final p = await _repo.load(widget.provider.userId);
    if (!mounted) return;
    setState(() {
      _profile = p ?? widget.provider;
      _loading = false;
    });
  }

  Future<void> _book() async {
    final p = _profile ?? widget.provider;
    final sent = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => RequestServiceSheet(provider: p),
    );
    if (sent == true && mounted) {
      showSuccessNotification(
        context,
        'Request sent. Track it under My requests.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = _profile ?? widget.provider;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 160,
                  pinned: true,
                  backgroundColor: const Color(0xFF0D9488),
                  foregroundColor: Colors.white,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      p.displayName,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xFF0F766E),
                            const Color(0xFF0D9488).withValues(alpha: 0.9),
                          ],
                        ),
                      ),
                      alignment: Alignment.bottomLeft,
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 48),
                      child: CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        child: Text(
                          p.displayName.isNotEmpty
                              ? p.displayName[0].toUpperCase()
                              : '?',
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _VerificationRow(provider: p),
                        const SizedBox(height: 16),
                        if (p.serviceArea != null && p.serviceArea!.isNotEmpty)
                          Text(
                            p.serviceArea!,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        const SizedBox(height: 12),
                        Text(
                          p.bio,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _StatsRow(provider: p),
                        if (p.basePriceRwf != null ||
                            p.pricingNotes != null ||
                            p.servicePricing.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          Text(
                            'Pricing',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (p.basePriceRwf != null)
                            Text(
                              'From ${p.formattedBasePrice}',
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                          if (p.pricingNotes != null &&
                              p.pricingNotes!.isNotEmpty)
                            Text(
                              p.pricingNotes!,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          for (final sp in p.servicePricing)
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                '${sp.serviceName}: ${sp.formattedPrice}',
                                style: GoogleFonts.poppins(fontSize: 13),
                              ),
                            ),
                        ],
                        if (p.availabilitySchedule != null &&
                            p.availabilitySchedule!.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Text(
                            'Availability',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            p.availabilitySchedule!,
                            style: GoogleFonts.poppins(fontSize: 13),
                          ),
                        ],
                        if (p.portfolio.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          Text(
                            'Portfolio',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 120,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: p.portfolio.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 10),
                              itemBuilder: (ctx, i) {
                                final item = p.portfolio[i];
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: AspectRatio(
                                    aspectRatio: 1.2,
                                    child: item.imageUrl.isNotEmpty
                                        ? Image.network(
                                            item.imageUrl,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) =>
                                                _portfolioPlaceholder(item.title),
                                          )
                                        : _portfolioPlaceholder(item.title),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                        if (p.recentReviews != null &&
                            p.recentReviews!.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          Text(
                            'Reviews',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...p.recentReviews!.map(
                            (rev) => Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          rev.reviewerDisplayName,
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const Spacer(),
                                        ...List.generate(
                                          5,
                                          (i) => Icon(
                                            i < rev.rating
                                                ? Icons.star
                                                : Icons.star_border,
                                            size: 16,
                                            color: Colors.amber.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      rev.comment,
                                      style: GoogleFonts.poppins(fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: FilledButton.icon(
            onPressed: p.isAvailable ? _book : null,
            icon: const Icon(Icons.send_outlined),
            label: Text(
              p.isAvailable ? 'Request this provider' : 'Unavailable right now',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF0D9488),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _portfolioPlaceholder(String title) {
    return Container(
      color: Colors.grey.shade200,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(fontSize: 12),
      ),
    );
  }
}

class _VerificationRow extends StatelessWidget {
  final ServiceGigProvider provider;

  const _VerificationRow({required this.provider});

  @override
  Widget build(BuildContext context) {
    final chips = <Widget>[];
    if (provider.isVerified) {
      chips.add(_chip(Icons.verified, 'Verified', Colors.blue.shade700));
    }
    if (provider.isBackgroundChecked) {
      chips.add(_chip(Icons.gpp_good_outlined, 'Background checked', Colors.teal.shade800));
    }
    if (provider.verificationBadge != null &&
        provider.verificationBadge!.isNotEmpty) {
      chips.add(_chip(Icons.military_tech_outlined, provider.verificationBadge!, Colors.purple.shade800));
    }
    for (final b in provider.badges) {
      if (b.isNotEmpty) {
        chips.add(_chip(Icons.workspace_premium_outlined, b, Colors.amber.shade900));
      }
    }
    if (chips.isEmpty) {
      return Text(
        'Standard provider profile',
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: Colors.grey.shade600,
        ),
      );
    }
    return Wrap(spacing: 8, runSpacing: 8, children: chips);
  }

  Widget _chip(IconData icon, String label, Color color) {
    return Chip(
      avatar: Icon(icon, size: 18, color: color),
      label: Text(label, style: GoogleFonts.poppins(fontSize: 12)),
      backgroundColor: color.withValues(alpha: 0.08),
      side: BorderSide(color: color.withValues(alpha: 0.35)),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final ServiceGigProvider provider;

  const _StatsRow({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _stat(Icons.star, '${provider.averageRating.toStringAsFixed(1)} ★'),
        const SizedBox(width: 16),
        _stat(Icons.reviews_outlined, '${provider.totalReviews} reviews'),
        const SizedBox(width: 16),
        _stat(Icons.task_alt, '${provider.completedJobs} jobs'),
      ],
    );
  }

  Widget _stat(IconData icon, String text) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: const Color(0xFF0D9488)),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
