import 'package:flipper_dashboard/features/tenant/mixins/tenant_management_mixin.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';

class TenantManagement extends StatefulHookConsumerWidget {
  const TenantManagement({Key? key}) : super(key: key);

  @override
  UserManagement createState() => UserManagement();
}

class UserManagement extends ConsumerState<TenantManagement>
    with WidgetsBindingObserver, TenantManagementMixin {
  @override
  void initState() {
    super.initState();
    for (final feature in features) {
      activeFeatures[feature] = false;
      tenantAllowedFeatures[feature] = 'No Access';
    }
    selectedUserType = 'Cashier';
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FlipperBaseModel>.reactive(
      onViewModelReady: (model) async => await model.loadTenants(),
      viewModelBuilder: () => FlipperBaseModel(),
      builder: (context, model, widget) {
        return Scaffold(
          appBar: _UserManagementAppBar(
            onClose: () => routerService.pop(),
            onRefresh: () async => await model.loadTenants(),
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: Container(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  padding: const EdgeInsets.all(20.0),
                  child: constraints.maxWidth > 600
                      ? buildWideLayout(model, context)
                      : buildNarrowLayout(model, context),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

/// App bar aligned with User Management mock: circular outline close, title, overflow menu.
class _UserManagementAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _UserManagementAppBar({
    required this.onClose,
    required this.onRefresh,
  });

  final VoidCallback onClose;
  final Future<void> Function() onRefresh;

  static const _outline = Color(0xFFE5E7EB);
  static const _iconColor = Color(0xFF374151);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: kToolbarHeight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                children: [
                  _CircleOutlineIconButton(
                    icon: Icons.close,
                    onPressed: onClose,
                  ),
                  Expanded(
                    child: Text(
                      'User Management',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF111827),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  PopupMenuButton<String>(
                    padding: EdgeInsets.zero,
                    offset: const Offset(0, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onSelected: (value) async {
                      if (value == 'refresh') await onRefresh();
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem<String>(
                        value: 'refresh',
                        child: Text(
                          'Refresh user list',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: _outline),
                        ),
                        child: const Icon(
                          Icons.more_vert,
                          size: 22,
                          color: _iconColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1, thickness: 1, color: _outline),
        ],
      ),
    );
  }
}

class _CircleOutlineIconButton extends StatelessWidget {
  const _CircleOutlineIconButton({
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: _UserManagementAppBar._outline),
          ),
          child: Icon(
            icon,
            size: 22,
            color: _UserManagementAppBar._iconColor,
          ),
        ),
      ),
    );
  }
}
