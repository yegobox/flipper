import 'package:flipper_dashboard/features/product_editor/product_editor_colors.dart';
import 'package:flipper_dashboard/features/product_editor/product_editor_tokens.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductEditorColorPicker extends StatefulWidget {
  const ProductEditorColorPicker({
    super.key,
    required this.color,
    required this.onColorChanged,
  });

  final Color color;
  final ValueChanged<Color> onColorChanged;

  @override
  State<ProductEditorColorPicker> createState() =>
      _ProductEditorColorPickerState();
}

class _ProductEditorColorPickerState extends State<ProductEditorColorPicker> {
  final LayerLink _link = LayerLink();
  OverlayEntry? _overlay;
  String _hueName = defaultProductEditorHue().name;
  int _shadeIdx = 5;

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _overlay?.remove();
    _overlay = null;
  }

  void _togglePopover() {
    if (_overlay != null) {
      _removeOverlay();
      return;
    }
    _overlay = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _removeOverlay,
              behavior: HitTestBehavior.translucent,
            ),
          ),
          CompositedTransformFollower(
            link: _link,
            targetAnchor: Alignment.bottomRight,
            followerAnchor: Alignment.topRight,
            offset: const Offset(0, 8),
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(20),
              color: ProductEditorTokens.surface,
              child: Container(
                width: 320,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: ProductEditorTokens.line),
                ),
                child: _buildPopoverContent(),
              ),
            ),
          ),
        ],
      ),
    );
    Overlay.of(context).insert(_overlay!);
  }

  Widget _buildPopoverContent() {
    final hue = productEditorHues.firstWhere(
      (h) => h.name == _hueName,
      orElse: () => defaultProductEditorHue(),
    );
    final shades = makeProductEditorShades(hue);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select color shade',
          style: GoogleFonts.outfit(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: ProductEditorTokens.ink2,
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final h in productEditorHues)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _hueName = h.name;
                    _shadeIdx = 5;
                    widget.onColorChanged(makeProductEditorShades(h)[5]);
                  });
                },
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: makeProductEditorShades(h)[5],
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _hueName == h.name
                          ? ProductEditorTokens.ink1
                          : ProductEditorTokens.line,
                      width: _hueName == h.name ? 2 : 1,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'SHADES',
          style: GoogleFonts.outfit(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.6,
            color: ProductEditorTokens.ink3,
          ),
        ),
        const SizedBox(height: 9),
        Row(
          children: [
            for (var i = 0; i < shades.length; i++)
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _shadeIdx = i;
                      widget.onColorChanged(shades[i]);
                    });
                    _removeOverlay();
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: i < shades.length - 1 ? 6 : 0),
                    height: 24,
                    decoration: BoxDecoration(
                      color: shades[i],
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _shadeIdx == i
                            ? ProductEditorTokens.ink1
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: _shadeIdx == i
                        ? const Icon(Icons.check, size: 12, color: Colors.white)
                        : null,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D102040),
                offset: Offset(0, 1),
                blurRadius: 2,
              ),
            ],
          ),
          child: Icon(
            Icons.palette_outlined,
            color: widget.color.computeLuminance() > 0.5
                ? ProductEditorTokens.ink1
                : Colors.white,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$_hueName · shade ${_shadeIdx + 1}',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: ProductEditorTokens.ink1,
                ),
              ),
              Text(
                "Used as the product's swatch across POS & reports",
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: ProductEditorTokens.ink3,
                ),
              ),
            ],
          ),
        ),
        CompositedTransformTarget(
          link: _link,
          child: Material(
            color: ProductEditorTokens.blueTint,
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              onTap: _togglePopover,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                height: 42,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.palette, size: 16, color: ProductEditorTokens.blue),
                    const SizedBox(width: 8),
                    Text(
                      'Choose color',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: ProductEditorTokens.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
