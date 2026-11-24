import 'package:flutter/material.dart';

import '../../../../domain/models/recipe.dart';
import '../../../../utils/app_exception.dart';
import '../../../../utils/result.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/primary_button.dart';
import '../../recipe_details/views/recipe_details_screen.dart';
import '../view_models/home_view_model.dart';
import 'widgets/home_header.dart';
import 'widgets/progress_card.dart';
import 'widgets/recipe_card.dart';
import 'widgets/recipe_search_field.dart';

/// A "Today" ful: fejlec, a mai haladas, kereses es a receptlista.
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

  Future<void> _toggleFavorite(Recipe recipe) async {
    final result = await widget.viewModel.toggleFavorite(recipe);
    if (!mounted || result is Ok) return;
    _showMessage('Could not save your favorite. Please try again.');
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
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
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                    onMenuPressed: () =>
                        _showMessage('The menu is coming soon.'),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                sliver: SliverToBoxAdapter(
                  child: ProgressCard(
                    progress: viewModel.progress,
                    onViewMore: () =>
                        _showMessage('Progress details are coming soon.'),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.md,
                  0,
                ),
                sliver: SliverToBoxAdapter(
                  child: RecipeSearchField(
                    onChanged: viewModel.onQueryChanged,
                    onCleared: viewModel.clearQuery,
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
        final query = viewModel.query;
        return [
          SliverFillRemaining(
            hasScrollBody: false,
            child: _Message(
              icon: Icons.search_off,
              title: query.isEmpty
                  ? 'No recipes yet'
                  : 'No recipes found for "$query"',
              body: 'Try a different name, for example "chicken" or "pasta".',
            ),
          ),
        ];
      case HomeStatus.error:
        final error = viewModel.error;
        return [
          SliverFillRemaining(
            hasScrollBody: false,
            child: _Message(
              icon: Icons.cloud_off,
              title: 'Could not load recipes',
              body: _errorText(error),
              action: PrimaryButton(
                label: 'Try again',
                onPressed: viewModel.load,
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
                      isFavorite: viewModel.isFavorite(recipe),
                      onTap: () => _openDetails(recipe),
                      onFavoritePressed: () => _toggleFavorite(recipe),
                    );
                  },
                );
              },
            ),
          ),
        ];
    }
  }

  /// A hiba fajtajabol ertheto, a felhasznalonak szolo uzenet.
  static String _errorText(AppException? error) {
    switch (error?.type) {
      case AppErrorType.noConnection:
        return 'You seem to be offline. Check your internet connection.';
      case AppErrorType.timeout:
        return 'The server is taking too long to respond.';
      case AppErrorType.server:
        return 'The recipe service is having problems right now.';
      case AppErrorType.invalidData:
      case AppErrorType.storage:
      case AppErrorType.unknown:
      case null:
        return 'Something went wrong. Please try again.';
    }
  }
}

class _Message extends StatelessWidget {
  const _Message({
    required this.icon,
    required this.title,
    required this.body,
    this.action,
  });

  final IconData icon;
  final String title;
  final String body;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final action = this.action;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: AppColors.textSecondary),
          const SizedBox(height: AppSpacing.md),
          Text(
            title,
            style: textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(body, style: textTheme.bodySmall, textAlign: TextAlign.center),
          if (action != null) ...[
            const SizedBox(height: AppSpacing.lg),
            action,
          ],
        ],
      ),
    );
  }
}
