import 'package:flipper_dashboard/features/services_gigs/models/service_gig_provider.dart';
import 'package:flipper_dashboard/features/services_gigs/services/service_gig_provider_repository.dart';
import 'package:flipper_dashboard/features/services_gigs/widgets/request_service_sheet.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Lists other service providers so a customer can open a profile and request a gig.
class ProviderBrowseScreen extends StatefulWidget {
  const ProviderBrowseScreen({Key? key}) : super(key: key);

  @override
  State<ProviderBrowseScreen> createState() => _ProviderBrowseScreenState();
}

class _ProviderBrowseScreenState extends State<ProviderBrowseScreen> {
  final _repo = ServiceGigProviderRepository();
  final _searchController = TextEditingController();

  List<ServiceGigProvider> _providers = [];
  bool _loading = true;

  /// Selected service label from provider profiles (null = show all).
  String? _selectedService;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _load();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() => setState(() {});

  Future<void> _load() async {
    setState(() => _loading = true);
    final me = ProxyService.box.getUserId();
    final list = await _repo.listProviders(excludeUserId: me);
    if (!mounted) return;
    setState(() {
      _providers = list;
      _loading = false;
      if (_selectedService != null &&
          !_serviceKeywordsFrom(_providers).contains(_selectedService)) {
        _selectedService = null;
      }
    });
  }

  /// Unique service labels across [list], sorted A→Z.
  List<String> _serviceKeywordsFrom(List<ServiceGigProvider> list) {
    final set = <String>{};
    for (final p in list) {
      for (final s in p.services) {
        final t = s.trim();
        if (t.isNotEmpty) set.add(t);
      }
    }
    final out = set.toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return out;
  }

  bool _providerMatchesSearch(ServiceGigProvider p, String q) {
    if (q.isEmpty) return true;
    bool inStr(String? s) =>
        s != null && s.toLowerCase().contains(q);

    if (inStr(p.displayName)) return true;
    if (inStr(p.bio)) return true;
    if (inStr(p.serviceArea)) return true;
    if (inStr(p.phone)) return true;
    for (final s in p.services) {
      if (inStr(s)) return true;
    }
    return false;
  }

  bool _providerMatchesService(ServiceGigProvider p, String? service) {
    if (service == null) return true;
    final want = service.toLowerCase();
    return p.services.any((s) => s.toLowerCase() == want);
  }

  List<ServiceGigProvider> get _filteredProviders {
    final q = _searchController.text.trim().toLowerCase();
    return _providers.where((p) {
      return _providerMatchesSearch(p, q) &&
          _providerMatchesService(p, _selectedService);
    }).toList();
  }

  static String _groupKey(String displayName) {
    if (displayName.isEmpty) return '#';
    final c = displayName[0].toUpperCase();
    final code = c.codeUnitAt(0);
    if (code >= 65 && code <= 90) return c;
    return '#';
  }

  static int _compareGroupKeys(String a, String b) {
    if (a == '#' && b == '#') return 0;
    if (a == '#') return 1;
    if (b == '#') return -1;
    return a.compareTo(b);
  }

  /// Flat list: section header rows + provider rows for [CustomScrollView].
  List<_BrowseListEntry> _buildBrowseEntries(List<ServiceGigProvider> filtered) {
    if (filtered.isEmpty) return [];

    final sorted = [...filtered]..sort(
          (a, b) => a.displayName.toLowerCase().compareTo(
                b.displayName.toLowerCase(),
              ),
        );

    final byGroup = <String, List<ServiceGigProvider>>{};
    for (final p in sorted) {
      final k = _groupKey(p.displayName);
      byGroup.putIfAbsent(k, () => []).add(p);
    }

    final keys = byGroup.keys.toList()..sort(_compareGroupKeys);
    final entries = <_BrowseListEntry>[];
    for (final k in keys) {
      entries.add(_BrowseListEntry.header(k));
      for (final p in byGroup[k]!) {
        entries.add(_BrowseListEntry.provider(p));
      }
    }
    return entries;
  }

