import 'dart:async';
import 'dart:convert';
import 'package:car/NetworkUtil.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewAppGPS extends StatefulWidget {
  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewAppGPS> {
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  WebViewController _web_controller;

  String _fcm_token = '';

  bool _isSendToSever = false;

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) {
        print('on launch $message');
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.getToken().then((token) {
      _fcm_token = token;
    });
  }


  var result =  Connectivity().checkConnectivity();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // We're using a Builder here so we have a context that is below the Scaffold
      // to allow calling Scaffold.of(context) so we can show a snackbar.
      child: Builder(builder: (BuildContext context) {
        return WebView(
          initialUrl: 'https://dvbk.vn/Mobile/MobileLogin',
          //initialUrl: 'https://dvbk.vn/Mobile/MobileLogin',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            if(1!=1){
              _controller.complete(webViewController);
              _web_controller = webViewController;
              print("mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");
            }else{
              print("=============================================================================");
            }
          },
          // ignore: prefer_collection_literals
          javascriptChannels: <JavascriptChannel>[
            _toasterJavascriptChannel(context),
          ].toSet(),
          navigationDelegate: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            print('Page started loading: $url');
          },
          onPageFinished: (String url) async {

            if(url.startsWith('https://dvbk.vn/Mobile/Index') && !_isSendToSever) {

              String cookies = await _web_controller.evaluateJavascript('document.cookie');
              if(cookies != null && cookies.contains('BKLoginName')) {
                this._isSendToSever = true;

                print("COOKIES ->" + cookies);
                print(_fcm_token);

                final String encodedCookies = base64.encode(utf8.encode(cookies)); // dXNlcm5hbWU6cGFzc3dvcmQ=
                final String encodedToken = base64.encode(utf8.encode(_fcm_token));     // username:password

//                print("Encoded Cookies: $encodedCookies");
//                print("Encoded token: $encodedToken");

                // Push to API
                final String urlPush = "https://dvbk.vn/BachKhoaAPI/InsertTokenMobile?cookies=$encodedCookies&token=$encodedToken";
                NetworkUtil network = new NetworkUtil();
                await network.get(urlPush);
              }
            }
            print('Page finished loading: $url');
          },
          gestureNavigationEnabled: true,
        );
      }),
      //floatingActionButton: favoriteButton(),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

//  Widget favoriteButton() {
//    return FutureBuilder<WebViewController>(
//        future: _controller.future,
//        builder: (BuildContext context,
//            AsyncSnapshot<WebViewController> controller) {
//          if (controller.hasData) {
//            return FloatingActionButton(
//              onPressed: () async {
//                final String url = await controller.data.currentUrl();
//                Scaffold.of(context).showSnackBar(
//                  SnackBar(content: Text('Favorited $url')),
//                );
//              },
//              child: const Icon(Icons.favorite),
//            );
//          }
//          return Container();
//        });
//  }
}

