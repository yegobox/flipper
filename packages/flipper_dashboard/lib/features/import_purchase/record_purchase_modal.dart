import 'package:flipper_dashboard/manual_purchase/manual_purchase_form.dart';
import 'package:flipper_models/providers/outer_variant_provider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/all_models.dart';

import 'import_purchase_helpers.dart';
import 'import_purchase_tokens.dart';

Future<void> showRecordPurchaseModal(BuildContext context, WidgetRef ref) async {
  final branchId = ProxyService.box.getBranchId() ?? '';
  final catalogVariants =
      ref.read(outerVariantsProvider(branchId)).value ?? <Variant>[];

  await showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Record Purchase',
    barrierColor: const Color(0x80141C2E),
    pageBuilder: (dialogContext, _, __) {
      return _RecordPurchaseModal(
        catalogVariants: catalogVariants,
        onClose: () => Navigator.of(dialogContext).pop(),
      );
    },
    transitionBuilder: (context, animation, _, child) {
      final width = MediaQuery.sizeOf(context).width;
      final isSheet = width <= ImportPurchaseTokens.modalSheetBreakpoint;
      final offset = isSheet
          ? Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
          : Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero);
      return SlideTransition(
        position: offset.animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        ),
        child: child,
      );
    },
  );
}

class _RecordPurchaseModal extends StatelessWidget {
  const _RecordPurchaseModal({
    required this.catalogVariants,
    required this.onClose,
  });

  final List<Variant> catalogVariants;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isSheet = width <= ImportPurchaseTokens.modalSheetBreakpoint;
    final padX = isSheet ? 18.0 : 30.0;

    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.escape): const _CloseIntent(),
      },
      child: Actions(
        actions: {
          _CloseIntent: CallbackAction<_CloseIntent>(
            onInvoke: (_) {
              onClose();
              return null;
            },
          ),
        },
        child: Focus(
          autofocus: true,
          child: Material(
            color: Colors.transparent,
            child: Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(onTap: onClose),
                ),
                if (isSheet)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _card(context, isSheet, padX),
                  )
                else
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: _card(context, isSheet, padX),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _card(BuildContext context, bool isSheet, double padX) {
    final width = MediaQuery.sizeOf(context).width;
    return Container(
      width: isSheet ? width : null,
      constraints: BoxConstraints(
        maxWidth: isSheet ? width : 1040,
        maxHeight: isSheet
            ? MediaQuery.sizeOf(context).height * 0.92
            : MediaQuery.sizeOf(context).height - 60,
      ),
      decoration: BoxDecoration(
        color: ImportPurchaseTokens.surface,
        borderRadius: BorderRadius.vertical(
          top: const Radius.circular(20),
          bottom: isSheet ? Radius.zero : const Radius.circular(18),
        ),
        boxShadow: ImportPurchaseTokens.modalShadows,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(padX, 20, padX - 8, 18),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: ImportPurchaseTokens.accentWash,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Icon(
                    Icons.description_outlined,
                    color: ImportPurchaseTokens.accentStrong,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Record Purchase',
                        style: ImportPurchaseHelpers.text(
                          size: 20,
                          weight: FontWeight.w800,
                          letterSpacing: -0.2,
                        ),
                      ),
                      Text(
                        'Capture a supplier invoice and its line items',
                        style: ImportPurchaseHelpers.text(
                          size: 13,
                          weight: FontWeight.w500,
                          color: ImportPurchaseTokens.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onClose,
                  icon: const Icon(Icons.close, size: 20),
                  color: ImportPurchaseTokens.muted,
                ),
              ],
            ),
          ),
          Container(height: 1, color: ImportPurchaseTokens.line),
          Expanded(
            child: ManualPurchaseForm(
              catalogVariants: catalogVariants,
              onClose: onClose,
              useImportPurchaseTheme: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _CloseIntent extends Intent {
  const _CloseIntent();
}
