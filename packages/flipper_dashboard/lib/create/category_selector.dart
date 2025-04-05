import 'package:flipper_models/db_model_export.dart';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flipper_models/providers/category_provider.dart';

class CategorySelector extends ConsumerWidget {
  const CategorySelector({
    super.key,
    this.modeOfOperation = 'product',
  });

  const CategorySelector.transactionMode({
    super.key,
    this.modeOfOperation = 'transaction',
  });

  final String modeOfOperation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoryProvider);

    return GestureDetector(
      onTap: () => _navigateToCategories(context, modeOfOperation),
      child: modeOfOperation == 'product'
          ? _buildProductMode(context, categories)
          : _buildTransactionMode(context, categories),
    );
  }

  void _navigateToCategories(BuildContext context, String mode) {
    // Assuming you're using go_router or similar
    final _routerService = locator<RouterService>();
    _routerService.navigateTo(
      ListCategoriesRoute(modeOfOperation: modeOfOperation),
    );
  }

  Widget _buildProductMode(
    BuildContext context,
    AsyncValue<List<Category>> categories,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 0.3),
        leading: Text(
          'Category',
          style: _getDefaultTextStyle(),
        ),
        trailing: _buildTrailing(categories, context),
      ),
    );
  }

  Widget _buildTransactionMode(
    BuildContext context,
    AsyncValue<List<Category>> categories,
  ) {
    return _buildTrailing(categories, context);
  }

  Widget _buildTrailing(
    AsyncValue<List<Category>> categories,
    BuildContext context,
  ) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _buildCategoryText(categories, context),
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
  ) {
    return categories.when(
      data: (categoryList) => _buildCategoryName(context, categoryList),
      loading: () => const Text('Loading...'),
      error: (error, _) => Text('Error: $error'),
    );
  }

  Widget _buildCategoryName(BuildContext context, List<Category> categories) {
    final focusedCategory = categories.firstWhere(
      (category) => category.focused && (category.active ?? false),
      orElse: () => Category(id: '', name: 'Select Category'),
    );

    return Text(
      focusedCategory.name!,
      style: focusedCategory.id.isNotEmpty
          ? Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.black,
              )
          : _getDefaultTextStyle(),
    );
  }

  TextStyle _getDefaultTextStyle() {
    return GoogleFonts.poppins(
      color: Colors.black,
      fontSize: 17,
      fontWeight: FontWeight.w400,
    );
  }
}
