import 'package:flutter/material.dart';
import 'package:app/widgets/ball_loading/delay_tween.dart';
import 'ball.dart';

///
/// desc:小球脉冲效果
///
class BallPulseLoading extends StatefulWidget {
  final BallStyle? ballStyle;
  final Duration duration;
  final Curve curve;

  const BallPulseLoading({
    Key? key,
    this.ballStyle,
    this.duration = const Duration(milliseconds: 800),
    this.curve = Curves.linear,
    this.padding = const EdgeInsets.symmetric(horizontal: 3),
  }) : super(key: key);

  final EdgeInsets padding;

  @override
  BallPulseLoadingState createState() => BallPulseLoadingState();
}

class BallPulseLoadingState extends State<BallPulseLoading>
    with SingleTickerProviderStateMixin {
  AnimationController? ccontroller;
  Animation<double>? aanimations;

  @override
  void initState() {
    ccontroller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();

    aanimations = ccontroller!.drive(CurveTween(curve: widget.curve));

    super.initState();
  }

  @override
  void dispose() {
    ccontroller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(3, (index) {
        return Padding(
          padding: widget.padding,
          child: ScaleTransition(
            scale: DelayTween(begin: 0.0, end: 1.0, delay: index * .2)
                .animate(aanimations!),
            child: Ball(
              style: widget.ballStyle,
            ),
          ),
        );
      }),
    );
  }
}
