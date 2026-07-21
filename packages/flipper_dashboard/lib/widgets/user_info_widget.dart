import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_models/providers/active_branch_provider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// A compact widget showing user information in the top bar
class UserInfoWidget extends StatefulHookConsumerWidget {
  const UserInfoWidget({super.key, this.handoffTopBarStyle = false});

  /// Handoff `.pos-user` chip (POS top bar).
  final bool handoffTopBarStyle;

  @override
  ConsumerState<UserInfoWidget> createState() => _UserInfoWidgetState();
}

class _UserInfoWidgetState extends ConsumerState<UserInfoWidget> {
  String _userName = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final userId = ProxyService.box.getUserId();
    if (userId != null) {
      // Fetch user access from DittoService as requested
      try {
        final userAccess = await ProxyService.ditto.getUserAccess(userId);

        if (userAccess != null && userAccess.containsKey('businesses')) {
          final businesses = userAccess['businesses'] as List;
          if (businesses.isNotEmpty) {
            // As per requirement: business is same name as user
            final business = businesses.first;
            if (business['name'] != null) {
              if (mounted) {
                setState(() {
                  _userName = business['name'];
                });
              }
              return;
            }
          }
        }
      } catch (e) {
        // Fallback to local data if fetching fails
      }
    }

    // Fallback if Ditto fetch fails or no business name found
    if (mounted) {
      setState(() {
        _userName = _AuthenticationFallback();
      });
    }
  }

  String _AuthenticationFallback() {
    // Try to get user ID or phone from ProxyService
    final userId = ProxyService.box.getUserId();
    if (userId != null && userId.isNotEmpty) {
      // If userId looks like an email, format it nicely
      if (userId.contains('@')) {
        final name = userId.split('@').first;
        return _formatName(name);
      }
      // Otherwise use the userId directly (might be a name or ID)
      return userId;
    }

    // Try phone number as fallback
    final phone = ProxyService.box.getUserPhone();
    if (phone != null && phone.isNotEmpty) {
      return phone;
    }

    // Final fallback
    return 'User';
  }

  String _getInitials(String name) {
    name = name.trim();
    if (name.isEmpty) return 'U';

    final parts = name.split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }
    return 'U';
  }

  String _formatName(String emailName) {
    // Convert "john.doe" or "john_doe" to "John Doe"
    final parts = emailName.replaceAll('_', '.').split('.');
    return parts
        .map(
          (part) => part.isEmpty
              ? ''
              : '${part[0].toUpperCase()}${part.substring(1).toLowerCase()}',
        )
        .join(' ');
  }

  String? _activeBranchName() {
    final name = ref.watch(
      activeBranchProvider.select((async) => async.asData?.value.name),
    );
    final trimmed = name?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  }

  Widget _nameColumn({
    required BuildContext context,
    required String displayName,
    required String? branchName,
    required TextStyle nameStyle,
    required TextStyle branchStyle,
  }) {
    // Cap width so long business/branch names ellipsize instead of
    // overflowing the top bar icons.
    final maxTextWidth = (MediaQuery.sizeOf(context).width * 0.18)
        .clamp(96.0, 180.0);

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxTextWidth),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            displayName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            style: nameStyle,
          ),
          if (branchName != null)
            Text(
              branchName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: branchStyle,
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayName = widget.handoffTopBarStyle
        ? _userName.toUpperCase()
        : _userName;
    final branchName = _activeBranchName();

    if (widget.handoffTopBarStyle) {
      return Padding(
        padding: const EdgeInsets.only(left: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 38,
              height: 38,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: PosTokens.gradBrand,
              ),
              child: Text(
                _getInitials(_userName),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 10),
            _nameColumn(
              context: context,
              displayName: displayName,
              branchName: branchName,
              nameStyle: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: PosTokens.ink1,
                height: 1.15,
              ),
              branchStyle: const TextStyle(
                fontSize: 11.5,
                color: PosTokens.ink3,
                height: 1.15,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Theme.of(
              context,
            ).primaryColor.withValues(alpha: 0.1),
            child: Text(
              _getInitials(_userName),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          const SizedBox(width: 8),
          _nameColumn(
            context: context,
            displayName: displayName,
            branchName: branchName,
            nameStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            branchStyle: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
