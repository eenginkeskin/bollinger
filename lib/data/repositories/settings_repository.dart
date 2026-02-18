import 'package:shared_preferences/shared_preferences.dart';
import 'package:bollinger/data/models/indicator_settings.dart';

class SettingsRepository {
  static const _keyPrefix = 'indicator_settings_';

  Future<IndicatorSettings> getSettings(String indicatorId) async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString('$_keyPrefix$indicatorId');
    if (json == null) {
      if (indicatorId == 'bollinger') {
        return IndicatorSettings.bollingerDefault();
      }
      return IndicatorSettings(indicatorId: indicatorId);
    }
    return IndicatorSettings.decode(json);
  }

  Future<void> saveSettings(IndicatorSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      '$_keyPrefix${settings.indicatorId}',
      settings.encode(),
    );
  }
}
