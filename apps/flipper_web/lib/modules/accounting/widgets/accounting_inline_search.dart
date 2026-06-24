import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_icon.dart';
import 'package:flutter/material.dart';

/// Handoff `.acc-inlsearch` — compact search in page headers.
class AccountingInlineSearch extends StatefulWidget {
  const AccountingInlineSearch({
    super.key,
    required this.hintText,
    required this.onChanged,
    this.minWidth = 230,
  });

  final String hintText;
  final ValueChanged<String> onChanged;
  final double minWidth;

  @override
  State<AccountingInlineSearch> createState() => _AccountingInlineSearchState();
}

class _AccountingInlineSearchState extends State<AccountingInlineSearch> {
  final _focusNode = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() => setState(() => _focused = _focusNode.hasFocus));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.minWidth,
      height: 40,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 13),
        decoration: BoxDecoration(
        color: AccountingTokens.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _focused ? AccountingTokens.accent : AccountingTokens.lineStrong,
          width: 1.5,
        ),
        boxShadow: _focused
            ? [
                BoxShadow(
                  color: AccountingTokens.accentTint,
                  blurRadius: 0,
                  spreadRadius: 4,
                ),
              ]
            : const [
                BoxShadow(
                  color: Color(0x0A0B1220),
                  blurRadius: 4,
                  offset: Offset(0, 1),
                ),
              ],
      ),
      child: Row(
        children: [
          const AccountingIcon(
            icon: AccIcon.search,
            size: 16,
            color: AccountingTokens.ink3,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: TextField(
              focusNode: _focusNode,
              style: AccountingTokens.sans(fontSize: 13.5, color: AccountingTokens.ink1),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: widget.hintText,
                hintStyle: AccountingTokens.sans(
                  fontSize: 13.5,
                  color: AccountingTokens.ink3,
                ),
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: widget.onChanged,
            ),
          ),
        ],
      ),
    ),
    );
  }
}
