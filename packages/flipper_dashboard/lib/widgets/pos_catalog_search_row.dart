import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_dashboard/widgets/pos_add_product_button.dart';
import 'package:flipper_models/providers/scan_mode_provider.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Handoff-style catalog search + barcode scan button.
class PosCatalogSearchRow extends ConsumerWidget {
  const PosCatalogSearchRow({
    super.key,
    required this.controller,
    this.hintText = 'Search products…',
  });

  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: _PosSearchField(
            controller: controller,
            hintText: hintText,
            onChanged: (text) {
              ref.read(searchStringProvider.notifier).emitString(value: text);
            },
          ),
        ),
        const SizedBox(width: 12),
        _PosScanButton(
          isActive: ref.watch(autoAddSearchProvider),
          onPressed: () => ref.read(autoAddSearchProvider.notifier).toggle(),
        ),
        const SizedBox(width: 12),
        const PosAddProductButton(),
      ],
    );
  }
}

class _PosSearchField extends StatefulWidget {
  const _PosSearchField({
    required this.controller,
    required this.hintText,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;

  @override
  State<_PosSearchField> createState() => _PosSearchFieldState();
}

class _PosSearchFieldState extends State<_PosSearchField> {
  final _focusNode = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (mounted) setState(() => _focused = _focusNode.hasFocus);
    });
    widget.controller.addListener(_syncSearch);
  }

  @override
  void didUpdateWidget(covariant _PosSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_syncSearch);
      widget.controller.addListener(_syncSearch);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_syncSearch);
    _focusNode.dispose();
    super.dispose();
  }

  void _syncSearch() => widget.onChanged(widget.controller.text);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PosTokens.focusTransition,
      curve: Curves.ease,
      height: PosTokens.searchFieldHeight,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: PosTokens.surface,
        borderRadius: BorderRadius.circular(PosTokens.radiusMd),
        border: Border.all(
          color: _focused ? PosTokens.blue : PosTokens.line,
          width: 1.5,
        ),
        boxShadow: _focused
            ? [
                BoxShadow(
                  color: PosTokens.blueTint.withValues(alpha: 0.9),
                  spreadRadius: 4,
                  blurRadius: 0,
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          const Icon(
            FluentIcons.search_24_regular,
            size: 20,
            color: PosTokens.ink3,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              style: const TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w500,
                color: PosTokens.ink1,
              ),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: widget.hintText,
                hintStyle: const TextStyle(
                  color: PosTokens.ink4,
                  fontWeight: FontWeight.w400,
                ),
              ),
              onChanged: widget.onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _PosScanButton extends StatelessWidget {
  const _PosScanButton({required this.onPressed, required this.isActive});

  final VoidCallback onPressed;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isActive ? PosTokens.blueTint : PosTokens.surface,
      borderRadius: BorderRadius.circular(PosTokens.radiusMd),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(PosTokens.radiusMd),
        hoverColor: PosTokens.blueTint,
        child: Ink(
          width: PosTokens.scanButtonSize,
          height: PosTokens.scanButtonSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(PosTokens.radiusMd),
            border: Border.all(
              color: isActive ? PosTokens.blue : PosTokens.line,
              width: 1.5,
            ),
          ),
          child: Icon(
            isActive
                ? FluentIcons.barcode_scanner_24_filled
                : FluentIcons.barcode_scanner_24_regular,
            size: 22,
            color: isActive ? PosTokens.blue : PosTokens.ink2,
          ),
        ),
      ),
    );
  }
}
