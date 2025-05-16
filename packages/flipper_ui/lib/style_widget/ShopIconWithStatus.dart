import 'package:flutter/material.dart';

class ShopIconWithStatus extends StatefulWidget {
  final double width;
  final double height;
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final Color statusColor;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;
  final String? tooltip;
  final bool isLoading;

  const ShopIconWithStatus({
    Key? key,
    this.width = 120.0,
    this.height = 50.0,
    this.backgroundColor = Colors.white,
    this.borderColor = Colors.grey,
    this.iconColor = Colors.black87,
    this.statusColor = Colors.green,
    this.label = 'Shop',
    this.isActive = true,
    this.onTap,
    this.tooltip,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<ShopIconWithStatus> createState() => _ShopIconWithStatusState();
}

class _ShopIconWithStatusState extends State<ShopIconWithStatus>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: widget.onTap != null,
      label: '${widget.label} ${widget.isActive ? 'active' : 'inactive'}',
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTapDown: (_) => _controller.forward(),
          onTapUp: (_) => _controller.reverse(),
          onTapCancel: () => _controller.reverse(),
          onTap: widget.onTap,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Tooltip(
              message: widget.tooltip ?? widget.label,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: widget.width,
                height: widget.height,
                decoration: BoxDecoration(
                  color: _isHovered
                      ? widget.backgroundColor.withOpacity(0.9)
                      : widget.backgroundColor,
                  border: Border.all(
                    color: _isHovered
                        ? widget.borderColor
                        : widget.borderColor.withOpacity(0.5),
                    width: _isHovered ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(_isHovered ? 0.1 : 0.05),
                      blurRadius: _isHovered ? 15 : 10,
                      offset: Offset(0, _isHovered ? 6 : 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    if (widget.isLoading)
                      Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(widget.iconColor),
                          strokeWidth: 2,
                        ),
                      )
                    else
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.store_rounded,
                              size: widget.height * 0.4,
                              color: widget.iconColor,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.label,
                              style: TextStyle(
                                color: widget.iconColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (widget.isActive)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: const Duration(milliseconds: 300),
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: value,
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: widget.statusColor,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          widget.statusColor.withOpacity(0.3),
                                      blurRadius: 4,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
