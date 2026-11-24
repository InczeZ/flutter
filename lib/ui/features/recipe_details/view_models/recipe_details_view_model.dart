import 'package:flutter/foundation.dart';

import '../../../../domain/models/recipe.dart';

/// A kivalasztott [Recipe] a konstruktoron keresztul erkezik, igy egyetlen
/// reszletek kepernyo szolgal ki minden receptet. A view model kezeli az
/// adagszam leptetot, es ahhoz igazitja a hozzavalok mennyiseget.
class RecipeDetailsViewModel extends ChangeNotifier {
  RecipeDetailsViewModel({required this.recipe}) : _servings = recipe.servings;

  static const minServings = 1;
  static const maxServings = 12;

  final Recipe recipe;

  int _servings;
  int get servings => _servings;

  bool get canDecrement => _servings > minServings;
  bool get canIncrement => _servings < maxServings;

  void incrementServings() {
    if (!canIncrement) return;
    _servings++;
    notifyListeners();
  }

  void decrementServings() {
    if (!canDecrement) return;
    _servings--;
    notifyListeners();
  }

  void resetServings() {
    if (_servings == recipe.servings) return;
    _servings = recipe.servings;
    notifyListeners();
  }

  /// Az [ingredient] mennyisege az aktualis adagszamra, pl. "250 g".
  String amountFor(Ingredient ingredient) {
    final scaled = ingredient.quantity * _servings / recipe.servings;
    return '${_formatQuantity(scaled)} ${ingredient.unit}'.trim();
  }

  static String _formatQuantity(double value) {
    if (value == value.roundToDouble()) return value.toInt().toString();
    final text = value.toStringAsFixed(1);
    return text.endsWith('.0') ? text.substring(0, text.length - 2) : text;
  }
}
