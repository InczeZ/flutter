import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';

/// Kor alaku haladasjelzo, benne a szazalekkal es egy rovid felirattal.
class MacroRing extends StatelessWidget {
  const MacroRing({
    super.key,
    required this.value,
    required this.label,
    required this.color,
    this.size = 60,
  });

  /// Haladas 0 es 1 kozott.
  final double value;
  final String label;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final percent = (value.clamp(0.0, 1.0) * 100).round();
    return Semantics(
      label: '$label $percent percent',
      excludeSemantics: true,
      child: SizedBox.square(
        dimension: size,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CircularProgressIndicator(
              value: value.clamp(0.0, 1.0),
              strokeWidth: 5,
              strokeCap: StrokeCap.round,
              color: color,
              backgroundColor: AppColors.ringTrack,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$percent%',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(label, style: Theme.of(context).textTheme.labelSmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
