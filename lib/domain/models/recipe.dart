import 'package:flutter/foundation.dart';

/// A recept tiszta domain modellje. A repository feletti retegek mind ezt
/// hasznaljak, a nyers API formatumot sosem latjak.
@immutable
class Recipe {
  const Recipe({
    required this.id,
    required this.title,
    required this.mealType,
    required this.imageUrl,
    required this.cookingMinutes,
    required this.servings,
    required this.nutrition,
    required this.ingredients,
    required this.steps,
  });

  final String id;
  final String title;

  /// Breakfast, Lunch, Dinner vagy Snack (reggeli, ebed, vacsora, nasi).
  final String mealType;
  final String imageUrl;
  final int cookingMinutes;

  /// Hany adagra vonatkoznak a hozzavalok mennyisegei.
  final int servings;
  final Nutrition nutrition;
  final List<Ingredient> ingredients;
  final List<String> steps;

  @override
  bool operator ==(Object other) => other is Recipe && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

/// Tapertekek egy adagra.
@immutable
class Nutrition {
  const Nutrition({
    required this.calories,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatGrams,
  });

  final int calories;
  final int proteinGrams;
  final int carbsGrams;
  final int fatGrams;
}

@immutable
class Ingredient {
  const Ingredient({
    required this.name,
    required this.quantity,
    required this.unit,
  });

  final String name;

  /// Mennyiseg a recept alap adagszamara ([Recipe.servings]).
  final double quantity;
  final String unit;
}
