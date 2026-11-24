import '../../domain/models/recipe.dart';
import '../../utils/result.dart';
import '../models/recipe_api_model.dart';
import '../services/recipe_local_service.dart';
import 'recipe_repository.dart';

/// A RecipeLocalServicere epulo repository. A nyers API modelleket domain
/// Recipe objektumokka alakitja, es a memoriaban tarolja (cache).
class RecipeRepositoryLocal implements RecipeRepository {
  RecipeRepositoryLocal({required RecipeLocalService service})
      : _service = service;

  final RecipeLocalService _service;
  List<Recipe>? _cache;

  @override
  Future<Result<List<Recipe>>> getRecipes() async {
    final cached = _cache;
    if (cached != null) return Result.ok(cached);

    try {
      final apiModels = await _service.fetchRecipes();
      final recipes = List<Recipe>.unmodifiable(apiModels.map(_toDomain));
      _cache = recipes;
      return Result.ok(recipes);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<Recipe>> getRecipe(String id) async {
    final result = await getRecipes();
    switch (result) {
      case Ok<List<Recipe>>(:final value):
        for (final recipe in value) {
          if (recipe.id == id) return Result.ok(recipe);
        }
        return Result.error(Exception('Recipe not found: $id'));
      case Error<List<Recipe>>(:final error):
        return Result.error(error);
    }
  }

  Recipe _toDomain(RecipeApiModel api) {
    return Recipe(
      id: api.id,
      title: api.name,
      mealType: api.mealType,
      imageUrl: api.image,
      cookingMinutes: api.totalTimeMin,
      servings: api.servings < 1 ? 1 : api.servings,
      nutrition: Nutrition(
        calories: api.kcal,
        proteinGrams: api.proteinG,
        carbsGrams: api.carbsG,
        fatGrams: api.fatG,
      ),
      ingredients: List.unmodifiable(
        api.ingredients.map(
          (raw) => Ingredient(
            name: raw['name'] as String? ?? '',
            quantity: (raw['quantity'] as num? ?? 0).toDouble(),
            unit: raw['unit'] as String? ?? '',
          ),
        ),
      ),
      steps: List.unmodifiable(api.instructions),
    );
  }
}
