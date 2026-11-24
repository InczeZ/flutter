/// TheMealDB "meal" objektum (DTO). A mezonevek az API-t kovetik
/// (idMeal, strMeal, ...), a mapping a repositoryban tortenik.
class MealDto {
  const MealDto({
    required this.idMeal,
    required this.strMeal,
    this.strCategory,
    this.strArea,
    this.strInstructions,
    this.strMealThumb,
    this.ingredients = const [],
  });

  /// Az API a hozzavalokat strIngredient1..20 es strMeasure1..20 mezokben
  /// kuldi. Ezeket egy listava fuzzuk ossze, az ures parokat kihagyjuk.
  factory MealDto.fromJson(Map<String, dynamic> json) {
    final ingredients = <MealIngredientDto>[];
    for (var i = 1; i <= 20; i++) {
      final name = _string(json['strIngredient$i']);
      if (name == null) continue;
      ingredients.add(
        MealIngredientDto(
          name: name,
          measure: _string(json['strMeasure$i']) ?? '',
        ),
      );
    }

    return MealDto(
      idMeal: _string(json['idMeal']),
      strMeal: _string(json['strMeal']),
      strCategory: _string(json['strCategory']),
      strArea: _string(json['strArea']),
      strInstructions: _string(json['strInstructions']),
      strMealThumb: _string(json['strMealThumb']),
      ingredients: ingredients,
    );
  }

  /// Hianyozhat: a repository az azonosito vagy nev nelkuli rekordokat eldobja.
  final String? idMeal;
  final String? strMeal;
  final String? strCategory;
  final String? strArea;
  final String? strInstructions;
  final String? strMealThumb;
  final List<MealIngredientDto> ingredients;

  /// Barmilyen erteket trimmelt szovegge alakit, az ures szoveg null lesz.
  static String? _string(Object? value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }
}

class MealIngredientDto {
  const MealIngredientDto({required this.name, required this.measure});

  final String name;
  final String measure;
}
