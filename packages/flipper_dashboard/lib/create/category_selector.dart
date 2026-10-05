import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_localize/flipper_localize.dart';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_models/providers/category_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';

class CategorySelector extends HookConsumerWidget {
  const CategorySelector({super.key, this.modeOfOperation = 'product'});

  const CategorySelector.transactionMode({
    super.key,
    this.modeOfOperation = 'transaction',
  });

  final String modeOfOperation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<List<Category>>>(categoryProvider, (previous, next) {
      next.whenData((list) {
        final optimistic = ref.read(optimisticFocusedCategoryProvider);
        if (optimistic == null) return;
        Category? focusedDb;
        try {
          focusedDb = list.firstWhere((c) => c.focused && (c.active ?? false));
        } catch (_) {
          focusedDb = null;
        }
        if (focusedDb != null && focusedDb.id == optimistic.id) {
          ref.read(optimisticFocusedCategoryProvider.notifier).clear();
        }
      });
    });

    final categories = ref.watch(categoryProvider);

    return GestureDetector(
      onTap: () => _navigateToCategories(context, ref, modeOfOperation),
      child: modeOfOperation == 'product'
          ? _buildProductMode(context, ref, categories)
          : _buildTransactionMode(context, ref, categories),
    );
  }

  Future<void> _navigateToCategories(
    BuildContext context,
    WidgetRef ref,
    String mode,
  ) async {
    // Assuming you're using go_router or similar
    final _routerService = locator<RouterService>();
    await _routerService.navigateTo(
      ListCategoriesRoute(modeOfOperation: modeOfOperation),
    );
    if (context.mounted) {
      final _ = ref.refresh(categoryProvider);
    }
  }

  Widget _buildProductMode(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<Category>> categories,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 0.3),
        leading: Text(
          context.flipperL10n.category,
          style: _getDefaultTextStyle(),
        ),
        trailing: _buildTrailing(categories, context, ref),
      ),
    );
  }

  Widget _buildTransactionMode(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<Category>> categories,
  ) {
    return _buildTrailing(categories, context, ref);
  }

  Widget _buildTrailing(
    AsyncValue<List<Category>> categories,
    BuildContext context,
    WidgetRef ref,
  ) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _buildCategoryText(categories, context, ref),
        const SizedBox(width: 4),
        Icon(
          FluentIcons.arrow_forward_20_regular,
          color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
        ),
      ],
    );
  }

  Widget _buildCategoryText(
    AsyncValue<List<Category>> categories,
    BuildContext context,
    WidgetRef ref,
  ) {
    return categories.when(
      data: (categoryList) => _buildCategoryName(context, ref, categoryList),
      loading: () => Text(context.flipperL10n.createLoadingEllipsis),
      error: (error, _) =>
          Text(context.flipperL10n.errorWithValue(error.toString())),
    );
  }

  Widget _buildCategoryName(
    BuildContext context,
    WidgetRef ref,
    List<Category> categories,
  ) {
    final optimistic = ref.watch(optimisticFocusedCategoryProvider);
    if (optimistic != null && optimistic.id.isNotEmpty) {
      return Text(
        optimistic.name ?? context.flipperL10n.createSelectCategory,
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(color: Colors.black),
      );
    }

    final focusedCategory = categories.firstWhere(
      (category) => category.focused && (category.active ?? false),
      orElse: () =>
          Category(id: '', name: context.flipperL10n.createSelectCategory),
    );

    return Text(
      focusedCategory.name!,
      style: focusedCategory.id.isNotEmpty
          ? Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black)
          : _getDefaultTextStyle(),
    );
  }

  TextStyle _getDefaultTextStyle() {
    return const TextStyle(
      color: Colors.black,
      fontSize: 17,
      fontWeight: FontWeight.w400,
    );
  }
}
