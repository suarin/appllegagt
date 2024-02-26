import 'package:appllegagt/models/general/login_success_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CancelAccountWebView extends StatefulWidget {
  const CancelAccountWebView({Key? key}) : super(key: key);

  @override
  _CancelAccountWebViewState createState() => _CancelAccountWebViewState();
}

class _CancelAccountWebViewState extends State<CancelAccountWebView> {
  String reqCHolderID = '0';
  String cancelUrl = '';
  bool isGT = false;
  bool isUS = false;
  var baseUrl = '';
  bool initialGet = false;

  //Load Country Scope
  _getCountryScope() async {
    final prefs = await SharedPreferences.getInstance();
    String countryScope = prefs.getString('countryScope')!;
    if (countryScope == 'GT') {
      setState(() {
        isGT = true;
        baseUrl = dotenv.env['GT_HOST']!;
      });
    }

    if (countryScope == 'US') {
      setState(() {
        isUS = true;
        baseUrl = dotenv.env['US_HOST']!;
      });
    }
    _getUserData();
  }

  _getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    LoginSuccessResponse loginSuccessResponse = LoginSuccessResponse(
        errorCode: 0,
        cHolderID: prefs.getInt('cHolderID'),
        userName: prefs.getString('userName'),
        cardNo: prefs.getString('cardNo'),
        currency: prefs.getString('currency'),
        balance: prefs.getString('balance'));
    setState(() {
      reqCHolderID = prefs.get('cHolderID').toString();
      cancelUrl =
          '${baseUrl}spa/xcmo/securew/customer_cancel_request.asp?CHolderID=$reqCHolderID';
      initialGet = true;
    });
  }

  _setLastPage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastPage', 'principalScreen');
  }

  @override
  void initState() {
    _getCountryScope();
    _setLastPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Cancelar Cuenta"),
          backgroundColor: const Color(0XFF0E325F),
          elevation: 1),
      body: initialGet
          ? WebView(
              initialUrl: cancelUrl,
            )
          : const Text('Cargando...'),
    );
  }
}
