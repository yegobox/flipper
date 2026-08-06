import 'package:flipper_dashboard/features/product_editor/product_editor_tokens.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/all_providers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Handoff `.pe-search` + `.pe-chip` + `.pe-suggest` category picker.
/// Wired to single-category selection (existing product editor logic).
///
/// Results render INLINE, deliberately. This was a `TypeAheadField`, whose
/// Floater anchors an `OverlayPortal` to the search box and re-shows it whenever
/// the anchor's geometry changes. Under DevicePreview (debug) the whole app sits
/// inside a `LayoutBuilder`, so rebuilds run during `performLayout`; inserting an
/// overlay's deferred child there throws from
/// `_RenderTheater._addDeferredChild`, and since that method has no try/finally
/// its `_skipMarkNeedsLayout` guard latches `true` — after which EVERY overlay
/// insert in the app asserts, once per frame, forever.
/// An inline list has no overlay, so that failure mode is unreachable here. It
/// also reads better for non-technical users: the choices are simply on the
/// page, not in a floating panel that can land off-screen.
class ProductEditorCategoryPicker extends ConsumerStatefulWidget {
  const ProductEditorCategoryPicker({
    super.key,
    required this.selectedCategoryId,
    required this.selectedCategoryName,
    required this.onCategoryChanged,
    required this.onAddCategory,
    this.onCreateCategory,
  });

  final String? selectedCategoryId;
  final String? selectedCategoryName;
  final ValueChanged<String?> onCategoryChanged;
  final VoidCallback onAddCategory;

  /// Opens the create-category flow and selects whatever comes back, optionally
  /// pre-filled with what the user typed in the search box. When null, falls
  /// back to [onAddCategory].
  final Future<void> Function(String? initialName)? onCreateCategory;

  @override
  ConsumerState<ProductEditorCategoryPicker> createState() =>
      _ProductEditorCategoryPickerState();
}

