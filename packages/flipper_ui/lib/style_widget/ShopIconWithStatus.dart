import 'package:flutter/material.dart';

class ShopIconWithStatus extends StatelessWidget {
  final double width;
  final double height;
  final Color borderColor;
  final Color iconColor;
  final Color statusColor;

  const ShopIconWithStatus({
    Key? key,
    this.width = 80.0,
    this.height = 50.0,
    this.borderColor = Colors.grey,
    this.iconColor = Colors.black,
    this.statusColor = Colors.green,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Green status dot
          Padding(
            padding: EdgeInsets.only(left: 12),
            child: Container(
              width: height * 0.4,
              height: height * 0.4,
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Shop icon
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(
              Icons.store,
              size: height * 0.6,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }
}
