import 'package:flutter/material.dart';
import 'package:bollinger/core/theme/app_theme.dart';
import 'package:bollinger/data/models/bollinger_result.dart';

class BollingerStatusBadge extends StatelessWidget {
  final BollingerStatus status;

  const BollingerStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      BollingerStatus.upper => ('UST BANT', AppTheme.red),
      BollingerStatus.lower => ('ALT BANT', AppTheme.green),
      BollingerStatus.middle => ('ORTA', Colors.grey),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
