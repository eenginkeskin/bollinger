import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bollinger/core/constants/app_constants.dart';
import 'package:bollinger/core/theme/app_theme.dart';
import 'package:bollinger/core/utils/number_formatter.dart';
import 'package:bollinger/providers/coin_detail_provider.dart';
import 'package:bollinger/ui/widgets/bollinger_chart.dart';
import 'package:bollinger/ui/widgets/bollinger_status_badge.dart';

class CoinDetailScreen extends ConsumerWidget {
  final String symbol;
  const CoinDetailScreen({super.key, required this.symbol});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final klineAsync = ref.watch(klineProvider(symbol));
    final bollingerAsync = ref.watch(bollingerResultProvider(symbol));
    final selectedInterval = ref.watch(selectedIntervalProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(symbol.replaceAll('USDT', '/USDT')),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Interval selector
              Row(
                children: AppConstants.intervals.map((interval) {
                  final isSelected = interval == selectedInterval;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(interval),
                      selected: isSelected,
                      selectedColor: AppTheme.surface,
                      onSelected: (_) => ref
                          .read(selectedIntervalProvider.notifier)
                          .state = interval,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Chart
              klineAsync.when(
                loading: () =>
                    const SizedBox(height: 380, child: Center(child: CircularProgressIndicator())),
                error: (e, _) => Text('Hata: $e'),
                data: (klines) => bollingerAsync.when(
                  loading: () =>
                      const SizedBox(height: 380, child: Center(child: CircularProgressIndicator())),
                  error: (e, _) => Text('Hata: $e'),
                  data: (result) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BollingerChart(klines: klines, result: result),
                      const SizedBox(height: 20),

                      // Status badge
                      Row(
                        children: [
                          const Text('Durum: ',
                              style: TextStyle(fontSize: 16)),
                          BollingerStatusBadge(
                              status: result.currentStatus),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Band values
                      _bandRow('Fiyat', result.currentPrice,
                          AppTheme.priceLine),
                      _bandRow('Ust Bant', result.currentUpper,
                          AppTheme.upperBand),
                      _bandRow('Orta Bant', result.currentMiddle,
                          AppTheme.middleBand),
                      _bandRow('Alt Bant', result.currentLower,
                          AppTheme.lowerBand),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bandRow(String label, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                  width: 12, height: 12,
                  decoration: BoxDecoration(
                      color: color, shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Text(label),
            ],
          ),
          Text(
            NumberFormatter.formatPrice(value),
            style: TextStyle(
                color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
