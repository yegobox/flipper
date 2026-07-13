import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/bar_mode/providers/bar_mode_providers.dart';
import 'package:flipper_dashboard/features/bar_mode/theme/bar_tokens.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_admin_widgets.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_shared_widgets.dart';
import 'package:flipper_models/sync/utils/bar_mode_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';

class BarMobilePeopleStrip extends StatelessWidget {
  const BarMobilePeopleStrip({
    super.key,
    required this.staff,
    required this.selected,
    required this.onSelect,
  });

  final List<Tenant> staff;
  final Tenant? selected;
  final ValueChanged<Tenant> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 88,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: staff.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, i) {
          final person = staff[i];
          final isOn = selected?.id == person.id;
          final color = barColorForTenant(person.id, staff);
          final firstName = barFirstName(person.name) ?? person.name ?? 'Staff';

          return GestureDetector(
            onTap: () => onSelect(person),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: BarTokens.mobilePersonAvatarSize,
                      height: BarTokens.mobilePersonAvatarSize,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isOn ? BarTokens.blue : Colors.transparent,
                          width: 2.5,
                        ),
                        boxShadow: isOn
                            ? [
                                BoxShadow(
                                  color: BarTokens.blue.withValues(alpha: 0.2),
                                  blurRadius: 8,
                                ),
                              ]
                            : null,
                      ),
                      child: Text(
                        barTenantInitials(person.name),
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    if (barTenantIsManager(person))
                      const Positioned(
                        right: -2,
                        bottom: -2,
                        child: BarManagerTag(),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: 64,
                  child: Text(
                    firstName,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 11.5,
                      fontWeight: isOn ? FontWeight.w700 : FontWeight.w600,
                      color: isOn ? BarTokens.ink1 : BarTokens.ink3,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
