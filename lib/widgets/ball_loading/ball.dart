// ignore_for_file: hash_and_equals

import 'package:flutter/material.dart';

///
/// 默认球的样式
///
const kDefaultBallStyle = BallStyle(
  size: 10.0,
  color: Colors.white,
  ballType: BallType.solid,
  borderWidth: 0.0,
  borderColor: Colors.white,
);

///
/// desc:球
///
class Ball extends StatelessWidget {
  ///
  /// 球样式
  ///
  final BallStyle? style;

  const Ball({
    Key? key,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BallStyle bballStyle = kDefaultBallStyle.copyWith(
        size: style?.size,
        color: style?.color,
        ballType: style?.ballType,
        borderWidth: style?.borderWidth,
        borderColor: style?.borderColor);

    return SizedBox(
      width: bballStyle.size,
      height: bballStyle.size,
      child: DecoratedBox(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                bballStyle.ballType == BallType.solid ? bballStyle.color : null,
            border: Border.all(
                color: bballStyle.borderColor!,
                width: bballStyle.borderWidth!)),
      ),
    );
  }
}

enum BallType {
  ///
  /// 空心
  ///
  hollow,

  ///
  /// 实心
  ///
  solid
}

class BallStyle {
  ///
  /// 尺寸
  ///
  final double? size;

  ///
  /// 实心球颜色
  ///
  final Color? color;

  ///
  /// 球的类型 [ BallType ]
  ///
  final BallType? ballType;

  ///
  /// 边框宽
  ///
  final double? borderWidth;

  ///
  /// 边框颜色
  ///
  final Color? borderColor;

  const BallStyle(
      {this.size,
      this.color,
      this.ballType,
      this.borderWidth,
      this.borderColor});

  BallStyle copyWith(
      {double? size,
      Color? color,
      BallType? ballType,
      double? borderWidth,
      Color? borderColor}) {
    return BallStyle(
        size: size ?? this.size,
        color: color ?? this.color,
        ballType: ballType ?? this.ballType,
        borderWidth: borderWidth ?? this.borderWidth,
        borderColor: borderColor ?? this.borderColor);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is BallStyle &&
        other.size == size &&
        other.color == color &&
        other.ballType == ballType &&
        other.borderWidth == borderWidth &&
        other.borderColor == borderColor;
  }
}
