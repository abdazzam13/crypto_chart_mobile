import 'dart:convert';
import 'dart:io';

import 'package:crypto_chart_mobile/cores/constant/app_constants.dart';
import 'package:crypto_chart_mobile/features/crypto/data/models/crypto_historical_data_model.dart';
import 'package:crypto_chart_mobile/features/crypto/domain/entities/crypto_historical_data_entity.dart';
import 'package:crypto_chart_mobile/features/crypto/presentation/bloc/submit_request/submit_request_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';

import '../../../../cores/dependencies_injection/dependencies_injection.dart';

class CryptoHistoricalData extends StatelessWidget {
  const CryptoHistoricalData({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => sl<SubmitRequestBloc>()
              ..add(
                const SubmitRequest(
                    action: AppConstants.subscribe,
                    symbols: AppConstants.symbols),
              )),
      ],
      child: const CryptoHistoricalDataLayout(),
    );
  }
}

class CryptoHistoricalDataLayout extends StatefulWidget {
  const CryptoHistoricalDataLayout({super.key});

  @override
  State<CryptoHistoricalDataLayout> createState() =>
      _CryptoHistoricalDataLayoutState();
}

class _CryptoHistoricalDataLayoutState
    extends State<CryptoHistoricalDataLayout> {
  List<CryptoHistoricalDataEntity> dataETH = [];
  List<CryptoHistoricalDataEntity> dataBTC = [];

  List<double> priceETH = [];
  List<String> dateETH = [];

  List<double> priceBTC = [];
  List<String> dateBTC = [];

  final List<String> cryptoSymbols = ['BTC', 'ETH'];
  String selectedSymbol = 'ETH';

  subscribe(BuildContext context) async {
    context.read<SubmitRequestBloc>().add(
          const SubmitRequest(
              action: AppConstants.subscribe, symbols: AppConstants.symbols),
        );
  }

  unSubscribe(BuildContext context) async {
    context.read<SubmitRequestBloc>().add(
          const SubmitRequest(
              action: AppConstants.unsubscribe, symbols: AppConstants.symbols),
        );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (canPop) {
          unSubscribe(context);
          if (canPop){
            return;
          }
        },
        child: BlocBuilder<SubmitRequestBloc, SubmitRequestState>(
          builder: (context, state) {
            if (state is SubmitRequestSuccess) {
              return Scaffold(
                backgroundColor: const Color(0XFF000080),
                body:  StreamBuilder(
                  stream: state.dataEntity,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (snapshot.hasData) {
                      var decode = jsonDecode(snapshot.data);
                      var statCode = decode['status_code'];

                      // if statcode is 200, then the snapshot data does not contain crypto price
                      // also, if statcode is 200, it means the app is not subscribed to the websocket, only connected
                      if (statCode != 200) {
                        var crypto = CryptoHistoricalDataModel.fromJson(decode);

                        // Split ETH and BTC prices
                        if (crypto.symbol == AppConstants.ethUSD) {
                          dataETH.add(crypto);
                        } else if (crypto.symbol == AppConstants.btcUSD) {
                          dataBTC.add(crypto);
                        }

                        // Process ETH prices
                        for (var i = 0; i < dataETH.length; i++) {
                          var date = DateTime.fromMillisecondsSinceEpoch(dataETH[i].timestamp);
                          var formattedDate = "${date.hour}:${date.minute}:${date.second}";

                          if (!dateETH.contains(formattedDate)) {
                            priceETH.add(dataETH[i].price);
                            dateETH.add(formattedDate);
                          }
                        }

                        // Process BTC prices
                        for (var i = 0; i < dataBTC.length; i++) {
                          var date = DateTime.fromMillisecondsSinceEpoch(dataBTC[i].timestamp);
                          var formattedDate = "${date.hour}:${date.minute}:${date.second}";

                          if (!dateBTC.contains(formattedDate)) {
                            dateBTC.add(formattedDate);
                            priceBTC.add(dataBTC[i].price);
                          }
                        }
                      }
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: statCode != 200
                              ? Column(
                            children: [
                              DropdownButton<String>(
                                value: selectedSymbol,
                                icon: const Icon(Icons.arrow_downward),
                                iconSize: 24,
                                elevation: 16,
                                style: const TextStyle(color: Colors.blue),
                                underline: Container(
                                  height: 2,
                                  color: Colors.blueAccent,
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedSymbol = newValue!;
                                  });
                                },
                                items: cryptoSymbols
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                              Expanded(
                                child: chart(selectedSymbol, priceETH, priceBTC, dateETH),
                              ),
                              watchlist(),
                            ],
                          )
                              : defaultView(),
                        ),
                      );
                    }


                    return const Center(child: Text(AppConstants.loading));
                  },
                )

              );
            }
            return Scaffold(
              backgroundColor: const Color(0XFF000080),
              body: Center(
                child: defaultView(),
              ),
            );
          },
        ));
  }

  Widget chart(String selectedSymbol, List<double> priceETH,
      List<double> priceBTC, List<String> dateETH) {
    return priceETH.isNotEmpty && priceBTC.isNotEmpty  && dateETH.isNotEmpty? LineChart(
      LineChartData(
        gridData: const FlGridData(show: true),
        titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  if (index < dateETH.length) {
                    return Text(dateETH[index],
                        style:
                            const TextStyle(fontSize: 10, color: Colors.white));
                  }
                  return const Text('',
                      style: TextStyle(fontSize: 10, color: Colors.white));
                },
                interval: 1,
              ),
            ),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false))),
        borderData: FlBorderData(
            show: true, border: Border.all(color: Colors.white, width: 1)),
        lineBarsData: [
          if (selectedSymbol == "ETH") ...[
            LineChartBarData(
              spots: List.generate(
                priceETH.length,
                (index) {
                  return FlSpot(index.toDouble(), priceETH[index]);
                },
              ),
              isCurved: true,
              color: Colors.blue,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
          ],
          if (selectedSymbol == "BTC") ...[
            LineChartBarData(
              spots: List.generate(
                priceBTC.length,
                (index) {
                  return FlSpot(index.toDouble(), priceBTC[index]);
                },
              ),
              isCurved: true,
              color: Colors.red,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            )
          ]
        ],
        minY: selectedSymbol == "ETH"
            ? priceETH.reduce((a, b) => a < b ? a : b) - 1
            : priceBTC.reduce((a, b) => a < b ? a : b) - 1,
        maxY: selectedSymbol == "ETH"
            ? priceETH.reduce((a, b) => a > b ? a : b) + 5
            : priceBTC.reduce((a, b) => a > b ? a : b) + 5,
      ),
    ) : const Text(AppConstants.loading);
  }

  Widget watchlist() {
    return dataETH.isNotEmpty  && dateBTC.isNotEmpty ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        const Row(
          children: [
            Text(
              "Watchlist",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Colors.white),
            ),
            SizedBox(
              width: 10,
            ),
            Icon(
              Icons.remove_red_eye,
              color: Colors.white,
            )
          ],
        ),
        const Divider(
          color: Colors.white,
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            itemWatchlist(AppConstants.symbolsText, AppConstants.ethUSDText,
                AppConstants.btcUSDText),
            const VerticalDivider(
              color: Colors.black,
              width: 5,
            ),
            itemWatchlist(AppConstants.last, dataETH.last.price.toString(),
                dataBTC.last.price.toString()),
            const VerticalDivider(),
            itemWatchlist(
                AppConstants.chg,
                dataETH.last.dailyDifference.toString(),
                dataBTC.last.dailyDifference.toString()),
            const VerticalDivider(),
            itemWatchlist(AppConstants.chgPersen,
                "${dataETH.last.dailyChange}%", "${dataBTC.last.dailyChange}%"),
          ],
        )
      ],
    ) : const Text(AppConstants.loading);
  }

  Widget itemWatchlist(String title, String valueETH, String valueBTC) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
              fontWeight: FontWeight.w700, fontSize: 18, color: Colors.white),
        ),
        Text(
          valueETH,
          style: const TextStyle(color: Colors.white),
        ),
        Text(
          valueBTC,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Widget defaultView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          AppConstants.websocketDisconnected,
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            subscribe(context);
          },
          child: const Text(AppConstants.subscribeText),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            if (Platform.isAndroid){
              FlutterExitApp.exitApp();
            } else if (Platform.isIOS){
              FlutterExitApp.exitApp(iosForceExit: true);
            }
          },
          child: const Text(AppConstants.back),
        ),
      ],
    );
  }
}
