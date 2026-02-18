import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bollinger/core/constants/app_constants.dart';
import 'package:bollinger/core/theme/app_theme.dart';
import 'package:bollinger/providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(bollingerSettingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar')),
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Hata: $e')),
        data: (settings) {
          final period = settings.params['period'] ?? 20;
          final stdDev = settings.params['stdDev'] ?? 2.0;
          final notifUpper = settings.notifications['upperBand'] ?? true;
          final notifLower = settings.notifications['lowerBand'] ?? true;
          final notifier = ref.read(bollingerSettingsProvider.notifier);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Section header
              const Text(
                'İndikatörler',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 8),

              // Bollinger card
              Card(
                child: Column(
                  children: [
                    // On/off toggle
                    SwitchListTile(
                      title: const Text(
                        'Bollinger Bands',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        settings.enabled ? 'Aktif' : 'Pasif',
                        style: TextStyle(
                          color: settings.enabled
                              ? AppTheme.green
                              : Colors.grey,
                        ),
                      ),
                      value: settings.enabled,
                      activeColor: AppTheme.green,
                      onChanged: (v) => notifier.setEnabled(v),
                    ),

                    // Settings (only when enabled)
                    if (settings.enabled) ...[
                      const Divider(height: 1),

                      // Period slider
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Periyot'),
                            Text(
                              period.toInt().toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Slider(
                        value: period,
                        min: 5,
                        max: 50,
                        divisions: 45,
                        label: period.toInt().toString(),
                        onChanged: (v) =>
                            notifier.updateParam('period', v.roundToDouble()),
                      ),

                      // StdDev slider
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Standart Sapma'),
                            Text(
                              stdDev.toStringAsFixed(1),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Slider(
                        value: stdDev,
                        min: 0.5,
                        max: 3.0,
                        divisions: 25,
                        label: stdDev.toStringAsFixed(1),
                        onChanged: (v) => notifier.updateParam(
                          'stdDev',
                          double.parse(v.toStringAsFixed(1)),
                        ),
                      ),

                      const Divider(height: 1),

                      // Interval selector
                      ListTile(
                        leading: const Icon(Icons.access_time,
                            color: Colors.grey),
                        title: const Text('Bildirim Zaman Dilimi'),
                        subtitle: const Text(
                          'Arka plan kontrolunde kullanilacak mum araligi',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        trailing: DropdownButton<String>(
                          value: settings.interval,
                          underline: const SizedBox(),
                          dropdownColor: AppTheme.cardColor,
                          items: AppConstants.intervals.map((i) {
                            return DropdownMenuItem(
                              value: i,
                              child: Text(i),
                            );
                          }).toList(),
                          onChanged: (v) {
                            if (v != null) notifier.setInterval(v);
                          },
                        ),
                      ),

                      const Divider(height: 1),

                      // Notification header
                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
                        child: Row(
                          children: [
                            Icon(Icons.notifications_outlined,
                                size: 18, color: Colors.grey),
                            SizedBox(width: 8),
                            Text(
                              'Bildirimler',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Upper band notification
                      SwitchListTile(
                        title: const Text('Ust banda degince'),
                        subtitle: const Text(
                          'Fiyat ust banda ulastiginda bildirim gonder',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        secondary: Icon(Icons.arrow_upward,
                            color: notifUpper ? AppTheme.red : Colors.grey),
                        value: notifUpper,
                        activeColor: AppTheme.red,
                        onChanged: (v) =>
                            notifier.setNotification('upperBand', v),
                      ),

                      // Lower band notification
                      SwitchListTile(
                        title: const Text('Alt banda degince'),
                        subtitle: const Text(
                          'Fiyat alt banda ulastiginda bildirim gonder',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        secondary: Icon(Icons.arrow_downward,
                            color: notifLower ? AppTheme.green : Colors.grey),
                        value: notifLower,
                        activeColor: AppTheme.green,
                        onChanged: (v) =>
                            notifier.setNotification('lowerBand', v),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Info box
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white10),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.grey, size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Arka plan kontrol araligi minimum 15 dakikadir (iOS kisitlamasi).',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
