import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../../data/repositories/favorites_repository.dart';
import '../../../../data/repositories/recipe_repository.dart';
import '../../../../domain/models/daily_progress.dart';
import '../../../../domain/models/recipe.dart';
import '../../../../utils/app_exception.dart';
import '../../../../utils/result.dart';

enum HomeStatus { loading, success, empty, error }

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    required RecipeRepository recipeRepository,
    required FavoritesRepository favoritesRepository,
    this.searchDebounce = const Duration(milliseconds: 400),
  })  : _recipeRepository = recipeRepository,
        _favoritesRepository = favoritesRepository {
    _favoritesRepository.addListener(notifyListeners);
  }

  final RecipeRepository _recipeRepository;
  final FavoritesRepository _favoritesRepository;

  /// Ennyi ideig varunk a gepeles utan, mielott elinditjuk a keresest.
  final Duration searchDebounce;

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

  AppException? _error;
  AppException? get error => _error;

  String _query = '';
  String get query => _query;

  Timer? _debounce;

  /// Minden keres kap egy sorszamot. Ha egy regebbi keres valasza a
  /// frissebb utan erkezik meg, eldobjuk (race condition elleni vedelem).
  int _requestId = 0;

  bool _disposed = false;

  bool isFavorite(Recipe recipe) => _favoritesRepository.isFavorite(recipe.id);

  Future<Result<void>> toggleFavorite(Recipe recipe) =>
      _favoritesRepository.toggle(recipe.id);

  /// Betolti az aktualis keresesnek megfelelo recepteket (retry is ezt hivja).
  Future<void> load() => _fetch(_query);

  /// A keresomezo minden valtozasakor hivodik. Debounce: csak akkor
  /// kerdezzuk az API-t, ha a felhasznalo [searchDebounce] ideig nem gepelt.
  void onQueryChanged(String value) {
    final query = value.trim();
    if (query == _query) return;
    _query = query;
    _debounce?.cancel();
    _debounce = Timer(searchDebounce, () => _fetch(_query));
  }

  /// Torli a keresest, es azonnal visszatolti az alap listat.
  void clearQuery() {
    _debounce?.cancel();
    if (_query.isEmpty) return;
    _query = '';
    _fetch('');
  }

  Future<void> _fetch(String query) async {
    final requestId = ++_requestId;

    // Csak akkor ertesitunk, ha az allapot tenylegesen valtozik. Az elso
    // betoltes meg a widget fa epitese kozben fut, es akkor az ertesites hibat dob.
    if (_status != HomeStatus.loading) {
      _status = HomeStatus.loading;
      _error = null;
      notifyListeners();
    }

    final result = query.isEmpty
        ? await _recipeRepository.getRecipes()
        : await _recipeRepository.searchRecipes(query);

    if (_disposed || requestId != _requestId) return;

    switch (result) {
      case Ok<List<Recipe>>(:final value):
        _recipes = value;
        _error = null;
        _status = value.isEmpty ? HomeStatus.empty : HomeStatus.success;
      case Error<List<Recipe>>(:final error):
        _recipes = const [];
        _error = error is AppException
            ? error
            : AppException(AppErrorType.unknown, error.toString());
        _status = HomeStatus.error;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _debounce?.cancel();
    _favoritesRepository.removeListener(notifyListeners);
    super.dispose();
  }
}
