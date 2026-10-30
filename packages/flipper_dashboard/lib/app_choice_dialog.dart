import 'package:flipper_localize/flipper_localize.dart';
import 'dart:async';
import 'dart:ui';

import 'package:flipper_dashboard/books_module_navigation.dart';
import 'package:flipper_dashboard/dashboard_shell.dart';
import 'package:flipper_dashboard/hr_module_entry.dart';
import 'package:flipper_dashboard/widgets/app_launch_overlay.dart';
import 'package:flipper_dashboard/widgets/dashboard_app_access.dart';
import 'package:flipper_design_system/flipper_design_system.dart';
import 'package:flipper_models/providers/active_branch_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_dashboard/widgets/dashboard_quick_access_svgs.dart';

/// Design tokens shared with the sign-in / branch chooser (`.sel-*` handoff), so
/// the app switcher reads as the last step of that same flow.
abstract final class AppChoiceTokens {
  static const Color app = Color(0xFFF5F8FD);
  static const Color app2 = Color(0xFFEDF2FB);
  static const Color ink1 = Color(0xFF0B1220);
  static const Color ink2 = Color(0xFF4A5567);
  static const Color ink3 = Color(0xFF7E8AA0);
  static const Color ink4 = Color(0xFFAEB8CA);
  static const Color line = Color(0xFFE6ECF5);
  static const Color lineStrong = Color(0xFFD6DEEA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surface2 = Color(0xFFF7F9FE);
  static const Color blue = Color(0xFF2563EB);
  static const Color blueTint = Color(0xFFEAF1FE);
  static const Color scrim = Color(0xFF0B1220);
}

/// Opens [appId] when it is an app with its own route (Books, HR) rather than
/// a tab of the dashboard shell, and says whether it did. Navigator-only, so
/// it works after the chooser has popped or the login flow cleared the stack.
bool openStandaloneApp(NavigatorState navigator, String? appId) {
  switch (appId) {
    case 'Books':
      unawaited(openBooksModuleOn(navigator));
      return true;
    case 'HR':
      unawaited(openHrModuleOn(navigator));
      return true;
  }
  return false;
}

/// Optional payload for [AppChoiceDialog], passed as `data` to
/// `DialogService.showCustomDialog`.
class AppChoiceDialogRequest {
  const AppChoiceDialogRequest({
    this.awaitsExternalNavigation = false,
    this.businessName,
    this.branchName,
  });

  /// `true` when the caller navigates *after* the dialog closes (the login
  /// flow). The chooser then leaves the launch curtain up and hands dismissal
  /// to that caller via [AppLaunchOverlay.dismiss].
  final bool awaitsExternalNavigation;

