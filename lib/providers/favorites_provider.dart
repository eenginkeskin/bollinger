import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bollinger/data/models/coin.dart';
import 'package:bollinger/data/repositories/favorites_repository.dart';
import 'package:bollinger/providers/all_coins_provider.dart';

final favoritesRepositoryProvider = Provider((ref) => FavoritesRepository());

final favoritesProvider =
    AsyncNotifierProvider<FavoritesNotifier, List<String>>(
        FavoritesNotifier.new);

class FavoritesNotifier extends AsyncNotifier<List<String>> {
  @override
  Future<List<String>> build() async {
    final repo = ref.read(favoritesRepositoryProvider);
    return repo.getFavorites();
  }

  Future<void> toggle(String symbol) async {
    final repo = ref.read(favoritesRepositoryProvider);
    final current = await future;
    if (current.contains(symbol)) {
      await repo.removeFavorite(symbol);
    } else {
      await repo.addFavorite(symbol);
    }
    ref.invalidateSelf();
    ref.invalidate(allTickersProvider);
  }
}

final favoriteCoinsProvider = FutureProvider<List<Coin>>((ref) async {
  final symbols = await ref.watch(favoritesProvider.future);
  if (symbols.isEmpty) return [];
  final repo = ref.read(binanceRepositoryProvider);
  final allCoins = await repo.fetchAllTickers();
  return allCoins
      .where((c) => symbols.contains(c.symbol))
      .map((c) => c.copyWith(isFavorite: true))
      .toList();
});
