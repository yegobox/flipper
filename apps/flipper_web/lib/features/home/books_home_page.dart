import 'package:flipper_web/features/home/sections/books_home_sections.dart';
import 'package:flipper_web/features/home/theme/books_home_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Flipper Books marketing home page (handoff v1).
class BooksHomePage extends ConsumerStatefulWidget {
  const BooksHomePage({super.key});

  @override
  ConsumerState<BooksHomePage> createState() => _BooksHomePageState();
}

class _BooksHomePageState extends ConsumerState<BooksHomePage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _pricingKey = GlobalKey();
  final GlobalKey _suiteKey = GlobalKey();
  final GlobalKey _flowKey = GlobalKey();
  final GlobalKey _capabilitiesKey = GlobalKey();
  bool _headerScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final scrolled = _scrollController.offset > 8;
    if (scrolled != _headerScrolled) {
      setState(() => _headerScrolled = scrolled);
    }
    // VisibilityDetector does not always re-fire inside CustomScrollView on web.
    VisibilityDetectorController.instance.notifyNow();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 700),
        curve: AppCurves.reveal,
      );
    }
  }

  void _onNavTap(String link) {
    switch (link) {
      case 'Pricing':
        _scrollTo(_pricingKey);
      case 'Platform':
      case 'Suite':
        _scrollTo(_suiteKey);
      case 'Flow AI':
      case 'Flow':
        _scrollTo(_flowKey);
      case 'Features':
        _scrollTo(_capabilitiesKey);
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = booksHomeL10n(context);

    return Theme(
      data: BooksHomeTheme.data,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: AppColors.bg,
        ),
        child: Material(
          color: AppColors.bg,
          child: Scaffold(
            backgroundColor: AppColors.bg,
            body: ColoredBox(
              color: AppColors.bg,
              child: CustomScrollView(
                controller: _scrollController,
                physics: const ClampingScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    elevation: 0,
                    scrolledUnderElevation: 0,
                    backgroundColor: Colors.transparent,
                    surfaceTintColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    forceMaterialTransparency: true,
                    toolbarHeight: 76,
                    automaticallyImplyLeading: false,
                    flexibleSpace: BooksHomeHeader(
                      scrolled: _headerScrolled,
                      onStartFree: () => booksHomeGoSignup(context),
                      onSignIn: () => booksHomeGoLogin(context),
                      onNavTap: _onNavTap,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        BooksHomeHero(
                          onStartFree: () => booksHomeGoSignup(context),
                          onSecondary: () => _scrollTo(_suiteKey),
                        ),
                        const BooksHomeTrustStrip(),
                        KeyedSubtree(
                          key: _suiteKey,
                          child: const BooksHomeSuiteSection(),
                        ),
                        KeyedSubtree(
                          key: _flowKey,
                          child: const BooksHomeFlowSection(),
                        ),
                        KeyedSubtree(
                          key: _capabilitiesKey,
                          child: const BooksHomeCapabilitiesSection(),
                        ),
                        BooksHomePricingSection(
                          sectionKey: _pricingKey,
                          onStartFree: () => booksHomeGoSignup(context),
                          l10n: l10n,
                        ),
                        BooksHomeBrandBand(
                          onStartFree: () => booksHomeGoSignup(context),
                          onSignIn: () => booksHomeGoLogin(context),
                        ),
                        const BooksHomeFooter(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
