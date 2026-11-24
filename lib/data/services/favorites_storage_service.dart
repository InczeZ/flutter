import 'package:shared_preferences/shared_preferences.dart';

/// Allapot nelkuli wrapper a SharedPreferences kore. A kedvencekbol csak az
/// azonositokat mentjuk: kis, egyszeru kulcs-ertek adat, erre a
/// SharedPreferences eleg, adatbazis nem kell.
class FavoritesStorageService {
  const FavoritesStorageService(this._prefs);

  static const _key = 'favorite_recipe_ids';

  final SharedPreferences _prefs;

  Set<String> loadIds() => (_prefs.getStringList(_key) ?? const []).toSet();

  /// false-t ad vissza, ha a mentes nem sikerult.
  Future<bool> saveIds(Set<String> ids) =>
      _prefs.setStringList(_key, ids.toList()..sort());
}
