import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// A compact widget showing user information in the top bar
class UserInfoWidget extends StatefulHookConsumerWidget {
  const UserInfoWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<UserInfoWidget> createState() => _UserInfoWidgetState();
}

class _UserInfoWidgetState extends ConsumerState<UserInfoWidget> {
  String _userName = 'Loading...';
  String? _branchName;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _loadBranchName();
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

  void _loadBranchName() {
    try {
      final branchId = ProxyService.box.getBranchId();
      if (branchId != null && branchId.toString().isNotEmpty) {
        // Here we could also fetch branch details if needed
        setState(() {
          _branchName = 'Branch';
        });
      }
    } catch (e) {
      // Ignore errors
    }
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // User avatar
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
          // User info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _userName,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              if (_branchName != null)
                Text(
                  _branchName!,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
