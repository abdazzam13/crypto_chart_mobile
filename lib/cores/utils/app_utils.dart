import 'package:flutter/foundation.dart';


appPrint(String message) {
  if (kDebugMode) {
    print(message);
  }
}

appPrintError(String message) {
  if (kDebugMode) {
    print(message);
  }
}