  Future<void> _openProvider(ServiceGigProvider p) async {
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
        'Request sent. The provider has 30 minutes to accept. Track and pay under My requests.',
      );
    }
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedService = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'Find a provider',
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
      body: RefreshIndicator(
        onRefresh: _load,
        color: const Color(0xFF0D9488),
        child: _loading
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 120),
                  Center(child: CircularProgressIndicator()),
                ],
              )
            : _providers.isEmpty
                ? _buildEmptyNoProviders()
                : _buildBrowseContent(),
      ),
    );
  }

  Widget _buildEmptyNoProviders() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: [
        Icon(Icons.people_outline, size: 56, color: Colors.grey.shade400),
        const SizedBox(height: 16),
        Text(
          'No providers yet',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'When people offer their services here, you will see them in this list and can send a request.\n\n'
          'Pull down to refresh. If you are registered as a provider yourself, your profile is not shown in this list.',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 14,
            height: 1.4,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildBrowseContent() {
    final filtered = _filteredProviders;
    final serviceKeywords = _serviceKeywordsFrom(_providers);
    final entries = _buildBrowseEntries(filtered);

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  style: GoogleFonts.poppins(fontSize: 15),
                  decoration: InputDecoration(
                    hintText: 'Search name, area, or service…',
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                    prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF0D9488),
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 12,
                    ),
                  ),
                ),
                if (serviceKeywords.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Text(
                    'Browse by service',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: serviceKeywords.length + 1,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, i) {
                        if (i == 0) {
                          final selected = _selectedService == null;
                          return FilterChip(
                            label: Text(
                              'All',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: selected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                              ),
                            ),
                            selected: selected,
                            onSelected: (_) {
                              setState(() => _selectedService = null);
                            },
                            selectedColor:
                                const Color(0xFF0D9488).withValues(alpha: 0.25),
                            checkmarkColor: const Color(0xFF0D9488),
                          );
                        }
                        final label = serviceKeywords[i - 1];
                        final selected = _selectedService == label;
                        return FilterChip(
                          label: Text(
                            label,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: selected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                            ),
                          ),
                          selected: selected,
                          onSelected: (_) {
                            setState(() {
                              _selectedService = selected ? null : label;
                            });
                          },
                          selectedColor:
                              const Color(0xFF0D9488).withValues(alpha: 0.25),
                          checkmarkColor: const Color(0xFF0D9488),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        if (filtered.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 52, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'No matches',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Try different keywords, pick another service, or clear your filters.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      height: 1.4,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton(
                    onPressed: _clearFilters,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF0D9488),
                      side: const BorderSide(color: Color(0xFF0D9488)),
                    ),
                    child: Text(
                      'Clear search & filters',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final e = entries[index];
                  if (e.isHeader) {
                    return Padding(
                      padding: EdgeInsets.only(
                        top: index == 0 ? 4 : 16,
                        bottom: 8,
                      ),
                      child: Text(
                        e.headerLabel!,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F766E),
                          letterSpacing: 0.5,
                        ),
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _ProviderListTile(
                      provider: e.provider!,
                      onTap: () => _openProvider(e.provider!),
                    ),
                  );
                },
                childCount: entries.length,
              ),
            ),
          ),
      ],
    );
  }
}

class _BrowseListEntry {
  final bool isHeader;
  final String? headerLabel;
  final ServiceGigProvider? provider;

  _BrowseListEntry._({
    required this.isHeader,
    this.headerLabel,
    this.provider,
  });

  factory _BrowseListEntry.header(String label) => _BrowseListEntry._(
        isHeader: true,
        headerLabel: label,
      );

  factory _BrowseListEntry.provider(ServiceGigProvider p) =>
      _BrowseListEntry._(isHeader: false, provider: p);
}

class _ProviderListTile extends StatelessWidget {
  final ServiceGigProvider provider;
  final VoidCallback onTap;

  const _ProviderListTile({
    required this.provider,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final p = provider;
    final preview = p.services.take(3).join(' · ');
    final more = p.services.length > 3 ? ' +${p.services.length - 3}' : '';

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor:
                    const Color(0xFF0D9488).withValues(alpha: 0.15),
                child: Text(
                  p.displayName.isNotEmpty
                      ? p.displayName[0].toUpperCase()
                      : '?',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0D9488),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.displayName,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    if (p.serviceArea != null && p.serviceArea!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        p.serviceArea!,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                    const SizedBox(height: 6),
                    Text(
                      '$preview$more',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                        height: 1.3,
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

