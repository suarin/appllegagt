import 'package:flutter/material.dart';
import 'package:appllegagt/models/general/login_success_response.dart';
import 'package:appllegagt/models/shop/virtual_card_request_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VirtualCardScreen extends StatefulWidget {
  final VirtualCardRequestResponse virtualCardRequestResponse;
  const VirtualCardScreen({Key? key, required this.virtualCardRequestResponse})
      : super(key: key);

  @override
  _VirtualCardScreenState createState() => _VirtualCardScreenState(
      virtualCardRequestResponse: virtualCardRequestResponse);
}

class _VirtualCardScreenState extends State<VirtualCardScreen> {
  final VirtualCardRequestResponse virtualCardRequestResponse;
  _VirtualCardScreenState({required this.virtualCardRequestResponse});
  var clientName = '';
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
    });
  }

  @override
  void initState() {
    _getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        flexibleSpace: Image.asset(
          'images/app_bar_header.png',
          fit: BoxFit.fill,
          height: 150.0,
        ),
        title: const Text(
          'virtualCard',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'VarealRoundRegular',
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              child: Stack(
                children: [
                  Positioned(
                    child: SizedBox(
                      child: Image.asset(
                          'images/llegelogoblanco154x154.png'),
                      width: 125,
                    ),
                    right: 10,
                    top: 10,
                  ),
                  Positioned(
                    child: SizedBox(
                      child: Image.asset('images/icons/contact_less_gold.png'),
                      width: 40.0,
                    ),
                    right: 15,
                    top: 60,
                  ),
                  Positioned(
                    child: SizedBox(
                      child: Image.asset('images/icons/chip_gold.png'),
                      width: 40.0,
                    ),
                    top: 60,
                    left: 25,
                  ),
                  Positioned(
                    child: Text(
                      virtualCardRequestResponse.cardNumber.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'VarealRoundRegular',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 6,
                      ),
                    ),
                    top: 120,
                    left: 20,
                  ),
                  Positioned(
                    child: Text(
                      clientName.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'VarealRoundRegular',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 6,
                      ),
                    ),
                    top: 95,
                    left: 20,
                  ),
                  Positioned(
                    child: Text(
                      'EXP ${virtualCardRequestResponse.expDate}',
                      style: const TextStyle(
                          color: Colors.white,
                          letterSpacing: 2,
                          fontFamily: 'NanumGothic Bold',
                          fontSize: 12.0),
                      textAlign: TextAlign.start,
                    ),
                    top: 150,
                    left: 40,
                  ),
                  Positioned(
                    child: Text(
                      'CVV ${virtualCardRequestResponse.cardCvv}',
                      style: const TextStyle(
                          color: Colors.white,
                          letterSpacing: 2,
                          fontFamily: 'NanumGothic Bold',
                          fontSize: 12.0),
                      textAlign: TextAlign.start,
                    ),
                    top: 150,
                    left: 200,
                  ),
                  Positioned(
                    child: SizedBox(
                      child: Image.asset('images/logos/visa-logo1.png'),
                      width: 40.0,
                    ),
                    right: 10,
                    top: 160,
                  ),
                ],
              ),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                image: DecorationImage(
                  image:
                      AssetImage('images/card_blue_background.png'),
                  fit: BoxFit.cover,
                ),
              ),
              width: screenWidth * 0.95,
              height: 200.0,
              margin: const EdgeInsets.only(
                top: 20,
                left: 5.0,
              ),
            ),
            Container(
              child: const Text(
                'invoiceAddress:\n1600 Ponce de Leon Blvd CORAL GABLES, FLORIDA, USA, 33134',
                style: TextStyle(
                    fontFamily: 'VarelaRoundRegular',
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  color: Color(0xFF00CAB2)),
              width: screenWidth * 0.90,
              height: 75.0,
              margin: const EdgeInsets.only(
                top: 250,
                left: 5.0,
              ),
              padding: const EdgeInsets.only(left: 15.0, top: 10),
            ),
          ],
        ),
      ),
    );
  }
}
