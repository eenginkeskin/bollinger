import 'dart:convert';

class IndicatorSettings {
  final String indicatorId;
  final bool enabled;
  final Map<String, double> params;
  final Map<String, bool> notifications;

  const IndicatorSettings({
    required this.indicatorId,
    this.enabled = true,
    this.params = const {},
    this.notifications = const {},
  });

  factory IndicatorSettings.bollingerDefault() {
    return const IndicatorSettings(
      indicatorId: 'bollinger',
      enabled: true,
      params: {
        'period': 20,
        'stdDev': 2.0,
      },
      notifications: {
        'upperBand': true,
        'lowerBand': true,
      },
    );
  }

  IndicatorSettings copyWith({
    bool? enabled,
    Map<String, double>? params,
    Map<String, bool>? notifications,
  }) {
    return IndicatorSettings(
      indicatorId: indicatorId,
      enabled: enabled ?? this.enabled,
      params: params ?? this.params,
      notifications: notifications ?? this.notifications,
    );
  }

  Map<String, dynamic> toJson() => {
        'indicatorId': indicatorId,
        'enabled': enabled,
        'params': params,
        'notifications': notifications,
      };

  factory IndicatorSettings.fromJson(Map<String, dynamic> json) {
    return IndicatorSettings(
      indicatorId: json['indicatorId'] as String,
      enabled: json['enabled'] as bool? ?? true,
      params: (json['params'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, (v as num).toDouble())) ??
          {},
      notifications: (json['notifications'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, v as bool)) ??
          {},
    );
  }

  String encode() => jsonEncode(toJson());

  factory IndicatorSettings.decode(String source) =>
      IndicatorSettings.fromJson(jsonDecode(source) as Map<String, dynamic>);
}
