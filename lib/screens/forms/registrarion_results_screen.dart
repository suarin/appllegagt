import 'package:appllegagt/models/general/registration_success_response.dart';
import 'package:appllegagt/screens/forms/identity_check_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class RegistrationResultsScreen extends StatefulWidget {
  final RegistrationSuccessResponse? registrationSuccessResponse;
  const RegistrationResultsScreen(
      {Key? key, @required this.registrationSuccessResponse})
      : super(key: key);

  @override
  _RegistrationResultsScreenState createState() =>
      _RegistrationResultsScreenState(
          registrationSuccessResponse: this.registrationSuccessResponse);
}

class _RegistrationResultsScreenState extends State<RegistrationResultsScreen> {
  final RegistrationSuccessResponse? registrationSuccessResponse;
  _RegistrationResultsScreenState(
      {Key? key, @required this.registrationSuccessResponse});

  bool isGT = false;
  bool isUS = false;

  final _gtText =
      '\nAL FINALIZAR EL REGISTRO NO PODRAS INGRESAR A TU CUENTA, HASTA QUE ENVÍES COPIA DE LOS SIGUIENTES DOCUMENTOS:\n'
      '1. DOCUMENTO DE IDENTIFICACION.\n'
      '2. RECIBO DE SERVICIOS QUE DEMUESTRE TU DIRECCION, ENVIALOS AL WHATSAPP, NUMERO 502 36074219.\n'
      'CUANDO ENVIE LAS IMAGENES RECUERDE HACER REFERENCIA DE TU NOMBRE EN EL RECUADRO QUE APARECE EN WHATSAPP "Añade un comentario"\n';

  final _usText =
      '\nPRESIONAR CARGAR DOCUMENTOS, SIGUE LOS PASOS QUE TE SOLICITA EL DEPARTAMENTO DE CUMPLIMIENTO\n'
      'O SI PREFIERES ENVIANOS COPIA DE LOS MISMOS DOCUMENTOS MENCIONADOS ARRIBA, AL WHATSAPP, NUMERO 502 2221 4775\n'
      'CUANDO ENVIE LAS IMAGENES RECUERDE HACER REFERENCIA DE TU NOMBRE EN EL RECUADRO QUE APARECE EN WHATSAPP\n'
      '"Añade un comentario".';
  //Open Load Documents form:
  _openURL() async {
    var url = 'https://n9.cl/llega';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  //Load Country Scope
  _getCountryScope() async {
    final prefs = await SharedPreferences.getInstance();
    String countryScope = prefs.getString('countryScope')!;
    if (countryScope == 'GT') {
      setState(() {
        isGT = true;
      });
    }

    if (countryScope == 'US') {
      setState(() {
        isUS = true;
      });
    }
  }

  @override
  void initState() {
    _getCountryScope();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Datos de la cuenta'),
          backgroundColor: const Color(0XFF0E325F),
        ),
        backgroundColor: const Color(0xFFAFBECC),
        body: SafeArea(
          child: Container(
            color: Colors.greenAccent,
            child: Center(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      child: Column(
                        children: [
                          Row(
                            children: const [
                              SizedBox(
                                child: Text(
                                  'GUARDA ESTOS DATOS, SON PARA TU USO EXCLUSIVAMENTE\n',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                  ),
                                ),
                                width: 300,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                child: Text(
                                  'No. Cuenta',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                width: 150,
                              ),
                              SizedBox(
                                child: Text(registrationSuccessResponse!.cardNo
                                    .toString()),
                                width: 150,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                child: Text(
                                  'ID Usuario',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                width: 150,
                              ),
                              SizedBox(
                                child: Text(registrationSuccessResponse!.userId
                                    .toString()),
                                width: 150,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                child: Text(
                                  'Contraseña',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                width: 150,
                              ),
                              SizedBox(
                                child: Text(registrationSuccessResponse!
                                    .password
                                    .toString()),
                                width: 150,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                child: Text(
                                  'Autorización',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                width: 150,
                              ),
                              SizedBox(
                                child: Text(registrationSuccessResponse!.authno
                                    .toString()),
                                width: 150,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                child: Text(
                                  isUS ? _usText : _gtText,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0),
                                ),
                                width: 300,
                              ),
                            ],
                          ),
                        ],
                      ),
                      margin: const EdgeInsets.only(left: 40),
                    ),
                    isUS
                        ? ElevatedButton(
                            child: const Text('Cargar Documentos'),
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => IdentityCheckScreen(
                                        registrationSuccessResponse:
                                            registrationSuccessResponse))),
                            style: ElevatedButton.styleFrom(
                              primary: const Color(0XFF0E325F),
                            ),
                          )
                        : const Text(''),
                    ElevatedButton(
                      child: const Text('Cerrar'),
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0XFF0E325F),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
