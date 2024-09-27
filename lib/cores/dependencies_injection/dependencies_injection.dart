import 'package:get_it/get_it.dart';

import '../services/api_service.dart';
import 'crypto_chart_module.dart' as crypto;
final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(() => ApiService());
  await Future.wait([crypto.init()]);

}
