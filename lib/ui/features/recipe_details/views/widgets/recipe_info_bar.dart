import 'package:flutter/material.dart';

import '../../../../../domain/models/recipe.dart';
import '../../../../core/theme/app_tokens.dart';

/// Szurke sav a recept alapadataival. A Figma itt tapertekeket mutat, de a
/// TheMealDB ilyet nem ad, ezert a rendelkezesre allo adatokat jelenitjuk
/// meg ugyanabban a formaban.
class RecipeInfoBar extends StatelessWidget {
  const RecipeInfoBar({super.key, required this.recipe});

  final Recipe recipe;

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
          children: [
            Expanded(child: _Item(value: recipe.category, label: 'Category')),
            Expanded(
              child: _Item(value: recipe.area ?? 'n/a', label: 'Cuisine'),
            ),
            Expanded(
              child: _Item(
                value: '${recipe.ingredients.length}',
                label: 'Ingredients',
              ),
            ),
            Expanded(
              child: _Item(value: '${recipe.steps.length}', label: 'Steps'),
            ),
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
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.bodySmall?.copyWith(color: AppColors.textPrimary),
        ),
        const SizedBox(height: 2),
        Text(label, style: textTheme.titleSmall),
      ],
    );
  }
}
