import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bollinger/data/models/indicator_settings.dart';
import 'package:bollinger/data/repositories/settings_repository.dart';

final settingsRepositoryProvider = Provider((ref) => SettingsRepository());

final bollingerSettingsProvider =
    AsyncNotifierProvider<BollingerSettingsNotifier, IndicatorSettings>(
        BollingerSettingsNotifier.new);

class BollingerSettingsNotifier extends AsyncNotifier<IndicatorSettings> {
  @override
  Future<IndicatorSettings> build() async {
    final repo = ref.read(settingsRepositoryProvider);
    return repo.getSettings('bollinger');
  }

  Future<void> setEnabled(bool enabled) async {
    final current = await future;
    final updated = current.copyWith(enabled: enabled);
    await _save(updated);
  }

  Future<void> updateParam(String key, double value) async {
    final current = await future;
    final newParams = Map<String, double>.from(current.params);
    newParams[key] = value;
    final updated = current.copyWith(params: newParams);
    await _save(updated);
  }

  Future<void> setNotification(String key, bool value) async {
    final current = await future;
    final newNotifs = Map<String, bool>.from(current.notifications);
    newNotifs[key] = value;
    final updated = current.copyWith(notifications: newNotifs);
    await _save(updated);
  }

  Future<void> _save(IndicatorSettings settings) async {
    final repo = ref.read(settingsRepositoryProvider);
    await repo.saveSettings(settings);
    state = AsyncData(settings);
  }
}
