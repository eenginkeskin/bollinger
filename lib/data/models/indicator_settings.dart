import 'dart:convert';

class IndicatorSettings {
  final String indicatorId;
  final bool enabled;
  final Map<String, double> params;
  final Map<String, bool> notifications;
  final String interval;

  const IndicatorSettings({
    required this.indicatorId,
    this.enabled = true,
    this.params = const {},
    this.notifications = const {},
    this.interval = '1h',
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
      interval: '1h',
    );
  }

  IndicatorSettings copyWith({
    bool? enabled,
    Map<String, double>? params,
    Map<String, bool>? notifications,
    String? interval,
  }) {
    return IndicatorSettings(
      indicatorId: indicatorId,
      enabled: enabled ?? this.enabled,
      params: params ?? this.params,
      notifications: notifications ?? this.notifications,
      interval: interval ?? this.interval,
    );
  }

  Map<String, dynamic> toJson() => {
        'indicatorId': indicatorId,
        'enabled': enabled,
        'params': params,
        'notifications': notifications,
        'interval': interval,
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
      interval: json['interval'] as String? ?? '1h',
    );
  }

  String encode() => jsonEncode(toJson());

  factory IndicatorSettings.decode(String source) =>
      IndicatorSettings.fromJson(jsonDecode(source) as Map<String, dynamic>);
}
