import 'package:flutter/material.dart';

class ShopIconWithStatus extends StatelessWidget {
  final double width;
  final double height;
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final Color statusColor;
  final String label;
  final bool isActive;

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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 8,
            right: 8,
            child: AnimatedOpacity(
              opacity: isActive ? 1.0 : 0.0,
              duration: Duration(milliseconds: 300),
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: statusColor.withOpacity(0.3),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.store_rounded,
                  size: height * 0.4,
                  color: iconColor,
                ),
                SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: iconColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
