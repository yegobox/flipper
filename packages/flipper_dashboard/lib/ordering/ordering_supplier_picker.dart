import 'dart:async';

import 'package:flipper_dashboard/ordering/ordering_state.dart';
import 'package:flipper_dashboard/ordering/ordering_tokens.dart';
import 'package:flipper_dashboard/ordering/ordering_widgets.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Minimum typed characters before the remote name search runs.
///
/// One letter matches most of the table and the answer is useless; the local
/// roster below already responds on the first keystroke.
const int _kRemoteSearchMinChars = 2;

/// First step of the order: who it is going to.
///
/// Fills the whole body until a supplier is picked — their catalogue, cost and
/// stock are what the other two panes are made of, so there is nothing useful
/// to show beside this.
///
/// Built search-first, because the roster is as long as the business is big.
/// Everything is one lazy scroll view: typing filters the branches already on
/// the device on the keystroke, and the slower name search against every branch
/// in the org appends its extra finds underneath. Pagination would not help —
/// `branches()` is a local query, so the rows are already in memory; paging
/// would only put clicks between the operator and a name they can see.
class OrderingSupplierPicker extends HookConsumerWidget {
  const OrderingSupplierPicker({
    super.key,
    required this.onPicked,
    this.onAddSupplier,
  });

  final ValueChanged<Branch> onPicked;
  final VoidCallback? onAddSupplier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();

    // Two states, deliberately: [typed] drives the local filter and must be
    // immediate, [remoteQuery] drives the Supabase search and must not fire
    // once per keystroke.
    final typed = useState('');
    final remoteQuery = useState('');
    final debounce = useRef<Timer?>(null);

    useEffect(
      () =>
          () => debounce.value?.cancel(),
      const [],
    );

    void onQueryChanged(String value) {
      typed.value = value;
      debounce.value?.cancel();
      debounce.value = Timer(const Duration(milliseconds: 280), () {
        remoteQuery.value = value;
      });
    }

    final needle = typed.value.trim().toLowerCase();
    final searching = needle.isNotEmpty;
    final options = ref.watch(orderingSupplierOptionsProvider);

    // Only consulted while searching, and only once the query is worth a
    // round-trip.
    final remote =
        searching && remoteQuery.value.trim().length >= _kRemoteSearchMinChars
        ? ref.watch(orderingSupplierSearchProvider(remoteQuery.value))
        : const AsyncValue<List<Branch>>.data([]);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: OrderingTokens.pickerMaxWidth,
        ),
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.only(
                left: 22,
                right: 22,
                top: 48,
                bottom: 20,
              ),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      context.flipperL10n.orderingPickerTitle,
                      style: OrderingTokens.pickerTitle,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      context.flipperL10n.orderingPickerBody,
                      style: OrderingTokens.pickerBody,
                    ),
                    const SizedBox(height: 20),
                    OrderingSearchField(
                      controller: controller,
                      hintText: context.flipperL10n.orderingSearchSuppliersHint,
                      fontSize: 15,
                      iconSize: 19,
                      verticalPadding: 15,
                      onChanged: onQueryChanged,
                      onClear: searching
                          ? () {
                              controller.clear();
                              debounce.value?.cancel();
                              typed.value = '';
                              remoteQuery.value = '';
                            }
                          : null,
                    ),
                  ],
                ),
              ),
            ),
            ..._body(
              options: options,
              remote: remote,
              needle: needle,
              rawQuery: typed.value.trim(),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(
                left: 22,
                right: 22,
                top: 20,
                bottom: 64,
              ),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Text(
                      context.flipperL10n.orderingNotOnList,
                      style: OrderingTokens.body,
                    ),
                    const SizedBox(width: 10),
                    _AddSupplierLink(onPressed: onAddSupplier),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _body({
    required AsyncValue<SupplierOptions> options,
    required AsyncValue<List<Branch>> remote,
    required String needle,
    required String rawQuery,
  }) {
    final l10n = FlipperL10n.current;
    if (options.hasError) {
      return [
        _message(
          icon: Icons.cloud_off_outlined,
          title: l10n.orderingCouldNotLoadSuppliers,
          hint: '${options.error}',
        ),
      ];
    }
    if (!options.hasValue) return [const _SliverSpinner()];

    final data = options.requireValue;

    if (needle.isEmpty) {
      if (data.isEmpty) {
        return [
          _message(
            icon: Icons.storefront_outlined,
            title: l10n.orderingNoOtherBranch,
            hint: l10n.orderingNoOtherBranchHint,
          ),
        ];
      }
      return [
        if (data.frequent.isNotEmpty)
          ..._section(
            label: l10n.orderingFrequentSuppliers,
            suppliers: data.frequent,
          ),
        if (data.others.isNotEmpty)
          ..._section(
            label: data.frequent.isEmpty
                ? l10n.orderingBranchesYouCanOrderFrom
                : l10n.orderingOtherBranchesYouCanOrderFrom,
            suppliers: data.others,
            // Long rosters are the norm, so the heading carries the size —
            // it is what tells the operator to type rather than scroll.
            showCount: true,
          ),
      ];
    }

    // Local first: these rows are already on the device, so they appear on the
    // keystroke while the remote search is still in flight.
    final local = [
      ...data.frequent,
      ...data.others,
    ].where((b) => _matches(b, needle)).toList();
    final localIds = {for (final b in local) b.id};
    final extra = (remote.value ?? const <Branch>[])
        .where((b) => !localIds.contains(b.id))
        .toList();

    if (local.isEmpty && extra.isEmpty) {
      if (remote.isLoading) return [const _SliverSpinner()];
      return [
        _message(
          icon: Icons.storefront_outlined,
          title: l10n.orderingNoSupplierMatches(rawQuery),
          hint: l10n.orderingNoSupplierMatchesHint,
        ),
      ];
    }

    return [
      if (local.isNotEmpty)
        ..._section(
          label: l10n.orderingOnThisDevice,
          suppliers: local,
          showCount: true,
        ),
      if (extra.isNotEmpty)
        ..._section(
          label: l10n.orderingFoundByNameSearch,
          suppliers: extra,
          showCount: true,
        ),
      if (remote.isLoading) const _SliverSpinner(height: 60),
    ];
  }

  /// Name, place and description — everything the row actually shows.
  static bool _matches(Branch branch, String needle) {
    final haystack = [
      branch.name ?? '',
      branch.location ?? '',
      branch.description ?? '',
    ].join(' ').toLowerCase();
    return haystack.contains(needle);
  }

  List<Widget> _section({
    required String label,
    required List<Branch> suppliers,
    bool showCount = false,
  }) {
    return [
      SliverPadding(
        padding: const EdgeInsets.only(left: 24, right: 22, bottom: 8),
        sliver: SliverToBoxAdapter(
          child: OrderingEyebrow(
            showCount ? '$label · ${suppliers.length}' : label,
          ),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        // Built lazily: a business with a few hundred branches would otherwise
        // build a card for every one of them before painting the first.
        sliver: SliverList.builder(
          itemCount: suppliers.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _SupplierCard(
              supplier: suppliers[index],
              onTap: () => onPicked(suppliers[index]),
            ),
          ),
        ),
      ),
      const SliverToBoxAdapter(child: SizedBox(height: 12)),
    ];
  }

  Widget _message({
    required IconData icon,
    required String title,
    String? hint,
  }) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      sliver: SliverToBoxAdapter(
        child: OrderingEmptyState(
          icon: icon,
          title: title,
          hint: hint,
          padding: const EdgeInsets.symmetric(vertical: 40),
        ),
      ),
    );
  }
}

