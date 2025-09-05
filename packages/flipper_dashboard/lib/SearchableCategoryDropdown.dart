import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_models/providers/all_providers.dart';
import 'package:flipper_models/db_model_export.dart';

class SearchableCategoryDropdown extends ConsumerStatefulWidget {
  final String? selectedValue;
  final ValueChanged<String?> onChanged;
  final VoidCallback? onAdd;
  final bool isEnabled;
  final Color? borderColor;
  final Color? textColor;

  const SearchableCategoryDropdown({
    super.key,
    this.selectedValue,
    required this.onChanged,
    this.onAdd,
    this.isEnabled = true,
    this.borderColor,
    this.textColor,
  });

  @override
  ConsumerState<SearchableCategoryDropdown> createState() =>
      _SearchableCategoryDropdownState();
}

class _SearchableCategoryDropdownState
    extends ConsumerState<SearchableCategoryDropdown> {
  TextEditingController? _controller;

  @override
  void initState() {
    super.initState();
    _updateControllerText();
  }

  @override
  void didUpdateWidget(SearchableCategoryDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedValue != widget.selectedValue) {
      _updateControllerText();
    }
  }

  void _updateControllerText() {
    if (_controller == null) return;
    
    if (widget.selectedValue == null) {
      if (_controller!.text.isNotEmpty) {
        _controller!.text = '';
      }
      return;
    }
    
    final categoryAsyncValue = ref.read(categoryProvider);
    categoryAsyncValue.whenData((categories) {
      final category = categories.firstWhere(
        (cat) => cat.id == widget.selectedValue,
        orElse: () => Category(id: '', name: ''),
      );
      final categoryName = category.name ?? '';
      if (_controller!.text != categoryName) {
        _controller!.text = categoryName;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryAsyncValue = ref.watch(categoryProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: widget.textColor ?? Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
              children: [
                TextSpan(text: "Category"),
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              TypeAheadField<Category>(
                suggestionsCallback: (search) {
                  return categoryAsyncValue.when(
                    data: (categories) {
                      if (search.isEmpty) return categories;
                      return categories.where((category) {
                        final name = category.name ?? '';
                        return name
                            .toLowerCase()
                            .contains(search.toLowerCase());
                      }).toList();
                    },
                    loading: () => <Category>[],
                    error: (_, __) => <Category>[],
                  );
                },
                builder: (context, controller, focusNode) {
                  if (_controller != controller) {
                    _controller = controller;
                    _updateControllerText();
                  }
                  return TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    enabled: widget.isEnabled,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                        left: 12,
                        top: 8,
                        bottom: 8,
                        right: widget.onAdd != null ? 88 : 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                            color: widget.borderColor ?? Colors.grey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                            color: widget.borderColor ?? Colors.grey),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      hintText: 'Search categories...',
                    ),
                  );
                },
                itemBuilder: (context, Category category) {
                  return ListTile(
                    title: Text(category.name ?? ''),
                    dense: true,
                  );
                },
                onSelected: (Category category) {
                  final categoryName = category.name ?? '';
                  if (_controller != null && _controller!.text != categoryName) {
                    _controller!.text = categoryName;
                  }
                  widget.onChanged(category.id);
                },
                emptyBuilder: (context) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'No categories found',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              if (widget.onAdd != null)
                Positioned(
                  right: 40,
                  top: 0,
                  bottom: 0,
                  child: IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: widget.isEnabled ? widget.onAdd : null,
                    tooltip: 'Add Category',
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
