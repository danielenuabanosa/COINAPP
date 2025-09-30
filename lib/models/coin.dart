class Coin {
  final String name;
  final String symbol;
  final double price;
  final double percentChange24h;
  final double marketCap;
  final double volume24h;

  Coin({
    required this.name,
    required this.symbol,
    required this.price,
    required this.percentChange24h,
    required this.marketCap,
    required this.volume24h,
  });

  factory Coin.fromJson(Map<String, dynamic> json) {
    final usdData = json["quote"]["USD"] ?? {};

    return Coin(
      name: json["name"] ?? "Unknown",
      symbol: json["symbol"] ?? "",
      price: (usdData["price"] ?? 0).toDouble(),
      percentChange24h: (usdData["percent_change_24h"] ?? 0).toDouble(),
      marketCap: (usdData["market_cap"] ?? 0).toDouble(),
      volume24h: (usdData["volume_24h"] ?? 0).toDouble(),
    );
  }
}
