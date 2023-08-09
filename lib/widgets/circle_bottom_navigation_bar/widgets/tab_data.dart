import 'package:flutter/material.dart';

/// Class [TabData] model for Tab
/// [icon]: icon
/// [title]: title
/// [onClick]: onClick
/// [iconSize]: iconSize
/// [fontSize]: fontSize
/// [fontWeight]: fontWeight
/// [key]: key
class TabData {
  final IconData icon;
  final String? title;
  final VoidCallback? onClick;
  final double? iconSize;
  final double? fontSize;
  final FontWeight? fontWeight;
  final UniqueKey key = UniqueKey();

  TabData({
    required this.icon,
    this.title,
    this.onClick,
    this.iconSize,
    this.fontSize,
    this.fontWeight,
  });
}
