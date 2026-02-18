import 'package:flutter/material.dart';
import 'package:bollinger/core/theme/app_theme.dart';
import 'package:bollinger/core/utils/number_formatter.dart';
import 'package:bollinger/data/models/coin.dart';

class CoinListTile extends StatelessWidget {
  final Coin coin;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;

  const CoinListTile({
    super.key,
    required this.coin,
    this.onTap,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = coin.priceChangePercent >= 0;
    final changeColor = isPositive ? AppTheme.green : AppTheme.red;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: AppTheme.surface,
          child: Text(
            coin.symbol.replaceAll('USDT', '').substring(0, coin.symbol.replaceAll('USDT', '').length.clamp(0, 3)),
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          coin.symbol.replaceAll('USDT', '/USDT'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          NumberFormatter.formatPrice(coin.price),
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: changeColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                NumberFormatter.formatPercent(coin.priceChangePercent),
                style: TextStyle(
                  color: changeColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onFavoriteToggle,
              child: Icon(
                coin.isFavorite ? Icons.star : Icons.star_border,
                color: coin.isFavorite ? AppTheme.yellow : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
