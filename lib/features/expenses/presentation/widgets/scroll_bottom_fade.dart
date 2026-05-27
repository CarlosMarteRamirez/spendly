import 'dart:ui';

import 'package:flutter/material.dart';

/// Height of the frosted-glass band at the bottom edge.
const kScrollFadeBandHeight = 56.0;

/// Wraps a scrollable so its bottom edge fades to transparent (Mail-style).
///
/// Instead of overlaying a colored fade (which washes out colored content like
/// red/green buttons), it stacks a [BackdropFilter] with a real Gaussian blur
/// over the scrollable's bottom edge, then masks it with a vertical gradient
/// so the blur ramps in gradually toward the screen edge.
class ScrollWithBottomFade extends StatelessWidget {
  const ScrollWithBottomFade({
    required this.child,
    super.key,
    this.fadeHeight = kScrollFadeBandHeight,
    this.blurSigma = 14,
  });

  final Widget child;
  final double fadeHeight;
  final double blurSigma;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: fadeHeight,
          child: IgnorePointer(
            child: ClipRect(
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 0.4, 1.0],
                    colors: [Colors.transparent, Colors.black54, Colors.black],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.dstIn,
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: blurSigma,
                    sigmaY: blurSigma,
                  ),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Bottom inset for the home list so the last row clears the FAB.
const kScrollBottomInsetWithFab = 96.0;
