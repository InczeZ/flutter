import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

/// Halozati kep semleges helyettesitovel betoltes es hiba eseten, igy egy
/// hianyzo kep sosem tori el az elrendezest.
class RecipeImage extends StatelessWidget {
  const RecipeImage({super.key, required this.url, this.semanticLabel});

  final String? url;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final src = url;
    if (src == null || src.isEmpty) return const _Placeholder();
    return Image.network(
      src,
      fit: BoxFit.cover,
      semanticLabel: semanticLabel,
      loadingBuilder: (context, child, progress) =>
          progress == null ? child : const _Placeholder(),
      errorBuilder: (context, error, stackTrace) => const _Placeholder(),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.surfaceMuted,
      child: Center(
        child: Icon(Icons.restaurant, color: AppColors.textSecondary),
      ),
    );
  }
}
