import 'package:flipper_dashboard/cashbook_form_rules.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A category the sheet can match a typed name against.
typedef CashbookCategoryRef = ({String id, String name});

/// Opens the "New category" bottom sheet and resolves to the id of the
/// category to select: an existing one when the typed name already exists,
/// otherwise the one [onCreate] made. `null` when dismissed.
Future<String?> showCashbookNewCategorySheet({
  required BuildContext context,
  required bool isIncome,
  required List<CashbookCategoryRef> existing,
  required Future<String> Function(String name) onCreate,
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    builder: (_) => CashbookNewCategorySheet(
      isIncome: isIncome,
      existing: existing,
      onCreate: onCreate,
    ),
  );
}

class CashbookNewCategorySheet extends StatefulWidget {
  const CashbookNewCategorySheet({
    super.key,
    required this.isIncome,
    required this.existing,
    required this.onCreate,
  });

  final bool isIncome;
  final List<CashbookCategoryRef> existing;
  final Future<String> Function(String name) onCreate;

  @override
  State<CashbookNewCategorySheet> createState() =>
      _CashbookNewCategorySheetState();
}

class _CashbookNewCategorySheetState extends State<CashbookNewCategorySheet> {
  static const int _maxLength = 30;
  static const Color _ink = Color(0xFF111827);
  static const Color _muted = Color(0xFF6B7280);
  static const Color _fieldFill = Color(0xFFF5F4EE);
  static const Color _border = Color(0xFFE5E7EB);

  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _saving = false;
  String? _error;

  Color get _accent =>
      widget.isIncome ? const Color(0xFF16A34A) : const Color(0xFFDC2626);
  Color get _accentSurface =>
      widget.isIncome ? const Color(0xFFE8F8EF) : const Color(0xFFFDECEC);

  String get _typed => _controller.text.trim();

  CashbookCategoryRef? get _match =>
      findCashbookCategoryByName(widget.existing, _typed, name: (c) => c.name);

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_error != null) _error = null;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_saving || _typed.isEmpty) return;
    final match = _match;
    if (match != null) {
      HapticFeedback.selectionClick();
      Navigator.of(context).pop(match.id);
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final id = await widget.onCreate(_typed);
      if (!mounted) return;
      HapticFeedback.mediumImpact();
      Navigator.of(context).pop(id);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error =
            'Couldn\'t save this category. Check your connection and try again.';
      });
    }
  }

  void _useSuggestion(String name) {
    HapticFeedback.selectionClick();
    _controller.value = TextEditingValue(
      text: name,
      selection: TextSelection.collapsed(offset: name.length),
    );
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final suggestions = cashbookCategorySuggestions(
      isIncome: widget.isIncome,
      existingNames: widget.existing.map((c) => c.name),
    );

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Material(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            clipBehavior: Clip.antiAlias,
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD1D5DB),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    _buildHeader(theme),
                    const SizedBox(height: 22),
                    _buildField(theme, suggestions),
                    _buildFeedback(),
                    if (suggestions.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Text(
                        'QUICK PICKS',
                        style: theme.textTheme.labelSmall?.copyWith(
                          letterSpacing: 1.1,
                          fontWeight: FontWeight.w600,
                          color: _muted,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final s in suggestions) _suggestionChip(s),
                        ],
                      ),
                    ],
                    const SizedBox(height: 24),
                    _buildPrimaryButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _accentSurface,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(Icons.sell_outlined, color: _accent, size: 24),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'New category',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: _ink,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                widget.isIncome
                    ? 'Group money coming in'
                    : 'Group money going out',
                style: theme.textTheme.bodyMedium?.copyWith(color: _muted),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          tooltip: 'Close',
          style: IconButton.styleFrom(
            backgroundColor: const Color(0xFFF3F4F6),
            foregroundColor: _ink,
          ),
          icon: const Icon(Icons.close_rounded, size: 20),
        ),
      ],
    );
  }

  Widget _buildField(ThemeData theme, List<String> suggestions) {
    OutlineInputBorder border(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: color, width: width),
        );

    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      autofocus: true,
      enabled: !_saving,
      maxLength: _maxLength,
      textCapitalization: TextCapitalization.sentences,
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => _submit(),
      cursorColor: _accent,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: _ink,
      ),
      decoration: InputDecoration(
        labelText: 'Category name',
        hintText: suggestions.isNotEmpty
            ? 'e.g. ${suggestions.first}'
            : 'Type a name',
        hintStyle: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w400,
          color: const Color(0xFF9CA3AF),
        ),
        labelStyle: const TextStyle(color: _muted),
        floatingLabelStyle: TextStyle(
          color: _accent,
          fontWeight: FontWeight.w600,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        filled: true,
        fillColor: _fieldFill,
        counterText: '',
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        prefixIcon: Icon(Icons.label_outline_rounded, color: _muted),
        suffixIcon: _controller.text.isEmpty || _saving
            ? null
            : IconButton(
                tooltip: 'Clear',
                icon: const Icon(Icons.cancel_rounded, size: 20),
                color: const Color(0xFF9CA3AF),
                onPressed: _controller.clear,
              ),
        border: border(_border),
        enabledBorder: border(_border),
        disabledBorder: border(_border),
        focusedBorder: border(_accent, 1.6),
      ),
    );
  }

  /// One line under the field: an error, the duplicate notice, or the counter.
  Widget _buildFeedback() {
    final match = _match;
    final Widget child;
    if (_error != null) {
      child = _feedbackRow(
        key: const ValueKey('error'),
        icon: Icons.error_outline_rounded,
        color: const Color(0xFFDC2626),
        text: _error!,
      );
    } else if (match != null) {
      child = _feedbackRow(
        key: const ValueKey('match'),
        icon: Icons.check_circle_outline_rounded,
        color: const Color(0xFF2563EB),
        text: '"${match.name}" already exists. We\'ll use it.',
      );
    } else {
      child = Align(
        key: const ValueKey('count'),
        alignment: Alignment.centerRight,
        child: Text(
          '${_controller.text.characters.length}/$_maxLength',
          style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 4, right: 4),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),
        child: child,
      ),
    );
  }

  Widget _feedbackRow({
    required Key key,
    required IconData icon,
    required Color color,
    required String text,
  }) {
    return Row(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _suggestionChip(String name) {
    final selected = _typed.toLowerCase() == name.toLowerCase();
    return ChoiceChip(
      label: Text(name),
      selected: selected,
      showCheckmark: false,
      onSelected: _saving ? null : (_) => _useSuggestion(name),
      labelStyle: TextStyle(
        fontWeight: FontWeight.w600,
        color: selected ? _accent : const Color(0xFF374151),
      ),
      backgroundColor: Colors.white,
      selectedColor: _accentSurface,
      side: BorderSide(color: selected ? _accent : _border),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    );
  }

  Widget _buildPrimaryButton() {
    final enabled = _typed.isNotEmpty && !_saving;
    final label = _match != null ? 'Use existing category' : 'Create category';
    return SizedBox(
      height: 54,
      child: FilledButton(
        onPressed: enabled ? _submit : null,
        style: FilledButton.styleFrom(
          backgroundColor: _accent,
          disabledBackgroundColor: const Color(0xFFE5E7EB),
          foregroundColor: Colors.white,
          disabledForegroundColor: const Color(0xFF9CA3AF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          child: _saving
              ? const SizedBox(
                  key: ValueKey('saving'),
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    color: Colors.white,
                  ),
                )
              : Text(label, key: ValueKey(label)),
        ),
      ),
    );
  }
}
