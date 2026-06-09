import 'package:flipper_design_system/flipper_design_system.dart';
import 'package:flipper_web/models/user_profile.dart';
import 'package:flutter/material.dart';

/// Design tokens from desktop [login_choices.dart] (.sel-*).
abstract final class LoginChoicesTokens {
  static const Color app = Color(0xFFF5F8FD);
  static const Color app2 = Color(0xFFEDF2FB);
  static const Color ink1 = Color(0xFF0B1220);
  static const Color ink2 = Color(0xFF4A5567);
  static const Color ink3 = Color(0xFF7E8AA0);
  static const Color ink4 = Color(0xFFAEB8CA);
  static const Color line = Color(0xFFE6ECF5);
  static const Color lineStrong = Color(0xFFD6DEEA);
  static const Color blue = Color(0xFF2563EB);
  static const Color blueTint = Color(0xFFEAF1FE);
  static const Color violet = Color(0xFF7C3AED);
  static const Color violetTint = Color(0xFFF3EEFB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surface2 = Color(0xFFF7F9FE);
  static const Color signOut = Color(0xFFEF4444);
  static const double desktopContentWidth = 480;
  static const double cardGap = 10;
}

enum LoginChoiceIconTone { blue, violet }

String loginChoiceUserInitial(String? label) {
  if (label == null || label.isEmpty) return 'U';
  for (var i = 0; i < label.length; i++) {
    final c = label[i];
    if (RegExp(r'[A-Za-z]').hasMatch(c)) return c.toUpperCase();
  }
  return 'U';
}

String displayUserName(UserProfile profile, List<Business> businesses) {
  for (final business in businesses) {
    final fullName = business.fullName.trim();
    if (fullName.isNotEmpty) return fullName;
  }
  final phone = profile.phoneNumber.trim();
  if (phone.isNotEmpty) return phone;
  return 'User';
}

String displayUserContact(UserProfile profile, List<Business> businesses) {
  for (final business in businesses) {
    final phone = business.phoneNumber.trim();
    if (phone.isNotEmpty) {
      return phone.startsWith('+') ? phone.substring(1) : phone;
    }
  }
  final phone = profile.phoneNumber.trim();
  if (phone.isEmpty) return '';
  return phone.startsWith('+') ? phone.substring(1) : phone;
}

String businessChoiceSubtitle(Business business, int branchCount, String userId) {
  final role = business.userId == userId ? 'Owner' : 'Member';
  final branchWord = branchCount == 1 ? 'branch' : 'branches';
  return '$role · $branchCount $branchWord';
}

LoginChoiceIconTone iconToneForIndex(int index) {
  return index.isEven ? LoginChoiceIconTone.blue : LoginChoiceIconTone.violet;
}

/// Radial gradient shell matching desktop login choices.
class LoginChoicesBackground extends StatelessWidget {
  final Widget child;

  const LoginChoicesBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, -0.85),
          radius: 1.35,
          colors: [
            LoginChoicesTokens.surface,
            LoginChoicesTokens.app,
            LoginChoicesTokens.app2,
          ],
          stops: [0, 0.46, 1],
        ),
      ),
      child: child,
    );
  }
}

