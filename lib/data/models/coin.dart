class Coin {
  final String symbol;
  final double price;
  final double priceChangePercent;
  final bool isFavorite;

  const Coin({
    required this.symbol,
    required this.price,
    required this.priceChangePercent,
    this.isFavorite = false,
  });

  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin(
      symbol: json['symbol'] as String,
      price: double.parse(json['lastPrice'] as String),
      priceChangePercent: double.parse(json['priceChangePercent'] as String),
    );
  }

  Coin copyWith({bool? isFavorite}) {
    return Coin(
      symbol: symbol,
      price: price,
      priceChangePercent: priceChangePercent,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
