import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bollinger/providers/favorites_provider.dart';
import 'package:bollinger/ui/widgets/coin_list_tile.dart';
import 'coin_detail_screen.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favCoins = ref.watch(favoriteCoinsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Favoriler')),
      body: favCoins.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Hata: $e')),
        data: (coins) {
          if (coins.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star_border, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Henüz favori coin eklemediniz.\nTüm Coinler tabindan ekleyebilirsiniz.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
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
              onFavoriteToggle: () =>
                  ref.read(favoritesProvider.notifier).toggle(coins[i].symbol),
            ),
          );
        },
      ),
    );
  }
}
