import 'package:flipper_dashboard/features/incoming_orders/om_tokens.dart';
import 'package:flutter/material.dart';

class OmSegOption<T> {
  const OmSegOption({
    required this.value,
    required this.label,
    this.icon,
  });

  final T value;
  final String label;
  final IconData? icon;
}

/// Sliding-thumb segmented control matching handoff `.seg` / `.seg-lg`.
class OmSegmented<T> extends StatefulWidget {
  const OmSegmented({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
    this.large = false,
  });

  final T value;
  final List<OmSegOption<T>> options;
  final ValueChanged<T> onChanged;
  final bool large;

  @override
  State<OmSegmented<T>> createState() => _OmSegmentedState<T>();
}

class _OmSegmentedState<T> extends State<OmSegmented<T>> {
  final GlobalKey _trackKey = GlobalKey();
  final List<GlobalKey> _btnKeys = [];
  double _thumbLeft = 4;
  double _thumbWidth = 0;

  @override
  void initState() {
    super.initState();
    _ensureKeys();
    WidgetsBinding.instance.addPostFrameCallback((_) => _recalc());
  }

  @override
  void didUpdateWidget(OmSegmented<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _ensureKeys();
    WidgetsBinding.instance.addPostFrameCallback((_) => _recalc());
  }

  void _ensureKeys() {
    while (_btnKeys.length < widget.options.length) {
      _btnKeys.add(GlobalKey());
    }
  }

  void _recalc() {
    final trackBox =
        _trackKey.currentContext?.findRenderObject() as RenderBox?;
    if (trackBox == null || !trackBox.hasSize) return;

    final idx = widget.options.indexWhere((o) => o.value == widget.value);
    if (idx < 0 || idx >= _btnKeys.length) return;

    final btnBox =
        _btnKeys[idx].currentContext?.findRenderObject() as RenderBox?;
    if (btnBox == null || !btnBox.hasSize) return;

    final trackOrigin = trackBox.localToGlobal(Offset.zero);
    final btnOrigin = btnBox.localToGlobal(Offset.zero);
    final left = btnOrigin.dx - trackOrigin.dx;
    if (!mounted) return;
    setState(() {
      _thumbLeft = left;
      _thumbWidth = btnBox.size.width;
    });
  }

  @override
  Widget build(BuildContext context) {
    final padding = widget.large ? 5.0 : 4.0;
    final radius = widget.large ? 14.0 : 12.0;
    final thumbRadius = widget.large ? 11.0 : 9.0;
    final fontSize = widget.large ? 15.0 : 14.0;
    final iconSize = widget.large ? 18.0 : 16.0;
    final btnPadV = widget.large ? 13.0 : 8.0;
    final btnPadH = widget.large ? 0.0 : 20.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _recalc());
        return Container(
          key: _trackKey,
          width: widget.large ? double.infinity : null,
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: OmTokens.surface3,
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Stack(
            children: [
              if (_thumbWidth > 0)
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 220),
                  curve: const Cubic(0.3, 0.7, 0.4, 1),
                  left: _thumbLeft,
                  top: 0,
                  bottom: 0,
                  width: _thumbWidth,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: OmTokens.surface,
                      borderRadius: BorderRadius.circular(thumbRadius),
                      boxShadow: OmTokens.shadowSm,
                    ),
                  ),
                ),
              Row(
                mainAxisSize:
                    widget.large ? MainAxisSize.max : MainAxisSize.min,
                children: [
                  for (var i = 0; i < widget.options.length; i++) ...[
                    if (i > 0) const SizedBox(width: 4),
                    if (widget.large)
                      Expanded(
                        child: _SegButton(
                          key: _btnKeys[i],
                          option: widget.options[i],
                          selected: widget.options[i].value == widget.value,
                          fontSize: fontSize,
                          iconSize: iconSize,
                          padV: btnPadV,
                          padH: btnPadH,
                          expand: true,
                          onTap: () =>
                              widget.onChanged(widget.options[i].value),
                        ),
                      )
                    else
                      _SegButton(
                        key: _btnKeys[i],
                        option: widget.options[i],
                        selected: widget.options[i].value == widget.value,
                        fontSize: fontSize,
                        iconSize: iconSize,
                        padV: btnPadV,
                        padH: btnPadH,
                        expand: false,
                        onTap: () =>
                            widget.onChanged(widget.options[i].value),
                      ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SegButton<T> extends StatelessWidget {
  const _SegButton({
    super.key,
    required this.option,
    required this.selected,
    required this.fontSize,
    required this.iconSize,
    required this.padV,
    required this.padH,
    required this.expand,
    required this.onTap,
  });

  final OmSegOption<T> option;
  final bool selected;
  final double fontSize;
  final double iconSize;
  final double padV;
  final double padH;
  final bool expand;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: padV, horizontal: padH),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
            children: [
              if (option.icon != null) ...[
                Icon(
                  option.icon,
                  size: iconSize,
                  color: selected ? OmTokens.accentStrong : OmTokens.ink2,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                option.label,
                style: OmTokens.text(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w700,
                  color: selected ? OmTokens.accentStrong : OmTokens.ink2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
