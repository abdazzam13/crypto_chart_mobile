class CryptoHistoricalDataReq {
  final String? action;
  final String? symbols;

  CryptoHistoricalDataReq({
    this.action,
    this.symbols = "ETH-USD,BTC-USD",
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {
      'action': action,
      'symbols': symbols,
    };
    return data;
  }
}
