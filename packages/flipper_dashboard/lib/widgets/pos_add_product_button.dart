import 'dart:async';

import 'package:flipper_dashboard/AddProductDialog.dart';
import 'package:flipper_dashboard/BulkAddProduct.dart';
import 'package:flipper_dashboard/features/product_entry/product_entry_navigation.dart';
import 'package:flipper_dashboard/popup_modal.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_models/helperModels/extensions.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_ui/dialogs/AdminPinDialog.dart';

/// Opens add-product flow (single / bulk). Shown beside catalog search on POS.
class PosAddProductButton extends ConsumerWidget {
  const PosAddProductButton({super.key});

  static Future<void> open(BuildContext context, WidgetRef ref) async {
    final settingsService = ProxyService.settings;
    if (settingsService.isAdminPinEnabled) {
      final setting = await settingsService.settings();
      final confirmed = await showAdminPinDialog(
        context: context,
        mode: AdminPinMode.verify,
        expectedPin: setting?.adminPin,
      );
      if (confirmed != true || !context.mounted) return;
    }

    final rootContext = context;
    showDialog<void>(
      barrierDismissible: true,
      context: rootContext,
      builder: (dialogContext) => AddProductDialog(
        onChoiceSelected: (choice) {
          if (choice == 'bulk') {
            showDialog<void>(
              barrierDismissible: true,
              context: rootContext,
              builder: (context) => OptionModal(child: BulkAddProduct()),
            );
          } else if (choice == 'single') {
            Navigator.of(dialogContext).maybePop();
            openProductEntryScreen(rootContext);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: PosTokens.surface,
      borderRadius: BorderRadius.circular(PosTokens.radiusMd),
      child: InkWell(
        onTap: () => unawaited(open(context, ref)),
        borderRadius: BorderRadius.circular(PosTokens.radiusMd),
        hoverColor: PosTokens.surface2,
        child: Ink(
          width: PosTokens.scanButtonSize,
          height: PosTokens.scanButtonSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(PosTokens.radiusMd),
            border: Border.all(color: PosTokens.line, width: 1.5),
          ),
          child: const Icon(
            FluentIcons.add_24_regular,
            size: 22,
            color: PosTokens.ink2,
          ),
        ),
      ),
    ).eligibleToSeeIfYouAre(ref, [UserType.ADMIN]);
  }
}
