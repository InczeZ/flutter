import 'package:flutter/material.dart';

import '../../../../../domain/models/recipe.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/widgets/favorite_button.dart';
import '../../../../core/widgets/recipe_image.dart';

/// Fotos receptkartya a Home designbol. Az API-bol jovo recepteknel a nev is
/// kell (kereses miatt), ezert a kep aljan, sotet atmeneten jelenik meg.
class RecipeCard extends StatelessWidget {
  const RecipeCard({
    super.key,
    required this.recipe,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoritePressed,
  });

  final Recipe recipe;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoritePressed;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Stack(
        fit: StackFit.expand,
        children: [
          RecipeImage(url: recipe.imageUrl),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.45, 1],
                colors: [Colors.transparent, Color(0xB3000000)],
              ),
            ),
          ),
          Positioned(
            left: AppSpacing.md,
            right: AppSpacing.md,
            bottom: AppSpacing.md,
            child: Text(
              recipe.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.onPrimary,
                  ),
            ),
          ),
          Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: onTap,
              child: Semantics(
                button: true,
                label: recipe.title,
                excludeSemantics: true,
              ),
            ),
          ),
          Positioned(
            top: AppSpacing.sm,
            right: AppSpacing.sm,
            child: FavoriteButton(
              isFavorite: isFavorite,
              onPressed: onFavoritePressed,
            ),
          ),
        ],
      ),
    );
  }
}
