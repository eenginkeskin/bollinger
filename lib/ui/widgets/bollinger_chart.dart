import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:bollinger/core/theme/app_theme.dart';
import 'package:bollinger/core/utils/number_formatter.dart';
import 'package:bollinger/data/models/kline.dart';
import 'package:bollinger/data/models/bollinger_result.dart';
import 'package:bollinger/core/constants/app_constants.dart';

class BollingerChart extends StatelessWidget {
  final List<Kline> klines;
  final BollingerResult result;

  const BollingerChart({
    super.key,
    required this.klines,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final offset = AppConstants.bollingerPeriod - 1;
    final visibleKlines = klines.sublist(offset);

    final priceSpots = <FlSpot>[];
    for (int i = 0; i < visibleKlines.length; i++) {
      priceSpots.add(FlSpot(i.toDouble(), visibleKlines[i].close));
    }

    final upperSpots = <FlSpot>[];
    final middleSpots = <FlSpot>[];
    final lowerSpots = <FlSpot>[];
    for (int i = 0; i < result.upperBand.length; i++) {
      upperSpots.add(FlSpot(i.toDouble(), result.upperBand[i]));
      middleSpots.add(FlSpot(i.toDouble(), result.middleBand[i]));
      lowerSpots.add(FlSpot(i.toDouble(), result.lowerBand[i]));
    }

    final allValues = [
      ...result.upperBand,
      ...result.lowerBand,
      ...visibleKlines.map((k) => k.close),
    ];
    final minY = allValues.reduce((a, b) => a < b ? a : b);
    final maxY = allValues.reduce((a, b) => a > b ? a : b);
    final padding = (maxY - minY) * 0.05;

    return Column(
      children: [
        SizedBox(
          height: 300,
          child: Padding(
            padding: const EdgeInsets.only(right: 16, top: 8),
            child: LineChart(
              LineChartData(
                minY: minY - padding,
                maxY: maxY + padding,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: Colors.white10,
                    strokeWidth: 0.5,
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 60,
                      getTitlesWidget: (value, _) => Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Text(
                          NumberFormatter.formatPrice(value),
                          style: const TextStyle(
                              fontSize: 9, color: Colors.white54),
                        ),
                      ),
                    ),
                  ),
                  bottomTitles:
                      const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles:
                      const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  _line(priceSpots, AppTheme.priceLine, 2),
                  _line(upperSpots, AppTheme.upperBand, 1),
                  _line(middleSpots, AppTheme.middleBand, 1, dashed: true),
                  _line(lowerSpots, AppTheme.lowerBand, 1),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (spots) => spots.map((spot) {
                      return LineTooltipItem(
                        NumberFormatter.formatPrice(spot.y),
                        TextStyle(
                          color: spot.bar.color,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        _CandlestickOverlay(klines: visibleKlines),
      ],
    );
  }

  LineChartBarData _line(List<FlSpot> spots, Color color, double width,
      {bool dashed = false}) {
    return LineChartBarData(
      spots: spots,
      isCurved: false,
      color: color,
      barWidth: width,
      dotData: const FlDotData(show: false),
      dashArray: dashed ? [5, 3] : null,
      belowBarData: BarAreaData(show: false),
    );
  }
}

class _CandlestickOverlay extends StatelessWidget {
  final List<Kline> klines;
  const _CandlestickOverlay({required this.klines});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: CustomPaint(
        size: const Size(double.infinity, 80),
        painter: _CandlestickPainter(klines),
      ),
    );
  }
}

class _CandlestickPainter extends CustomPainter {
  final List<Kline> klines;
  _CandlestickPainter(this.klines);

  @override
  void paint(Canvas canvas, Size size) {
    if (klines.isEmpty) return;
    final allPrices = klines.expand((k) => [k.high, k.low]);
    final minP = allPrices.reduce((a, b) => a < b ? a : b);
    final maxP = allPrices.reduce((a, b) => a > b ? a : b);
    final range = maxP - minP;
    if (range == 0) return;

    final candleWidth = size.width / klines.length;

    for (int i = 0; i < klines.length; i++) {
      final k = klines[i];
      final x = i * candleWidth + candleWidth / 2;
      final isGreen = k.close >= k.open;
      final color = isGreen ? AppTheme.green : AppTheme.red;

      final highY = size.height - ((k.high - minP) / range) * size.height;
      final lowY = size.height - ((k.low - minP) / range) * size.height;
      final openY = size.height - ((k.open - minP) / range) * size.height;
      final closeY = size.height - ((k.close - minP) / range) * size.height;

      // Wick
      canvas.drawLine(
        Offset(x, highY),
        Offset(x, lowY),
        Paint()
          ..color = color
          ..strokeWidth = 1,
      );

      // Body
      final bodyTop = isGreen ? closeY : openY;
      final bodyBottom = isGreen ? openY : closeY;
      canvas.drawRect(
        Rect.fromLTRB(
          x - candleWidth * 0.3,
          bodyTop,
          x + candleWidth * 0.3,
          bodyBottom < bodyTop + 1 ? bodyTop + 1 : bodyBottom,
        ),
        Paint()..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
