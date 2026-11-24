import 'package:flutter/foundation.dart';

/// Amit a felhasznalo ma evett, a "Today's Progress" kartyan jelenik meg.
@immutable
class DailyProgress {
  const DailyProgress({
    required this.calories,
    required this.fatPercent,
    required this.proteinPercent,
    required this.carbsPercent,
    required this.message,
  });

  final int calories;

  /// A napi cel teljesitett resze makronkent, 0 es 1 kozott.
  final double fatPercent;
  final double proteinPercent;
  final double carbsPercent;

  /// Rovid motivalo uzenet a gyuruk alatt.
  final String message;
}
