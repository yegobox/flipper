// ignore_for_file: unused_result

import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/active_branch_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';

class CircleAvatarWidget extends StatelessWidget {
  final String text;
  final double size;
  final Color? backgroundColor;
  final Color? textColor;

  const CircleAvatarWidget({
    Key? key,
    required this.text,
    this.size = 40,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String displayText = text.isEmpty
        ? 'NA'
        : text.length >= 2
            ? text.substring(0, 2).toUpperCase()
            : text;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor ?? Theme.of(context).primaryColorDark,
      ),
      child: Center(
        child: Text(
          displayText,
          style: TextStyle(
            color: textColor ?? Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: size * 0.4,
          ),
        ),
      ),
    );
  }
}

final _adminStatusProvider = FutureProvider.autoDispose((ref) async {
  final userId = ProxyService.box.getUserId() ?? 0;
  return ProxyService.strategy.isAdmin(
    userId: userId,
    appFeature: AppFeature.Settings,
  );
});

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.all(12.0),
          child: SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  final Object error;

  const _ErrorWidget(this.error);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Error: ${error.toString()}',
      child: const CircleAvatarWidget(
        text: "!",
        backgroundColor: Colors.red,
        size: 40,
      ),
    );
  }
}

class _AdminButton extends ConsumerWidget {
  final bool isCompact;

  const _AdminButton({required this.isCompact});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adminStatus = ref.watch(_adminStatusProvider);
    final connectivityStatus = ref.watch(connectivityStreamProvider);

    return adminStatus.when(
      data: (isAdmin) {
        if (!isAdmin) return const SizedBox.shrink();

        final backgroundColor =
            _getStatusColor(connectivityStatus, Theme.of(context));

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: isCompact ? 4.0 : 12.0),
          child: SizedBox(
            height: isCompact ? 32 : 40,
            width: isCompact ? 32 : 40,
            child: IconButton(
              icon: Icon(
                Icons.settings,
                color: Colors.white,
                size: isCompact ? 16 : 20,
              ),
              onPressed: () =>
                  locator<RouterService>().navigateTo(AdminControlRoute()),
              style: IconButton.styleFrom(
                shape: CircleBorder(
                  side: BorderSide(
                    color: backgroundColor,
                    width: isCompact ? 2 : 3,
                  ),
                ),
                backgroundColor: backgroundColor,
                padding: EdgeInsets.zero,
              ),
            ).eligibleToSeeIfYouAre(ref, [UserType.ADMIN]),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _BranchContent extends ConsumerWidget {
  final dynamic branchData;

  const _BranchContent({required this.branchData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityStatus = ref.watch(connectivityStreamProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 100;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isCompact ? 4.0 : 12.0,
                vertical: 4.0,
              ),
              child: CircleAvatarWidget(
                text: branchData?.name ?? "N/A",
                size: isCompact ? 32 : 40,
                backgroundColor:
                    _getStatusColor(connectivityStatus, Theme.of(context)),
              ),
            ),
            if (!isCompact) const SizedBox(height: 16),
            _AdminButton(isCompact: isCompact),
          ],
        );
      },
    );
  }
}

Color _getStatusColor(AsyncValue<bool> connectivityStatus, ThemeData theme) {
  return connectivityStatus.when(
    data: (isReachable) => isReachable ? Colors.green : Colors.red,
    loading: () => theme.colorScheme.primary,
    error: (_, __) => Colors.red,
  );
}

class ActiveBranch extends ConsumerWidget {
  const ActiveBranch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branch = ref.watch(activeBranchProvider);

    return branch.when(
      data: (branchData) => _BranchContent(branchData: branchData),
      loading: () => const _LoadingWidget(),
      error: (error, stackTrace) => _ErrorWidget(error),
    );
  }
}
