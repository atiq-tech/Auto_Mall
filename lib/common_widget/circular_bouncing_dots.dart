import 'package:auto_mall/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math';

class CircularBouncingDots extends StatefulWidget {
  final double size;
  final double dotSize;
  final Color? color;
  final int dotCount;
  final Duration duration;

  const CircularBouncingDots({
    super.key,
    this.size = 50,
    this.dotSize = 9,
    this.color,
    this.dotCount = 8,
    this.duration = const Duration(milliseconds: 1400),
  });

  @override
  State<CircularBouncingDots> createState() => _CircularBouncingDotsState();
}

class _CircularBouncingDotsState extends State<CircularBouncingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color dotColor = widget.color ?? AppColors.appColor;

    return SizedBox(
      width: widget.size.w,
      height: widget.size.w,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: List.generate(widget.dotCount, (index) {
              final double angle = (index / widget.dotCount) * 2 * pi;

              // Delay for each dot
              final double delay = index / widget.dotCount;
              double t = (_controller.value + delay) % 1.0;

              // Smooth scale (bounce)
              double scale;
              if (t < 0.5) {
                scale = 0.4 + (t * 2) * 0.8;
              } else {
                scale = 1.2 - ((t - 0.5) * 2) * 0.8;
              }

              final double opacity = 0.35 + (scale - 0.4) * 0.9;
              final double radius = (widget.size / 2) - (widget.dotSize * 1.1);

              return Transform.translate(
                offset: Offset(
                  radius * cos(angle),
                  radius * sin(angle),
                ),
                child: Transform.scale(
                  scale: scale.clamp(0.4, 1.25),
                  child: Opacity(
                    opacity: opacity.clamp(0.3, 1.0),
                    child: Container(
                      width: widget.dotSize.w,
                      height: widget.dotSize.w,
                      decoration: BoxDecoration(
                        color: dotColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: dotColor.withOpacity(0.35),
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}