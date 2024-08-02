import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';

class CircleAvatarWidget extends StatelessWidget {
  final String text;
  final double size;

  const CircleAvatarWidget({
    Key? key,
    required this.text,
    this.size = 40,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String displayText =
        text.length >= 2 ? text.substring(0, 2).toUpperCase() : text;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).primaryColorDark,
      ),
      child: Center(
        child: Text(
          displayText,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: size * 0.4,
          ),
        ),
      ),
    );
  }
}

class TenantWidget extends ConsumerWidget {
  const TenantWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    talker.info("Current BranchId:${ProxyService.box.getBranchId()}");
    talker.info("Current BusinessId:${ProxyService.box.getBusinessId()}");
    talker.info("Current UserId:${ProxyService.box.getUserId()}");
    final tenant = ref.watch(tenantProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: CircleAvatarWidget(
            text: tenant?.name ?? "U",
            size: 40,
          ),
        ),
        const SizedBox(height: 16),
        if (ProxyService.realm
            .isAdmin(userId: ProxyService.box.getUserId() ?? 0))
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: SizedBox(
              height: 40,
              width: 40,
              child: IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  locator<RouterService>().navigateTo(AdminControlRoute());
                },
                style: IconButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
