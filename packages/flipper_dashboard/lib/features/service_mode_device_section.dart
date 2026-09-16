import 'package:flipper_dashboard/features/bar_mode/bar_mode_settings.dart';
import 'package:flipper_dashboard/features/bar_mode/theme/bar_tokens.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_admin_widgets.dart';
import 'package:flipper_dashboard/features/hotel_mode/hotel_mode_settings.dart';
import 'package:flipper_dashboard/features/service_mode_switch.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Picks which surface *this terminal* runs, out of the services the branch
/// offers.
///
/// A property with rooms and a bar runs both at once: the desk terminal on the
/// front desk, the counter terminal on the table floor, the shop till on plain
/// POS. The branch document says which services exist; this choice is local to
/// the device and never synced.
///
/// Hidden entirely while the branch offers neither — there is nothing to pick
/// between, and an admin who has not turned a service mode on should not have
/// to reason about one.
class ServiceModeDeviceSection extends StatefulWidget {
  const ServiceModeDeviceSection({super.key});

  @override
  State<ServiceModeDeviceSection> createState() =>
      _ServiceModeDeviceSectionState();
}

class _ServiceModeDeviceSectionState extends State<ServiceModeDeviceSection> {
  @override
  void initState() {
    super.initState();
    serviceModeRevision.addListener(_onServiceModeChanged);
  }

  @override
  void dispose() {
    serviceModeRevision.removeListener(_onServiceModeChanged);
    super.dispose();
  }

  void _onServiceModeChanged() {
    if (mounted) setState(() {});
  }

  void _pick(ServiceMode mode) {
    setDeviceServiceMode(mode);
    showCustomSnackBarUtil(
      context,
      'This device now runs ${mode.deviceLabel}.',
    );
  }

  void _followBranch() {
    setDeviceServiceMode(null);
    showCustomSnackBarUtil(
      context,
      'This device follows the branch default again '
      '(${activeServiceMode.deviceLabel}).',
    );
  }

  @override
  Widget build(BuildContext context) {
    final hotelEnabled = HotelModeSettings.enabled;
    final barEnabled = BarModeSettings.enabled;
    if (!hotelEnabled && !barEnabled) return const SizedBox.shrink();

    final modes = availableServiceModes(
      hotelEnabled: hotelEnabled,
      barEnabled: barEnabled,
    );
    final active = activeServiceMode;
    final pinned = deviceServiceMode != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 28),
        const BarAdminEyebrow(label: 'This device'),
        BarCard(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What this terminal opens',
                style: GoogleFonts.outfit(
                  fontSize: 16.5,
                  fontWeight: FontWeight.w800,
                  color: BarTokens.ink1,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                hotelEnabled && barEnabled
                    ? 'This branch runs both. Put the front desk on the desk '
                          'terminal and the table floor on the bar counter — '
                          'each device keeps its own choice.'
                    : 'Pick what this screen shows after login. Other devices '
                          'on this branch keep their own choice.',
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                  color: BarTokens.ink3,
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final mode in modes)
                    _ModeChip(
                      label: mode.deviceLabel,
                      icon: _iconFor(mode),
                      selected: mode == active,
                      onTap: () => _pick(mode),
                    ),
                ],
              ),
              if (pinned) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.push_pin_outlined,
                      size: 15,
                      color: BarTokens.ink3,
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        'Pinned on this device only.',
                        style: GoogleFonts.outfit(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: BarTokens.ink3,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _followBranch,
                      style: TextButton.styleFrom(
                        foregroundColor: BarTokens.blue,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        minimumSize: const Size(0, 34),
                      ),
                      child: Text(
                        'Use branch default',
                        style: GoogleFonts.outfit(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  IconData _iconFor(ServiceMode mode) => switch (mode) {
    ServiceMode.pos => Icons.point_of_sale_outlined,
    ServiceMode.bar => Icons.local_bar_outlined,
    ServiceMode.hotel => Icons.hotel_outlined,
  };
}

class _ModeChip extends StatelessWidget {
  const _ModeChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? BarTokens.blueTint : BarTokens.surface,
      borderRadius: BorderRadius.circular(BarTokens.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(BarTokens.radiusMd),
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(BarTokens.radiusMd),
            border: Border.all(
              color: selected ? BarTokens.blue : BarTokens.line,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: selected ? BarTokens.blue : BarTokens.ink3,
              ),
              const SizedBox(width: 9),
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: selected ? BarTokens.blue : BarTokens.ink2,
                ),
              ),
              if (selected) ...[
                const SizedBox(width: 8),
                const Icon(Icons.check, size: 16, color: BarTokens.blue),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
