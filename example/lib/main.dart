import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xlog_flutter/export.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  XlogFlutter.init(mode: XlogMode.debug, fileName: 'meet');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _xlogFlutterPlugin = XlogFlutter();

  @override
  void initState() {
    super.initState();

    XlogFlutter.print(tag: '_MAIN', message: '初始化');
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    XlogFlutter.print(tag: 'MAIN', message: '测试');

    for (int i = 0; i < 100; i++) { 
      XlogFlutter.print(tag: 'MAIN', message: '测试---- $i');
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}
