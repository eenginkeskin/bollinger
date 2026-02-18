import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bollinger/providers/all_coins_provider.dart';
import 'package:bollinger/providers/favorites_provider.dart';
import 'package:bollinger/ui/widgets/coin_list_tile.dart';
import 'package:bollinger/ui/widgets/search_bar_widget.dart';
import 'coin_detail_screen.dart';

class AllCoinsScreen extends ConsumerWidget {
  const AllCoinsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredAsync = ref.watch(filteredCoinsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Tüm Coinler')),
      body: Column(
        children: [
          SearchBarWidget(
            onChanged: (q) =>
                ref.read(searchQueryProvider.notifier).state = q,
          ),
          Expanded(
            child: filteredAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Hata: $e')),
              data: (coins) => RefreshIndicator(
                onRefresh: () =>
                    ref.read(allTickersProvider.notifier).refresh(),
                child: ListView.builder(
                  itemCount: coins.length,
                  itemBuilder: (_, i) => CoinListTile(
                    coin: coins[i],
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            CoinDetailScreen(symbol: coins[i].symbol),
                      ),
                    ),
                    onFavoriteToggle: () => ref
                        .read(favoritesProvider.notifier)
                        .toggle(coins[i].symbol),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
