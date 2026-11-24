import 'package:flutter/material.dart';

import '../../../../../domain/models/recipe.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/recipe_image.dart';

/// Csak fotot mutato receptkartya a Home designbol. A recept nevet a
/// kepernyoolvasok a semantics feliraton keresztul kapjak meg.
class RecipeCard extends StatelessWidget {
  const RecipeCard({super.key, required this.recipe, required this.onTap});

  final Recipe recipe;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '${recipe.title}, ${recipe.cookingMinutes} minutes',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: AspectRatio(
          aspectRatio: 2,
          child: Stack(
            fit: StackFit.expand,
            children: [
              RecipeImage(url: recipe.imageUrl),
              Material(
                type: MaterialType.transparency,
                child: InkWell(onTap: onTap),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
