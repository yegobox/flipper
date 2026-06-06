import 'dart:async';

import 'package:flipper_dashboard/theme/mpos_tokens.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_dashboard/utils/mpos_helpers.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_dashboard/providers/customer_phone_provider.dart';
import 'package:flipper_dashboard/widgets/mpos/mpos_animated_sheet.dart';
import 'package:flipper_dashboard/widgets/mpos/mpos_toast.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';

/// Customer picker bottom sheet ([design_handoff_mobile_pos] CustomerSheet).
class MposCustomerSheet {
  static Future<void> show({
    required BuildContext context,
    required WidgetRef ref,
    required ITransaction transaction,
    VoidCallback? onAttached,
  }) {
    return showMposAnimatedSheet<void>(
      context: context,
      builder: (ctx) => _MposCustomerSheetBody(
        transaction: transaction,
        onAttached: onAttached,
      ),
    );
  }
}

class _MposCustomerSheetBody extends ConsumerStatefulWidget {
  const _MposCustomerSheetBody({
    required this.transaction,
    this.onAttached,
  });

  final ITransaction transaction;
  final VoidCallback? onAttached;

  @override
  ConsumerState<_MposCustomerSheetBody> createState() =>
      _MposCustomerSheetBodyState();
}

class _MposCustomerSheetBodyState extends ConsumerState<_MposCustomerSheetBody> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  List<Customer> _results = [];
  bool _loading = false;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _search(String key) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      if (key.trim().isEmpty) {
        if (mounted) setState(() => _results = []);
        return;
      }
      setState(() => _loading = true);
      try {
        final branchId = ProxyService.box.getBranchId();
        final customers = branchId != null && branchId.isNotEmpty
            ? await ProxyService.getStrategy(
                Strategy.capella,
              ).customers(key: key, branchId: branchId)
            : <Customer>[];
        if (mounted) {
          setState(() {
            _results = customers;
            _loading = false;
          });
        }
      } catch (e) {
        talker.warning('MposCustomerSheet search: $e');
        if (mounted) setState(() => _loading = false);
      }
    });
  }

  Future<void> _attach(Customer customer) async {
    try {
      await ProxyService.getStrategy(
        Strategy.capella,
      ).assignCustomerToTransaction(
        customer: customer,
        transaction: widget.transaction,
      );
      await ProxyService.box.writeString(
        key: 'customerName',
        value: customer.custNm ?? '',
      );
      await ProxyService.box.writeString(
        key: 'currentSaleCustomerPhoneNumber',
        value: customer.telNo ?? '',
      );
      ref.read(customerPhoneNumberProvider.notifier).state = customer.telNo;
      ref.invalidate(attachedCustomerProvider(customer.id));
      ref.invalidate(transactionByIdProvider(widget.transaction.id));
      ref.invalidate(
        pendingTransactionStreamProvider(isExpense: false),
      );
      if (!mounted) return;
      Navigator.of(context).pop();
      widget.onAttached?.call();
      MposToast.show(
        context,
        message: '${customer.custNm} attached to this sale',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not attach customer: $e')),
        );
      }
    }
  }

  void _walkIn() {
    Navigator.of(context).pop();
  }

  void _addNew() {
    Navigator.of(context).pop();
    locator<RouterService>().navigateTo(CustomersRoute());
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final bottomSafe = media.padding.bottom;
    final keyboardInset = media.viewInsets.bottom;
    final maxH = (media.size.height * 0.88)
        .clamp(0.0, media.size.height - media.padding.top - keyboardInset - 16);
    return Material(
      color: PosTokens.surface,
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(MposTokens.sheetRadius),
      ),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxH),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: PosTokens.lineStrong,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 12, 12),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Attach customer',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: PosTokens.ink1,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: IconButton.styleFrom(
                    backgroundColor: PosTokens.surface2,
                  ),
                  icon: const Icon(Icons.close_rounded, size: 18),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: PosTokens.surface2,
                borderRadius: BorderRadius.circular(MposTokens.radiusMd),
                border: Border.all(color: PosTokens.line, width: 1.5),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search_rounded, color: PosTokens.ink3),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search name or phone',
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      onChanged: _search,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.fromLTRB(18, 0, 18, 18 + bottomSafe),
              children: [
                Material(
                  color: PosTokens.surface2,
                  borderRadius: BorderRadius.circular(MposTokens.radiusMd),
                  child: InkWell(
                    onTap: _walkIn,
                    borderRadius: BorderRadius.circular(MposTokens.radiusMd),
                    child: Padding(
                      padding: const EdgeInsets.all(13),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: PosTokens.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: PosTokens.line),
                            ),
                            child: const Icon(
                              Icons.directions_walk_rounded,
                              color: PosTokens.ink2,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Continue as walk-in',
                                  style: TextStyle(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  'No customer on this sale',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: PosTokens.ink3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (_loading)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ..._results.map((c) {
                  final name = c.custNm ?? 'Customer';
                  final color = mposColorForName(name);
                  return InkWell(
                    onTap: () => _attach(c),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              mposAbbreviation(name),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14.5,
                                  ),
                                ),
                                if (c.telNo != null)
                                  Text(
                                    c.telNo!,
                                    style: const TextStyle(
                                      fontSize: 12.5,
                                      color: PosTokens.ink3,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right_rounded,
                            color: PosTokens.ink4,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _addNew,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    side: const BorderSide(
                      color: PosTokens.lineStrong,
                      width: 1.5,
                    ),
                    foregroundColor: PosTokens.blue,
                  ),
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text(
                    'Add new customer',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }
}
