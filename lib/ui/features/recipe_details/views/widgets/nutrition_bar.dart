import 'package:flutter/material.dart';

import '../../../../../domain/models/recipe.dart';
import '../../../../core/theme/app_tokens.dart';

/// Szurke sav az energiaval, feherjevel, szenhidrattal es zsirral adagonkent.
class NutritionBar extends StatelessWidget {
  const NutritionBar({super.key, required this.nutrition});

  final Nutrition nutrition;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surfaceMuted,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _Item(value: '${nutrition.calories} kcal', label: 'Energy'),
            _Item(value: '${nutrition.proteinGrams} g', label: 'Protein'),
            _Item(value: '${nutrition.carbsGrams} g', label: 'Carbs'),
            _Item(value: '${nutrition.fatGrams} g', label: 'Fat'),
          ],
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(
          value,
          style: textTheme.bodySmall?.copyWith(color: AppColors.textPrimary),
        ),
        const SizedBox(height: 2),
        Text(label, style: textTheme.titleSmall),
      ],
    );
  }
}
