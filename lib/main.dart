import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:newcar/screen/WebViewAppGPS.dart';

void main() {
  runApp(MyApp());
}

//final ThemeData _AppTheme = CustomAppTheme().data;
class MyApp extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyApp> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MaterialApp(
        home: Scaffold(
          body: WebViewAppGPS(),
        ),
        //home: WebViewAppGPS(),
      ),
    );

//    return MaterialApp(
//      debugShowCheckedModeBanner: false,
//      //theme: _AppTheme,
//      home: Scaffold(
//        body: WebViewAppGPS(),
//      ),
//      //home: WebViewAppGPS(),
//    );
  }
}
