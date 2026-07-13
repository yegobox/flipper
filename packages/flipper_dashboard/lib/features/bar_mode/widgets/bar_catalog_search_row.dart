import 'dart:async';

import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_models/providers/scan_mode_provider.dart';
import 'package:flipper_models/sync/utils/pos_catalog_search.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// POS-style catalog search for bar mode (updates shared [searchStringProvider]).
class BarCatalogSearchRow extends ConsumerStatefulWidget {
  const BarCatalogSearchRow({
    super.key,
    required this.controller,
    this.hintText = 'Search products…',
  });

  final TextEditingController controller;
  final String hintText;

  @override
  ConsumerState<BarCatalogSearchRow> createState() =>
      _BarCatalogSearchRowState();
}

class _BarCatalogSearchRowState extends ConsumerState<BarCatalogSearchRow> {
  Timer? _debounce;
  bool _focused = false;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (mounted) setState(() => _focused = _focusNode.hasFocus);
    });
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(covariant BarCatalogSearchRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onTextChanged);
      widget.controller.addListener(_onTextChanged);
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    widget.controller.removeListener(_onTextChanged);
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() => _scheduleSearch(widget.controller.text);

  void _scheduleSearch(String value) {
    _debounce?.cancel();
    _debounce = Timer(posCatalogSearchDebounce, () {
      if (!mounted) return;
      final current = ref.read(searchStringProvider);
      if (current == value) return;
      ref.read(searchStringProvider.notifier).emitString(value: value);
    });
  }

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
              onChanged: _scheduleSearch,
            ),
          ),
        ],
      ),
    );
  }
}
