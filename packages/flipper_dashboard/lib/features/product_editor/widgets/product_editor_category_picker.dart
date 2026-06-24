import 'package:flipper_dashboard/features/product_editor/product_editor_tokens.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/all_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Handoff `.pe-search` + `.pe-chip` + `.pe-suggest` category picker.
/// Wired to single-category selection (existing product editor logic).
class ProductEditorCategoryPicker extends ConsumerStatefulWidget {
  const ProductEditorCategoryPicker({
    super.key,
    required this.selectedCategoryId,
    required this.selectedCategoryName,
    required this.onCategoryChanged,
    required this.onAddCategory,
  });

  final String? selectedCategoryId;
  final String? selectedCategoryName;
  final ValueChanged<String?> onCategoryChanged;
  final VoidCallback onAddCategory;

  @override
  ConsumerState<ProductEditorCategoryPicker> createState() =>
      _ProductEditorCategoryPickerState();
}

class _ProductEditorCategoryPickerState
    extends ConsumerState<ProductEditorCategoryPicker> {
  FocusNode? _activeFocusNode;

  @override
  void dispose() {
    _activeFocusNode?.removeListener(_onFocusChange);
    super.dispose();
  }

  void _onFocusChange() {
    if (mounted) setState(() {});
  }

  void _attachFocusNode(FocusNode node) {
    if (_activeFocusNode == node) return;
    _activeFocusNode?.removeListener(_onFocusChange);
    _activeFocusNode = node;
    _activeFocusNode?.addListener(_onFocusChange);
  }

  void _selectCategory(Category category) {
    widget.onCategoryChanged(category.id);
    _activeFocusNode?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoryProvider);
    final selectedName = widget.selectedCategoryName?.trim();

    final suggestions = categoriesAsync.maybeWhen(
      data: (categories) {
        final selectedId = widget.selectedCategoryId;
        return categories
            .where((c) => c.id != selectedId && (c.name?.isNotEmpty ?? false))
            .take(6)
            .toList();
      },
      orElse: () => <Category>[],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TypeAheadField<Category>(
          key: ValueKey(widget.selectedCategoryId ?? 'no-cat'),
          suggestionsCallback: (search) {
            return categoriesAsync.when(
              data: (categories) {
                if (search.isEmpty) return categories.take(50).toList();
                final q = search.toLowerCase();
                return categories
                    .where((c) => (c.name ?? '').toLowerCase().contains(q))
                    .take(50)
                    .toList();
              },
              loading: () => <Category>[],
              error: (_, __) => <Category>[],
            );
          },
          hideOnUnfocus: false,
          builder: (context, controller, focusNode) {
            _attachFocusNode(focusNode);
            final focused = focusNode.hasFocus;
            return Container(
              height: ProductEditorTokens.fieldHeight,
              decoration: BoxDecoration(
                color: ProductEditorTokens.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: focused
                      ? ProductEditorTokens.blue
                      : ProductEditorTokens.line,
                  width: 1.5,
                ),
                boxShadow: focused
                    ? [
                        BoxShadow(
                          color: ProductEditorTokens.blue.withValues(alpha: 0.12),
                          blurRadius: 0,
                          spreadRadius: 4,
                        ),
                      ]
                    : null,
              ),
              padding: const EdgeInsets.only(left: 14, right: 6),
              child: Row(
                children: [
                  const Icon(
                    Icons.search,
                    size: 18,
                    color: ProductEditorTokens.ink3,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      focusNode: focusNode,
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: ProductEditorTokens.ink1,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        hintText: 'Search categories…',
                        hintStyle: GoogleFonts.outfit(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: ProductEditorTokens.ink4,
                        ),
                      ),
                      onSubmitted: (_) {},
                    ),
                  ),
                  Material(
                    color: ProductEditorTokens.blueTint,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: widget.onAddCategory,
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        width: 38,
                        height: 38,
                        child: const Icon(
                          Icons.add,
                          size: 18,
                          color: ProductEditorTokens.blue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          itemBuilder: (context, category) {
            return ListTile(
              dense: true,
              title: Text(
                category.name ?? '',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          },
          onSelected: _selectCategory,
          emptyBuilder: (context) => Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'No categories found',
              style: GoogleFonts.outfit(
                fontSize: 13,
                color: ProductEditorTokens.ink3,
              ),
            ),
          ),
        ),
        if (selectedName != null && selectedName.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _CategoryChip(
                label: selectedName,
                onRemove: () => widget.onCategoryChanged(null),
              ),
            ],
          ),
        ],
        if (suggestions.isNotEmpty) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              for (final category in suggestions)
                _SuggestChip(
                  label: category.name ?? '',
                  onTap: () => _selectCategory(category),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label, required this.onRemove});

  final String label;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      padding: const EdgeInsets.only(left: 13, right: 6),
      decoration: BoxDecoration(
        color: ProductEditorTokens.blueTint,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1D4ED8),
            ),
          ),
          const SizedBox(width: 7),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onRemove,
              borderRadius: BorderRadius.circular(999),
              child: SizedBox(
                width: 20,
                height: 20,
                child: const Icon(
                  Icons.close,
                  size: 13,
                  color: ProductEditorTokens.blue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuggestChip extends StatelessWidget {
  const _SuggestChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          height: 30,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: ProductEditorTokens.lineStrong,
              width: 1.5,
              style: BorderStyle.solid,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.add, size: 12, color: ProductEditorTokens.ink2),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: ProductEditorTokens.ink2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
