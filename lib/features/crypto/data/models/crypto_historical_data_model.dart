import '../../domain/entities/crypto_historical_data_entity.dart';

class CryptoHistoricalDataModel extends CryptoHistoricalDataEntity {
  CryptoHistoricalDataModel({
    required String symbol,
    required double price,
    required double quantity,
    required double dailyChange,
    required double dailyDifference,
    required int timestamp,
  }) : super(
    symbol: symbol,
    price: price,
    quantity: quantity,
    dailyChange: dailyChange,
    dailyDifference: dailyDifference,
    timestamp: timestamp,
  );

  // From JSON method
  factory CryptoHistoricalDataModel.fromJson(Map<String, dynamic> json) {
    return CryptoHistoricalDataModel(
      symbol: json['s'].toString(),
      price: double.parse(json['p']),
      quantity: double.parse(json['q']),
      dailyChange: double.parse(json['dc']),
      dailyDifference: double.parse(json['dd']),
      timestamp: json['t'],
    );
  }

  // To JSON method
  Map<String, dynamic> toJson() {
    return {
      's': symbol,
      'p': price,
      'q': quantity,
      'dc': dailyChange,
      'dd': dailyDifference,
      't': timestamp,
    };
  }
}
