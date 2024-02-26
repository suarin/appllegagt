import 'package:appllegagt/models/general/login_success_response.dart';
import 'package:appllegagt/screens/procedure_screen.dart';
import 'package:appllegagt/screens/recharge_screen.dart';
import 'package:appllegagt/screens/select_country_screen.dart';
import 'package:appllegagt/screens/shop_screen.dart';
import 'package:appllegagt/screens/transfer_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrincipalScreen extends StatefulWidget {
  const PrincipalScreen({Key? key}) : super(key: key);

  @override
  _PrincipalScreenState createState() => _PrincipalScreenState();
}

class _PrincipalScreenState extends State<PrincipalScreen>
    with WidgetsBindingObserver {
  var screenSize,
      screenHeight,
      screenWidth,
      logoRightDistance,
      elementLeftDistance,
      elementRigthDistance,
      cardLeftDistance,
      screenMiddleHeight;

  String clientName = '';
  String cardNo = '';
  String currency = '';
  String balance = '';
  String userID = '';

  _setLastPage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastPage', 'principalScreen');
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
      userID = prefs.getString('userID').toString();
    });
  }

  _logOut() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.getBool('isScanning')!) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const SelectCountryScreen()));
    }
    if (prefs.getString('lastPage') != 'qr') {
      _cleanPreferences();
    }
  }

  _cleanPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('cHolderID', 0);
    await prefs.setString('userID', '');
    await prefs.setString('userName', '');
    await prefs.setString('cardNo', '');
    await prefs.setString('currency', '');
    await prefs.setString('balance', '');
    await prefs.setBool('isScanning', false);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.paused:
        _logOut();
        break;

      case AppLifecycleState.resumed:
        _logOut();
        break;

      case AppLifecycleState.inactive:
        _logOut();
        break;

      case AppLifecycleState.detached:
        _logOut();
        break;
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    _getUserData();
    _setLastPage();
    super.initState();
  }

  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    screenHeight = MediaQuery.of(context).size.height;
    screenMiddleHeight = MediaQuery.of(context).size.height / 2;
    screenWidth = MediaQuery.of(context).size.width;
    cardLeftDistance = (screenWidth - 325.0) / 2;

    return WillPopScope(
      child: Scaffold(
        backgroundColor: const Color(0xFF42A5F5),
        body: SizedBox(
          child: SafeArea(
            child: Stack(
              children: [
                Positioned(
                  child: Container(
                    child: Stack(
                      children: [
                        Positioned(
                          child: Text(
                            clientName.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          left: 15.0,
                          top: 25.0,
                        ),
                        Positioned(
                          child: Text(
                            // Format cardNo to "XXXX XXXX XXXX XXXX"
                            '${cardNo.substring(0, 4)} ${cardNo.substring(4, 8)} ${cardNo.substring(8, 12)} ${cardNo.substring(12)}',
                            style: const TextStyle(
                              color: Colors.white,
                              letterSpacing: 5,
                            ),
                          ),
                          left: 25.0,
                          top: 75.0,
                        ),
                        Positioned(
                          child: Text(
                            '$currency $balance',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                            ),
                          ),
                          left: 15.0,
                          top: 140.0,
                        ),
                        Positioned(
                          child: SizedBox(
                            child: Image.asset('images/llegelogoblanco154x154.png'),
                            height: 100.0,
                            width: 100.0,
                          ),
                          left: 200.0,
                          top: 100.0,
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: const Color(0xFF0E325F),
                    ),
                    height: 180.0,
                    width: 325.0,
                  ),
                  top: 20.0,
                  left: cardLeftDistance,
                ),
                Positioned(
                  child: SizedBox(
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0)),
                        color: Colors.white,
                      ),
                    ),
                    height: screenMiddleHeight,
                    width: screenWidth,
                  ),
                  top: screenMiddleHeight - 15,
                ),
                Positioned(
                  child: SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: Ink(
                            child: Column(
                              children: [
                                IconButton(
                                  icon: Image.asset(
                                      'images/icons/recharge_icon.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RechargeScreen()));
                                  },
                                  iconSize: 70,
                                ),
                                const Text(
                                  'Recargas',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            ),
                            decoration: const ShapeDecoration(
                              color: Color(0xFF0E325F),
                              shape: CircleBorder(),
                            ),
                          ),
                          decoration: const BoxDecoration(
                              color: Color(0xFF0E2238),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          height: 130,
                          width: 115,
                        ),
                        Container(
                          child: Ink(
                            child: Column(
                              children: [
                                IconButton(
                                  icon: Image.asset(
                                      'images/icons/transfer_icon.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TransferScreen()));
                                  },
                                  iconSize: 70,
                                ),
                                const Text(
                                  'Transferencias',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            ),
                            decoration: const ShapeDecoration(
                              color: Color(0xFF0E325F),
                              shape: CircleBorder(),
                            ),
                          ),
                          decoration: const BoxDecoration(
                              color: Color(0xFF0E2238),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          height: 130,
                          width: 115,
                        ),
                      ],
                    ),
                    height: 150,
                    width: 300,
                  ),
                  top: screenMiddleHeight - 10,
                  left: (screenWidth - 300) / 2,
                ),
                Positioned(
                  child: SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: Ink(
                            child: Column(
                              children: [
                                IconButton(
                                  icon:
                                      Image.asset('images/icons/shop_icon.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ShopScreen()));
                                  },
                                  iconSize: 70,
                                ),
                                const Text(
                                  'Compras',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            ),
                            decoration: const ShapeDecoration(
                              color: Color(0xFF0E325F),
                              shape: CircleBorder(),
                            ),
                          ),
                          decoration: const BoxDecoration(
                              color: Color(0xFF0E2238),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          height: 130,
                          width: 115,
                        ),
                        Container(
                          child: Ink(
                            child: Column(
                              children: [
                                IconButton(
                                  icon: Image.asset(
                                      'images/icons/procedure_icon.png'),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProcedureScreen()));
                                  },
                                  iconSize: 70,
                                ),
                                const Text(
                                  'Gestiones',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            ),
                            decoration: const ShapeDecoration(
                              color: Color(0xFF0E325F),
                              shape: CircleBorder(),
                            ),
                          ),
                          decoration: const BoxDecoration(
                              color: Color(0xFF0E2238),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          height: 130,
                          width: 115,
                        ),
                      ],
                    ),
                    height: 150,
                    width: 300,
                  ),
                  top: screenMiddleHeight + 130,
                  left: (screenWidth - 300) / 2,
                ),
              ],
            ),
          ),
          height: screenHeight,
          width: screenWidth,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _logOut,
          tooltip: 'Salir',
          child: const Icon(Icons.exit_to_app),
          backgroundColor: const Color(0xFF0E2238),
        ),
      ),
      onWillPop: () async => false,
    );
  }
}
