import 'package:appllegagt/models/general/registration_success_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class IdentityCheckScreen extends StatefulWidget {
  final RegistrationSuccessResponse? registrationSuccessResponse;
  const IdentityCheckScreen(
      {Key? key, @required this.registrationSuccessResponse})
      : super(key: key);

  @override
  _IdentityCheckScreenState createState() {
    return _IdentityCheckScreenState(
        registrationSuccessResponse: this.registrationSuccessResponse);
  }
}

class _IdentityCheckScreenState extends State<IdentityCheckScreen> {
  final RegistrationSuccessResponse? registrationSuccessResponse;
  _IdentityCheckScreenState(
      {Key? key, @required this.registrationSuccessResponse});

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

  @override
  void initState() {
    _loadBaseUrl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var url =
        '${baseUrl}spa/xcmo/securew/mati_cproof.asp?CHolderID=${registrationSuccessResponse!.cHolderId}';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0XFF0E325F),
        title: const Text(
          'Verificar Identidad',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'VarealRoundRegular',
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: WebView(
        initialUrl: url,
      ),
    );
    /*return WebviewScaffold(
      url: url,
      withJavascript: true,
      withZoom: false,
      appBar: AppBar(
        backgroundColor: const Color(0XFF0E325F),
        title: const Text(
          'Verificar Identidad',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'VarealRoundRegular',
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 1,
      ),
    );*/
  }
}
