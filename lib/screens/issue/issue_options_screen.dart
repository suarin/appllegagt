import 'package:appllegagt/screens/issue/account_screen.dart';
import 'package:appllegagt/screens/issue/password_form.dart';
import 'package:appllegagt/screens/issue/virtual_card_balance_form.dart';
import 'package:appllegagt/screens/issue/visa_balance_form.dart';
import 'package:appllegagt/screens/issue/visa_request_form.dart';
import 'package:appllegagt/screens/issue/web_pin_form.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IssueOptionsScreen extends StatefulWidget {
  const IssueOptionsScreen({Key? key}) : super(key: key);

  @override
  _IssueOptionsScreenState createState() => _IssueOptionsScreenState();
}

class _IssueOptionsScreenState extends State<IssueOptionsScreen>
    with WidgetsBindingObserver {
  var screenWidth, screenHeight;

  _setLastPage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastPage', 'principalScreen');
  }

  @override
  void initState() {
    _setLastPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil del cliente'),
        backgroundColor: const Color(0xFF0E325F),
      ),
      backgroundColor: const Color(0XFF0E2238),
      body: SizedBox(
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                child: SizedBox(
                  child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0)),
                        color: Colors.white),
                  ),
                  height: screenHeight * 0.80,
                  width: screenWidth,
                ),
                top: 125.0,
              ),
              Positioned(
                child: SizedBox(
                  child: Column(
                    children: [
                      Container(
                        child: TextButton(
                          child: const Text(
                            'Perfil del ciente',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AccountScreen(),
                              ),
                            );
                          },
                        ),
                        decoration: const BoxDecoration(
                            color: Color(0xFF0E2238),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        margin: const EdgeInsets.only(bottom: 5.0),
                        width: 325,
                      ),
                      Container(
                        child: TextButton(
                          child: const Text(
                            'Cambio Web Pin',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        margin: const EdgeInsets.only(bottom: 5.0),
                        width: 325,
                      ),
                      Container(
                        child: TextButton(
                          child: const Text(
                            'Recuperar contraseña',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        margin: const EdgeInsets.only(bottom: 5.0),
                        width: 325,
                      ),
                      Container(
                        child: TextButton(
                          child: const Text(
                            'Solicitar Tarjeta Visa',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const VisaRequestForm(),
                              ),
                            );
                          },
                        ),
                        decoration: const BoxDecoration(
                            color: Color(0xFF0E2238),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        margin: const EdgeInsets.only(bottom: 5.0),
                        width: 325,
                      ),
                      Container(
                        child: TextButton(
                          child: const Text(
                            'Solicitar Saldo Visa',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const VisaBalanceForm(),
                                ));
                          },
                        ),
                        decoration: const BoxDecoration(
                            color: Color(0xFF0E2238),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        margin: const EdgeInsets.only(bottom: 5.0),
                        width: 325,
                      ),
                      Container(
                        child: TextButton(
                          child: const Text(
                            'Solicitar Saldo Tarjeta Virtual',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const VirtualCardBalanceForm(),
                                ));
                          },
                        ),
                        decoration: const BoxDecoration(
                            color: Color(0xFF0E2238),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        margin: const EdgeInsets.only(bottom: 5.0),
                        width: 325,
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  ),
                  width: 325.0,
                ),
                top: 200,
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
