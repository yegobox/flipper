// ignore_for_file: unused_result

import 'package:flipper_dashboard/SnackBarMixin.dart';
import 'package:flipper_dashboard/features/incoming_orders/om_tokens.dart';
import 'package:flipper_dashboard/features/incoming_orders/providers/incoming_orders_provider.dart';
import 'package:flipper_dashboard/features/production_output/services/production_output_service.dart';
import 'package:flipper_dashboard/features/production_output/widgets/work_order_bottom_sheet.dart';
import 'package:flipper_dashboard/features/production_output/widgets/work_order_form.dart';
import 'package:flipper_dashboard/stockApprovalMixin.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/providers/orders_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/sms/sms_notification_service.dart';
import 'package:flipper_ui/dialogs/ProduceSelectionDialog.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/all_models.dart' as models;

class ActionRow extends ConsumerWidget
    with StockRequestApprovalLogic, SnackBarMixin {
  final InventoryRequest request;

  const ActionRow({Key? key, required this.request}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFullyApproved = request.status == RequestStatus.approved;
    final isProcessing = request.status == RequestStatus.processing;
    final isPending = request.status == RequestStatus.pending;

    // Approved history / non-actionable: no footer (handoff §6).
    if (isFullyApproved || (!isPending && !isProcessing)) {
      return const SizedBox.shrink();
    }

    final itemsAsync =
        request.transactionItems != null && request.transactionItems!.isNotEmpty
            ? AsyncValue.data(request.transactionItems!)
            : ref.watch(transactionItemsProvider(request.id));

    return itemsAsync.when(
      loading: () => _ActionsBar(
        children: [
          _OmBtn(
            onPressed: null,
            icon: Icons.factory_outlined,
            label: 'Produce',
            variant: _OmBtnVariant.ghost,
          ),
          _OmBtn(
            onPressed: null,
            icon: Icons.check_circle_outline,
            label: 'Approve',
            variant: _OmBtnVariant.greenSoft,
          ),
          _OmBtn(
            onPressed: null,
            icon: Icons.cancel_outlined,
            label: 'Void',
            variant: _OmBtnVariant.voidDisabled,
          ),
        ],
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (items) {
        final hasApprovedItems = items.any(
          (item) => (item.quantityApproved ?? 0) > 0,
        );
        final voidDisabled = hasApprovedItems || isProcessing;
        final approveDisabled = isFullyApproved || isProcessing;

        return _ActionsBar(
          children: [
            _OmBtn(
              onPressed: isProcessing
                  ? () => _handleFinishProduction(context, ref)
                  : () => _handleProduce(context, ref, items),
              icon: isProcessing ? Icons.check : Icons.factory_outlined,
              label: isProcessing ? 'Finish Production' : 'Produce',
              variant: _OmBtnVariant.ghost,
            ),
            _OmBtn(
              onPressed: approveDisabled
                  ? null
                  : () => _handleApproveRequest(context, ref, request),
              icon: Icons.check_circle_outline,
              label: isProcessing ? 'In Production' : 'Approve',
              variant: _OmBtnVariant.greenSoft,
              isDisabled: approveDisabled,
            ),
            _OmBtn(
              onPressed: voidDisabled ? null : () => _voidRequest(context, ref),
              icon: Icons.cancel_outlined,
              label: 'Void',
              variant: voidDisabled
                  ? _OmBtnVariant.voidDisabled
                  : _OmBtnVariant.ghost,
              isDisabled: voidDisabled,
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleApproveRequest(
    BuildContext context,
    WidgetRef ref,
    InventoryRequest request,
  ) async {
    final bool? confirmApprove = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.check_circle_outline,
              color: OmTokens.greenStrong,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              'Approve Request',
              style: OmTokens.text(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to approve all items in this request?',
          style: OmTokens.text(fontSize: 16, color: OmTokens.ink2),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: OmTokens.text(
                color: OmTokens.muted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: OmTokens.greenStrong,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(OmTokens.radiusXs),
              ),
            ),
            child: Text(
              'Approve All',
              style: OmTokens.text(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmApprove == true) {
      try {
        await approveRequest(request: request, context: context);
        final stringValue = ref.read(stringProvider);
        ref.refresh(
          stockRequestsProvider(
            status: RequestStatus.pending,
            search: stringValue?.isNotEmpty == true ? stringValue : null,
          ),
        );
      } catch (_) {}
    }
  }

  void _voidRequest(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(OmTokens.radius),
          ),
          title: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: OmTokens.red,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Void Request',
                style: OmTokens.text(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to void this request?',
                style: OmTokens.text(fontSize: 16, color: OmTokens.ink2),
              ),
              const SizedBox(height: 8),
              Text(
                'This action cannot be undone.',
                style: OmTokens.text(
                  fontSize: 14,
                  color: OmTokens.muted,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: OmTokens.text(
                  color: OmTokens.muted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await ProxyService.strategy.updateStockRequest(
                    stockRequestId: request.id,
                    status: RequestStatus.voided,
                  );

                  await ProxyService.strategy.flipperDelete(
                    id: request.id,
                    endPoint: 'stockRequest',
                  );

                  try {
                    final requesterConfig =
                        await SmsNotificationService.getBranchSmsConfig(
                      request.branch!.id,
                    );
                    if (requesterConfig?.smsPhoneNumber != null) {
                      await SmsNotificationService.sendOrderRequestNotification(
                        receiverBranchId: request.branch!.id,
                        orderDetails:
                            'Your stock request #${request.id.substring(0, 5)} has been declined.',
                        requesterPhone: requesterConfig!.smsPhoneNumber!,
                      );
                    }
                  } catch (smsError) {
                    talker.error('Failed to send SMS notification: $smsError');
                  }

                  final stringValue = ref.read(stringProvider);
                  ref.refresh(
                    stockRequestsProvider(
                      status: RequestStatus.voided,
                      search: stringValue?.isNotEmpty == true
                          ? stringValue
                          : null,
                    ),
                  );
                  Navigator.of(context).pop();
                  showCustomSnackBar(
                    context,
                    'Request voided successfully',
                    type: NotificationType.warning,
                  );
                } catch (e, s) {
                  talker.error(s);
                  showCustomSnackBar(
                    context,
                    'Failed to void request: ${e.toString()}',
                    type: NotificationType.error,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: OmTokens.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(OmTokens.radiusXs),
                ),
              ),
              child: Text(
                'Void Request',
                style: OmTokens.text(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleFinishProduction(
    BuildContext context,
    WidgetRef ref,
  ) async {
    try {
      await ProxyService.strategy.updateStockRequest(
        stockRequestId: request.id,
        status: RequestStatus.pending,
      );

      final stringValue = ref.read(stringProvider);
      final search = stringValue?.isNotEmpty == true ? stringValue : null;
      ref.refresh(
        stockRequestsProvider(
          status: RequestStatus.processing,
          search: search,
        ),
      );
      ref.refresh(
        stockRequestsProvider(status: RequestStatus.pending, search: search),
      );

      showCustomSnackBar(
        context,
        'Production marked as finished. Ready for approval.',
        type: NotificationType.success,
      );
    } catch (e) {
      talker.error('Error finishing production: $e');
      showCustomSnackBar(
        context,
        'Failed to finish production',
        type: NotificationType.error,
      );
    }
  }

  Future<void> _handleProduce(
    BuildContext context,
    WidgetRef ref,
    List<models.TransactionItem> items,
  ) async {
    if (items.isEmpty) return;

    if (items.length == 1) {
      final item = items.first;
      if (!context.mounted) return;

      WorkOrderBottomSheet.show(
        context: context,
        ref: ref,
        workOrderId: null,
        initialVariantId: item.variantId,
        initialVariantName: item.name,
        initialPlannedQuantity: item.qty.toDouble(),
        onSubmit: (data) async {
          await ProductionOutputService().createWorkOrder(
            variantId: data['variantId'] as String,
            variantName: data['variantName'] as String?,
            plannedQuantity: data['plannedQuantity'] as double,
            targetDate: data['targetDate'] as DateTime,
            shiftId: data['shiftId'] as String?,
            notes: data['notes'] as String?,
          );

          await ProxyService.strategy.updateStockRequest(
            stockRequestId: request.id,
            status: RequestStatus.processing,
          );

          final stringValue = ref.read(stringProvider);
          ref.refresh(
            stockRequestsProvider(
              status: RequestStatus.pending,
              search: stringValue?.isNotEmpty == true ? stringValue : null,
            ),
          );
        },
      );
      return;
    }

    bool isFirstSubmission = true;

    await showProduceSelectionDialog(
      context: context,
      items: items,
      onProduce: (item, formData) async {
        await ProductionOutputService().createWorkOrder(
          variantId: formData['variantId'] as String,
          variantName: formData['variantName'] as String?,
          plannedQuantity: formData['plannedQuantity'] as double,
          targetDate: formData['targetDate'] as DateTime,
          shiftId: formData['shiftId'] as String?,
          notes: formData['notes'] as String?,
        );

        if (isFirstSubmission) {
          await ProxyService.strategy.updateStockRequest(
            stockRequestId: request.id,
            status: RequestStatus.processing,
          );
          isFirstSubmission = false;
        }
      },
      formBuilder: ({
        String? initialVariantId,
        String? initialVariantName,
        double? initialPlannedQuantity,
        Future<void> Function(Map<String, dynamic>)? onSubmit,
        VoidCallback? onCancel,
      }) {
        return WorkOrderForm(
          initialVariantId: initialVariantId,
          initialVariantName: initialVariantName,
          initialPlannedQuantity: initialPlannedQuantity,
          onSubmit: onSubmit,
          onCancel: onCancel,
        );
      },
    );

    final stringValue = ref.read(stringProvider);
    ref.refresh(
      stockRequestsProvider(
        status: RequestStatus.pending,
        search: stringValue?.isNotEmpty == true ? stringValue : null,
      ),
    );
  }
}

enum _OmBtnVariant { ghost, greenSoft, voidDisabled }

class _ActionsBar extends StatelessWidget {
  const _ActionsBar({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final stretch = constraints.maxWidth < OmTokens.compactBreakpoint;
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.only(top: 16),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: OmTokens.line)),
          ),
          child: wrapActions(
            stretch: stretch,
            children: children,
          ),
        );
      },
    );
  }

  Widget wrapActions({required bool stretch, required List<Widget> children}) {
    if (stretch) {
      return Row(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(width: 10),
            Expanded(child: children[i]),
          ],
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) const SizedBox(width: 10),
          children[i],
        ],
      ],
    );
  }
}

class _OmBtn extends StatelessWidget {
  const _OmBtn({
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.variant,
    this.isDisabled = false,
  });

  final VoidCallback? onPressed;
  final IconData icon;
  final String label;
  final _OmBtnVariant variant;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    final disabled = isDisabled || onPressed == null;
    late Color bg;
    late Color fg;
    late Color border;

    switch (variant) {
      case _OmBtnVariant.ghost:
        bg = OmTokens.surface;
        fg = OmTokens.ink2;
        border = OmTokens.line2;
        break;
      case _OmBtnVariant.greenSoft:
        bg = OmTokens.greenWash;
        fg = OmTokens.greenStrong;
        border = Colors.transparent;
        break;
      case _OmBtnVariant.voidDisabled:
        bg = OmTokens.surface2;
        fg = OmTokens.faint;
        border = OmTokens.line2;
        break;
    }

    if (disabled && variant != _OmBtnVariant.voidDisabled) {
      fg = OmTokens.faint;
      bg = OmTokens.surface2;
      border = OmTokens.line2;
    }

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(OmTokens.radiusSm),
      child: InkWell(
        onTap: disabled ? null : onPressed,
        borderRadius: BorderRadius.circular(OmTokens.radiusSm),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(OmTokens.radiusSm),
            border: Border.all(color: border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: fg, size: 18),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: OmTokens.text(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: fg,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
