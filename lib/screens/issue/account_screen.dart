import 'package:appllegagt/models/general/login_success_response.dart';
import 'package:appllegagt/screens/issue/password_form.dart';
import 'package:appllegagt/screens/issue/web_pin_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>  with WidgetsBindingObserver {

  var screenWidth, screenHeight;

  String clientName = '';
  String cardNo = '';
  String currency = '';
  String balance = '';
  String userID ='';

  _getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    LoginSuccessResponse  loginSuccessResponse = LoginSuccessResponse(
        errorCode: 0,
        cHolderID: prefs.getInt('cHolderID'),
        userName: prefs.getString('userName'),
        cardNo: prefs.getString('cardNo'),
        currency: prefs.getString('currency'),
        balance: prefs.getString('balance')
    );
    setState(() {
      clientName = loginSuccessResponse.userName.toString();
      cardNo = loginSuccessResponse.cardNo.toString();
      currency = loginSuccessResponse.currency.toString();
      balance = loginSuccessResponse.balance.toString();
      userID = prefs.getString('userID').toString();
    });
  }

  @override
  void initState(){
    _getUserData();
    super.initState();
  }
  Widget build(BuildContext context) {

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil del cliente'),
        backgroundColor: const Color(0xFF0E325F),
      ),
      backgroundColor: Colors.white,
      body: SizedBox(
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                child: SizedBox(
                  child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
                        color: Color(0xFFE1E8EF),
                    ),
                  ),
                  height: screenHeight * 0.80,
                  width: screenWidth,
                ),
                top: 125.0,
              ),
              Positioned(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF86C0E7),
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                  height: 150,
                  width: 150,
                ),
                top: 50.0,
                left: (screenWidth - 150)/2,
              ),
              Positioned(
                child: SizedBox(
                  child: Column(
                    children: [
                      Container(
                        child: Text(
                          clientName.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.black26,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        margin: const EdgeInsets.only(bottom: 30.0),
                      ),
                      Container(
                        child: Row(
                          children:  [
                            const Icon(
                              Icons.credit_card,
                              color: Colors.black26,
                            ),
                            Container(
                               child: Text(
                                  cardNo,
                                  style: const TextStyle(
                                      color: Colors.black26,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 3.0
                                  ),
                                ),
                              margin: const EdgeInsets.only(left: 30),
                            ),
                          ],
                        ),
                        width: 250,
                        margin: const EdgeInsets.only(bottom: 10),
                      ),
                      Container(
                        child: Row(
                          children:  [
                            const Icon(
                              Icons.monetization_on_rounded,
                              color: Colors.black26,
                            ),
                            Container(
                              child:  Text(
                                '$currency $balance',
                                style: const TextStyle(
                                    color: Colors.black26,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 3.0
                                ),
                              ),
                              margin: const EdgeInsets.only(left: 30),
                            ),
                          ],
                        ),
                        width: 250,
                        margin: const EdgeInsets.only(bottom: 10),
                      ),
                      Container(
                        child: Row(
                          children: [
                            const Icon(
                              Icons.person,
                              color: Colors.black26,
                            ),
                            Container(
                              child:  Text(
                                userID,
                                style: const TextStyle(
                                    color: Colors.black26,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 3.0
                                ),
                              ),
                              margin: const EdgeInsets.only(left: 30),
                            ),
                          ],
                        ),
                        width: 250,
                        margin: const EdgeInsets.only(bottom: 50),
                      ),
                      Container(
                        child: TextButton(
                          child: const Text(
                            'Cambiar web PIN',
                            style: TextStyle(
                                color: Colors.white
                            ),
                          ),
                          onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const WebPinForm(),
                              ),
                            );
                          },
                        ),
                        decoration: const BoxDecoration(
                            color: Color(0xFF0E2238),
                            borderRadius: BorderRadius.all(Radius.circular(10.0))
                        ),
                        margin: const EdgeInsets.only(bottom: 5.0),
                        width: 325,
                      ),
                      Container(
                        child: TextButton(
                          child: const Text(
                            'Cambiar contraseña',
                            style: TextStyle(
                                color: Colors.white
                            ),
                          ),
                          onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PasswordForm(),
                              ),
                            );
                          },
                        ),
                        decoration: const BoxDecoration(
                            color: Color(0xFF0E2238),
                            borderRadius: BorderRadius.all(Radius.circular(10.0))
                        ),
                        margin: const EdgeInsets.only(bottom: 5.0),
                        width: 325,
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  ),
                  width: 325.0,
                ),
                top: screenHeight - 500,
                left: (screenWidth - 325.0) / 2,
              ),
            ],
          ),
        ),
        height: screenHeight,
        width: screenWidth,
      ),
    );
  }
}
