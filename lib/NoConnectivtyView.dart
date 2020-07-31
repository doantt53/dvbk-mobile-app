import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


// Stateful widget for managing name data
class NoConnectivtyView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        body: Center(
            child: Container(child: Image.asset('assets/no-internet-connection.jpg'))
        ),
      ),
    );
  }
}
