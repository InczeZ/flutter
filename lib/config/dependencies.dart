import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/repositories/favorites_repository.dart';
import '../data/repositories/recipe_repository.dart';
import '../data/repositories/recipe_repository_remote.dart';
import '../data/services/favorites_storage_service.dart';
import '../data/services/meal_db_api_service.dart';
import '../ui/features/home/view_models/home_view_model.dart';

/// Fuggosegi lanc: Service -> Repository -> ViewModel.
/// Az API-t vagy a tarolot csak itt kell lecserelni, a UI nem valtozik.
List<SingleChildWidget> appProviders({
  required SharedPreferences prefs,
  RecipeRepository? recipeRepository,
}) {
  return [
    Provider<MealDbApiService>(create: (_) => MealDbApiService()),
    Provider<RecipeRepository>(
      create: (context) =>
          recipeRepository ??
          RecipeRepositoryRemote(
            apiService: context.read<MealDbApiService>(),
          ),
    ),
    Provider<FavoritesStorageService>(
      create: (_) => FavoritesStorageService(prefs),
    ),
    ChangeNotifierProvider<FavoritesRepository>(
      create: (context) => FavoritesRepository(
        storage: context.read<FavoritesStorageService>(),
      ),
    ),
    ChangeNotifierProvider<HomeViewModel>(
      create: (context) => HomeViewModel(
        recipeRepository: context.read<RecipeRepository>(),
        favoritesRepository: context.read<FavoritesRepository>(),
      ),
    ),
  ];
}
