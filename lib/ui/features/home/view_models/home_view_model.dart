import 'package:flutter/foundation.dart';

import '../../../../data/repositories/recipe_repository.dart';
import '../../../../domain/models/daily_progress.dart';
import '../../../../domain/models/recipe.dart';
import '../../../../utils/result.dart';

enum HomeStatus { loading, success, empty, error }

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({required RecipeRepository recipeRepository})
      : _recipeRepository = recipeRepository;

  final RecipeRepository _recipeRepository;

  /// Helyettesito ertekek, amig egy kesobbi sprintben elkeszul az etkezesnaplo.
  final DailyProgress progress = const DailyProgress(
    calories: 1284,
    fatPercent: 0.29,
    proteinPercent: 0.65,
    carbsPercent: 0.85,
    message: 'Keep the pace! You\'re doing great.',
  );

  HomeStatus _status = HomeStatus.loading;
  HomeStatus get status => _status;

  List<Recipe> _recipes = const [];
  List<Recipe> get recipes => _recipes;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> load() async {
    // Csak akkor ertesitunk, ha az allapot tenylegesen valtozik. Az elso
    // betoltes meg a widget fa epitese kozben fut, es akkor az ertesites hibat dob.
    if (_status != HomeStatus.loading) {
      _status = HomeStatus.loading;
      _errorMessage = null;
      notifyListeners();
    }

    final result = await _recipeRepository.getRecipes();
    switch (result) {
      case Ok<List<Recipe>>(:final value):
        _recipes = value;
        _status = value.isEmpty ? HomeStatus.empty : HomeStatus.success;
      case Error<List<Recipe>>(:final error):
        _recipes = const [];
        _errorMessage = error.toString();
        _status = HomeStatus.error;
    }
    notifyListeners();
  }
}
