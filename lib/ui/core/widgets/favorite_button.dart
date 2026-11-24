import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

/// Kerek sziv gomb fotok fole. Nincs sajat allapota: a kedvenc allapotot
/// mindig kivulrol kapja (FavoritesRepository), igy minden kepernyon egyezik.
class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onPressed,
  });

  final bool isFavorite;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background.withValues(alpha: 0.92),
      shape: const CircleBorder(),
      child: IconButton(
        tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
        onPressed: onPressed,
        icon: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: isFavorite ? AppColors.favorite : AppColors.textPrimary,
        ),
      ),
    );
  }
}
