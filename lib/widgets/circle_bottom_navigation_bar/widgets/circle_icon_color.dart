import 'package:flutter/material.dart';

import 'tab_item.dart';

/// Class [CircleIconColor]
/// [circleSize]: circle Size
/// [circleIconAlpha]: circle Icon Alpha
/// [circleColor]: circle Color
/// [activeIcon]: active Icon
/// [activeIconColor]: active Icon Color
/// [activeIconSize]: active Icon Size
class CircleIconColor extends StatelessWidget {
  const CircleIconColor({
    super.key,
    required this.circleSize,
    required this.circleIconAlpha,
    required this.circleColor,
    required this.activeIcon,
    required this.activeIconColor,
    required this.activeIconSize,
  });

  final double circleSize;
  final double circleIconAlpha;
  final Color? circleColor;
  final IconData? activeIcon;
  final Color? activeIconColor;
  final double? activeIconSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: circleSize,
      width: circleSize,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: circleColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(
            0.0,
          ),
          child: AnimatedOpacity(
            duration: const Duration(
              milliseconds: ANIM_DURATION ~/ 5,
            ),
            opacity: circleIconAlpha,
            child: Icon(
              activeIcon,
              color: activeIconColor,
              size: activeIconSize,
            ),
          ),
        ),
      ),
    );
  }
}
