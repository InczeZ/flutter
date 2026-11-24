import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../data/repositories/recipe_repository.dart';
import '../data/repositories/recipe_repository_local.dart';
import '../data/services/recipe_local_service.dart';
import '../ui/features/home/view_models/home_view_model.dart';

/// Fuggosegi lanc: Service -> Repository -> ViewModel.
/// Ha a mock szervizt REST kliensre csereljuk, csak ez a fajl valtozik.
List<SingleChildWidget> appProviders({
  RecipeRepository? recipeRepository,
}) {
  return [
    Provider<RecipeLocalService>(create: (_) => const RecipeLocalService()),
    Provider<RecipeRepository>(
      create: (context) =>
          recipeRepository ??
          RecipeRepositoryLocal(service: context.read<RecipeLocalService>()),
    ),
    ChangeNotifierProvider<HomeViewModel>(
      create: (context) => HomeViewModel(
        recipeRepository: context.read<RecipeRepository>(),
      ),
    ),
  ];
}
