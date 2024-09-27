import 'package:crypto_chart_mobile/cores/utils/app_utils.dart';
import 'package:crypto_chart_mobile/features/crypto/data/data_sources/interfaces/i_crypto_chart_remote_data_source.dart';

import '../../domain/repositories/crypto_chart_repository.dart';
import '../models/crypto_historical_data_req.dart';

class CryptoChartRepositoryImpl extends CryptoChartRepository {
  final ICryptoChartRemoteDataSource remoteDataSource;

  CryptoChartRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Stream?> submitRequest({String? action, String? symbols}) async {
    try {
      final resp = await remoteDataSource.submitRequest(
          request: "{\"action\": \"$action\", \"symbols\": \"$symbols\"}");
      return resp;
    } catch (e) {
      appPrintError(e.toString());
    }
  }
}
