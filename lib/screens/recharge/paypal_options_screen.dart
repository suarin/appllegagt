import 'dart:io';
import 'package:appllegagt/screens/recharge/card_load_pay_safe_form.dart';
import 'package:appllegagt/screens/recharge/paypal_transfer_form.dart';
import 'package:appllegagt/screens/forms/insurance_pay_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:appllegagt/models/general/login_success_response.dart';

_openURL() async {
  Uri url = Uri.parse('https://www.paypal.com/paypalme/LLegaExpress/');
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw 'Could not launch $url';
  }
}

class PayPalOptionsScreen extends StatefulWidget {
  const PayPalOptionsScreen({Key? key}) : super(key: key);

  @override
  _PayPalOptionsScreenState createState() => _PayPalOptionsScreenState();
}

class _PayPalOptionsScreenState extends State<PayPalOptionsScreen>
    with WidgetsBindingObserver{
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Opciones PayPal'),
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
                          '1- Debe realizar primero la transferencia desde su cuenta PayPal hacia nosotros usando el boton "Transferir hacia PayPal"',
                          style: TextStyle(
                            fontSize: 18.0, // Adjust font size according to your preference
                          ),
                          textAlign: TextAlign.center, // Align text within the container
                        ),
                        SizedBox(height: 10), // Adjust spacing between title and content
                        Text(
                          '2- Despues de realizada la Transferencia debe solicitar el deposito en su cuenta en el boton "Solicitar Transferencia PayPal "',
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
                      'Transferir \n hacia PayPal',
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
                      'Solicitar \n transferencia PayPal',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PaypalTransferForm(),
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
