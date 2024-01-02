import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaySafeCashWebView extends StatefulWidget {
  final String? paySafeUrl;
  const PaySafeCashWebView({Key? key, @required this.paySafeUrl})
      : super(key: key);

  @override
  _PaySafeCashWebViewState createState() {
    return _PaySafeCashWebViewState(paySafeUrl: this.paySafeUrl);
  }
}

class _PaySafeCashWebViewState extends State<PaySafeCashWebView>
    with WidgetsBindingObserver {
  final String? paySafeUrl;
  _PaySafeCashWebViewState({Key? key, @required this.paySafeUrl});

  var baseUrl = '';

  _loadBaseUrl() async {
    var baseUrlScope = '0';
    final prefs = await SharedPreferences.getInstance();
    if (prefs.get('baseUrl') != null) {
      baseUrlScope = dotenv.env[prefs.getString('baseUrl')]!;
    }
    setState(() {
      baseUrl = dotenv.env['US_HOST']!;
    });
  }

  _setLastPage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastPage', 'principalScreen');
  }

  @override
  void initState() {
    _loadBaseUrl();
    _setLastPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("PaySafeCash"),
          backgroundColor: const Color(0XFF0E325F),
          elevation: 1),
      body: WebView(
        initialUrl: paySafeUrl,
      ),
    );
  }
}
