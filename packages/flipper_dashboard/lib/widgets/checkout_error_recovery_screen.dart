import 'dart:async';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flipper_dashboard/functions.dart';
import 'package:flipper_dashboard/theme/mpos_tokens.dart';
import 'package:flipper_dashboard/widgets/checkout_error_recovery.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/active_branch_provider.dart';
import 'package:flipper_models/providers/branch_business_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/locator.dart' as loc;
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

/// Branded checkout error / recovery flow (design handoff: checkout_error).
class CheckoutErrorRecoveryScreen extends ConsumerStatefulWidget {
  const CheckoutErrorRecoveryScreen({
    super.key,
    required this.error,
    required this.onRecovered,
    this.onClose,
    this.isExpense = false,
  });

  final Object error;
  final Future<void> Function() onRecovered;
  final VoidCallback? onClose;
  final bool isExpense;

  @override
  ConsumerState<CheckoutErrorRecoveryScreen> createState() =>
      _CheckoutErrorRecoveryScreenState();
}

enum _RecoveryStage { error, loading, ready }

class _CheckoutErrorRecoveryScreenState
    extends ConsumerState<CheckoutErrorRecoveryScreen> {
  static const Color _app = Color(0xFFF5F8FD);
  static const Color _app2 = Color(0xFFEDF2FB);
  static const Color _ink1 = Color(0xFF0B1220);
  static const Color _ink2 = Color(0xFF4A5567);
  static const Color _ink3 = Color(0xFF7E8AA0);
  static const Color _line = Color(0xFFE6ECF5);
  static const Color _lineStrong = Color(0xFFD6DEEA);
  static const Color _blue = Color(0xFF2563EB);

  _RecoveryStage _stage = _RecoveryStage.error;
  bool _sheetOpen = false;
  Branch? _pickedBranch;
  bool _makeDefault = true;
  bool _retrying = false;
  bool _shakeBadge = false;
  bool _showToast = false;
  List<Branch> _branches = [];
  bool _branchesLoading = false;
  Branch? _confirmedBranch;
  Timer? _toastTimer;
  Timer? _shakeTimer;

  CheckoutErrorKind get _kind => checkoutErrorKindFrom(widget.error);

  /// Matches login choices: ~430 phone, ~480 desktop (handoff phone is 412-wide).
  static double _contentMaxWidth(double screenWidth) {
    if (screenWidth >= 900) return 480;
    if (screenWidth >= 600) return 430;
    return screenWidth;
  }

  bool _isWideLayout(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 600;

  Widget _constrainForViewport(Widget child) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = _contentMaxWidth(constraints.maxWidth);
        if (constraints.maxWidth <= 600) {
          return child;
        }
        return Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: maxW,
            child: child,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _toastTimer?.cancel();
    _shakeTimer?.cancel();
    super.dispose();
  }

  /// Same sources as [LoginChoices]: Ditto user_access via [branchesProvider],
  /// with [ProxyService.ditto.getBranches] as a fallback when the provider is empty.
  Future<List<Branch>> _fetchBranchesForBusiness(String businessId) async {
    var list = await ref.read(branchesProvider(businessId: businessId).future);

    if (list.isEmpty) {
      final userId = ProxyService.box.getUserId();
      if (userId != null && ProxyService.ditto.isReady()) {
        final branchesJson = await ProxyService.ditto.getBranches(
          userId,
          businessId,
        );
        list = branchesJson
            .map((j) => Branch.fromMap(Map<String, dynamic>.from(j)))
            .toList();
      }
    }

    return list;
  }

  Future<void> _loadBranches() async {
    setState(() => _branchesLoading = true);
    try {
      final businessId = ProxyService.box.getBusinessId();
      if (businessId == null) {
        setState(() {
          _branches = [];
          _branchesLoading = false;
        });
        return;
      }
      final list = await _fetchBranchesForBusiness(businessId);
      if (!mounted) return;
      setState(() {
        _branches = list;
        _branchesLoading = false;
        final currentId = ProxyService.box.getBranchId();
        if (currentId != null) {
          for (final b in list) {
            if (b.id == currentId) {
              _pickedBranch = b;
              break;
            }
          }
        }
        _pickedBranch ??= list.isNotEmpty ? list.first : null;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _branches = [];
          _branchesLoading = false;
        });
      }
    }
  }

  void _openBranchSheet() {
    HapticFeedback.lightImpact();
    setState(() => _sheetOpen = true);
    if (_branches.isEmpty && !_branchesLoading) {
      unawaited(_loadBranches());
    }
  }

  Future<void> _confirmBranch() async {
    final branch = _pickedBranch;
    if (branch == null) return;
    setState(() {
      _sheetOpen = false;
      _stage = _RecoveryStage.loading;
    });
    try {
      await loc.getIt<AppService>().setDefaultBranch(branch);
      ref.invalidate(activeBranchProvider);
      final businessId = ProxyService.box.getBusinessId();
      if (businessId != null) {
        ref.invalidate(branchesProvider(businessId: businessId));
      }
      ref.invalidate(
        pendingTransactionStreamProvider(isExpense: widget.isExpense),
      );
      await widget.onRecovered();
      if (!mounted) return;
      setState(() {
        _confirmedBranch = branch;
        _stage = _RecoveryStage.ready;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _stage = _RecoveryStage.error);
    }
  }

  bool _deviceHasBranchSelected() {
    try {
      final id = ProxyService.box.getBranchId();
      return id != null && id.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<void> _tryAgain() async {
    if (_retrying) return;
    HapticFeedback.lightImpact();
    setState(() => _retrying = true);
    try {
      await widget.onRecovered();
      if (!mounted) return;
      if (_kind == CheckoutErrorKind.noBranch && !_deviceHasBranchSelected()) {
        _triggerNoBranchToast();
      }
    } finally {
      if (mounted) setState(() => _retrying = false);
    }
  }

  void _triggerNoBranchToast() {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    setState(() {
      _showToast = true;
      if (!reduceMotion) _shakeBadge = true;
    });
    _toastTimer?.cancel();
    _toastTimer = Timer(const Duration(milliseconds: 2600), () {
      if (mounted) setState(() => _showToast = false);
    });
    _shakeTimer?.cancel();
    if (!reduceMotion) {
      _shakeTimer = Timer(const Duration(milliseconds: 500), () {
        if (mounted) setState(() => _shakeBadge = false);
      });
    }
  }

  Future<void> _openCheckout() async {
    HapticFeedback.lightImpact();
    setState(() => _stage = _RecoveryStage.loading);
    try {
      await widget.onRecovered();
    } catch (_) {
      if (mounted) setState(() => _stage = _RecoveryStage.ready);
    }
  }

  Future<void> _openSupport() async {
    final uri = Uri.parse('https://wa.me/250788360058');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _handleClose() {
    if (widget.onClose != null) {
      widget.onClose!();
      return;
    }
    onWillPop(
      context: context,
      navigationPurpose: NavigationPurpose.home,
      message: 'Leave checkout?',
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Semantics(
      container: true,
      liveRegion: true,
      child: Scaffold(
        backgroundColor: _app,
        body: Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.35),
                  radius: 1.2,
                  colors: [_app, _app2],
                ),
              ),
              child: switch (_stage) {
                _RecoveryStage.ready => _constrainForViewport(
                    _buildReadyState(bottomInset),
                  ),
                _ => _constrainForViewport(
                    Column(
                      children: [
                        _buildTopBar(),
                        Expanded(child: _buildErrorBody()),
                        _buildFooter(bottomInset),
                      ],
                    ),
                  ),
              },
            ),
            if (_stage == _RecoveryStage.loading) _buildLoadingOverlay(),
            if (_showToast) _buildToast(bottomInset),
            if (_sheetOpen) _buildBranchSheet(bottomInset),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 12, 0),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Icon(FluentIcons.cart_24_regular, size: 16, color: _ink3),
                  const SizedBox(width: 8),
                  Text(
                    'Checkout',
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _ink2,
                    ),
                  ),
                  Text(
                    ' · Sale',
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _ink3,
                    ),
                  ),
                ],
              ),
            ),
            Material(
              color: Colors.white,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: _handleClose,
                customBorder: const CircleBorder(),
                child: const SizedBox(
                  width: 38,
                  height: 38,
                  child: Icon(Icons.close, size: 18, color: _ink2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorBody() {
    final isNoBranch = _kind == CheckoutErrorKind.noBranch;
    final tint = isNoBranch ? MposTokens.warnTint : MposTokens.lossTint;
    final ink = isNoBranch ? MposTokens.warnAmber : MposTokens.lossInk;
    final eyebrow = isNoBranch ? 'ACTION NEEDED' : 'CHECKOUT UNAVAILABLE';
    final headline = isNoBranch
        ? 'No branch selected yet'
        : 'Couldn\'t load checkout';
    final body = isNoBranch
        ? 'Checkout needs a branch to load products and record the sale. Pick a branch to continue.'
        : 'Something went wrong while opening checkout. Try again or contact support if this keeps happening.';
    final diagnostic = checkoutErrorDiagnosticCode(widget.error);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            transform: Matrix4.translationValues(
              _shakeBadge ? 6 : 0,
              0,
              0,
            ),
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: tint,
                shape: BoxShape.circle,
                border: Border.all(color: ink.withValues(alpha: 0.28)),
              ),
              alignment: Alignment.center,
              child: Icon(
                FluentIcons.building_shop_24_regular,
                size: 42,
                color: ink,
              ),
            ),
          ),
          const SizedBox(height: 22),
          Text(
            eyebrow,
            style: GoogleFonts.outfit(
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.14 * 11.5,
              color: ink,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            headline,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 25,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.025 * 25,
              color: _ink1,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            body,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 15,
              height: 1.5,
              color: _ink2,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(13, 12, 13, 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(MposTokens.radiusMd),
              border: Border.all(color: _line),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0F0B1220),
                  offset: Offset(0, 2),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: tint,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    FluentIcons.info_24_regular,
                    size: 17,
                    color: ink,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'What happened',
                        style: GoogleFonts.outfit(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: _ink1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$diagnostic — ${isNoBranch ? "checkout couldn't resolve a location for this device." : widget.error.toString()}',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 11.5,
                          color: _ink3,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(double bottomInset) {
    final isNoBranch = _kind == CheckoutErrorKind.noBranch;
    return Padding(
      padding: EdgeInsets.fromLTRB(22, 12, 22, 14 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isNoBranch) ...[
            _PrimaryRecoveryButton(
              icon: FluentIcons.building_shop_24_regular,
              title: 'Select a branch',
              subtitle: 'Choose where this sale happens',
              onTap: _openBranchSheet,
            ),
            const SizedBox(height: 11),
          ],
          _SecondaryRetryButton(
            retrying: _retrying,
            onTap: _tryAgain,
          ),
          const SizedBox(height: 11),
          GestureDetector(
            onTap: _openSupport,
            child: Text.rich(
              TextSpan(
                text: 'Still stuck? ',
                style: GoogleFonts.outfit(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: _ink3,
                ),
                children: [
                  TextSpan(
                    text: 'Get help',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w700,
                      color: _blue,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    final branchName = _confirmedBranch?.name ?? _pickedBranch?.name ?? '';
    return ColoredBox(
      color: _app.withValues(alpha: 0.92),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 46,
              height: 46,
              child: CircularProgressIndicator(
                strokeWidth: 4,
                color: _blue,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Loading checkout…',
              style: GoogleFonts.outfit(
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
                color: _ink1,
              ),
            ),
            if (branchName.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                branchName,
                style: GoogleFonts.outfit(fontSize: 13, color: _ink3),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildReadyState(double bottomInset) {
    final name = _confirmedBranch?.name ?? 'Branch';
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: MposTokens.gainTint,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFBFE6CF)),
                    ),
                    child: Icon(
                      FluentIcons.checkmark_24_regular,
                      size: 46,
                      color: MposTokens.gainInk,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Checkout ready',
                    style: GoogleFonts.outfit(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.02 * 24,
                      color: _ink1,
                    ),
                  ),
                  const SizedBox(height: 9),
                  Text(
                    'You\'re all set to take payments. Items and totals will sync to this branch.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 14.5,
                      height: 1.5,
                      color: _ink2,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.fromLTRB(12, 0, 16, 0),
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: _line),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          FluentIcons.building_shop_24_regular,
                          size: 18,
                          color: _blue,
                        ),
                        const SizedBox(width: 9),
                        Text(
                          name,
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: _ink1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(22, 0, 22, 16 + bottomInset),
          child: _PrimaryRecoveryButton(
            icon: FluentIcons.cart_24_regular,
            title: 'Open checkout',
            subtitle: null,
            onTap: _openCheckout,
          ),
        ),
      ],
    );
  }

  Widget _buildToast(double bottomInset) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final maxW = _contentMaxWidth(screenWidth);
    return Positioned(
      left: 16,
      right: 16,
      bottom: 150 + bottomInset,
      child: Align(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxW),
          child: Material(
            color: const Color(0xFF0B1220),
            borderRadius: BorderRadius.circular(MposTokens.radiusMd),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 13, 15, 13),
              child: Row(
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: const BoxDecoration(
                      color: MposTokens.warnAmber,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      FluentIcons.warning_24_regular,
                      size: 15,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Text(
                      'Still no branch selected — pick one to continue.',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
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

  Widget _buildBranchSheet(double bottomInset) {
    final sheetMaxWidth = _isWideLayout(context) ? 480.0 : double.infinity;
    return GestureDetector(
      onTap: () => setState(() => _sheetOpen = false),
      child: ColoredBox(
        color: const Color(0x6B0B1220),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {},
            child: Container(
              width: sheetMaxWidth < double.infinity ? sheetMaxWidth : null,
              constraints: BoxConstraints(
                maxWidth: sheetMaxWidth,
                maxHeight: MediaQuery.sizeOf(context).height * 0.84,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(MposTokens.sheetRadius),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: _lineStrong,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 6),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Select a branch',
                            style: GoogleFonts.outfit(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.02 * 20,
                              color: _ink1,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Where is this sale taking place?',
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              color: _ink3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    child: _branchesLoading
                        ? const Padding(
                            padding: EdgeInsets.all(32),
                            child: CircularProgressIndicator(),
                          )
                        : ListView(
                            shrinkWrap: true,
                            padding: const EdgeInsets.fromLTRB(18, 12, 18, 8),
                            children: [
                              for (final b in _branches)
                                _BranchRow(
                                  branch: b,
                                  selected: _pickedBranch?.id == b.id,
                                  onTap: () =>
                                      setState(() => _pickedBranch = b),
                                ),
                              InkWell(
                                onTap: () =>
                                    setState(() => _makeDefault = !_makeDefault),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    4,
                                    8,
                                    4,
                                    2,
                                  ),
                                  child: Row(
                                    children: [
                                      _CheckboxSquare(on: _makeDefault),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          'Set as default branch for this device',
                                          style: GoogleFonts.outfit(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: _ink2,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      18,
                      8,
                      18,
                      16 + bottomInset,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton(
                        onPressed: _pickedBranch == null ? null : _confirmBranch,
                        style: FilledButton.styleFrom(
                          backgroundColor: _blue,
                          disabledBackgroundColor: _line,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          _pickedBranch == null
                              ? 'Choose a branch'
                              : 'Continue to checkout',
                          style: GoogleFonts.outfit(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
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

class _PrimaryRecoveryButton extends StatelessWidget {
  const _PrimaryRecoveryButton({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          height: 60,
          decoration: BoxDecoration(
            gradient: MposTokens.gradBtn,
            borderRadius: BorderRadius.circular(16),
            boxShadow: MposTokens.shadowBlue,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.outfit(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.01 * 15.5,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.82),
                        ),
                      ),
                  ],
                ),
              ),
              Icon(
                FluentIcons.chevron_right_24_regular,
                color: Colors.white.withValues(alpha: 0.9),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SecondaryRetryButton extends StatelessWidget {
  const _SecondaryRetryButton({
    required this.retrying,
    required this.onTap,
  });

  final bool retrying;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: retrying ? null : onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(color: Color(0xFFD6DEEA), width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (retrying)
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              const Icon(FluentIcons.arrow_sync_24_regular, size: 18),
            const SizedBox(width: 9),
            Text(
              retrying ? 'Checking…' : 'Try again',
              style: GoogleFonts.outfit(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0B1220),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BranchRow extends StatelessWidget {
  const _BranchRow({
    required this.branch,
    required this.selected,
    required this.onTap,
  });

  final Branch branch;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF2563EB);
    const blueTint = Color(0xFFEAF1FE);
    final loc = branch.location?.trim();
    final subtitle = loc != null && loc.isNotEmpty ? loc : 'Branch location';

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: selected ? blueTint : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: selected ? blue : const Color(0xFFE6ECF5),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 14, 15, 14),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: selected ? blue : blueTint,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(
                    FluentIcons.building_shop_24_regular,
                    color: selected ? Colors.white : blue,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              branch.name ?? 'Branch',
                              style: GoogleFonts.outfit(
                                fontSize: 15.5,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF0B1220),
                              ),
                            ),
                          ),
                          if (branch.isDefault == true) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: blueTint,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                'HQ',
                                style: GoogleFonts.outfit(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w800,
                                  color: blue,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            FluentIcons.location_24_regular,
                            size: 13,
                            color: const Color(0xFF7E8AA0),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              subtitle,
                              style: GoogleFonts.outfit(
                                fontSize: 12.5,
                                color: const Color(0xFF7E8AA0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (selected)
                  Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: blue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      FluentIcons.checkmark_24_regular,
                      size: 15,
                      color: Colors.white,
                    ),
                  )
                else
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFD6DEEA),
                        width: 2,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CheckboxSquare extends StatelessWidget {
  const _CheckboxSquare({required this.on});

  final bool on;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: on ? const Color(0xFF2563EB) : Colors.white,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: on ? const Color(0xFF2563EB) : const Color(0xFFD6DEEA),
          width: 1.5,
        ),
      ),
      child: on
          ? const Icon(
              FluentIcons.checkmark_24_regular,
              size: 13,
              color: Colors.white,
            )
          : null,
    );
  }
}
