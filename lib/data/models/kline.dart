class Kline {
  final DateTime openTime;
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;
  final DateTime closeTime;

  const Kline({
    required this.openTime,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
    required this.closeTime,
  });

  factory Kline.fromBinanceList(List<dynamic> data) {
    return Kline(
      openTime: DateTime.fromMillisecondsSinceEpoch(data[0] as int),
      open: double.parse(data[1] as String),
      high: double.parse(data[2] as String),
      low: double.parse(data[3] as String),
      close: double.parse(data[4] as String),
      volume: double.parse(data[5] as String),
      closeTime: DateTime.fromMillisecondsSinceEpoch(data[6] as int),
    );
  }
}
