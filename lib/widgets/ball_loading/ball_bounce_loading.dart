import 'package:flutter/material.dart';
import 'package:app/widgets/ball_loading/delay_tween.dart';
import 'package:app/widgets/ball_loading/ball.dart';

///
/// desc:
///

class BallBounceLoading extends StatefulWidget {
  final BallStyle? ballStyle;
  final Duration duration;
  final Curve curve;

  const BallBounceLoading(
      {Key? key,
      this.ballStyle,
      this.duration = const Duration(milliseconds: 800),
      this.curve = Curves.linear})
      : super(key: key);
  @override
  BallBounceLoadingState createState() => BallBounceLoadingState();
}

class BallBounceLoadingState extends State<BallBounceLoading>
    with SingleTickerProviderStateMixin {
  AnimationController? ccontroller;
  List<Animation> aanimations = [];

  @override
  void initState() {
    ccontroller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
    List.generate(3, (index) {
      aanimations.add(DelayTween(begin: 0.0, end: 1.0, delay: 0.2 * index)
          .animate(CurvedAnimation(parent: ccontroller!, curve: widget.curve)));
    });
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
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: AnimatedBuilder(
            animation: ccontroller!,
            builder: (context, child) {
              return Align(
                alignment: Alignment(0.0, 0.4 * aanimations[index].value),
                child: Ball(
                  style: widget.ballStyle,
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
