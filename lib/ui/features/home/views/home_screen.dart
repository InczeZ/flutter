import 'package:flutter/material.dart';

import '../../../../domain/models/recipe.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/primary_button.dart';
import '../../recipe_details/views/recipe_details_screen.dart';
import '../view_models/home_view_model.dart';
import 'widgets/home_header.dart';
import 'widgets/progress_card.dart';
import 'widgets/recipe_card.dart';

/// A "Today" ful: fejlec, a mai haladas es a receptlista.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.load();
  }

  void _openDetails(Recipe recipe) {
    Navigator.of(context).push(RecipeDetailsScreen.route(recipe));
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$feature is coming soon.')));
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    return SafeArea(
      bottom: false,
      child: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.sm,
                  AppSpacing.xs,
                  AppSpacing.sm,
                ),
                sliver: SliverToBoxAdapter(
                  child: HomeHeader(
                    onMenuPressed: () => _showComingSoon('The menu'),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                sliver: SliverToBoxAdapter(
                  child: ProgressCard(
                    progress: viewModel.progress,
                    onViewMore: () => _showComingSoon('Progress details'),
                  ),
                ),
              ),
              ..._buildRecipes(viewModel),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildRecipes(HomeViewModel viewModel) {
    switch (viewModel.status) {
      case HomeStatus.loading:
        return const [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: CircularProgressIndicator()),
          ),
        ];
      case HomeStatus.empty:
        return const [
          SliverFillRemaining(
            hasScrollBody: false,
            child:
                Center(child: Text('No recipes match your preferences yet.')),
          ),
        ];
      case HomeStatus.error:
        return [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Could not load recipes.'),
                  const SizedBox(height: AppSpacing.md),
                  PrimaryButton(label: 'Try again', onPressed: viewModel.load),
                ],
              ),
            ),
          ),
        ];
      case HomeStatus.success:
        return [
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.md),
            sliver: SliverLayoutBuilder(
              builder: (context, constraints) {
                // Telefonon soronkent egy kartya, szelesebb kepernyon ketto.
                final columns = constraints.crossAxisExtent >= 600 ? 2 : 1;
                final spacing = AppSpacing.md * (columns - 1);
                final cardWidth =
                    (constraints.crossAxisExtent - spacing) / columns;
                return SliverGrid.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    mainAxisSpacing: AppSpacing.md,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisExtent: cardWidth / 2,
                  ),
                  itemCount: viewModel.recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = viewModel.recipes[index];
                    return RecipeCard(
                      recipe: recipe,
                      onTap: () => _openDetails(recipe),
                    );
                  },
                );
              },
            ),
          ),
        ];
    }
  }
}
