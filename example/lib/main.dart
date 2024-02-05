import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xlog_flutter/export.dart';
import 'dart:async';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final Directory appDocumentsDir = await getApplicationSupportDirectory();
  final parentDir = "${appDocumentsDir.path}/mars_xlog";
  final logDir = "$parentDir/xlog";
  final cacheDir = "$parentDir/cacheDir";
  if (!Directory(parentDir).existsSync()) {
    await Directory(parentDir).create(recursive: true);
  }
  XlogFlutter.init(
      mode: XlogMode.debug,
      fileName: 'meet',
      logDir: logDir,
      cacheDir: cacheDir);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int number = 0;

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
            title: Text('Plugin example app ${number}'),
          ),
          body: Center(
              child: Column(children: [
            Text("current Number : $number"),
            ElevatedButton(
                onPressed: () {
                  number += 1;
                  XlogFlutter.print(message: "input content number:${number}");
                  setState(() {});
                },
                child: const Text("test Log")),
            ElevatedButton(
                onPressed: () {
                  XlogFlutter.flush();
                },
                child: const Text("flush Log")),
          ]))),
    );
  }
}
