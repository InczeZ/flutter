import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';

/// Egy hozzavalo sor: balra a nev, jobbra a skalazott mennyiseg.
class IngredientRow extends StatelessWidget {
  const IngredientRow({super.key, required this.name, required this.amount});

  final String name;
  final String amount;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Expanded(child: Text(name, style: textTheme.bodyMedium)),
          const SizedBox(width: AppSpacing.md),
          Text(
            amount,
            style: textTheme.bodySmall?.copyWith(color: AppColors.textDisabled),
          ),
        ],
      ),
    );
  }
}