//enum MenuOptions {
//  showUserAgent,
//  listCookies,
//  clearCookies,
//  addToCache,
//  listCache,
//  clearCache,
//  navigationDelegate,
//}
//
//class SampleMenu extends StatelessWidget {
//  SampleMenu(this.controller);
//
//  final Future<WebViewController> controller;
//  final CookieManager cookieManager = CookieManager();
//
//  @override
//  Widget build(BuildContext context) {
//    return FutureBuilder<WebViewController>(
//      future: controller,
//      builder:
//          (BuildContext context, AsyncSnapshot<WebViewController> controller) {
//        return PopupMenuButton<MenuOptions>(
//          onSelected: (MenuOptions value) {
//            switch (value) {
//              case MenuOptions.showUserAgent:
//                _onShowUserAgent(controller.data, context);
//                break;
//              case MenuOptions.listCookies:
//                _onListCookies(controller.data, context);
//                break;
//              case MenuOptions.clearCookies:
//                _onClearCookies(context);
//                break;
//              case MenuOptions.addToCache:
//                _onAddToCache(controller.data, context);
//                break;
//              case MenuOptions.listCache:
//                _onListCache(controller.data, context);
//                break;
//              case MenuOptions.clearCache:
//                _onClearCache(controller.data, context);
//                break;
//              case MenuOptions.navigationDelegate:
//                _onNavigationDelegateExample(controller.data, context);
//                break;
//            }
//          },
//          itemBuilder: (BuildContext context) => <PopupMenuItem<MenuOptions>>[
//            PopupMenuItem<MenuOptions>(
//              value: MenuOptions.showUserAgent,
//              child: const Text('Show user agent'),
//              enabled: controller.hasData,
//            ),
//            const PopupMenuItem<MenuOptions>(
//              value: MenuOptions.listCookies,
//              child: Text('List cookies'),
//            ),
//            const PopupMenuItem<MenuOptions>(
//              value: MenuOptions.clearCookies,
//              child: Text('Clear cookies'),
//            ),
//            const PopupMenuItem<MenuOptions>(
//              value: MenuOptions.addToCache,
//              child: Text('Add to cache'),
//            ),
//            const PopupMenuItem<MenuOptions>(
//              value: MenuOptions.listCache,
//              child: Text('List cache'),
//            ),
//            const PopupMenuItem<MenuOptions>(
//              value: MenuOptions.clearCache,
//              child: Text('Clear cache'),
//            ),
//            const PopupMenuItem<MenuOptions>(
//              value: MenuOptions.navigationDelegate,
//              child: Text('Navigation Delegate example'),
//            ),
//          ],
//        );
//      },
//    );
//  }
//
//  void _onShowUserAgent(
//      WebViewController controller, BuildContext context) async {
//    // Send a message with the user agent string to the Toaster JavaScript channel we registered
//    // with the WebView.
//    await controller.evaluateJavascript(
//        'Toaster.postMessage("User Agent: " + navigator.userAgent);');
//  }
//
//  void _onListCookies(
//      WebViewController controller, BuildContext context) async {
//    final String cookies =
//        await controller.evaluateJavascript('document.cookie');
//    print("COOKIES ->" + cookies);
////    Scaffold.of(context).showSnackBar(SnackBar(
////      content: Column(
////        mainAxisAlignment: MainAxisAlignment.end,
////        mainAxisSize: MainAxisSize.min,
////        children: <Widget>[
////          const Text('Cookies:'),
////          _getCookieList(cookies),
////        ],
////      ),
////    ));
//  }
//
//  void _onAddToCache(WebViewController controller, BuildContext context) async {
//    await controller.evaluateJavascript(
//        'caches.open("test_caches_entry"); localStorage["test_localStorage"] = "dummy_entry";');
//    Scaffold.of(context).showSnackBar(const SnackBar(
//      content: Text('Added a test entry to cache.'),
//    ));
//  }
//
//  void _onListCache(WebViewController controller, BuildContext context) async {
//    await controller.evaluateJavascript('caches.keys()'
//        '.then((cacheKeys) => JSON.stringify({"cacheKeys" : cacheKeys, "localStorage" : localStorage}))'
//        '.then((caches) => Toaster.postMessage(caches))');
//  }
//
//  void _onClearCache(WebViewController controller, BuildContext context) async {
//    await controller.clearCache();
//    Scaffold.of(context).showSnackBar(const SnackBar(
//      content: Text("Cache cleared."),
//    ));
//  }
//
//  void _onClearCookies(BuildContext context) async {
//    final bool hadCookies = await cookieManager.clearCookies();
//    String message = 'There were cookies. Now, they are gone!';
//    if (!hadCookies) {
//      message = 'There are no cookies.';
//    }
//    Scaffold.of(context).showSnackBar(SnackBar(
//      content: Text(message),
//    ));
//  }
//
//  void _onNavigationDelegateExample(
//      WebViewController controller, BuildContext context) async {
//    final String contentBase64 =
//        base64Encode(const Utf8Encoder().convert(kNavigationExamplePage));
//    await controller.loadUrl('data:text/html;base64,$contentBase64');
//  }
//
//  Widget _getCookieList(String cookies) {
//    if (cookies == null || cookies == '""') {
//      return Container();
//    }
//    final List<String> cookieList = cookies.split(';');
//    final Iterable<Text> cookieWidgets =
//        cookieList.map((String cookie) => Text(cookie));
//    return Column(
//      mainAxisAlignment: MainAxisAlignment.end,
//      mainAxisSize: MainAxisSize.min,
//      children: cookieWidgets.toList(),
//    );
//  }
//}
//
//class NavigationControls extends StatelessWidget {
//  const NavigationControls(this._webViewControllerFuture)
//      : assert(_webViewControllerFuture != null);
//
//  final Future<WebViewController> _webViewControllerFuture;
//
//  @override
//  Widget build(BuildContext context) {
//    return FutureBuilder<WebViewController>(
//      future: _webViewControllerFuture,
//      builder:
//          (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
//        final bool webViewReady =
//            snapshot.connectionState == ConnectionState.done;
//        final WebViewController controller = snapshot.data;
//        return Row(
//          children: <Widget>[
//            IconButton(
//              icon: const Icon(Icons.arrow_back_ios),
//              onPressed: !webViewReady
//                  ? null
//                  : () async {
//                      if (await controller.canGoBack()) {
//                        await controller.goBack();
//                      } else {
//                        Scaffold.of(context).showSnackBar(
//                          const SnackBar(content: Text("No back history item")),
//                        );
//                        return;
//                      }
//                    },
//            ),
//            IconButton(
//              icon: const Icon(Icons.arrow_forward_ios),
//              onPressed: !webViewReady
//                  ? null
//                  : () async {
//                      if (await controller.canGoForward()) {
//                        await controller.goForward();
//                      } else {
//                        Scaffold.of(context).showSnackBar(
//                          const SnackBar(
//                              content: Text("No forward history item")),
//                        );
//                        return;
//                      }
//                    },
//            ),
//            IconButton(
//              icon: const Icon(Icons.replay),
//              onPressed: !webViewReady
//                  ? null
//                  : () {
//                      controller.reload();
//                    },
//            ),
//          ],
//        );
//      },
//    );
//  }
//}
