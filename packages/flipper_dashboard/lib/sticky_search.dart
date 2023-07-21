import 'package:flutter/material.dart';

class StickyHeader extends SliverPersistentHeaderDelegate {
  final Widget child;

  StickyHeader({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      elevation: 0.0,
      child: child,
      shape: Border(bottom: BorderSide.none),
    );
  }

  @override
  double get maxExtent => 56.0;

  @override
  double get minExtent => 56.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
