import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/bar_mode/providers/bar_mode_providers.dart';
import 'package:flipper_dashboard/features/bar_mode/theme/bar_tokens.dart';
import 'package:flipper_models/sync/utils/bar_mode_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';

/// Section eyebrow — `.bar-admin-eyebrow` (+ `.violet` / `.amber`).
class BarAdminEyebrow extends StatelessWidget {
  const BarAdminEyebrow({
    super.key,
    required this.label,
    this.accent = BarTokens.blue,
  });

  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 17,
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            label.toUpperCase(),
            style: GoogleFonts.outfit(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.56,
              color: BarTokens.ink2,
            ),
          ),
        ],
      ),
    );
  }
}

/// Pure-CSS switch — `.bar-toggle` / `.bar-toggle.sm`.
class BarToggle extends StatelessWidget {
  const BarToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.small = false,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final w = small ? 46.0 : 58.0;
    final h = small ? 26.0 : 32.0;
    final knob = small ? 20.0 : 26.0;

    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: value ? BarTokens.blue : BarTokens.lineStrong,
          borderRadius: BorderRadius.circular(999),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: knob,
            height: knob,
            margin: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// `.bar-card` surface.
class BarCard extends StatelessWidget {
  const BarCard({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: BarTokens.surface,
        borderRadius: BorderRadius.circular(BarTokens.radiusLg),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D102040),
            offset: Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: child,
    );
  }
}

/// `.bar-subrow` for settings rows.
class BarSubRow extends StatelessWidget {
  const BarSubRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.showTopBorder = true,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool showTopBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        border: showTopBorder
            ? const Border(top: BorderSide(color: BarTokens.line))
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: BarTokens.surface2,
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: BarTokens.line),
            ),
            child: Icon(icon, size: 18, color: BarTokens.ink2),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: BarTokens.ink1,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  subtitle,
                  style: GoogleFonts.outfit(
                    fontSize: 12.5,
                    color: BarTokens.ink3,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          BarToggle(small: true, value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

/// `.bar-mgr-tag` pill — uppercase on admin roster, title case on lock screen.
class BarManagerTag extends StatelessWidget {
  const BarManagerTag({super.key, this.uppercase = false});

  final bool uppercase;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: BarTokens.violetTint,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        uppercase ? 'MANAGER' : 'Manager',
        style: GoogleFonts.outfit(
          fontSize: 9.5,
          fontWeight: FontWeight.w800,
          letterSpacing: uppercase ? 0.4 : 0.38,
          color: BarTokens.violet,
        ),
      ),
    );
  }
}

class BarStaffRow extends StatelessWidget {
  const BarStaffRow({
    super.key,
    required this.tenant,
    required this.color,
    required this.onEdit,
    this.onDelete,
    this.isDeleteLoading = false,
    this.showTopBorder = true,
  });

  final Tenant tenant;
  final Color color;
  final VoidCallback onEdit;
  final VoidCallback? onDelete;
  final bool isDeleteLoading;
  final bool showTopBorder;

  static String roleLabel(Tenant tenant) {
    if (barTenantIsManager(tenant)) return 'Manager';
    final raw = tenant.type?.trim();
    if (raw == null || raw.isEmpty) return 'Server';
    return raw[0].toUpperCase() + raw.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final isManager = barTenantIsManager(tenant);
    final role = roleLabel(tenant);
    final hasPin =
        (tenant.userId != null && tenant.userId!.trim().isNotEmpty) ||
        isUsableStaffPin(tenant.pin);
    final pinPart = hasPin ? 'PIN ••••' : 'PIN —';
    final permPart = isManager ? 'can settle bills' : 'logs orders';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        border: showTopBorder
            ? const Border(top: BorderSide(color: BarTokens.line))
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Text(
              barTenantInitials(tenant.name),
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        tenant.name ?? 'Staff',
                        style: GoogleFonts.outfit(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: BarTokens.ink1,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isManager) ...[
                      const SizedBox(width: 8),
                      const BarManagerTag(uppercase: true),
                    ],
                  ],
                ),
                const SizedBox(height: 1),
                Text(
                  '$role · $pinPart · $permPart',
                  style: GoogleFonts.outfit(
                    fontSize: 12.5,
                    color: BarTokens.ink3,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (onDelete != null) ...[
            BarDeleteButton(
              onPressed: isDeleteLoading ? null : onDelete,
              isLoading: isDeleteLoading,
            ),
            const SizedBox(width: 8),
          ],
          BarEditButton(onPressed: onEdit),
        ],
      ),
    );
  }
}

/// Danger action — trash icon, matches [BarEditButton] footprint.
class BarDeleteButton extends StatelessWidget {
  const BarDeleteButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: BarTokens.surface2,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: BarTokens.line),
          ),
          alignment: Alignment.center,
          child: isLoading
              ? const SizedBox(
                  width: 17,
                  height: 17,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: BarTokens.lossInk,
                  ),
                )
              : const Icon(
                  Icons.delete_outline,
                  size: 17,
                  color: BarTokens.lossInk,
                ),
        ),
      ),
    );
  }
}

/// `.pos-backbtn` — cog + Edit.
class BarEditButton extends StatelessWidget {
  const BarEditButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: BarTokens.surface2,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: BarTokens.line),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.settings_outlined, size: 15),
              const SizedBox(width: 8),
              Text(
                'Edit',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: BarTokens.ink1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BarGhostButton extends StatelessWidget {
  const BarGhostButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: BarTokens.surface,
      borderRadius: BorderRadius.circular(BarTokens.radiusMd),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(BarTokens.radiusMd),
        child: Container(
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(BarTokens.radiusMd),
            border: Border.all(color: BarTokens.lineStrong, width: 1.5),
            boxShadow: BarTokens.shadow1,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              color: BarTokens.ink1,
            ),
          ),
        ),
      ),
    );
  }
}

class BarPrimaryButton extends StatelessWidget {
  const BarPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon = Icons.north_east,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(BarTokens.radiusMd),
        child: Ink(
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(BarTokens.radiusMd),
            gradient: enabled ? BarTokens.gradBtn : null,
            color: enabled ? null : BarTokens.line,
            boxShadow: enabled ? BarTokens.shadow2 : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: enabled ? Colors.white : BarTokens.ink4),
              const SizedBox(width: 9),
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: enabled ? Colors.white : BarTokens.ink4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
