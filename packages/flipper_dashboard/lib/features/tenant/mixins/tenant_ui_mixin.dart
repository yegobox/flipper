import 'package:flipper_dashboard/features/tickets/widgets/tickets_list.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/branch_business_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const Color _kUserMgmtAccent = Color(0xff006AFE);

class TenantUIMixin {
  static Widget buildTenantsListStatic(
    BuildContext context,
    FlipperBaseModel model,
    Widget Function(Tenant, FlipperBaseModel) buildTenantCard,
    String searchQuery,
    void Function(String) onSearchChanged,
  ) {
    final q = searchQuery.trim().toLowerCase();
    final filtered = model.tenants.where((t) {
      if (q.isEmpty) return true;
      final name = (t.name ?? '').toLowerCase();
      final email = (t.email ?? '').toLowerCase();
      final phone = (t.phoneNumber ?? '').toLowerCase();
      return name.contains(q) || email.contains(q) || phone.contains(q);
    }).toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  'CURRENT USERS',
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${model.tenants.length}',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            TicketSearchBar(
              hintText: 'Search users...',
              onChanged: onSearchChanged,
            ),
            const SizedBox(height: 16),
            if (filtered.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  q.isEmpty ? 'No users yet.' : 'No users match your search.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) =>
                    buildTenantCard(filtered[index], model),
              ),
          ],
        ),
      ),
    );
  }

  static String _tenantInitials(Tenant tenant) {
    final name = (tenant.name ?? '').trim();
    if (name.isEmpty) return '?';
    final parts = name.split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    if (parts.length >= 2) {
      final a = parts[0].isNotEmpty ? parts[0][0] : '';
      final b = parts[1].isNotEmpty ? parts[1][0] : '';
      return ('$a$b').toUpperCase();
    }
    final single = parts[0];
    if (single.length >= 2) return single.substring(0, 2).toUpperCase();
    return single[0].toUpperCase();
  }

  static Color _roleBadgeColor(String? type) {
    switch ((type ?? '').toLowerCase()) {
      case 'admin':
        return const Color(0xFF1565C0);
      case 'agent':
        return const Color(0xFF6B4EA2);
      case 'cashier':
        return const Color(0xFF0D9488);
      case 'driver':
        return const Color(0xFF5D4037);
      case 'viewer':
        return const Color(0xFF2E7D32);
      default:
        return Colors.grey[700]!;
    }
  }

  static Widget _roleChip(String? type) {
    final label = (type?.trim().isNotEmpty == true) ? type!.trim() : 'User';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _roleBadgeColor(type).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _roleBadgeColor(type).withValues(alpha: 0.35)),
      ),
      child: Text(
        label,
        style: GoogleFonts.outfit(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: _roleBadgeColor(type),
        ),
      ),
    );
  }

  static Widget _squareIconButton({
    required IconData icon,
    required Color iconColor,
    required VoidCallback? onPressed,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 20, color: iconColor),
        ),
      ),
    );
  }

  static Widget buildTenantCardStatic(
    BuildContext context,
    Tenant tenant,
    FlipperBaseModel model,
    bool isSelected,
    Future<void> Function(Tenant) onTenantSelected,
    void Function(BuildContext, Tenant, FlipperBaseModel) showDeleteConfirmation,
  ) {
    final currentUser = tenant.userId == ProxyService.box.getUserId();
    final subtitle =
        tenant.email?.trim().isNotEmpty == true
            ? tenant.email!
            : (tenant.phoneNumber ?? 'No contact');

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onTenantSelected(tenant),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? _kUserMgmtAccent : Colors.grey[300]!,
              width: isSelected ? 1.8 : 1,
            ),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: _kUserMgmtAccent.withValues(alpha: 0.12),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: _kUserMgmtAccent,
                child: Text(
                  _tenantInitials(tenant),
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tenant.name ?? '—',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _roleChip(tenant.type),
              const SizedBox(width: 8),
              _squareIconButton(
                icon: Icons.edit_outlined,
                iconColor: _kUserMgmtAccent,
                onPressed: () => onTenantSelected(tenant),
              ),
              const SizedBox(width: 6),
              if (!currentUser)
                _squareIconButton(
                  icon: Icons.delete_outline,
                  iconColor: Colors.red[600]!,
                  onPressed: () => showDeleteConfirmation(context, tenant, model),
                ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget buildBranchDropdownStatic(BuildContext context, WidgetRef ref) {
    final asyncBranches = ref.watch(
      branchesProvider(businessId: ProxyService.box.getBusinessId()),
    );
    final selectedBranch = ref.watch(selectedBranchProvider);

    return asyncBranches.when(
      data: (branches) {
        if (branches.isEmpty) {
          return Text("No branches available");
        }

        return DropdownButtonFormField<Branch>(
          initialValue: selectedBranch ?? branches.first,
          onChanged: (Branch? newValue) {
            ref.read(selectedBranchProvider.notifier).state = newValue;
          },
          items: branches.map<DropdownMenuItem<Branch>>((Branch branch) {
            return DropdownMenuItem<Branch>(
              value: branch,
              child: Text(branch.name ?? 'Unnamed Branch'),
            );
          }).toList(),
          decoration: InputDecoration(
            labelText: "Select Branch",
            labelStyle: TextStyle(color: Colors.grey[600]),
            prefixIcon: Icon(
              Icons.business,
              color: Colors.blueAccent,
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5)),
            filled: true,
            fillColor: const Color(0xFFF3F4F6),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        );
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Text('Error: $error'),
    );
  }
}
