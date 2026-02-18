enum BollingerStatus { upper, lower, middle }

class BollingerResult {
  final List<double> upperBand;
  final List<double> middleBand;
  final List<double> lowerBand;
  final BollingerStatus currentStatus;
  final double currentPrice;

  const BollingerResult({
    required this.upperBand,
    required this.middleBand,
    required this.lowerBand,
    required this.currentStatus,
    required this.currentPrice,
  });

  double get currentUpper => upperBand.last;
  double get currentMiddle => middleBand.last;
  double get currentLower => lowerBand.last;

  static BollingerStatus calculateStatus(
      double price, double upper, double lower) {
    if (price >= upper) return BollingerStatus.upper;
    if (price <= lower) return BollingerStatus.lower;
    return BollingerStatus.middle;
  }
}
