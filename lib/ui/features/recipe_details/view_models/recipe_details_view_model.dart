import 'package:flutter/foundation.dart';

import '../../../../data/repositories/favorites_repository.dart';
import '../../../../domain/models/recipe.dart';
import '../../../../utils/result.dart';

/// A kivalasztott [Recipe] a konstruktoron keresztul erkezik, igy egyetlen
/// reszletek kepernyo szolgal ki minden receptet. A view model kezeli a
/// kedvenc allapotot (a kozos FavoritesRepository-n at) es a mennyiseg
/// szorzot, amellyel a hozzavalok mennyisegeit skalazzuk.
class RecipeDetailsViewModel extends ChangeNotifier {
  RecipeDetailsViewModel({
    required this.recipe,
    required FavoritesRepository favoritesRepository,
  }) : _favoritesRepository = favoritesRepository {
    _favoritesRepository.addListener(notifyListeners);
  }

  static const minMultiplier = 1;
  static const maxMultiplier = 8;

  final Recipe recipe;
  final FavoritesRepository _favoritesRepository;

  /// Az API nem adja meg az adagszamot, ezert a recept eredeti mennyiseget
  /// szorozzuk (x1, x2, ...).
  int _multiplier = minMultiplier;
  int get multiplier => _multiplier;

  bool get canDecrement => _multiplier > minMultiplier;
  bool get canIncrement => _multiplier < maxMultiplier;

  bool get isFavorite => _favoritesRepository.isFavorite(recipe.id);

  Future<Result<void>> toggleFavorite() =>
      _favoritesRepository.toggle(recipe.id);

  void increment() {
    if (!canIncrement) return;
    _multiplier++;
    notifyListeners();
  }

  void decrement() {
    if (!canDecrement) return;
    _multiplier--;
    notifyListeners();
  }

  void reset() {
    if (_multiplier == minMultiplier) return;
    _multiplier = minMultiplier;
    notifyListeners();
  }

  /// Az [ingredient] mennyisege az aktualis szorzoval, pl. "200g" x2 ->
  /// "400g". Ha a mennyiseg nem szammal kezdodik (pl. "To taste"),
  /// valtozatlanul adjuk vissza.
  String amountFor(Ingredient ingredient) =>
      scaleMeasure(ingredient.measure, _multiplier);

  @visibleForTesting
  static String scaleMeasure(String measure, int multiplier) {
    if (multiplier == 1) return measure;
    final match = _leadingNumber.firstMatch(measure);
    if (match == null) return measure;

    final value = _parseNumber(match.group(1)!);
    if (value == null) return measure;
    return '${_format(value * multiplier)}${match.group(2)}';
  }

  /// Elol allo szam: egesz, tizedes, tort ("1/2") vagy vegyes tort ("1 1/2").
  static final _leadingNumber =
      RegExp(r'^\s*(\d+\s+\d+/\d+|\d+/\d+|\d+(?:[.,]\d+)?)(.*)$');

  static double? _parseNumber(String text) {
    final parts = text.trim().split(RegExp(r'\s+'));
    var total = 0.0;
    for (final part in parts) {
      if (part.contains('/')) {
        final pieces = part.split('/');
        final numerator = double.tryParse(pieces.first);
        final denominator = double.tryParse(pieces.last);
        if (numerator == null || denominator == null || denominator == 0) {
          return null;
        }
        total += numerator / denominator;
      } else {
        final value = double.tryParse(part.replaceAll(',', '.'));
        if (value == null) return null;
        total += value;
      }
    }
    return total;
  }

  static String _format(double value) {
    if (value == value.roundToDouble()) return value.toInt().toString();
    final text = value.toStringAsFixed(2);
    return text
        .replaceFirst(RegExp(r'0+$'), '')
        .replaceFirst(RegExp(r'\.$'), '');
  }

  @override
  void dispose() {
    _favoritesRepository.removeListener(notifyListeners);
    super.dispose();
  }
}
