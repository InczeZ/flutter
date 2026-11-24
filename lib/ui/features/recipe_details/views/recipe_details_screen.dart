import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../data/repositories/favorites_repository.dart';
import '../../../../domain/models/recipe.dart';
import '../../../../utils/result.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/favorite_button.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/recipe_image.dart';
import '../view_models/recipe_details_view_model.dart';
import 'widgets/ingredient_row.dart';
import 'widgets/recipe_info_bar.dart';
import 'widgets/servings_stepper.dart';

class RecipeDetailsScreen extends StatelessWidget {
  const RecipeDetailsScreen({super.key, required this.viewModel});

  final RecipeDetailsViewModel viewModel;

  /// Felepiti a [recipe] route-jat. A provider birtokolja a view modelt, es
  /// felszabaditja, amikor a route bezarul.
  static Route<void> route(Recipe recipe) {
    return MaterialPageRoute<void>(
      builder: (_) => ChangeNotifierProvider(
        create: (context) => RecipeDetailsViewModel(
          recipe: recipe,
          favoritesRepository: context.read<FavoritesRepository>(),
        ),
        child: Builder(
          builder: (context) => RecipeDetailsScreen(
            viewModel: context.read<RecipeDetailsViewModel>(),
          ),
        ),
      ),
    );
  }

  void _showMessage(BuildContext context, String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _toggleFavorite(BuildContext context) async {
    final result = await viewModel.toggleFavorite();
    if (!context.mounted || result is Ok) return;
    _showMessage(context, 'Could not save your favorite. Please try again.');
  }

  @override
  Widget build(BuildContext context) {
    final recipe = viewModel.recipe;
    final textTheme = Theme.of(context).textTheme;
    final heroHeight = MediaQuery.sizeOf(context).height * 0.42;
    final topInset = MediaQuery.paddingOf(context).top;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListenableBuilder(
              listenable: viewModel,
              builder: (context, _) => CustomScrollView(
                slivers: [
                  // A foto es a lap egy Columnban van, igy a lap a foto folott
                  // rajzolodik ki (a viewport a korabbi slivereket rajzolja utoljara).
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: heroHeight,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              RecipeImage(
                                url: recipe.imageUrl,
                                semanticLabel: recipe.title,
                              ),
                              Positioned(
                                top: topInset + AppSpacing.sm,
                                left: AppSpacing.sm,
                                child: Material(
                                  color: AppColors.background
                                      .withValues(alpha: 0.92),
                                  shape: const CircleBorder(),
                                  child: IconButton(
                                    tooltip: 'Back',
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    icon: const Icon(
                                      Icons.arrow_back,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: topInset + AppSpacing.sm,
                                right: AppSpacing.sm,
                                child: FavoriteButton(
                                  isFavorite: viewModel.isFavorite,
                                  onPressed: () => _toggleFavorite(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Feljebb huzzuk a lapot, hogy a lekerekitett sarkai
                        // ralogjanak a fotora.
                        Transform.translate(
                          offset: const Offset(0, -AppRadius.sheet),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(AppRadius.sheet),
                              ),
                            ),
                            child: _SheetContent(
                              viewModel: viewModel,
                              textTheme: textTheme,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            minimum: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              AppSpacing.md,
            ),
            child: PrimaryButton(
              label: 'Start cooking',
              onPressed: () => _showMessage(
                context,
                'Cooking mode is coming in a later sprint.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetContent extends StatelessWidget {
  const _SheetContent({required this.viewModel, required this.textTheme});

  final RecipeDetailsViewModel viewModel;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final recipe = viewModel.recipe;
    final subtitle =
        [recipe.category, if (recipe.area != null) recipe.area!].join(' / ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xs,
            AppSpacing.md,
            AppSpacing.xs,
            0,
          ),
          child: Row(
            children: [
              IconButton(
                tooltip: 'Reset amounts',
                onPressed: viewModel.reset,
                icon: const Icon(Icons.refresh, color: AppColors.textPrimary),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      recipe.title,
                      style: textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(subtitle, style: textTheme.bodySmall),
                  ],
                ),
              ),
              // Ellensulyozza a reset gombot, hogy a cim kozepen maradjon.
              const SizedBox(width: 48),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        RecipeInfoBar(recipe: recipe),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.sm,
          ),
          child: Row(
            children: [
              Text('Ingredients', style: textTheme.titleSmall),
              const SizedBox(width: AppSpacing.sm),
              Text('x${viewModel.multiplier}', style: textTheme.bodySmall),
              const Spacer(),
              ServingsStepper(
                onDecrement:
                    viewModel.canDecrement ? viewModel.decrement : null,
                onIncrement:
                    viewModel.canIncrement ? viewModel.increment : null,
              ),
            ],
          ),
        ),
        for (final ingredient in recipe.ingredients)
          IngredientRow(
            name: ingredient.name,
            amount: viewModel.amountFor(ingredient),
          ),
        if (recipe.steps.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            child: Text('Instructions', style: textTheme.titleSmall),
          ),
          for (final (index, step) in recipe.steps.indexed)
            _StepRow(number: index + 1, text: step),
        ],
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.number, required this.text});

  final int number;
  final String text;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: AppColors.surfaceMuted,
            child: Text(
              '$number',
              style: textTheme.labelSmall?.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: Text(text, style: textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
