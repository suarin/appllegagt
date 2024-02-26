import 'dart:io';

import 'package:appllegagt/screens/recharge/card_load_pay_safe_form.dart';
import 'package:appllegagt/screens/recharge/pay_safe_code_request_form.dart';
import 'package:appllegagt/screens/forms/insurance_pay_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:appllegagt/models/general/login_success_response.dart';

class PaySafeOptionsScreen extends StatefulWidget {
  const PaySafeOptionsScreen({Key? key}) : super(key: key);

  @override
  _PaySafeOptionsScreenState createState() => _PaySafeOptionsScreenState();
}

class _PaySafeOptionsScreenState extends State<PaySafeOptionsScreen>
    with WidgetsBindingObserver{
  String clientName = '';
  String cardNo = '';
  String currency = '';
  String balance = '';
  String cHolderID = '';
  bool isGT = false;
  bool isUS = false;
  bool userDataLoaded = false;

  _showErrorResponse(String errorMessage) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.red,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.white),
                  ),
                  margin: const EdgeInsets.only(left: 40.0),
                ),
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
        );
      },
    );
  }
  _openURL() async {
    Uri url = Uri.parse(
        'https://web.llega.com/codigos/paysafe/${cHolderID}_codigo.pdf');
    http.Response response;
    try {
      response = await http.get(url, headers: {
        HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
      });

      if (response.statusCode == 200) {
        if (!await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        )) {
          throw 'Could not launch $url';
        }
      } else {
        _showErrorResponse(response.statusCode.toString());
      }
    } catch (e) {
      _showErrorResponse(e.toString());
    }
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
      clientName = loginSuccessResponse.userName.toString();
      cardNo = loginSuccessResponse.cardNo.toString();
      currency = loginSuccessResponse.currency.toString();
      balance = loginSuccessResponse.balance.toString();
      cHolderID = loginSuccessResponse.cHolderID.toString();
    });
    userDataLoaded = true;
  }

  @override
  void initState() {
    _getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recarga PaySafe'),
        backgroundColor: const Color(0XFF0E325F),
      ),
      backgroundColor: const Color(0XFFAFBECC),
      body: Container(
        child: Stack(
          children: [
            Positioned(
              top: 150.0,
              left: (screenWidth - 350.0) / 8,
              child: Column(
                children: [
                  SizedBox(
                    width: 350.0,
                    child: Image.asset('images/paysafe_banner500x400.png'),
                  ),
                  SizedBox(
                    height: 20.0, // Adjust the height according to your preference
                  ),
                  Container(
                    width: 350.0, // Adjust width as needed
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'ALERTA!',
                          style: TextStyle(
                            fontSize: 24.0, // Adjust font size according to your preference
                            fontWeight: FontWeight.bold, // Adjust font weight according to your preference
                            color: Colors.red, // Add red color to the title
                          ),
                        ),
                        SizedBox(height: 10), // Adjust spacing between title and content
                        Text(
                          'Despues de solicitar el Codigo PaySafe, debe esperar un tiempo de hasta 15 minutos antes de oprimir el Boton que dice "Mostrar codigo PaySafe"',
                          style: TextStyle(
                            fontSize: 18.0, // Adjust font size according to your preference
                          ),
                          textAlign: TextAlign.center, // Align text within the container
                        ),
                        SizedBox(height: 10), // Adjust spacing between title and content
                        Text(
                          'Despues de canjear el Codigo PaySafe en la tienda, debe oprimir el Boton que dice "Solicitar Deposito"',
                          style: TextStyle(
                            fontSize: 18.0, // Adjust font size according to your preference
                          ),
                          textAlign: TextAlign.center, // Align text within the container
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ListView(
              children: [
                Container(
                  child: TextButton(
                    child: const Text(
                      'Solicitar \n código PaySafe',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CardLoadPaySafeForm(),
                        ),
                      );
                    },
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0XFF0E325F),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  width: screenWidth,
                  margin: const EdgeInsets.only(bottom: 5.0),
                ),
                Container(
                  child: TextButton(
                    child: const Text(
                      'Mostrar \n código PaySafe',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    onPressed: () {
                      _openURL();
                    },
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0XFF0E325F),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  width: screenWidth,
                  margin: const EdgeInsets.only(bottom: 5.0),
                ),
                Container(
                  child: TextButton(
                    child: const Text(
                      'Solicitar Depósito',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PaySafeCodeRequestForm(),
                        ),
                      );
                    },
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0XFF0E325F),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  width: screenWidth,
                  margin: const EdgeInsets.only(bottom: 5.0),
                ),
                Container(
                  child: TextButton(
                    child: const Text(
                      'Pago Mensual \n Repatriacion',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const InsurancePayScreen(),
                        ),
                      );
                    },
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0XFF0E325F),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  width: screenWidth,
                  margin: const EdgeInsets.only(bottom: 5.0),
                ),
              ],
            ),
          ],
        ),
        margin: const EdgeInsets.only(top: 10.0),
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      ),
    );
  }
}