class _ProductEditorCategoryPickerState
    extends ConsumerState<ProductEditorCategoryPicker> {
  static const _maxRows = 6;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _query = '';

  /// Whether the inline results are open.
  ///
  /// Deliberately NOT derived from [_searchFocusNode.hasFocus]: a **mouse**
  /// press outside a focused TextField makes Flutter unfocus it on POINTER DOWN
  /// (EditableTextTapOutsideAction). Focus-gating the list therefore unmounted
  /// the row under the cursor before the pointer-up, so clicking a result did
  /// nothing at all — with a mouse. Touch taps were unaffected, which is why
  /// widget tests using the default touch pointer passed.
  bool _browsing = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onQueryChanged);
    _searchFocusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onQueryChanged);
    _searchFocusNode.removeListener(_onFocusChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onQueryChanged() {
    if (!mounted) return;
    final next = _searchController.text;
    if (next != _query) setState(() => _query = next);
  }

  void _onFocusChanged() {
    if (!mounted) return;
    // Focus only ever OPENS the list (and repaints the focus ring). Losing focus
    // must not close it — see [_browsing].
    setState(() {
      if (_searchFocusNode.hasFocus) _browsing = true;
    });
  }

  void _selectCategory(Category category) {
    widget.onCategoryChanged(category.id);
    _searchController.clear();
    setState(() => _browsing = false);
    _searchFocusNode.unfocus();
  }

  /// Starts the create flow. [initialName] carries the text the user already
  /// typed so they never have to type the name twice.
  void _startCreate([String? initialName]) {
    setState(() => _browsing = false);
    _searchFocusNode.unfocus();
    final create = widget.onCreateCategory;
    if (create != null) {
      create(initialName);
    } else {
      widget.onAddCategory();
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoryProvider);
    final all = categoriesAsync.maybeWhen(
      data: (categories) =>
          categories.where((c) => (c.name ?? '').trim().isNotEmpty).toList(),
      orElse: () => <Category>[],
    );

    final selectedName = widget.selectedCategoryName?.trim();
    final hasSelection =
        widget.selectedCategoryId != null &&
        (selectedName?.isNotEmpty ?? false);

    final query = _query.trim();
    final lowerQuery = query.toLowerCase();
    final matches = query.isEmpty
        ? all
        : all
              .where((c) => (c.name ?? '').toLowerCase().contains(lowerQuery))
              .toList();
    final exactMatch = all.any(
      (c) => (c.name ?? '').trim().toLowerCase() == lowerQuery,
    );

    // The list is open while the user is working the field; otherwise the chips
    // below carry the quick choices.
    final listOpen = _browsing || query.isNotEmpty;
    final visible = matches.take(_maxRows).toList();
    final hiddenCount = matches.length - visible.length;

    final chips = all
        .where((c) => c.id != widget.selectedCategoryId)
        .take(_maxRows)
        .toList();

    // The field AND the results share one region, so a click on a result is
    // "inside" and never dismisses the list. A click genuinely elsewhere closes
    // it. onTapOutside fires on pointer down, which is exactly why the list
    // must not also be focus-gated.
    return TapRegion(
      onTapOutside: (_) {
        if (_browsing) setState(() => _browsing = false);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SearchRow(
            controller: _searchController,
            focusNode: _searchFocusNode,
            hasSelection: hasSelection,
            onNewTap: () => _startCreate(),
          ),
          if (listOpen) ...[
            const SizedBox(height: 8),
            _ResultsList(
              categories: visible,
              hiddenCount: hiddenCount,
              query: query,
              showCreate: query.isNotEmpty && !exactMatch,
              onSelect: _selectCategory,
              onCreate: () => _startCreate(query.isEmpty ? null : query),
            ),
          ],
          const SizedBox(height: 12),
          if (hasSelection)
            _SelectedCategoryBanner(
              label: selectedName!,
              onRemove: () => widget.onCategoryChanged(null),
            )
          else
            const _NoCategoryYetBanner(),
          if (!listOpen && chips.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              hasSelection ? 'Switch to' : 'Or pick one of yours',
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: ProductEditorTokens.ink3,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 7,
              runSpacing: 7,
              children: [
                for (final category in chips)
                  _SuggestChip(
                    label: category.name ?? '',
                    onTap: () => _selectCategory(category),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _SearchRow extends StatelessWidget {
  const _SearchRow({
    required this.controller,
    required this.focusNode,
    required this.hasSelection,
    required this.onNewTap,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool hasSelection;
  final VoidCallback onNewTap;

  @override
  Widget build(BuildContext context) {
    final focused = focusNode.hasFocus;
    return Container(
      height: ProductEditorTokens.fieldHeight,
      decoration: BoxDecoration(
        color: ProductEditorTokens.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: focused ? ProductEditorTokens.blue : ProductEditorTokens.line,
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
          const Icon(Icons.search, size: 18, color: ProductEditorTokens.ink3),
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
                hintText: hasSelection
                    ? 'Search to change category…'
                    : 'Search categories…',
                hintStyle: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: ProductEditorTokens.ink4,
                ),
              ),
            ),
          ),
          _NewCategoryButton(onTap: onNewTap),
        ],
      ),
    );
  }
}

/// Inline results. Capped at a handful of rows so it never needs its own
/// scrollable inside the editor sheet's scroll view.
class _ResultsList extends StatelessWidget {
  const _ResultsList({
    required this.categories,
    required this.hiddenCount,
    required this.query,
    required this.showCreate,
    required this.onSelect,
    required this.onCreate,
  });

  final List<Category> categories;
  final int hiddenCount;
  final String query;
  final bool showCreate;
  final ValueChanged<Category> onSelect;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ProductEditorTokens.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ProductEditorTokens.line, width: 1.5),
      ),
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (categories.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Text(
                query.isEmpty
                    ? 'You have no categories yet'
                    : 'Nothing matches "$query"',
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  color: ProductEditorTokens.ink3,
                ),
              ),
            )
          else
            for (final category in categories)
              _ResultRow(
                label: category.name ?? '',
                onTap: () => onSelect(category),
              ),
          if (hiddenCount > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              child: Text(
                '$hiddenCount more — keep typing to narrow it down',
                style: GoogleFonts.outfit(
                  fontSize: 11.5,
                  color: ProductEditorTokens.ink4,
                ),
              ),
            ),
          if (showCreate) ...[
            const Divider(
              height: 9,
              thickness: 1,
              color: ProductEditorTokens.lineSoft,
            ),
            _ResultRow(
              label: 'Create "$query"',
              icon: Icons.add_circle_outline,
              emphasised: true,
              onTap: onCreate,
            ),
          ],
        ],
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({
    required this.label,
    required this.onTap,
    this.icon = Icons.sell_outlined,
    this.emphasised = false,
  });

  final String label;
  final VoidCallback onTap;
  final IconData icon;
  final bool emphasised;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          child: Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: emphasised
                    ? ProductEditorTokens.blue
                    : ProductEditorTokens.ink3,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: emphasised ? FontWeight.w700 : FontWeight.w600,
                    color: emphasised
                        ? ProductEditorTokens.blue
                        : ProductEditorTokens.ink1,
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

/// Shows, in plain words, which category the product will be filed under.
class _SelectedCategoryBanner extends StatelessWidget {
  const _SelectedCategoryBanner({required this.label, required this.onRemove});

  final String label;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: ProductEditorTokens.blueTint,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: ProductEditorTokens.blue.withValues(alpha: 0.35),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            size: 18,
            color: ProductEditorTokens.blue,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Filed under',
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                    color: ProductEditorTokens.blue,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  label,
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1D4ED8),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Semantics(
            button: true,
            label: 'Remove category',
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onRemove,
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  child: Text(
                    'Remove',
                    style: GoogleFonts.outfit(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: ProductEditorTokens.blue,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoCategoryYetBanner extends StatelessWidget {
  const _NoCategoryYetBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: ProductEditorTokens.surface2,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ProductEditorTokens.line, width: 1.5),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.radio_button_unchecked,
            size: 18,
            color: ProductEditorTokens.ink4,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'No category chosen yet — search above or create a new one.',
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: ProductEditorTokens.ink3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Labelled "New" action. A bare `+` next to a search box reads as "add what I
/// typed"; the word makes it unmistakable that this creates a category.
class _NewCategoryButton extends StatelessWidget {
  const _NewCategoryButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Create a new category',
      child: Material(
        color: ProductEditorTokens.blueTint,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.add,
                  size: 16,
                  color: ProductEditorTokens.blue,
                ),
                const SizedBox(width: 4),
                Text(
                  'New',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: ProductEditorTokens.blue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Tap-to-choose shortcut for a category the business already has. Uses a tag
/// icon (not `+`) so it never reads as "create".
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
              const Icon(
                Icons.sell_outlined,
                size: 12,
                color: ProductEditorTokens.ink2,
              ),
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