class _SliverSpinner extends StatelessWidget {
  const _SliverSpinner({this.height = 80});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: height,
        child: const Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.4,
              color: OrderingTokens.blue,
            ),
          ),
        ),
      ),
    );
  }
}

class _SupplierCard extends StatelessWidget {
  const _SupplierCard({required this.supplier, required this.onTap});

  final Branch supplier;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final line = supplier.description?.trim();
    final place = supplier.location?.trim();

    return OrderingHover(
      builder: (context, hovered) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: OrderingTokens.hover,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
          decoration: BoxDecoration(
            color: OrderingTokens.surface,
            borderRadius: OrderingTokens.cardRadius,
            border: Border.all(
              color: hovered ? OrderingTokens.blue : OrderingTokens.line,
              width: 1.5,
            ),
            boxShadow: hovered ? OrderingTokens.cardHoverShadow : null,
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  color: OrderingTokens.thumbWell,
                  borderRadius: BorderRadius.all(Radius.circular(11)),
                ),
                child: const Icon(
                  Icons.storefront_outlined,
                  size: 21,
                  color: OrderingTokens.inkGroup,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      supplier.name ??
                          context.flipperL10n.orderingUnnamedBranch,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: const TextStyle(
                        fontFamily: OrderingTokens.sans,
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        color: OrderingTokens.ink1,
                        height: 1.2,
                      ),
                    ),
                    if (line != null && line.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        line,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: OrderingTokens.body.copyWith(fontSize: 13),
                      ),
                    ],
                  ],
                ),
              ),
              if (place != null && place.isNotEmpty) ...[
                const SizedBox(width: 16),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 160),
                  child: Text(
                    place,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    textAlign: TextAlign.right,
                    style: OrderingTokens.monoStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: OrderingTokens.ink4,
                    ),
                  ),
                ),
              ],
              const SizedBox(width: 16),
              const Icon(
                Icons.chevron_right,
                size: 18,
                color: OrderingTokens.ink7,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddSupplierLink extends StatelessWidget {
  const _AddSupplierLink({required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OrderingHover(
      enabled: onPressed != null,
      builder: (context, hovered) => GestureDetector(
        onTap: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add,
              size: 16,
              color: hovered ? OrderingTokens.blueHover : OrderingTokens.blue,
            ),
            const SizedBox(width: 7),
            Text(
              context.flipperL10n.orderingAddNewSupplier,
              style: TextStyle(
                fontFamily: OrderingTokens.sans,
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: hovered ? OrderingTokens.blueHover : OrderingTokens.blue,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
