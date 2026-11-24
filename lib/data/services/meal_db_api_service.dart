import 'package:dio/dio.dart';

import '../models/meal_dto.dart';

/// Allapot nelkuli HTTP szerviz a TheMealDB API-hoz
/// (https://www.themealdb.com/api.php). Csak a kereseket vegzi es DTO-kat
/// ad vissza; a hibakat a repository alakitja at.
class MealDbApiService {
  MealDbApiService({Dio? dio}) : _dio = dio ?? createDio();

  static const baseUrl = 'https://www.themealdb.com/api/json/v1/1/';

  final Dio _dio;

  /// Kozponti Dio konfiguracio: alap URL es idokorlatok.
  static Dio createDio() {
    return Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        responseType: ResponseType.json,
      ),
    );
  }

  /// Receptek keresese nev alapjan. Ures [query] eseten az API egy
  /// alapertelmezett listat ad vissza.
  Future<List<MealDto>> searchMeals(String query) async {
    final response = await _dio.get<Map<String, dynamic>>(
      'search.php',
      queryParameters: {'s': query},
    );
    return _parseMeals(response.data);
  }

  /// Egy recept lekerese azonosito alapjan, null ha nincs ilyen.
  Future<MealDto?> lookupMeal(String id) async {
    final response = await _dio.get<Map<String, dynamic>>(
      'lookup.php',
      queryParameters: {'i': id},
    );
    final meals = _parseMeals(response.data);
    return meals.isEmpty ? null : meals.first;
  }

  /// Az API talalat nelkul {"meals": null} valaszt kuld, ezt ures listanak
  /// vesszuk.
  List<MealDto> _parseMeals(Map<String, dynamic>? body) {
    final meals = body?['meals'];
    if (meals is! List) return const [];
    return meals
        .whereType<Map<String, dynamic>>()
        .map(MealDto.fromJson)
        .toList();
  }
}
