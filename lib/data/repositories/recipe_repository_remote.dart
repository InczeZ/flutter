import 'package:dio/dio.dart';

import '../../domain/models/recipe.dart';
import '../../utils/app_exception.dart';
import '../../utils/result.dart';
import '../models/meal_dto.dart';
import '../services/meal_db_api_service.dart';
import 'recipe_repository.dart';

/// A TheMealDB API-ra epulo repository. Feladatai:
/// - a DTO-k atalakitasa domain [Recipe]-pe, a hibas rekordok eldobasa,
/// - memoriabeli cache keresesi kifejezesenkent es azonositonkent,
/// - a Dio hibak atalakitasa [AppException]-ne.
class RecipeRepositoryRemote implements RecipeRepository {
  RecipeRepositoryRemote({required MealDbApiService apiService})
      : _api = apiService;

  final MealDbApiService _api;

  /// Cache first: egy mar lekert keresest nem kerunk le ujra.
  final Map<String, List<Recipe>> _searchCache = {};
  final Map<String, Recipe> _byId = {};

  @override
  Future<Result<List<Recipe>>> getRecipes() => searchRecipes('');

  @override
  Future<Result<List<Recipe>>> searchRecipes(String query) async {
    final key = query.trim().toLowerCase();
    final cached = _searchCache[key];
    if (cached != null) return Result.ok(cached);

    try {
      final dtos = await _api.searchMeals(key);
      final recipes = List<Recipe>.unmodifiable(
        dtos.map(_toDomain).whereType<Recipe>(),
      );
      _searchCache[key] = recipes;
      for (final recipe in recipes) {
        _byId[recipe.id] = recipe;
      }
      return Result.ok(recipes);
    } on DioException catch (e) {
      return Result.error(_mapDioError(e));
    } on Exception catch (e) {
      return Result.error(AppException(AppErrorType.unknown, e.toString()));
    }
  }

  @override
  Future<Result<Recipe>> getRecipe(String id) async {
    final cached = _byId[id];
    if (cached != null) return Result.ok(cached);

    try {
      final dto = await _api.lookupMeal(id);
      final recipe = dto == null ? null : _toDomain(dto);
      if (recipe == null) {
        return const Result.error(
          AppException(AppErrorType.invalidData, 'Recipe not found'),
        );
      }
      _byId[recipe.id] = recipe;
      return Result.ok(recipe);
    } on DioException catch (e) {
      return Result.error(_mapDioError(e));
    } on Exception catch (e) {
      return Result.error(AppException(AppErrorType.unknown, e.toString()));
    }
  }

  /// DTO -> domain mapping. Azonosito vagy nev nelkul a rekord nem
  /// azonosithato biztonsagosan, ezert null-t adunk (validacios hiba).
  Recipe? _toDomain(MealDto dto) {
    final id = dto.idMeal;
    final title = dto.strMeal;
    if (id == null || title == null) return null;

    return Recipe(
      id: id,
      title: title,
      category: dto.strCategory ?? 'Other',
      area: dto.strArea == 'Unknown' ? null : dto.strArea,
      imageUrl: dto.strMealThumb,
      ingredients: List.unmodifiable(
        dto.ingredients.map(
          (i) => Ingredient(name: i.name, measure: i.measure),
        ),
      ),
      steps: List.unmodifiable(_splitSteps(dto.strInstructions)),
    );
  }

  /// Az utasitasokat sorokra bontja. Az API neha kulon sorba irja a lepes
  /// szamat ("2" vagy "STEP 2"), ezeket kihagyjuk.
  static List<String> _splitSteps(String? instructions) {
    if (instructions == null) return const [];
    final stepLabel = RegExp(r'^(step\s*)?\d+[.):]?$', caseSensitive: false);
    return instructions
        .split(RegExp(r'[\r\n]+'))
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty && !stepLabel.hasMatch(line))
        .toList();
  }

  static AppException _mapDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return AppException(AppErrorType.timeout, e.message);
      case DioExceptionType.connectionError:
        return AppException(AppErrorType.noConnection, e.message);
      case DioExceptionType.badResponse:
        return AppException(
          AppErrorType.server,
          'HTTP ${e.response?.statusCode}',
        );
      case DioExceptionType.badCertificate:
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
        return AppException(AppErrorType.unknown, e.message);
    }
  }
}
