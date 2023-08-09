import 'package:flutter/material.dart';
import 'package:app/widgets/circle_bottom_navigation_bar/widgets/circle_icon_color.dart';
import 'package:app/widgets/circle_bottom_navigation_bar/widgets/tab_data.dart';
import 'package:app/widgets/circle_bottom_navigation_bar/widgets/tab_item.dart';
import 'package:app/widgets/circle_bottom_navigation_bar/utils/half_clipper.dart';
import 'package:app/widgets/circle_bottom_navigation_bar/utils/half_painter.dart';

/// Class [CircleBottomNavigationBar]:
/// [key]: optional widget key reference
/// [tabs]: list of TabData
/// [onTabChangedListener]: function for control when change Tab
/// [initialSelection]: index of selection item
/// [circleColor]: circle color
/// [activeIconColor]: active icon color
/// [inactiveIconColor]: inactive icon color
/// [textColor]: text color
/// [barBackgroundColor]: bar background color
/// [circleSize]: circle size
/// [barHeight]: bar height
/// [arcHeight]: arc height
/// [arcWidth]: arc width
/// [circleOutline]: circle outline
/// [shadowAllowance]:  shadowAllowance
/// [hasElevationShadows]: has elevation shadows
/// [blurShadowRadius]: blur shadow radius
/// [iconYAxisSpace]: icon Y Axis Space
/// [textYAxisSpace]: text Y Axis Space
/// [itemIconOn]: item Icon On
/// [itemIconOff]: item Icon Off
/// [itemTextOn]: item Text On
/// [itemTextOff]: item Text Off
class CircleBottomNavigationBar extends StatefulWidget {
  @override
  // ignore: overridden_fields
  final Key? key;
  final List<TabData> tabs;
  final Function(int position) onTabChangedListener;
  final int? initialSelection;
  final Color? circleColor;
  final Color? activeIconColor;
  final Color? inactiveIconColor;
  final Color? textColor;
  final Color? barBackgroundColor;
  final double circleSize;
  final double barHeight;
  final double arcHeight;
  final double arcWidth;
  final double circleOutline;
  final double shadowAllowance;
  final bool hasElevationShadows;
  final double blurShadowRadius;
  final double iconYAxisSpace;
  final double textYAxisSpace;
  final double itemIconOn;
  final double itemIconOff;
  final double itemTextOn;
  final double itemTextOff;

  // ignore: use_key_in_widget_constructors
  const CircleBottomNavigationBar({
    this.key,
    required this.tabs,
    required this.onTabChangedListener,
    this.initialSelection,
    this.circleColor,
    this.inactiveIconColor,
    this.activeIconColor,
    this.textColor,
    this.barBackgroundColor,
    this.iconYAxisSpace = -0.5,
    this.textYAxisSpace = 1,
    this.itemIconOn = -1,
    this.itemIconOff = -1,
    this.itemTextOn = 0,
    this.itemTextOff = 0,
    this.circleSize = 60.0,
    this.barHeight = 60.0,
    this.arcHeight = 70.0,
    this.arcWidth = 90.0,
    this.circleOutline = 10.0,
    this.shadowAllowance = 20.0,
    this.hasElevationShadows = true,
    this.blurShadowRadius = 8.0,
  });

  @override
  CircleBottomNavigationBarState createState() =>
      CircleBottomNavigationBarState();
}

