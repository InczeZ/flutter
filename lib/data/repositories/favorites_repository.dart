import 'package:flutter/foundation.dart';

import '../../utils/app_exception.dart';
import '../../utils/result.dart';
import '../services/favorites_storage_service.dart';

/// A kedvencek kozos, tartos allapota. Minden kepernyo ezt figyeli, igy a
/// Home es a Recipe kepernyo mindig ugyanazt mutatja, es a kedvencek az
/// ujrainditas utan is megmaradnak.
class FavoritesRepository extends ChangeNotifier {
  FavoritesRepository({required FavoritesStorageService storage})
      : _storage = storage,
        _ids = storage.loadIds();

  final FavoritesStorageService _storage;
  final Set<String> _ids;

  Set<String> get ids => Set.unmodifiable(_ids);

  bool isFavorite(String recipeId) => _ids.contains(recipeId);

  /// Optimista frissites: a UI azonnal valtozik, es ha a mentes nem
  /// sikerul, visszaallitjuk az elozo allapotot.
  Future<Result<void>> toggle(String recipeId) async {
    final wasFavorite = _ids.contains(recipeId);
    _apply(recipeId, favorite: !wasFavorite);

    final saved = await _storage.saveIds(_ids);
    if (saved) return const Result.ok(null);

    _apply(recipeId, favorite: wasFavorite);
    return const Result.error(
      AppException(AppErrorType.storage, 'Could not save favorites'),
    );
  }

  void _apply(String recipeId, {required bool favorite}) {
    if (favorite) {
      _ids.add(recipeId);
    } else {
      _ids.remove(recipeId);
    }
    notifyListeners();
  }
}
