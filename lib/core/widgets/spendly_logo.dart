import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Spendly shield logo (mint background + dark icon).
class SpendlyLogo extends StatelessWidget {
  const SpendlyLogo({super.key, this.size = 96});

  final double size;

  static const _assetPath = 'assets/icon/spendly_logo.svg';

  static const _backgroundColor = Color(0xFF99DDCC);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.22),
      child: ColoredBox(
        color: _backgroundColor,
        child: SvgPicture.asset(
          _assetPath,
          width: size,
          height: size,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
