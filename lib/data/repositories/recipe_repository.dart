import '../../domain/models/recipe.dart';
import '../../utils/result.dart';

/// A receptek egyetlen igazsagforrasa. A view modelek erre az absztrakciora
/// epulnek, igy a megvalositas (API, cache, mock) a UI modositasa nelkul
/// cserelheto.
abstract class RecipeRepository {
  /// Az alapertelmezett receptlista a Home kepernyohoz.
  Future<Result<List<Recipe>>> getRecipes();

  /// Receptek keresese nev alapjan.
  Future<Result<List<Recipe>>> searchRecipes(String query);

  Future<Result<Recipe>> getRecipe(String id);
}
