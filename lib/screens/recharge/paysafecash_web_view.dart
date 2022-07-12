import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class PaySafeCashWebView extends StatefulWidget {
  final String? paySafeUrl;
  const PaySafeCashWebView({Key? key, @required this.paySafeUrl}) : super(key: key);

  @override
  _PaySafeCashWebViewState createState() {
    return _PaySafeCashWebViewState(paySafeUrl: this.paySafeUrl);
  }
}

class _PaySafeCashWebViewState extends State<PaySafeCashWebView> with WidgetsBindingObserver {

  final String? paySafeUrl;
  _PaySafeCashWebViewState({Key? key, @required this.paySafeUrl});

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: paySafeUrl!,
      withJavascript: true,
      withZoom: false,
      appBar: AppBar(
          title: Text("PaySafeCash"),
          backgroundColor: const Color(0XFF0E325F),
          elevation: 1
      ),
    );
  }
}
