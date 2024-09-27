import 'package:crypto_chart_mobile/cores/constant/api_path.dart';
import 'package:crypto_chart_mobile/cores/services/api_service.dart';
import 'package:crypto_chart_mobile/features/crypto/data/data_sources/interfaces/i_crypto_chart_remote_data_source.dart';

class CryptoChartRemoteDataSource implements ICryptoChartRemoteDataSource {
  final ApiService apiService;

  CryptoChartRemoteDataSource({required this.apiService});


  @override
  Future<Stream> submitRequest({String? apiPath, String? request}) async {
    final result = await apiService.post(apiPath: ApiPath.baseUrl, request:  request);
    return result;
  }
}