import 'dart:async';
import 'dart:ffi';
import 'dart:io';

//import 'package:connectivity/connectivity.dart';
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
      title: 'DVBK',
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

  StreamSubscription _connectionChangeStream;

  AnimationController controller;
  Stream stream;

  bool _hasConnection = true;

  @override
  void initState() {
    super.initState();

//    _ConnectionStatusSingleton connectionStatus = _ConnectionStatusSingleton.getInstance();
//    connectionStatus.initialize("google.com");
//    _connectionChangeStream = connectionStatus.connectionChange.listen(_connectionChanged);

    //CheckNetWorkOpenApp();

    _ConnectionStatusSingleton connectionStatus = _ConnectionStatusSingleton.getInstance();
    connectionStatus.initialize("google.com");
    _connectionChangeStream = connectionStatus.connectionChange.listen(_connectionChanged);


  }

//  void CheckNetWork(bool hasConnection) async {
//    try {
//      final result = await InternetAddress.lookup('google.com');
//      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//       // Navigator.pop(dialogContext);
//        nav.currentState.pushReplacement(
//            MaterialPageRoute(builder: (BuildContext _) => WebViewAppGPS()));
//      }
//    } on SocketException catch (_) {
//      nav.currentState.pushReplacement(
//          MaterialPageRoute(builder: (BuildContext _) => NoConnectivtyView()));
//      _showDialog('Không có Internet', "Bạn cần kết nối Internet để truy cập ứng dụng");
//    }
//  }


  void _connectionChanged(bool hasConnection) {

    if (_hasConnection == hasConnection) return;
    //hasConnection == false ? controller.forward() : controller.reverse();
    _hasConnection = hasConnection;
    print('connected============================ $_hasConnection');
    if(_hasConnection == true){
      try{
        Navigator.pop(dialogContext);
      }catch(e){}

      nav.currentState.pushReplacement(
           MaterialPageRoute(builder: (BuildContext _) => WebViewAppGPS()));
    }else{
      nav.currentState.pushReplacement(
          MaterialPageRoute(builder: (BuildContext _) => NoConnectivtyView()));
      _showDialog('Không có Internet', "Bạn cần kết nối Internet để truy cập ứng dụng");
    }
    // print('connected $_hasConnection');

  }

  BuildContext dialogContext;
  _showDialog(title, text) {
    showDialog(
        context: context,
        builder: (context) {
          dialogContext = context;
          return AlertDialog(
            title: Text(title),
            content: Text(text),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  //Navigator.of(context).pop();
                  SystemNavigator.pop(); // Close cả app ra ngoài
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
          //body: NoConnectivtyView(),
          body: WebViewAppGPS(),
          //body: _checkInternetConnectivity(),
        ),
        //home: WebViewAppGPS(),
      ),
    );
  }
}




class _ConnectionStatusSingleton {
  String _lookUpAddress;
  static final _ConnectionStatusSingleton _singleton = _ConnectionStatusSingleton._internal();
  _ConnectionStatusSingleton._internal();

  static _ConnectionStatusSingleton getInstance() => _singleton;

  bool hasConnection = true;

  StreamController<bool> connectionChangeController = StreamController.broadcast();

  final Connectivity _connectivity = Connectivity();

  void initialize(String lookUpAddress) {
    this._lookUpAddress = lookUpAddress;
    _connectivity.onConnectivityChanged.listen(_connectionChange);
    checkConnection();
  }

  Stream<bool> get connectionChange => connectionChangeController.stream;

  void dispose() {
    connectionChangeController.close();
  }

  void _connectionChange(ConnectivityResult result) {
    checkConnection();
  }

  Future<bool> checkConnection() async {
    assert(_lookUpAddress != null || _lookUpAddress != '');
    bool previousConnection = hasConnection;

    try {
      final result = await InternetAddress.lookup(_lookUpAddress);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasConnection = true;
      } else {
        hasConnection = false;
      }
    } on SocketException catch (_) {
      hasConnection = false;
    }

    if (previousConnection != hasConnection) {
      connectionChangeController.add(hasConnection);
    }

    return hasConnection;
  }
}