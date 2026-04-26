import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_dashboard/pos_layout_breakpoints.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_models/providers/all_providers.dart';

class ListCategories extends StatefulHookConsumerWidget {
  const ListCategories({Key? key, required this.modeOfOperation})
    : super(key: key);
  final String? modeOfOperation;

  @override
  ListCategoriesState createState() => ListCategoriesState();
}

class ListCategoriesState extends ConsumerState<ListCategories> {
  final _routerService = locator<RouterService>();
  String? _selectedCategoryId;
  late final TextEditingController _searchController;

  static const _categoryIconColors = <Color>[
    Color(0xFF7C4DFF),
    Color(0xFF00796B),
    Color(0xFF1E88E5),
    Color(0xFFE64A19),
    Color(0xFF6D4C41),
    Color(0xFF9E9E9E),
  ];

  static const _categoryIconData = <IconData>[
    FluentIcons.home_24_regular,
    FluentIcons.filter_24_regular,
    FluentIcons.payment_24_regular,
    FluentIcons.cellular_data_1_24_regular,
    FluentIcons.briefcase_24_regular,
    FluentIcons.tag_24_regular,
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  int _categoryVisualIndex(String id) {
    if (id.isEmpty) return 0;
    return id.runes.fold(0, (a, c) => a + c) % _categoryIconColors.length;
  }

  List<Category> _searchFiltered(List<Category> categories) {
    final q = _searchController.text.trim().toLowerCase();
    if (q.isEmpty) return categories;
    return categories
        .where((c) => (c.name ?? '').toLowerCase().contains(q))
        .toList();
  }

  bool _isMobileLayout(BuildContext context) =>
      MediaQuery.sizeOf(context).width < PosLayoutBreakpoints.mobileLayoutMaxWidth;

  Widget buildCategoryItem({
    required Category category,
    required CoreViewModel model,
    required String groupValue,
  }) {
    final isSelected = category.id.toString() == groupValue;
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        onTap: () {
          setState(() {
            _selectedCategoryId = category.id.toString();
          });
          model.updateCategoryCore(category: category);
          log("Category selected: ${category.name}");
        },
        title: Text(
          category.name ?? '',
          style: TextStyle(
            color: isSelected ? Theme.of(context).primaryColor : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: Radio<String>(
          value: category.id.toString(),
          groupValue: groupValue,
          activeColor: Theme.of(context).primaryColor,
          onChanged: (value) {
            setState(() {
              _selectedCategoryId = value;
            });
            model.updateCategoryCore(category: category);
          },
        ),
        tileColor: isSelected
            ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
            : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.transparent,
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget buildCategoryItemMobile({
    required Category category,
    required CoreViewModel model,
    required String groupValue,
  }) {
    final idx = _categoryVisualIndex(category.id);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedCategoryId = category.id.toString();
          });
          model.updateCategoryCore(category: category);
          log("Category selected: ${category.name}");
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _categoryIconColors[idx],
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Icon(
                  _categoryIconData[idx],
                  size: 22,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  category.name ?? '',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Radio<String>(
                value: category.id.toString(),
                groupValue: groupValue,
                activeColor: Theme.of(context).colorScheme.primary,
                onChanged: (value) {
                  setState(() {
                    _selectedCategoryId = value;
                  });
                  model.updateCategoryCore(category: category);
                },
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCategoryList({
    required List<Category> categories,
    required CoreViewModel model,
    required String groupValue,
  }) {
    return ListView.builder(
      itemCount: categories.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return buildCategoryItem(
          category: categories[index],
          model: model,
          groupValue: groupValue,
        );
      },
    );
  }

  Widget buildCategoryListMobile({
    required List<Category> categories,
    required CoreViewModel model,
    required String groupValue,
  }) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemCount: categories.length,
      separatorBuilder: (_, __) => Divider(
        height: 1,
        thickness: 1,
        color: Colors.grey.shade200,
        indent: 44,
        endIndent: 0,
      ),
      itemBuilder: (context, index) {
        return buildCategoryItemMobile(
          category: categories[index],
          model: model,
          groupValue: groupValue,
        );
      },
    );
  }

  static const _mobileCreateAccent = Color(0xFF6B4CE6);

  Widget _buildMobileBody({
    required BuildContext context,
    required CoreViewModel model,
    required List<Category> listForListView,
    required String groupValue,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Search categories...',
              prefixIcon: Icon(
                Icons.search,
                size: 22,
                color: Colors.grey.shade500,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1.2,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _DashedRRect(
            borderRadius: 12,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _routerService.navigateTo(AddCategoryRoute()),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _mobileCreateAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          FluentIcons.add_24_filled,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Text(
                        'Create new category',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'ALL CATEGORIES',
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Container(
            color: Colors.white,
            child: listForListView.isEmpty
                ? Center(
                    child: Text(
                      'No categories found',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 15,
                      ),
                    ),
                  )
                : buildCategoryListMobile(
                    categories: listForListView,
                    model: model,
                    groupValue: groupValue,
                  ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = _isMobileLayout(context);
    return ViewModelBuilder<CoreViewModel>.reactive(
      viewModelBuilder: () => CoreViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: isMobile
              ? const Color(0xFFF7F4EF)
              : Theme.of(context).scaffoldBackgroundColor,
          appBar: CustomAppBar(
            onPop: () {
              log('back');
              _routerService.back();
            },
            showActionButton: false,
            title: 'Categories',
            icon: Icons.arrow_back_ios,
            multi: 3,
            bottomSpacer: 80,
          ),
          body: ref
              .watch(
                categoriesProvider(branchId: ProxyService.box.getBranchId()!),
              )
              .when(
                data: (categories) {
                  final withoutCustom = categories
                      .where(
                        (c) =>
                            (c.name ?? '').toLowerCase() != 'custom',
                      )
                      .toList();
                  final groupValue =
                      _selectedCategoryId ??
                      withoutCustom
                          .firstWhere(
                            (c) => (c.focused) && (c.active ?? false),
                            orElse: () => Category(id: '', name: ''),
                          )
                          .id
                          .toString();

                  if (isMobile) {
                    return _buildMobileBody(
                      context: context,
                      model: model,
                      listForListView: _searchFiltered(withoutCustom),
                      groupValue: groupValue,
                    );
                  }

                  return SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Card(
                          margin: const EdgeInsets.all(8),
                          child: ListTile(
                            onTap: () =>
                                _routerService.navigateTo(AddCategoryRoute()),
                            title: const Text(
                              'Create Category',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            trailing: const Icon(FluentIcons.add_24_regular),
                          ),
                        ),
                        const SizedBox(height: 16),
                        buildCategoryList(
                          categories: withoutCustom,
                          model: model,
                          groupValue: groupValue,
                        ),
                      ],
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(child: Text('Error: $error')),
              ),
        );
      },
    );
  }
}

/// Dashed rounded rectangle (reference UI) without adding a new dependency.
class _DashedRRect extends StatelessWidget {
  const _DashedRRect({required this.child, this.borderRadius = 12});

  final Widget child;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedRRectPainter(
        borderRadius: borderRadius,
        color: Colors.grey.shade400,
      ),
      child: child,
    );
  }
}

class _DashedRRectPainter extends CustomPainter {
  _DashedRRectPainter({
    required this.borderRadius,
    required this.color,
  });

  static const double _dash = 5;
  static const double _gap = 4;
  static const double _strokeWidth = 1.2;

  final double borderRadius;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final r = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        _strokeWidth * 0.5,
        _strokeWidth * 0.5,
        math.max(0, size.width - _strokeWidth),
        math.max(0, size.height - _strokeWidth),
      ),
      Radius.circular(
        math.max(0, borderRadius - _strokeWidth * 0.5),
      ),
    );
    final path = Path()..addRRect(r);
    final paint = Paint()
      ..color = color
      ..strokeWidth = _strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    for (final m in path.computeMetrics()) {
      var d = 0.0;
      while (d < m.length) {
        final end = math.min(d + _dash, m.length);
        final seg = m.extractPath(d, end);
        canvas.drawPath(seg, paint);
        d = end + _gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRRectPainter old) {
    return old.color != color || old.borderRadius != borderRadius;
  }
}
