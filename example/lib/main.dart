import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_braintree/flutter_braintree.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _nonce = 'Unknown';
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _controller,
                decoration: InputDecoration(hintText: 'Your client token'),
              ),
              RaisedButton(
                child: Text('Pay'),
                onPressed: () => _pay(_controller.text),
              ),
              Text(_nonce),
            ],
          ),
        ),
      ),
    );
  }

  void _pay(String token) async {
    String nonce;

    try {
      nonce = await FlutterBraintree.showDropIn(token);
    } on PlatformException catch (e) {
      nonce = e.message;
    }

    setState(() {
      _nonce = nonce;
    });
  }
}
