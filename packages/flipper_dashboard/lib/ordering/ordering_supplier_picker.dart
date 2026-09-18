import 'dart:async';

import 'package:flipper_dashboard/ordering/ordering_state.dart';
import 'package:flipper_dashboard/ordering/ordering_tokens.dart';
import 'package:flipper_dashboard/ordering/ordering_widgets.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// First step of the order: who it is going to.
///
/// Fills the whole body until a supplier is picked — their catalogue, cost and
/// stock are what the other two panes are made of, so there is nothing useful
/// to show beside this.
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
    final query = useState('');
    final debounce = useRef<Timer?>(null);

    useEffect(() => () => debounce.value?.cancel(), const []);

    // Typing a supplier name hits Supabase; settle first so a four-letter name
    // is one query rather than four.
    void onQueryChanged(String value) {
      debounce.value?.cancel();
      debounce.value = Timer(const Duration(milliseconds: 280), () {
        query.value = value;
      });
    }

    final searching = query.value.trim().isNotEmpty;
    final results = searching
        ? ref.watch(orderingSupplierSearchProvider(query.value))
        : ref.watch(orderingFrequentSuppliersProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        left: 22,
        right: 22,
        top: 48,
        bottom: 64,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: OrderingTokens.pickerMaxWidth,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Which supplier are you ordering from?',
                style: OrderingTokens.pickerTitle,
              ),
              const SizedBox(height: 6),
              const Text(
                'Pick a branch you buy from. Their catalogue, your last cost '
                'and their stock on hand load straight into the order.',
                style: OrderingTokens.pickerBody,
              ),
              const SizedBox(height: 20),
              OrderingSearchField(
                controller: controller,
                hintText: 'Search suppliers by name…',
                fontSize: 15,
                iconSize: 19,
                verticalPadding: 15,
                onChanged: onQueryChanged,
              ),
              const SizedBox(height: 20),
              OrderingEyebrow(
                searching
                    ? 'Search results'
                    : 'Suppliers you order from most',
                padding: const EdgeInsets.only(left: 2, bottom: 8),
              ),
              _Results(
                results: results,
                searching: searching,
                query: query.value,
                onPicked: onPicked,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text('Not on the list?', style: OrderingTokens.body),
                  const SizedBox(width: 10),
                  _AddSupplierLink(onPressed: onAddSupplier),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Results extends StatelessWidget {
  const _Results({
    required this.results,
    required this.searching,
    required this.query,
    required this.onPicked,
  });

  final AsyncValue<List<Branch>> results;
  final bool searching;
  final String query;
  final ValueChanged<Branch> onPicked;

  @override
  Widget build(BuildContext context) {
    return results.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(
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
      error: (error, _) => OrderingEmptyState(
        icon: Icons.cloud_off_outlined,
        title: 'Could not load suppliers',
        hint: '$error',
        padding: const EdgeInsets.symmetric(vertical: 40),
      ),
      data: (suppliers) {
        if (suppliers.isEmpty) {
          return OrderingEmptyState(
            icon: Icons.storefront_outlined,
            title: searching
                ? 'No supplier matches “$query”'
                : 'No orders yet',
            hint: searching
                ? 'Check the spelling, or add them as a new supplier.'
                : 'Search a branch name to place your first order.',
            padding: const EdgeInsets.symmetric(vertical: 40),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final supplier in suppliers)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _SupplierCard(
                  supplier: supplier,
                  onTap: () => onPicked(supplier),
                ),
              ),
          ],
        );
      },
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
                      supplier.name ?? 'Unnamed branch',
                      overflow: TextOverflow.ellipsis,
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
                        overflow: TextOverflow.ellipsis,
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
                    overflow: TextOverflow.ellipsis,
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
              'Add a new supplier',
              style: TextStyle(
                fontFamily: OrderingTokens.sans,
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: hovered
                    ? OrderingTokens.blueHover
                    : OrderingTokens.blue,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
