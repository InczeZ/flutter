import 'package:flutter/foundation.dart';

/// A recept tiszta domain modellje. A repository feletti retegek mind ezt
/// hasznaljak, a nyers API formatumot (MealDto) sosem latjak.
@immutable
class Recipe {
  const Recipe({
    required this.id,
    required this.title,
    required this.category,
    required this.area,
    required this.imageUrl,
    required this.ingredients,
    required this.steps,
  });

  final String id;
  final String title;

  /// Pl. "Dessert" vagy "Chicken"; ha az API nem kuldi, "Other".
  final String category;

  /// A konyha szarmazasa, pl. "Japanese"; null, ha ismeretlen.
  final String? area;

  /// Null, ha nincs kep; ilyenkor a UI helyettesito kepet mutat.
  final String? imageUrl;
  final List<Ingredient> ingredients;
  final List<String> steps;

  @override
  bool operator ==(Object other) => other is Recipe && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

@immutable
class Ingredient {
  const Ingredient({required this.name, required this.measure});

  final String name;

  /// Szabad szoveges mennyiseg az API-bol, pl. "100g" vagy "1/2 cup".
  final String measure;
}
