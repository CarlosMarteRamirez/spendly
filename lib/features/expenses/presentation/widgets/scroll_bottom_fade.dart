import 'package:flutter/material.dart';

/// Thin Mail-style fade sitting right above a fixed bottom bar (or screen edge).
const kScrollFadeBandHeight = 24.0;

/// Soft fade anchored to the bottom of a scrollable area.
class ScrollBottomFade extends StatelessWidget {
  const ScrollBottomFade({
    super.key,
    this.height = kScrollFadeBandHeight,
    this.color,
  });

  final double height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final bg = color ?? Theme.of(context).scaffoldBackgroundColor;

    return IgnorePointer(
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [bg.withValues(alpha: 0), bg],
            ),
          ),
        ),
      ),
    );
  }
}

/// Stacks a child scrollable with a fade pinned to its bottom edge.
class ScrollWithBottomFade extends StatelessWidget {
  const ScrollWithBottomFade({
    required this.child,
    super.key,
    this.fadeHeight = kScrollFadeBandHeight,
    this.color,
  });

  final Widget child;
  final double fadeHeight;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        child,
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: ScrollBottomFade(height: fadeHeight, color: color),
        ),
      ],
    );
  }
}

/// Bottom inset for the home list so the last row clears the FAB.
const kScrollBottomInsetWithFab = 96.0;

/// Bottom inset added inside a form scroll so content clears the action bar.
const kFormActionBarReservedSpace = 16.0;
