import '../models/recipe_api_model.dart';

/// Allapot nelkuli adatforras, amely mock recepteket ad vissza. A Sprint 2-ben
/// egy ugyanilyen metodusu REST kliens valthatja le, a UI reteg modositasa
/// nelkul.
class RecipeLocalService {
  const RecipeLocalService({this.latency = const Duration(milliseconds: 400)});

  /// Szimulalt halozati kesleltetes, hogy a betoltesi allapot lathato legyen.
  final Duration latency;

  Future<List<RecipeApiModel>> fetchRecipes() async {
    await Future<void>.delayed(latency);
    return _mockJson.map(RecipeApiModel.fromJson).toList();
  }
}

const List<Map<String, dynamic>> _mockJson = [
  {
    'id': 'teriyaki-chicken',
    'name': 'Teriyaki Chicken',
    'meal_type': 'Dinner',
    'image':
        'https://images.unsplash.com/photo-1598515214211-89d3c73ae83b?w=800',
    'total_time_min': 30,
    'servings': 2,
    'kcal': 540,
    'protein_g': 42,
    'carbs_g': 38,
    'fat_g': 22,
    'ingredients': [
      {'name': 'Chicken thighs', 'quantity': 400, 'unit': 'g'},
      {'name': 'Soy sauce', 'quantity': 3, 'unit': 'tbsp'},
      {'name': 'Honey', 'quantity': 1, 'unit': 'tbsp'},
      {'name': 'Sesame seeds', 'quantity': 1, 'unit': 'tsp'},
      {'name': 'Baby spinach', 'quantity': 60, 'unit': 'g'},
    ],
    'instructions': [
      'Mix the soy sauce and honey into a glaze.',
      'Pan-fry the chicken for 6 minutes on each side.',
      'Pour over the glaze and reduce until sticky.',
      'Slice, sprinkle with sesame seeds and serve with spinach.',
    ],
  },
  {
    'id': 'chicken-skewers',
    'name': 'Grilled Chicken Skewers',
    'meal_type': 'Lunch',
    'image':
        'https://images.unsplash.com/photo-1603360946369-dc9bb6258143?w=800',
    'total_time_min': 25,
    'servings': 2,
    'kcal': 460,
    'protein_g': 36,
    'carbs_g': 44,
    'fat_g': 14,
    'ingredients': [
      {'name': 'Chicken breasts', 'quantity': 300, 'unit': 'g'},
      {'name': 'Red onion', 'quantity': 1, 'unit': 'pc'},
      {'name': 'Bell pepper', 'quantity': 1, 'unit': 'pc'},
      {'name': 'Basmati rice', 'quantity': 150, 'unit': 'g'},
    ],
    'instructions': [
      'Cube the chicken and vegetables and thread them onto skewers.',
      'Grill for 10 to 12 minutes, turning often.',
      'Serve with the cooked rice.',
    ],
  },
  {
    'id': 'ramen',
    'name': 'Ramen',
    'meal_type': 'Lunch',
    'image':
        'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=800',
    'total_time_min': 15,
    'servings': 2,
    'kcal': 100,
    'protein_g': 15,
    'carbs_g': 58,
    'fat_g': 20,
    'ingredients': [
      {'name': 'Chicken breasts', 'quantity': 250, 'unit': 'g'},
      {'name': 'Unsalted butter', 'quantity': 1, 'unit': 'tbsp'},
      {'name': 'Sesame or vegetable oil', 'quantity': 2, 'unit': 'tsp'},
      {'name': 'Fresh ginger', 'quantity': 2, 'unit': 'tsp'},
      {'name': 'Large eggs', 'quantity': 100, 'unit': 'g'},
      {'name': 'Ramen noodles', 'quantity': 200, 'unit': 'g'},
    ],
    'instructions': [
      'Bring the stock to a simmer with the ginger.',
      'Cook the noodles according to the package.',
      'Soft-boil the eggs for 6 minutes.',
      'Assemble the bowl with the sliced chicken and halved eggs.',
    ],
  },
];
