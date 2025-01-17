import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_package_manager/flutter_package_manager.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  Image? appImage;
  List? installedApps;
  List? userInstalledApps;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterPackageManager.platformVersion;
      final value = await FlutterPackageManager.getPackageInfo(
          'dev.wurikiji.flutter_hook_test');
      appImage = value.getAppIcon(
        fit: BoxFit.contain,
      );
      installedApps = await FlutterPackageManager.getInstalledPackages();
      userInstalledApps =
          await FlutterPackageManager.getUserInstalledPackages();
      debugPrint('I got $value');
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: ListView(
            children: <Widget>[
              Text(
                  'Platform: $_platformVersion with\n${installedApps?.length}'),
              Text(
                  'Platform: $_platformVersion with\n${userInstalledApps?.length}'),
              if (appImage != null) appImage!,
            ],
          ),
        ),
      ),
    );
  }
}
