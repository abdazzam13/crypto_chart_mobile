import 'package:crypto_chart_mobile/cores/constant/api_path.dart';
import 'package:crypto_chart_mobile/features/crypto/presentation/pages/crypto_historical_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'cores/dependencies_injection/dependencies_injection.dart' as di;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([di.init()]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto Watch App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CryptoHistoricalData(),
    );
  }
}