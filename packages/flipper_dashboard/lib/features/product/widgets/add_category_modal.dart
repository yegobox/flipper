import 'package:flipper_dashboard/features/product_editor/product_editor_tokens.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/all_providers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';

class AddCategoryModal extends StatelessWidget {
  const AddCategoryModal({Key? key, this.initialName}) : super(key: key);

  /// Pre-fills the name field — used when the user typed a category that does
  /// not exist yet and tapped "Create <name>".
  final String? initialName;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductViewModel>.nonReactive(
      builder: (context, model, child) =>
          _AddCategoryForm(model: model, initialName: initialName),
      viewModelBuilder: () => ProductViewModel(),
    );
  }
}

class _AddCategoryForm extends ConsumerStatefulWidget {
  const _AddCategoryForm({required this.model, this.initialName});

  final ProductViewModel model;
  final String? initialName;

  @override
  ConsumerState<_AddCategoryForm> createState() => _AddCategoryFormState();
}

class _AddCategoryFormState extends ConsumerState<_AddCategoryForm> {
  late final TextEditingController _nameController;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.initialName?.trim() ?? '',
    );
    _nameController.addListener(_onNameChanged);
  }

  @override
  void dispose() {
    _nameController.removeListener(_onNameChanged);
    _nameController.dispose();
    super.dispose();
  }

  void _onNameChanged() {
    if (mounted) setState(() => _error = null);
  }

  /// An existing category with the same (case-insensitive) name, if any.
  /// Offering it beats creating "Drinks" three times over.
  Category? _duplicateOf(List<Category> categories, String name) {
    final needle = name.trim().toLowerCase();
    if (needle.isEmpty) return null;
    for (final category in categories) {
      if ((category.name ?? '').trim().toLowerCase() == needle) return category;
    }
    return null;
  }

  Future<void> _create() async {
    final name = _nameController.text.trim();
    if (name.length < 2) {
      setState(() => _error = 'Type at least 2 characters.');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      widget.model.setCategoryName(name: name);
      final created = await widget.model.createCategory();
      if (!mounted) return;
      if (created == null) {
        setState(() {
          _saving = false;
          _error = 'Could not create the category. Please try again.';
        });
        return;
      }
      Navigator.of(context).pop(created);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = 'Could not create the category. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories =
        ref.watch(categoryProvider).value ?? const <Category>[];
    final typedName = _nameController.text.trim();
    final duplicate = _duplicateOf(categories, typedName);
    final canCreate = typedName.length >= 2 && duplicate == null && !_saving;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: ProductEditorTokens.blueTint,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.sell_outlined,
                    size: 20,
                    color: ProductEditorTokens.blue,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'New category',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: ProductEditorTokens.ink1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'A category groups similar products together.',
                        style: GoogleFonts.outfit(
                          fontSize: 12.5,
                          color: ProductEditorTokens.ink3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Text(
              'Category name',
              style: GoogleFonts.outfit(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: ProductEditorTokens.ink2,
              ),
            ),
            const SizedBox(height: 7),
            TextField(
              controller: _nameController,
              autofocus: true,
              enabled: !_saving,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) {
                if (canCreate) _create();
              },
              style: GoogleFonts.outfit(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: ProductEditorTokens.ink1,
              ),
              decoration: InputDecoration(
                hintText: 'e.g. Drinks, Bread, Airtime',
                hintStyle: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: ProductEditorTokens.ink4,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: ProductEditorTokens.line,
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: ProductEditorTokens.blue,
                    width: 1.5,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: ProductEditorTokens.line,
                    width: 1.5,
                  ),
                ),
              ),
            ),
            if (duplicate != null) ...[
              const SizedBox(height: 12),
              _NoticeRow(
                icon: Icons.info_outline,
                color: ProductEditorTokens.blue,
                message: '"${duplicate.name}" already exists.',
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 46,
                child: FilledButton.icon(
                  onPressed: _saving
                      ? null
                      : () => Navigator.of(context).pop(duplicate),
                  icon: const Icon(Icons.check, size: 18),
                  label: Text(
                    'Use "${duplicate.name}"',
                    overflow: TextOverflow.ellipsis,
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: ProductEditorTokens.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
            if (_error != null) ...[
              const SizedBox(height: 12),
              _NoticeRow(
                icon: Icons.error_outline,
                color: ProductEditorTokens.loss,
                message: _error!,
              ),
            ],
            const SizedBox(height: 22),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _saving ? null : () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    foregroundColor: ProductEditorTokens.ink2,
                  ),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 46,
                  child: FilledButton(
                    onPressed: canCreate ? _create : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: ProductEditorTokens.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _saving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Create category',
                            style: GoogleFonts.outfit(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NoticeRow extends StatelessWidget {
  const _NoticeRow({
    required this.icon,
    required this.color,
    required this.message,
  });

  final IconData icon;
  final Color color;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 15, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            message,
            style: GoogleFonts.outfit(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

/// Opens the create-category dialog.
///
/// Resolves to the category the user ended up with — newly created, or an
/// existing one they chose to reuse — or null when they cancelled. Callers that
/// only need the side effect can ignore the result.
Future<Category?> showAddCategoryModal(
  BuildContext context, {
  String? initialName,
}) async {
  return showDialog<Category>(
    context: context,
    builder: (context) => AddCategoryModal(initialName: initialName),
  );
}
