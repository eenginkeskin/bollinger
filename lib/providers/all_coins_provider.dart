import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bollinger/core/constants/app_constants.dart';
import 'package:bollinger/data/models/coin.dart';
import 'package:bollinger/data/repositories/binance_repository.dart';
import 'package:bollinger/providers/favorites_provider.dart';

final binanceRepositoryProvider = Provider((ref) => BinanceRepository());

final allTickersProvider =
    AsyncNotifierProvider<AllTickersNotifier, List<Coin>>(
        AllTickersNotifier.new);

class AllTickersNotifier extends AsyncNotifier<List<Coin>> {
  Timer? _timer;

  @override
  Future<List<Coin>> build() async {
    ref.onDispose(() => _timer?.cancel());
    _startAutoRefresh();
    return _fetch();
  }

  Future<List<Coin>> _fetch() async {
    final repo = ref.read(binanceRepositoryProvider);
    final coins = await repo.fetchAllTickers();
    final favorites = await ref.read(favoritesProvider.future);
    return coins
        .map((c) => c.copyWith(isFavorite: favorites.contains(c.symbol)))
        .toList();
  }

  void _startAutoRefresh() {
    _timer = Timer.periodic(AppConstants.tickerRefreshInterval, (_) async {
      state = AsyncData(await _fetch());
    });
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(await _fetch());
  }
}

final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredCoinsProvider = Provider<AsyncValue<List<Coin>>>((ref) {
  final query = ref.watch(searchQueryProvider).toLowerCase();
  final coinsAsync = ref.watch(allTickersProvider);
  return coinsAsync.whenData((coins) {
    if (query.isEmpty) return coins;
    return coins.where((c) => c.symbol.toLowerCase().contains(query)).toList();
  });
});
