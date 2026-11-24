/// Nyers recept, ahogy az adatforras adja (most mock JSON, kesobb REST API).
/// A mezonevek a forrast kovetik, nem az appot.
class RecipeApiModel {
  const RecipeApiModel({
    required this.id,
    required this.name,
    required this.mealType,
    required this.image,
    required this.totalTimeMin,
    required this.servings,
    required this.kcal,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.ingredients,
    required this.instructions,
  });

  factory RecipeApiModel.fromJson(Map<String, dynamic> json) {
    return RecipeApiModel(
      id: json['id'] as String,
      name: json['name'] as String,
      mealType: json['meal_type'] as String? ?? '',
      image: json['image'] as String? ?? '',
      totalTimeMin: json['total_time_min'] as int? ?? 0,
      servings: json['servings'] as int? ?? 1,
      kcal: json['kcal'] as int? ?? 0,
      proteinG: json['protein_g'] as int? ?? 0,
      carbsG: json['carbs_g'] as int? ?? 0,
      fatG: json['fat_g'] as int? ?? 0,
      ingredients: (json['ingredients'] as List<dynamic>? ?? const [])
          .cast<Map<String, dynamic>>(),
      instructions:
          (json['instructions'] as List<dynamic>? ?? const []).cast<String>(),
    );
  }

  final String id;
  final String name;
  final String mealType;
  final String image;
  final int totalTimeMin;
  final int servings;
  final int kcal;
  final int proteinG;
  final int carbsG;
  final int fatG;
  final List<Map<String, dynamic>> ingredients;
  final List<String> instructions;
}
