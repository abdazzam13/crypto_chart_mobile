import '../entities/crypto_historical_data_entity.dart';
import '../repositories/crypto_chart_repository.dart';

class SubmitRequestUc {
  final CryptoChartRepository chartRepository;

  SubmitRequestUc({required this.chartRepository});

  Future<Stream?> call({
    required String action,
    String? symbol,
  }) {
    return chartRepository.submitRequest(action: action, symbols: symbol);
  }
}