import 'package:flutter/material.dart';

class StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  StickyHeaderDelegate({required this.child});

  @override
  double get minExtent => 150; // Minimum height of the header
  @override
  double get maxExtent => 150; // Maximum height of the header

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
