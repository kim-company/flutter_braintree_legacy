import 'dart:async';

import 'package:flutter/services.dart';

class FlutterBraintree {
  static const MethodChannel _channel =
      const MethodChannel('info.keepinmind.flutter_braintree');

  static Future<String> showDropIn(String clientToken) async {
    final String nonce =
        await _channel.invokeMethod('showDropIn', {'clientToken': clientToken});
    return nonce;
  }
}