class CircleBottomNavigationBarState extends State<CircleBottomNavigationBar>
    with TickerProviderStateMixin, RouteAware {
  IconData nextIcon = Icons.search;
  IconData? activeIcon = Icons.search;

  int currentSelected = -1;
  double _circleAlignX = 0;
  double _circleIconAlpha = 1;

  Color? circleColor;
  Color? activeIconColor;
  Color? inactiveIconColor;
  Color? barBackgroundColor;
  Color? textColor;
  double? activeIconSize;
  double? nextIconSize;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    activeIcon =
        currentSelected >= 0 ? widget.tabs[currentSelected].icon : null;
    activeIconSize = currentSelected >= 0
        ? widget.tabs[currentSelected].iconSize ?? 30
        : null;

    circleColor = (widget.circleColor == null)
        ? (Theme.of(context).brightness == Brightness.dark)
            ? Colors.white
            : Theme.of(context).primaryColor
        : widget.circleColor;

    activeIconColor = (widget.activeIconColor == null)
        ? (Theme.of(context).brightness == Brightness.dark)
            ? Colors.black54
            : Colors.white
        : widget.activeIconColor;

    barBackgroundColor = (widget.barBackgroundColor == null)
        ? (Theme.of(context).brightness == Brightness.dark)
            ? Colors.black54
            : Colors.white
        : widget.barBackgroundColor;

    textColor = (widget.textColor == null)
        ? (Theme.of(context).brightness == Brightness.dark)
            ? Colors.white
            : Colors.black54
        : widget.textColor;

    inactiveIconColor = (widget.inactiveIconColor == null)
        ? (Theme.of(context).brightness == Brightness.dark)
            ? Colors.white
            : Theme.of(context).primaryColor
        : widget.inactiveIconColor;
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialSelection != null) {
      _setSelected(widget.tabs[widget.initialSelection!].key);
    } else {
      setState(() {});
    }
  }

  void setPage(int page) {
    widget.onTabChangedListener(page);
    _setSelected(widget.tabs[page].key);
    _initAnimationAndStart(_circleAlignX, 1);

    setState(() => currentSelected = page);
  }

  void _setSelected(UniqueKey key) {
    final selected =
        widget.tabs.indexWhere((TabData tabData) => tabData.key == key);

    if (mounted) {
      setState(() {
        currentSelected = selected;
        _circleAlignX = -1 + (2 / (widget.tabs.length - 1) * selected);
        nextIcon = widget.tabs[selected].icon;
        nextIconSize = widget.tabs[selected].iconSize ?? 30;
      });
    }
  }

  void _initAnimationAndStart(double from, double to) {
    _circleIconAlpha = 0;

    Future.delayed(
      const Duration(
        milliseconds: ANIM_DURATION ~/ 5,
      ),
      () {
        setState(() {
          activeIcon = nextIcon;
          activeIconSize = nextIconSize;
        });
      },
    ).then((_) {
      Future.delayed(
          const Duration(
            milliseconds: ANIM_DURATION ~/ 5 * 3,
          ), () {
        setState(() => _circleIconAlpha = 1);
      });
    });
  }

  void _callbackFunction(UniqueKey key) {
    final selected =
        widget.tabs.indexWhere((TabData tabData) => tabData.key == key);

    widget.onTabChangedListener(selected);
    _setSelected(key);
    _initAnimationAndStart(_circleAlignX, 1);
  }

  @override
  Widget build(BuildContext context) => Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Container(
            height: widget.barHeight,
            decoration: BoxDecoration(
              color: barBackgroundColor,
              boxShadow: <BoxShadow>[
                widget.hasElevationShadows
                    ? BoxShadow(
                        color: Colors.black12,
                        offset: const Offset(
                          0,
                          -1,
                        ),
                        blurRadius: widget.blurShadowRadius,
                      )
                    : const BoxShadow(),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: widget.tabs
                  .map(
                    (TabData tab) => TabItem(
                      uniqueKey: tab.key,
                      selected: false,
                      icon: tab.icon,
                      title: tab.title,
                      iconColor: inactiveIconColor,
                      textColor: textColor,
                      iconOn: widget.itemIconOn,
                      iconOff: widget.itemIconOff,
                      textOff: widget.itemTextOff,
                      textOn: widget.itemTextOn,
                      iconSize: tab.iconSize,
                      fontSize: tab.fontSize,
                      fontWeight: tab.fontWeight,
                      callbackFunction: (UniqueKey key) =>
                          _callbackFunction(key),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      );
}
