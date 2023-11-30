import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class TapableProps {
  final Widget child;
  final Duration startAnimationDelay;
  final Curve? animation;
  final double minScale;
  final double maxScale;
  final EdgeInsets? padding;
  final BoxDecoration? decoration;
  final Color? highlightColor;
  final Color? splashColor;
  final Color? focusColor;
  final Color? hoverColor;
  final double? width;
  final double? height;
  final bool enableTapAnimation;
  final bool enableStartAnimation;
  final void Function(bool)? onHover;
  final void Function(TapDownDetails)? onTapDown;
  final void Function(TapUpDetails)? onTapUp;
  final void Function()? onTapCancel;
  final void Function() onTap;
  final void Function(Size tapableContainerSize)? onSizeChange;

  const TapableProps({
    this.animation,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.onSizeChange,
    this.onHover,
    this.padding,
    this.decoration,
    this.splashColor,
    this.highlightColor,
    this.focusColor,
    this.hoverColor,
    this.width,
    this.height,
    this.startAnimationDelay = const Duration(seconds: 0),
    this.minScale = 0.9,
    this.maxScale = 1.0,
    this.enableTapAnimation = true,
    this.enableStartAnimation = false,
    required this.child,
    required this.onTap,
  });
}

class Tapable extends StatefulWidget {
  final TapableProps properties;

  const Tapable({
    Key? key,
    required this.properties,
  }) : super(key: key);

  @override
  State<Tapable> createState() => _TapableState();
}

class _TapableState extends State<Tapable> with TickerProviderStateMixin {
  double scale = 1;
  bool _mounted = false;
  final GlobalKey containerKey = GlobalKey();
  Size? lastFrameSize;

  late final AnimationController _animationInController = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );
  late final Animation<double> _animationIn = CurvedAnimation(
    parent: _animationInController,
    curve: widget.properties.animation ?? Curves.fastLinearToSlowEaseIn,
  );
  late final AnimationController _tapAnimationController = AnimationController(
    vsync: this,
    duration: const Duration(
      milliseconds: 100,
    ),
    lowerBound: 1 - widget.properties.maxScale,
    upperBound: 1 - widget.properties.minScale,
  )..addListener(() {
      if (!widget.properties.enableTapAnimation) {
        return;
      }
      setState(() {
        scale = 1 - _tapAnimationController.value;
      });
    });

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback(postFrameCallback);
    _mounted = true;
    if (!widget.properties.enableStartAnimation) {
      _animationInController.value = 1;
      return;
    }
    switch (_animationInController.status) {
      case AnimationStatus.completed:
      case AnimationStatus.dismissed:
        Timer(
          widget.properties.startAnimationDelay,
          () {
            if (_mounted) {
              _animationInController.forward();
            }
          },
        );
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    _animationInController.dispose();
    _tapAnimationController.dispose();
    super.dispose();
  }

  void postFrameCallback(Duration duration) {
    try {
      final BuildContext? context = containerKey.currentContext;
      final Size? containerSize = context!.size;
      if (containerSize != null && containerSize != lastFrameSize) {
        if (widget.properties.onSizeChange != null) {
          widget.properties.onSizeChange!(containerSize);
        }
        lastFrameSize = containerSize;
      }
    } catch (_) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animationIn,
      child: Transform.scale(
        scale: scale,
        child: Material(
          color: Colors.transparent,
          child: SizedBox(
            width: widget.properties.width,
            height: widget.properties.height,
            child: Ink(
              key: containerKey,
              decoration: widget.properties.decoration,
              child: InkWell(
                customBorder: RoundedRectangleBorder(
                  borderRadius: widget.properties.decoration?.borderRadius ??
                      BorderRadius.circular(0.0),
                ),
                hoverColor: widget.properties.hoverColor ?? Colors.transparent,
                highlightColor:
                    widget.properties.highlightColor ?? Colors.transparent,
                splashColor: widget.properties.splashColor ??
                    Colors.grey.withOpacity(0.2),
                onTapDown: (details) {
                  if (widget.properties.enableTapAnimation) {
                    _tapAnimationController.forward();
                  }
                  if (widget.properties.onTapDown != null) {
                    widget.properties.onTapDown!(details);
                  }
                },
                onTapCancel: () {
                  if (widget.properties.enableTapAnimation) {
                    _tapAnimationController.reverse();
                  }
                  if (widget.properties.onTapCancel != null) {
                    widget.properties.onTapCancel!();
                  }
                },
                onTap: () {
                  if (widget.properties.enableTapAnimation) {
                    _tapAnimationController.reverse();
                  }
                  widget.properties.onTap();
                },
                onHover: widget.properties.onHover,
                child: Container(
                  padding: widget.properties.padding,
                  child: widget.properties.child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
