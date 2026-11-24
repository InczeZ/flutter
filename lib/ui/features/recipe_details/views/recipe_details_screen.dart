import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../domain/models/recipe.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/recipe_image.dart';
import '../view_models/recipe_details_view_model.dart';
import 'widgets/ingredient_row.dart';
import 'widgets/nutrition_bar.dart';
import 'widgets/servings_stepper.dart';

class RecipeDetailsScreen extends StatelessWidget {
  const RecipeDetailsScreen({super.key, required this.viewModel});

  final RecipeDetailsViewModel viewModel;

  /// Felepiti a [recipe] route-jat. A provider birtokolja a view modelt, es
  /// felszabaditja, amikor a route bezarul.
  static Route<void> route(Recipe recipe) {
    return MaterialPageRoute<void>(
      builder: (_) => ChangeNotifierProvider(
        create: (_) => RecipeDetailsViewModel(recipe: recipe),
        child: Builder(
          builder: (context) => RecipeDetailsScreen(
            viewModel: context.read<RecipeDetailsViewModel>(),
          ),
        ),
      ),
    );
  }

  void _startCooking(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Cooking mode is coming in Sprint 2.')),
      );
  }

  @override
  Widget build(BuildContext context) {
    final recipe = viewModel.recipe;
    final textTheme = Theme.of(context).textTheme;
    final heroHeight = MediaQuery.sizeOf(context).height * 0.42;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
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
                              top: MediaQuery.paddingOf(context).top +
                                  AppSpacing.xs,
                              left: AppSpacing.xs,
                              child: IconButton(
                                tooltip: 'Back',
                                onPressed: () => Navigator.of(context).pop(),
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Feljebb huzzuk a lapot, hogy a lekerekitett sarkai ralogjanak a fotora.
                      Transform.translate(
                        offset: const Offset(0, -AppRadius.sheet),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(AppRadius.sheet),
                            ),
                          ),
                          child: ListenableBuilder(
                            listenable: viewModel,
                            builder: (context, _) => Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _TitleBlock(
                                  recipe: recipe,
                                  onReset: viewModel.resetServings,
                                ),
                                const SizedBox(height: AppSpacing.md),
                                NutritionBar(nutrition: recipe.nutrition),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    AppSpacing.md,
                                    AppSpacing.md,
                                    AppSpacing.md,
                                    AppSpacing.sm,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Ingredients',
                                        style: textTheme.titleSmall,
                                      ),
                                      const SizedBox(width: AppSpacing.sm),
                                      Text(
                                        '${viewModel.servings} serves',
                                        style: textTheme.bodySmall,
                                      ),
                                      const Spacer(),
                                      ServingsStepper(
                                        onDecrement: viewModel.canDecrement
                                            ? viewModel.decrementServings
                                            : null,
                                        onIncrement: viewModel.canIncrement
                                            ? viewModel.incrementServings
                                            : null,
                                      ),
                                    ],
                                  ),
                                ),
                                for (final ingredient in recipe.ingredients)
                                  IngredientRow(
                                    name: ingredient.name,
                                    amount: viewModel.amountFor(ingredient),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
              onPressed: () => _startCooking(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _TitleBlock extends StatelessWidget {
  const _TitleBlock({required this.recipe, required this.onReset});

  final Recipe recipe;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xs,
        AppSpacing.md,
        AppSpacing.xs,
        0,
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Reset servings',
            onPressed: onReset,
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
                Text(
                  '${recipe.mealType} / ${recipe.cookingMinutes} mins',
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          ),
          // Ellensulyozza a reset gombot, hogy a cim kozepen maradjon.
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}
