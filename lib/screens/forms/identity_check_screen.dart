import 'package:appllegagt/models/general/registration_success_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class IdentityCheckScreen extends StatefulWidget {
  final RegistrationSuccessResponse? registrationSuccessResponse;
  const IdentityCheckScreen({Key? key, @required this.registrationSuccessResponse}) : super(key: key);

  @override
  _IdentityCheckScreenState createState() {
    return _IdentityCheckScreenState(registrationSuccessResponse: this.registrationSuccessResponse);
  }
}

class _IdentityCheckScreenState extends State<IdentityCheckScreen> {
  final RegistrationSuccessResponse? registrationSuccessResponse;
  _IdentityCheckScreenState({Key? key, @required this.registrationSuccessResponse});
  @override
  Widget build(BuildContext context) {
    var url = 'https://bgipay.me/spa/xcmo/securew/mati_cproof.asp?CHolderID=${registrationSuccessResponse!.cHolderId}';
    return WebviewScaffold(
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
    );
  }
}
