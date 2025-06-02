import 'package:flutter/material.dart';

class TaxConfigSwitchTile extends StatefulWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final IconData? icon;

  const TaxConfigSwitchTile({
    Key? key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
    this.icon,
  }) : super(key: key);

  @override
  State<TaxConfigSwitchTile> createState() => _TaxConfigSwitchTileState();
}

class _TaxConfigSwitchTileState extends State<TaxConfigSwitchTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: MouseRegion(
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            child: GestureDetector(
              onTapDown: (_) {
                setState(() => _isPressed = true);
                _animationController.forward();
              },
              onTapUp: (_) {
                setState(() => _isPressed = false);
                _animationController.reverse();
                widget.onChanged(!widget.value);
              },
              onTapCancel: () {
                setState(() => _isPressed = false);
                _animationController.reverse();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                  color: _getBackgroundColor(isDark),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getBorderColor(isDark),
                    width: 1,
                  ),
                  boxShadow: _isHovered
                      ? [
                          BoxShadow(
                            color: Colors.black.withAlpha(isDark ? 76 : 26),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withAlpha(isDark ? 51 : 13),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      if (widget.icon != null) ...[
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: widget.value
                                ? const Color(0xFF0078D4)
                                    .withAlpha(26) // 0.1 opacity = 26/255
                                : Colors.grey
                                    .withAlpha(26), // 0.1 opacity = 26/255
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            widget.icon,
                            color: widget.value
                                ? const Color(0xFF0078D4)
                                : Colors.grey[600],
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : Colors.black87,
                                letterSpacing: -0.2,
                              ),
                            ),
                            if (widget.subtitle != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                widget.subtitle!,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      _FluentSwitch(
                        value: widget.value,
                        onChanged: widget.onChanged,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getBackgroundColor(bool isDark) {
    if (_isPressed) {
      return isDark ? const Color(0xFF2D2D30) : const Color(0xFFF0F0F0);
    }
    if (_isHovered) {
      return isDark ? const Color(0xFF3C3C3C) : const Color(0xFFFAFAFA);
    }
    return isDark ? const Color(0xFF323233) : Colors.white;
  }

  Color _getBorderColor(bool isDark) {
    if (widget.value) {
      return const Color(0xFF0078D4).withAlpha(76); // 0.3 opacity = 76/255
    }
    return isDark ? const Color(0xFF484848) : const Color(0xFFE1E1E1);
  }
}

class _FluentSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _FluentSwitch({
    required this.value,
    required this.onChanged,
  });

  @override
  State<_FluentSwitch> createState() => _FluentSwitchState();
}

class _FluentSwitchState extends State<_FluentSwitch> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: widget.value,
      onChanged: widget.onChanged,
      activeColor: const Color(0xFF0078D4),
      activeTrackColor: const Color(0xFF0078D4).withAlpha(200),
      inactiveThumbColor: Colors.grey[400],
      inactiveTrackColor: Colors.grey[200],
    );
  }
}
