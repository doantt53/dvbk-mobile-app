import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';

import 'WebViewGPS.dart';
import 'package:car/NoConnectivtyView.dart';

void main() => runApp(new MyApp());

final GlobalKey<NavigatorState> nav = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
//  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

//  @override
//  void initState() {
//    super.initState();
//    _firebaseMessaging.configure(
//      onMessage: (Map<String, dynamic> message) {
//        print('on message $message');
//      },
//      onResume: (Map<String, dynamic> message) {
//        print('on resume $message');
//      },
//      onLaunch: (Map<String, dynamic> message) {
//        print('on launch $message');
//      },
//    );
//    _firebaseMessaging.requestNotificationPermissions(
//        const IosNotificationSettings(sound: true, badge: true, alert: true));
//    _firebaseMessaging.getToken().then((token) {
//      print(token);
//    });
//  }

  StreamSubscription connectivitySubscription;
  ConnectivityResult _previousResult;

  @override
  void initState() {
    super.initState();
//    connectivitySubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult connectivityResult) {
//      if (connectivityResult == ConnectivityResult.none) {
//        _showDialog('Không có Internet', "Bạn cần kết nối Internet để truy cập ứng dụng");
//        nav.currentState.pop(MaterialPageRoute(
//            builder: (BuildContext _) => NoConnectivtyView()
//        ));
////        nav.currentState.pop(MaterialPageRoute(
////            builder: (BuildContext _) => WebViewAppGPS()
////        ));
//      }
//      else if (_previousResult == ConnectivityResult.none){
//        nav.currentState.push(MaterialPageRoute(
//            builder: (BuildContext _) => WebViewAppGPS()
//        ));
//      }
//
//      _previousResult = connectivityResult;
//    });

    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult connectivityResult) {
      if (connectivityResult != ConnectivityResult.none) {
        nav.currentState.pushReplacement(
            MaterialPageRoute(builder: (BuildContext _) => WebViewAppGPS()));
      }
      if (connectivityResult == ConnectivityResult.none) {
        _showDialog('Không có Internet', "Bạn cần kết nối Internet để truy cập ứng dụng");
      }
      _previousResult = connectivityResult;
    });
  }

//  _checkInternetConnectivity() async {
//    var result = await Connectivity().checkConnectivity();
//    if (result == ConnectivityResult.none) {
//      _showDialog('No internet', "You're not connected to a network");
//    } else if (result == ConnectivityResult.mobile) {
//      _showDialog('Internet access', "You're connected over mobile data");
//    } else if (result == ConnectivityResult.wifi) {
//      _showDialog('Internet access', "You're connected over wifi");
//    }
//    //return WebViewAppGPS();
//  }
  _showDialog(title, text) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(text),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  //Navigator.of(context).pop();
                  SystemNavigator.pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: MaterialApp(
        navigatorKey: nav,
        home: Scaffold(
          body: NoConnectivtyView(),
          //body: NoConnectivtyView(),
          //body: _checkInternetConnectivity(),
        ),
        //home: WebViewAppGPS(),
      ),
    );
  }
}
