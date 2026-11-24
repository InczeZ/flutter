import '../../domain/models/recipe.dart';
import '../../utils/result.dart';

/// A receptek egyetlen igazsagforrasa. A view modelek erre az absztrakciora
/// epulnek, igy a tesztek hamis implementaciot adhatnak at, a Sprint 2-ben
/// pedig lecserelheto egy tavoli (API-s) valtozatra.
abstract class RecipeRepository {
  Future<Result<List<Recipe>>> getRecipes();

  Future<Result<Recipe>> getRecipe(String id);
}