class LoginChoicesBrand extends StatelessWidget {
  const LoginChoicesBrand({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const FlipperBrandBadge(size: 30),
        const SizedBox(width: 10),
        const Text(
          'Flipper',
          style: TextStyle(
            color: LoginChoicesTokens.ink1,
            fontWeight: FontWeight.w700,
            fontSize: 18,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }
}

class LoginChoicesDesktopScaffold extends StatefulWidget {
  final String userInitial;
  final String userName;
  final String userContact;
  final bool isSigningOut;
  final Future<void> Function() onSignOut;
  final Widget child;

  const LoginChoicesDesktopScaffold({
    super.key,
    required this.userInitial,
    required this.userName,
    required this.userContact,
    required this.isSigningOut,
    required this.onSignOut,
    required this.child,
  });

  @override
  State<LoginChoicesDesktopScaffold> createState() =>
      _LoginChoicesDesktopScaffoldState();
}

class _LoginChoicesDesktopScaffoldState
    extends State<LoginChoicesDesktopScaffold> {
  bool _isMenuOpen = false;

  void _toggleMenu() {
    if (widget.isSigningOut) return;
    setState(() => _isMenuOpen = !_isMenuOpen);
  }

  void _closeMenu() {
    if (widget.isSigningOut) return;
    if (_isMenuOpen) setState(() => _isMenuOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    final pillName = widget.userName.trim().split(RegExp(r'\s+')).first;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(48, 20, 48, 0),
              child: Row(
                children: [
                  const LoginChoicesBrand(),
                  const Spacer(),
                  _LoginChoicesUserPill(
                    initial: widget.userInitial,
                    name: pillName,
                    contact: widget.userContact,
                    isOpen: _isMenuOpen,
                    onTap: widget.isSigningOut ? null : _toggleMenu,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: LoginChoicesTokens.desktopContentWidth,
                    ),
                    child: widget.child,
                  ),
                ),
              ),
            ),
          ],
        ),
        if (_isMenuOpen) ...[
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _closeMenu,
            ),
          ),
          Positioned(
            top: 68,
            right: 48,
            child: Material(
              color: Colors.transparent,
              child: _LoginChoicesAccountMenu(
                initial: widget.userInitial,
                name: widget.userName,
                contact: widget.userContact,
                isSigningOut: widget.isSigningOut,
                onSignOut: widget.onSignOut,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _LoginChoicesUserPill extends StatelessWidget {
  final String initial;
  final String name;
  final String contact;
  final bool isOpen;
  final VoidCallback? onTap;

  const _LoginChoicesUserPill({
    required this.initial,
    required this.name,
    required this.contact,
    required this.isOpen,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 320),
          padding: const EdgeInsets.fromLTRB(4, 4, 12, 4),
          decoration: BoxDecoration(
            color: LoginChoicesTokens.surface,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: LoginChoicesTokens.line),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D102040),
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
              BoxShadow(
                color: Color(0x0A102040),
                blurRadius: 1,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _LoginChoicesAvatar(initial: initial, radius: 16),
              const SizedBox(width: 10),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: LoginChoicesTokens.ink1,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                      ),
                    ),
                    if (contact.isNotEmpty) ...[
                      const SizedBox(height: 1),
                      Text(
                        contact,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: LoginChoicesTokens.ink3,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                isOpen
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                color: LoginChoicesTokens.ink3,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginChoicesAccountMenu extends StatelessWidget {
  final String initial;
  final String name;
  final String contact;
  final bool isSigningOut;
  final Future<void> Function() onSignOut;

  const _LoginChoicesAccountMenu({
    required this.initial,
    required this.name,
    required this.contact,
    required this.isSigningOut,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.fromLTRB(16, 16, 8, 12),
      decoration: BoxDecoration(
        color: LoginChoicesTokens.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: LoginChoicesTokens.line),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF102040).withValues(alpha: .14),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _LoginChoicesAvatar(initial: initial, radius: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: LoginChoicesTokens.ink1,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                      ),
                    ),
                    if (contact.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        contact,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: LoginChoicesTokens.ink3,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: LoginChoicesTokens.line),
          _LoginChoicesMenuRow(
            icon: Icons.logout_rounded,
            label: isSigningOut ? 'Signing out…' : 'Sign out',
            color: LoginChoicesTokens.signOut,
            isLoading: isSigningOut,
            onTap: isSigningOut ? null : () => onSignOut(),
          ),
        ],
      ),
    );
  }
}

class _LoginChoicesMenuRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isLoading;
  final VoidCallback? onTap;

  const _LoginChoicesMenuRow({
    required this.icon,
    required this.label,
    this.color = LoginChoicesTokens.ink1,
    this.isLoading = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              if (isLoading)
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: color.withValues(alpha: .78),
                  ),
                )
              else
                Icon(icon, color: color.withValues(alpha: .78), size: 20),
              const SizedBox(width: 14),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginChoicesAvatar extends StatelessWidget {
  final String initial;
  final double radius;

  const _LoginChoicesAvatar({required this.initial, required this.radius});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: LoginChoicesTokens.blue,
      child: Text(
        initial.isEmpty ? 'U' : initial[0].toUpperCase(),
        style: TextStyle(
          color: Colors.white,
          fontSize: radius * .9,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class BusinessChoiceTile extends StatelessWidget {
  final String name;
  final String subtitle;
  final LoginChoiceIconTone iconTone;
  final bool isLoading;
  final VoidCallback onTap;

  const BusinessChoiceTile({
    super.key,
    required this.name,
    required this.subtitle,
    required this.iconTone,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LoginChoiceCard(
      onTap: onTap,
      selected: false,
      child: Row(
        children: [
          LoginChoiceIcon(
            icon: Icons.storefront_outlined,
            tone: iconTone,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: LoginChoicesTokens.ink1,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: LoginChoicesTokens.ink3,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            const Icon(
              Icons.chevron_right_rounded,
              color: LoginChoicesTokens.ink4,
              size: 20,
            ),
        ],
      ),
    );
  }
}

class BranchChoiceTile extends StatelessWidget {
  final String name;
  final String subtitle;
  final bool isDefault;
  final bool isSelected;
  final bool isLoading;
  final VoidCallback onTap;

  const BranchChoiceTile({
    super.key,
    required this.name,
    required this.subtitle,
    required this.isDefault,
    required this.isSelected,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LoginChoiceCard(
      onTap: onTap,
      selected: isSelected,
      child: Row(
        children: [
          LoginChoiceIcon(
            icon: Icons.location_on_outlined,
            selected: isSelected,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: LoginChoicesTokens.ink1,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    if (isDefault)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE7E5FF),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text(
                          'DEFAULT',
                          style: TextStyle(
                            color: Color(0xFF4F46E5),
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: LoginChoicesTokens.ink3,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else if (isSelected)
            const CircleAvatar(
              radius: 20,
              backgroundColor: Color(0xFF4F46E5),
              child: Icon(Icons.check_rounded, color: Colors.white),
            )
          else
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: LoginChoicesTokens.lineStrong, width: 2),
              ),
            ),
        ],
      ),
    );
  }
}

class AddBusinessTile extends StatefulWidget {
  final VoidCallback onTap;

  const AddBusinessTile({super.key, required this.onTap});

  @override
  State<AddBusinessTile> createState() => _AddBusinessTileState();
}

class _AddBusinessTileState extends State<AddBusinessTile> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isActive = _isHovered || _isPressed;
    final foreground =
        isActive ? LoginChoicesTokens.blue : LoginChoicesTokens.ink2;
    final borderColor =
        isActive ? LoginChoicesTokens.blue : LoginChoicesTokens.lineStrong;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() {
        _isHovered = false;
        _isPressed = false;
      }),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapCancel: () => setState(() => _isPressed = false),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isPressed ? .99 : 1,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              color: isActive ? LoginChoicesTokens.blueTint : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: CustomPaint(
              painter: _DashedBorderPainter(
                color: borderColor,
                borderRadius: 14,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add_rounded, size: 18, color: foreground),
                      const SizedBox(width: 8),
                      Text(
                        'Add a business',
                        style: TextStyle(
                          color: foreground,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BranchSelectionTopRow extends StatelessWidget {
  final String businessName;
  final VoidCallback onBack;

  const BranchSelectionTopRow({
    super.key,
    required this.businessName,
    required this.onBack,
  });

  static const double _sideSlot = 44;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _sideSlot,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: _RoundBackButton(onPressed: onBack),
          ),
          Center(child: _BusinessPill(name: businessName)),
          const Align(
            alignment: Alignment.centerRight,
            child: SizedBox(width: _sideSlot, height: _sideSlot),
          ),
        ],
      ),
    );
  }
}

class _BusinessPill extends StatelessWidget {
  final String name;

  const _BusinessPill({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      padding: const EdgeInsets.fromLTRB(8, 0, 14, 0),
      decoration: BoxDecoration(
        color: LoginChoicesTokens.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: LoginChoicesTokens.line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D102040),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: const BoxDecoration(
              color: LoginChoicesTokens.blueTint,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.storefront_outlined,
              color: LoginChoicesTokens.blue,
              size: 15,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            name,
            style: const TextStyle(
              color: LoginChoicesTokens.ink1,
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundBackButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _RoundBackButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onPressed,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: LoginChoicesTokens.surface,
          shape: BoxShape.circle,
          border: Border.all(color: LoginChoicesTokens.line),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D102040),
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: const Icon(
          Icons.chevron_left_rounded,
          color: LoginChoicesTokens.ink2,
          size: 20,
        ),
      ),
    );
  }
}

class LoginChoiceCard extends StatefulWidget {
  final Widget child;
  final bool selected;
  final VoidCallback onTap;

  const LoginChoiceCard({
    super.key,
    required this.child,
    required this.selected,
    required this.onTap,
  });

  @override
  State<LoginChoiceCard> createState() => _LoginChoiceCardState();
}

class _LoginChoiceCardState extends State<LoginChoiceCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final selected = widget.selected;
    final hovered = _isHovered && !selected;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          decoration: BoxDecoration(
            color: selected ? LoginChoicesTokens.blueTint : LoginChoicesTokens.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected
                  ? LoginChoicesTokens.blue
                  : hovered
                  ? LoginChoicesTokens.lineStrong
                  : LoginChoicesTokens.line,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF102040)
                    .withValues(alpha: hovered || selected ? .14 : .05),
                blurRadius: hovered || selected ? 18 : 2,
                offset: Offset(0, hovered || selected ? 6 : 1),
              ),
              if (!hovered && !selected)
                const BoxShadow(
                  color: Color(0x0A102040),
                  blurRadius: 1,
                  offset: Offset(0, 1),
                ),
            ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

class LoginChoiceIcon extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final LoginChoiceIconTone? tone;

  const LoginChoiceIcon({
    super.key,
    required this.icon,
    this.selected = false,
    this.tone,
  });

  @override
  Widget build(BuildContext context) {
    late final Color background;
    late final Color foreground;
    if (selected) {
      background = LoginChoicesTokens.blue;
      foreground = Colors.white;
    } else if (tone == LoginChoiceIconTone.violet) {
      background = LoginChoicesTokens.violetTint;
      foreground = LoginChoicesTokens.violet;
    } else if (tone == LoginChoiceIconTone.blue) {
      background = LoginChoicesTokens.blueTint;
      foreground = LoginChoicesTokens.blue;
    } else {
      background = LoginChoicesTokens.surface2;
      foreground = LoginChoicesTokens.ink3;
    }

    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(13),
        border: selected
            ? null
            : tone == null
            ? Border.all(color: LoginChoicesTokens.line)
            : null,
      ),
      child: Icon(icon, color: foreground, size: 22),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double borderRadius;

  const _DashedBorderPainter({required this.color, required this.borderRadius});

  @override
  void paint(Canvas canvas, Size size) {
    const dash = 6.0;
    const gap = 4.0;
    final rect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(borderRadius),
    ).deflate(.75);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final path = Path()..addRRect(rect);

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = (distance + dash).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.borderRadius != borderRadius;
  }
}
