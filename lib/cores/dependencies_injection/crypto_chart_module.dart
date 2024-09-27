import 'package:crypto_chart_mobile/features/crypto/data/data_sources/crypto_chart_remote_data_source.dart';
import 'package:crypto_chart_mobile/features/crypto/data/repositories/crypto_chart_repository_impl.dart';
import 'package:crypto_chart_mobile/features/crypto/domain/repositories/crypto_chart_repository.dart';
import 'package:crypto_chart_mobile/features/crypto/domain/usecases/submit_request_uc.dart';
import 'package:crypto_chart_mobile/features/crypto/presentation/bloc/submit_request/submit_request_bloc.dart';

import '../../features/crypto/data/data_sources/interfaces/i_crypto_chart_remote_data_source.dart';
import 'dependencies_injection.dart';

Future<void> init() async {
  // Data sources
  sl.registerFactory<ICryptoChartRemoteDataSource>(
      () => CryptoChartRemoteDataSource(apiService: sl()));

  //Repositories
  sl.registerFactory<CryptoChartRepository>(
      () => CryptoChartRepositoryImpl(remoteDataSource: sl()));

  //Usecases
  sl.registerFactory(() => SubmitRequestUc(chartRepository: sl()));

  //Bloc
  sl.registerFactory(() => SubmitRequestBloc(submitRequestUc: sl()));
}