  /// Context shown under the title. Falls back to [activeBranchProvider] for the
  /// branch; the business chip is omitted when the caller does not know it.
  final String? businessName;
  final String? branchName;
}

/// Presents [AppChoiceDialog] through [DialogService] with the chrome the
/// redesign needs: no framework barrier or route transition — the dialog paints
/// its own blurred scrim and owns both its entrance and its exit, so a cancel
/// always resolves through the completer instead of a bare barrier pop.
Future<DialogResponse?> showAppChoiceDialog({
  required DialogService dialogService,
  required dynamic variant,
  String? title,
  AppChoiceDialogRequest request = const AppChoiceDialogRequest(),
}) {
  return dialogService.showCustomDialog<dynamic, AppChoiceDialogRequest>(
    variant: variant,
    title: title,
    data: request,
    barrierColor: Colors.transparent,
    barrierDismissible: false,
    useSafeArea: false,
    transitionBuilder: (context, animation, secondaryAnimation, child) => child,
  );
}

class AppChoiceDialog extends StatefulHookConsumerWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const AppChoiceDialog({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  ConsumerState<AppChoiceDialog> createState() => _AppChoiceDialogState();
}

class _AppChoiceDialogState extends ConsumerState<AppChoiceDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrance = AnimationController(
    duration: const Duration(milliseconds: 380),
    vsync: this,
  );

  final FocusNode _keyboardFocus = FocusNode(debugLabel: 'appChoiceKeyboard');

  /// Highlighted tile for keyboard navigation; also tracks pointer hover so the
  /// two never disagree.
  int _cursor = 0;

  /// Set once the user moves the cursor (keys or pointer). Until then the
  /// cursor follows the stored default, which may only appear once HR access
  /// has loaded.
  bool _cursorMoved = false;
  int _columns = 4;
  bool _isLaunching = false;
  bool _isClosing = false;
  String? _launchingId;

  AppChoiceDialogRequest get _payload {
    final data = widget.request.data;
    return data is AppChoiceDialogRequest
        ? data
        : const AppChoiceDialogRequest();
  }

  // Only POS, Books and HR are apps: inventory, reports, orders, customers and
  // settings all live inside POS, so they are not offered here.
  //
  // Labels come from [FlipperL10n.current] rather than the context, matching
  // the rest of the dialog. It is rebuilt each time it opens, so it always
  // uses the active language.
  late final List<_AppChoice> _allApps = [
    _AppChoice(
      id: 'POS',
      title: 'POS',
      subtitle: FlipperL10n.current.appChoicePosSubtitle,
      iconSvg: DashboardQuickAccessSvgs.appSwitcherPosIcon(),
      accent: const Color(0xFF185FA5),
      page: DashboardPage.inventory,
    ),
    _AppChoice(
      id: 'Books',
      title: FlipperL10n.current.appChoiceBooks,
      subtitle: FlipperL10n.current.appChoiceBooksSubtitle,
      iconSvg: DashboardQuickAccessSvgs.appSwitcherBooksIcon(),
      accent: const Color(0xFF2563EB),
    ),
    _AppChoice(
      id: 'HR',
      title: FlipperL10n.current.hrAndPayroll,
      subtitle: FlipperL10n.current.appChoiceHrSubtitle,
      iconSvg: DashboardQuickAccessSvgs.appSwitcherHrIcon(),
      accent: const Color(0xFF0F766E),
    ),
  ];

  /// The [_allApps] this user may open, as of the last build. Recomputed every
  /// build because HR access can resolve after the first frame.
  List<_AppChoice> _apps = const [];

  @override
  void initState() {
    super.initState();
    _entrance.forward();
  }

  /// Maps a stored `defaultApp` onto one of [_apps]. Older builds offered
  /// Inventory, Reports, Orders, Customers and Settings as apps; those are all
  /// inside POS now, so they read as POS, as does HR for someone who may not
  /// open it. The stored value is left alone: [layout.dart] still opens their
  /// old tab.
  String? _normalizedDefault(String? stored) {
    if (stored == null) return null;
    return _apps.any((a) => a.id == stored) ? stored : 'POS';
  }

  @override
  void dispose() {
    _entrance.dispose();
    _keyboardFocus.dispose();
    super.dispose();
  }

  /// Branch label as of the last build. Cached because [_select] needs it after
  /// the pop, where `ref.watch` is no longer legal.
  String? _branchName;

  /// Resolves the branch label; only valid inside `build` (it may watch).
  String? _watchBranchName() {
    final fromRequest = _payload.branchName?.trim();
    if (fromRequest != null && fromRequest.isNotEmpty) return fromRequest;
    final resolved = ref
        .watch(activeBranchProvider)
        .maybeWhen(data: (branch) => branch.name?.trim(), orElse: () => null);
    return (resolved != null && resolved.isNotEmpty) ? resolved : null;
  }

  String? get _businessName {
    final name = _payload.businessName?.trim();
    return (name != null && name.isNotEmpty) ? name : null;
  }

  /// Plays the entrance in reverse before completing, so dismissing does not
  /// snap (the route itself has no transition of its own).
  Future<void> _close() async {
    if (_isLaunching || _isClosing) return;
    _isClosing = true;
    try {
      await _entrance.reverse();
    } on TickerCanceled {
      // Disposed mid-reverse — the completer below is all that still matters.
    }
    widget.completer(DialogResponse(confirmed: false));
  }

  Future<void> _select(_AppChoice choice) async {
    if (_isLaunching) return;
    setState(() {
      _isLaunching = true;
      _launchingId = choice.id;
    });

    // Everything the hand-off needs, captured before the route pops and this
    // State (and its `ref`) goes away.
    final navigator = Navigator.of(context, rootNavigator: true);
    final awaitsExternalNavigation = _payload.awaitsExternalNavigation;
    final contextLabel = _branchName;

    await ProxyService.box.writeString(key: 'defaultApp', value: choice.id);
    if (choice.page != null) {
      ref.read(selectedPageProvider.notifier).state = choice.page!;
    }

    await AppLaunchOverlay.show(
      navigator: navigator,
      appLabel: choice.title,
      accent: choice.accent,
      iconSvg: choice.iconSvg,
      contextLabel: contextLabel,
    );

    widget.completer(
      DialogResponse(confirmed: true, data: {'defaultApp': choice.id}),
    );

    // The login flow finishes authentication and navigates itself; it dismisses
    // the curtain when the destination is up. Everything else navigates here.
    if (awaitsExternalNavigation) return;

    // Navigator-only entry points: this State is deactivated by the pop above,
    // so nothing here may touch `context` or `ref`.
    var settle = AppLaunchOverlay.routeSettle;
    if (!openStandaloneApp(navigator, choice.id)) {
      // A shell tab: already swapped by the provider write above, so there is no
      // route transition to wait out.
      settle = AppLaunchOverlay.inShellSettle;
    }
    AppLaunchOverlay.dismissWhenSettled(settle: settle);
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    if (_isLaunching) return KeyEventResult.handled;

    final key = event.logicalKey;

    if (key == LogicalKeyboardKey.escape) {
      unawaited(_close());
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter ||
        key == LogicalKeyboardKey.space) {
      unawaited(_select(_apps[_cursor]));
      return KeyEventResult.handled;
    }

    // 1-9 launches directly, the way a launcher should.
    for (var i = 0; i < _apps.length && i < 9; i++) {
      if (key == _digitKeys[i] || key == _numpadKeys[i]) {
        unawaited(_select(_apps[i]));
        return KeyEventResult.handled;
      }
    }

    final delta = switch (key) {
      LogicalKeyboardKey.arrowRight => 1,
      LogicalKeyboardKey.arrowLeft => -1,
      LogicalKeyboardKey.arrowDown => _columns,
      LogicalKeyboardKey.arrowUp => -_columns,
      LogicalKeyboardKey.tab => 1,
      _ => 0,
    };
    if (delta == 0) return KeyEventResult.ignored;

    setState(() {
      _cursorMoved = true;
      _cursor = (_cursor + delta).clamp(0, _apps.length - 1);
    });
    return KeyEventResult.handled;
  }

  static const List<LogicalKeyboardKey> _digitKeys = [
    LogicalKeyboardKey.digit1,
    LogicalKeyboardKey.digit2,
    LogicalKeyboardKey.digit3,
    LogicalKeyboardKey.digit4,
    LogicalKeyboardKey.digit5,
    LogicalKeyboardKey.digit6,
    LogicalKeyboardKey.digit7,
    LogicalKeyboardKey.digit8,
    LogicalKeyboardKey.digit9,
  ];

  static const List<LogicalKeyboardKey> _numpadKeys = [
    LogicalKeyboardKey.numpad1,
    LogicalKeyboardKey.numpad2,
    LogicalKeyboardKey.numpad3,
    LogicalKeyboardKey.numpad4,
    LogicalKeyboardKey.numpad5,
    LogicalKeyboardKey.numpad6,
    LogicalKeyboardKey.numpad7,
    LogicalKeyboardKey.numpad8,
    LogicalKeyboardKey.numpad9,
  ];

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final canOpenHr = dashboardCanOpenHr(ref);
    _apps = [
      for (final app in _allApps)
        if (app.id != 'HR' || canOpenHr) app,
    ];
    final currentDefault = _normalizedDefault(ProxyService.box.getDefaultApp());
    // Start on the current default so Enter repeats the user's last choice.
    if (!_cursorMoved) {
      _cursor = _apps.indexWhere((a) => a.id == currentDefault);
    }
    _cursor = _cursor.clamp(0, _apps.length - 1);
    _branchName = _watchBranchName();

    return Focus(
      focusNode: _keyboardFocus,
      autofocus: true,
      onKeyEvent: _onKey,
      child: AnimatedBuilder(
        animation: _entrance,
        builder: (context, _) {
          final t = reduceMotion
              ? 1.0
              : Curves.easeOutCubic.transform(_entrance.value);

          return Stack(
            fit: StackFit.expand,
            children: [
              _scrim(t),
              Center(
                child: Opacity(
                  opacity: t,
                  child: Transform.translate(
                    offset: Offset(0, 18 * (1 - t)),
                    child: Transform.scale(
                      scale: 0.97 + (0.03 * t),
                      child: _panel(context, currentDefault, reduceMotion),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _scrim(double t) {
    return GestureDetector(
      onTap: () => unawaited(_close()),
      behavior: HitTestBehavior.opaque,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14 * t, sigmaY: 14 * t),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0, -0.4),
              radius: 1.2,
              colors: [
                AppChoiceTokens.scrim.withValues(alpha: 0.60 * t),
                AppChoiceTokens.scrim.withValues(alpha: 0.78 * t),
              ],
            ),
          ),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }

  Widget _panel(
    BuildContext context,
    String? currentDefault,
    bool reduceMotion,
  ) {
    return SafeArea(
      // Sized from the box actually handed to it rather than MediaQuery: the two
      // disagree whenever the dialog is laid out into anything but the raw
      // window, and trusting MediaQuery there clips the footer away.
      child: LayoutBuilder(
        builder: (context, outer) =>
            _sizedPanel(currentDefault, reduceMotion, available: outer.biggest),
      ),
    );
  }

  Widget _sizedPanel(
    String? currentDefault,
    bool reduceMotion, {
    required Size available,
  }) {
    final width = available.width.isFinite ? available.width : 760.0;
    final height = available.height.isFinite ? available.height : 900.0;

    return ConstrainedBox(
      constraints: BoxConstraints(
        // Two cards, or three when HR is offered.
        maxWidth: width < 620
            ? width - 32
            : _apps.length > 2
            ? 680.0
            : 560.0,
        maxHeight: height - 48,
      ),
      child: Material(
        color: AppChoiceTokens.surface,
        borderRadius: BorderRadius.circular(26),
        clipBehavior: Clip.antiAlias,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: AppChoiceTokens.line),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppChoiceTokens.surface, AppChoiceTokens.surface2],
              stops: [0.55, 1],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(26, 22, 26, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(),
                const SizedBox(height: 22),
                Text(
                  context.flipperL10n.appChoiceTitle,
                  style: const TextStyle(
                    color: AppChoiceTokens.ink1,
                    fontSize: 27,
                    fontWeight: FontWeight.w700,
                    height: 1.05,
                    letterSpacing: -0.68,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  context.flipperL10n.appChoiceSubtitle,
                  style: const TextStyle(
                    color: AppChoiceTokens.ink2,
                    fontSize: 15,
                    height: 1.35,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 16),
                _contextRow(),
                const SizedBox(height: 20),
                // Only the grid scrolls: on a short window the keyboard hint and
                // the default chip must stay reachable rather than scroll away.
                Flexible(
                  child: SingleChildScrollView(
                    child: _grid(reduceMotion, currentDefault),
                  ),
                ),
                const SizedBox(height: 18),
                const Divider(height: 1, color: AppChoiceTokens.line),
                const SizedBox(height: 14),
                _footer(currentDefault),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        const FlipperBrandBadge(size: 30),
        const SizedBox(width: 10),
        const Text(
          'Flipper',
          style: TextStyle(
            color: AppChoiceTokens.ink1,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),
        const Spacer(),
        _RoundIconButton(
          icon: Icons.close_rounded,
          onTap: _isLaunching ? null : () => unawaited(_close()),
          tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
        ),
      ],
    );
  }

  Widget _contextRow() {
    final business = _businessName;
    final branch = _branchName;
    if (business == null && branch == null) return const SizedBox.shrink();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (business != null)
          _ContextPill(icon: Icons.storefront_outlined, label: business),
        if (branch != null)
          _ContextPill(icon: Icons.location_on_outlined, label: branch),
      ],
    );
  }

  Widget _grid(bool reduceMotion, String? currentDefault) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        // One row of cards where they fit; a lone third card wraps rather than
        // squeezing three into a narrow window.
        final columns = width >= 600
            ? _apps.length.clamp(1, 3)
            : width >= 460
            ? 2
            : 1;
        // Read by the arrow-key handler; assigning during layout is safe here
        // because it never triggers a rebuild on its own.
        _columns = columns;

        return GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            // Fixed extent: tile content varies (badge row) and font metrics
            // differ per platform, so aspect ratio would overflow somewhere.
            mainAxisExtent: 168,
          ),
          itemCount: _apps.length,
          itemBuilder: (context, index) {
            final app = _apps[index];
            final delay = reduceMotion ? 0.0 : (index * 0.055).clamp(0.0, 0.45);
            final reveal = CurvedAnimation(
              parent: _entrance,
              curve: Interval(
                delay,
                (delay + 0.55).clamp(0.0, 1.0),
                curve: Curves.easeOutCubic,
              ),
            );

            return AnimatedBuilder(
              animation: reveal,
              builder: (context, child) => Opacity(
                opacity: reveal.value,
                child: Transform.translate(
                  offset: Offset(0, 12 * (1 - reveal.value)),
                  child: child,
                ),
              ),
              child: _AppChoiceTile(
                app: app,
                shortcut: index < 9 ? '${index + 1}' : null,
                isDefault: app.id == currentDefault,
                isCursor: index == _cursor,
                isLaunching: _launchingId == app.id,
                isDimmed: _isLaunching && _launchingId != app.id,
                onHover: () {
                  if (_isLaunching || _cursor == index) return;
                  setState(() {
                    _cursorMoved = true;
                    _cursor = index;
                  });
                },
                onTap: () => unawaited(_select(app)),
              ),
            );
          },
        );
      },
    );
  }

  Widget _footer(String? currentDefault) {
    final matches = currentDefault == null
        ? const <_AppChoice>[]
        : _apps.where((a) => a.id == currentDefault).toList();
    final current = matches.isEmpty ? null : matches.first.title;

    return Row(
      children: [
        const Icon(
          Icons.keyboard_outlined,
          size: 16,
          color: AppChoiceTokens.ink4,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            context.flipperL10n.appChoiceKeyboardHint,
            style: const TextStyle(
              color: AppChoiceTokens.ink3,
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        if (current != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppChoiceTokens.blueTint,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '${context.flipperL10n.branchesDefaultBadge} · $current',
              style: const TextStyle(
                color: AppChoiceTokens.blue,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }
}

class _AppChoice {
  const _AppChoice({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.iconSvg,
    required this.accent,
    this.page,
  });

  /// Stored as `defaultApp` — must stay stable, [layout.dart] switches on it.
  final String id;
  final String title;
  final String subtitle;
  final String iconSvg;
  final Color accent;

  /// Inner dashboard page, when this app is a tab of the shell.
  final DashboardPage? page;
}

class _AppChoiceTile extends StatefulWidget {
  const _AppChoiceTile({
    required this.app,
    required this.shortcut,
    required this.isDefault,
    required this.isCursor,
    required this.isLaunching,
    required this.isDimmed,
    required this.onHover,
    required this.onTap,
  });

  final _AppChoice app;
  final String? shortcut;
  final bool isDefault;
  final bool isCursor;
  final bool isLaunching;
  final bool isDimmed;
  final VoidCallback onHover;
  final VoidCallback onTap;

  @override
  State<_AppChoiceTile> createState() => _AppChoiceTileState();
}

class _AppChoiceTileState extends State<_AppChoiceTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.isCursor || widget.isLaunching;
    final accent = widget.app.accent;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => widget.onHover(),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: AnimatedOpacity(
          opacity: widget.isDimmed ? 0.45 : 1,
          duration: const Duration(milliseconds: 160),
          child: AnimatedScale(
            scale: _pressed ? 0.985 : 1,
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOut,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              curve: Curves.easeOut,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: active
                    ? Color.alphaBlend(
                        accent.withValues(alpha: 0.05),
                        AppChoiceTokens.surface,
                      )
                    : AppChoiceTokens.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: active
                      ? accent.withValues(alpha: 0.55)
                      : widget.isDefault
                      ? AppChoiceTokens.lineStrong
                      : AppChoiceTokens.line,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: active
                        ? accent.withValues(alpha: 0.16)
                        : const Color(0xFF102040).withValues(alpha: 0.05),
                    blurRadius: active ? 20 : 2,
                    offset: Offset(0, active ? 8 : 1),
                    spreadRadius: active ? -6 : 0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _iconPlate(accent),
                      const Spacer(),
                      // Two-column tiles leave little room beside the plate, and
                      // the DEFAULT pill's width is font-dependent — scale the
                      // trailing slot down rather than overflow it.
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.topRight,
                          child: widget.isLaunching
                              ? SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      accent,
                                    ),
                                  ),
                                )
                              : widget.isDefault
                              ? const _DefaultPill()
                              : widget.shortcut != null
                              ? _ShortcutBadge(
                                  label: widget.shortcut!,
                                  highlighted: widget.isCursor,
                                )
                              : const SizedBox.shrink(),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    widget.app.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppChoiceTokens.ink1,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.16,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    widget.app.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppChoiceTokens.ink3,
                      fontSize: 12.5,
                      height: 1.25,
                      fontWeight: FontWeight.w500,
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

  Widget _iconPlate(Color accent) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: Color.alphaBlend(
          accent.withValues(alpha: widget.isCursor ? 0.16 : 0.10),
          AppChoiceTokens.surface,
        ),
        borderRadius: BorderRadius.circular(13),
      ),
      alignment: Alignment.center,
      child: SvgPicture.string(widget.app.iconSvg, width: 20, height: 20),
    );
  }
}

class _DefaultPill extends StatelessWidget {
  const _DefaultPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppChoiceTokens.blueTint,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        context.flipperL10n.branchesDefaultBadge.toUpperCase(),
        style: const TextStyle(
          color: AppChoiceTokens.blue,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

class _ShortcutBadge extends StatelessWidget {
  const _ShortcutBadge({required this.label, required this.highlighted});

  final String label;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: highlighted
            ? AppChoiceTokens.blueTint
            : AppChoiceTokens.surface2,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: highlighted ? AppChoiceTokens.blue : AppChoiceTokens.line,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: highlighted ? AppChoiceTokens.blue : AppChoiceTokens.ink4,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          height: 1,
        ),
      ),
    );
  }
}

class _ContextPill extends StatelessWidget {
  const _ContextPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 6, 12, 6),
      decoration: BoxDecoration(
        color: AppChoiceTokens.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppChoiceTokens.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(
              color: AppChoiceTokens.blueTint,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 13, color: AppChoiceTokens.blue),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: AppChoiceTokens.ink1,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
    required this.icon,
    required this.onTap,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final button = Material(
      color: AppChoiceTokens.surface,
      shape: const CircleBorder(side: BorderSide(color: AppChoiceTokens.line)),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 38,
          height: 38,
          child: Icon(icon, size: 18, color: AppChoiceTokens.ink2),
        ),
      ),
    );

    return tooltip == null ? button : Tooltip(message: tooltip!, child: button);
  }
}
