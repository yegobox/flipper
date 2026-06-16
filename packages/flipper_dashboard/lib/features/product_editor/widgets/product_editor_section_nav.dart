import 'package:flipper_dashboard/features/product_editor/product_editor_tokens.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductEditorSectionDef {
  const ProductEditorSectionDef({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isFilled,
  });

  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isFilled;
}

class ProductEditorSectionNav extends StatelessWidget {
  const ProductEditorSectionNav({
    super.key,
    required this.sections,
    required this.activeId,
    required this.onSectionTap,
    this.horizontal = false,
  });

  final List<ProductEditorSectionDef> sections;
  final String activeId;
  final ValueChanged<String> onSectionTap;
  final bool horizontal;

  @override
  Widget build(BuildContext context) {
    if (horizontal) {
      return Container(
        decoration: const BoxDecoration(
          color: ProductEditorTokens.surface,
          border: Border(bottom: BorderSide(color: ProductEditorTokens.line)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final s in sections) ...[
                _NavItem(
                  section: s,
                  active: activeId == s.id,
                  onTap: () => onSectionTap(s.id),
                  compact: true,
                ),
                const SizedBox(width: 6),
              ],
            ],
          ),
        ),
      );
    }

    return Container(
      width: ProductEditorTokens.navWidth,
      decoration: const BoxDecoration(
        color: ProductEditorTokens.surface,
        border: Border(right: BorderSide(color: ProductEditorTokens.line)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 26, 16, 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'SECTIONS',
              style: GoogleFonts.outfit(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
                color: ProductEditorTokens.ink3,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView(
              children: [
                for (final s in sections)
                  _NavItem(
                    section: s,
                    active: activeId == s.id,
                    onTap: () => onSectionTap(s.id),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.section,
    required this.active,
    required this.onTap,
    this.compact = false,
  });

  final ProductEditorSectionDef section;
  final bool active;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Material(
        color: active ? ProductEditorTokens.blueTint : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          hoverColor: active ? null : ProductEditorTokens.surface2,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 12,
              vertical: compact ? 8 : 11,
            ),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: active
                        ? ProductEditorTokens.blue
                        : ProductEditorTokens.surface2,
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(
                      color: active
                          ? ProductEditorTokens.blue
                          : ProductEditorTokens.line,
                    ),
                  ),
                  child: Icon(
                    section.icon,
                    size: 16,
                    color: active ? Colors.white : ProductEditorTokens.ink3,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        section.title,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: active
                              ? const Color(0xFF1D4ED8)
                              : ProductEditorTokens.ink2,
                        ),
                      ),
                      if (!compact)
                        Text(
                          section.subtitle,
                          style: GoogleFonts.outfit(
                            fontSize: 11.5,
                            color: ProductEditorTokens.ink4,
                          ),
                        ),
                    ],
                  ),
                ),
                if (!compact)
                  Opacity(
                    opacity: section.isFilled ? 1 : 0,
                    child: const Icon(
                      Icons.check,
                      size: 16,
                      color: ProductEditorTokens.gain,
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
