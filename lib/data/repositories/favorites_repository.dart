import 'package:shared_preferences/shared_preferences.dart';
import 'package:bollinger/core/constants/app_constants.dart';

class FavoritesRepository {
  Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(AppConstants.favoritesKey) ?? [];
  }

  Future<void> addFavorite(String symbol) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(AppConstants.favoritesKey) ?? [];
    if (!favorites.contains(symbol)) {
      favorites.add(symbol);
      await prefs.setStringList(AppConstants.favoritesKey, favorites);
    }
  }

  Future<void> removeFavorite(String symbol) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(AppConstants.favoritesKey) ?? [];
    favorites.remove(symbol);
    await prefs.setStringList(AppConstants.favoritesKey, favorites);
  }

  Future<bool> isFavorite(String symbol) async {
    final favorites = await getFavorites();
    return favorites.contains(symbol);
  }
}
