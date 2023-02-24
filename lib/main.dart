import 'dart:io';

import 'package:flutter/material.dart';
import 'package:advertising_id/advertising_id.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:imagecomp/screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: compres(),
    );
  }
}
