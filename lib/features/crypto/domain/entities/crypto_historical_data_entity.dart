class CryptoHistoricalDataEntity {
  final String symbol;
  final double price;
  final double quantity;
  final double dailyChange;
  final double dailyDifference;
  final int timestamp;

  CryptoHistoricalDataEntity({
    required this.symbol,
    required this.price,
    required this.quantity,
    required this.dailyChange,
    required this.dailyDifference,
    required this.timestamp,
  });
}
