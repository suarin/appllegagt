import 'package:appllegagt/models/general/login_success_response.dart';
import 'package:appllegagt/screens/procedure_screen.dart';
import 'package:appllegagt/screens/recharge_screen.dart';
import 'package:appllegagt/screens/select_country_screen.dart';
import 'package:appllegagt/screens/shop_screen.dart';
import 'package:appllegagt/screens/transfer/bank_transfer_form.dart';
import 'package:appllegagt/screens/transfer/international_card_transfer.dart';
import 'package:appllegagt/screens/transfer/local_transfer_form.dart';
import 'package:appllegagt/screens/transfer/visa_transfer_form.dart';
import 'package:appllegagt/screens/transfer/visa_transfer_from.dart';
import 'package:appllegagt/screens/transfer/virtual_transfer_form.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:appllegagt/widgets/option_button.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({Key? key}) : super(key: key);

  @override
  _TransferScreenState createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen>
    with WidgetsBindingObserver {
  String clientName = '';
  String cardNo = '';
  String currency = '';
  String balance = '';
  bool isGT = false;
  bool isUS = false;

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
    });
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

  _logOut() async {
    _cleanPreferences();
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const SelectCountryScreen()));
  }

  _setLastPage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastPage', 'principalScreen');
  }

  @override
  void initState() {
    _getUserData();
    _getCountryScope();
    _setLastPage();
    super.initState();
  }

  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var screenMiddleHeight = MediaQuery.of(context).size.height / 2;
    var cardLeftDistance = (screenWidth - 325.0) / 2;
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: Ink(
                            child: Column(
                              children: [
                                Container(
                                  child: IconButton(
                                    icon: Image.asset(
                                        'images/icons/recharge_icon.png'),
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const RechargeScreen()));
                                    },
                                    iconSize: 30,
                                  ),
                                  decoration: const BoxDecoration(
                                      color: Color(0xFF0E325F),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                ),
                                const Text(
                                  'Recargas',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10.0),
                                ),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                            ),
                          ),
                          height: 75,
                          width: 75,
                        ),
                        Container(
                          child: Ink(
                            child: Column(
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                      color: Color(0XFF86C0E7),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: IconButton(
                                    icon: Image.asset(
                                        'images/icons/transfer_icon.png'),
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  TransferScreen()));
                                    },
                                    iconSize: 30,
                                  ),
                                ),
                                const Text(
                                  'Transferencias',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10),
                                ),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                            ),
                          ),
                          height: 75,
                          width: 75,
                        ),
                        Container(
                          child: Ink(
                            child: Column(
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                      color: Color(0xFF0E325F),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: IconButton(
                                    icon: Image.asset(
                                        'images/icons/shop_icon.png'),
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ShopScreen()));
                                    },
                                    iconSize: 30,
                                  ),
                                ),
                                const Text(
                                  'Compras',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10.0),
                                ),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                            ),
                          ),
                          height: 75,
                          width: 75,
                        ),
                        Container(
                          child: Ink(
                            child: Column(
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                      color: Color(0xFF0E325F),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: IconButton(
                                    icon: Image.asset(
                                        'images/icons/procedure_icon.png'),
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProcedureScreen()));
                                    },
                                    iconSize: 30,
                                  ),
                                ),
                                const Text(
                                  'Gestiones',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10.0),
                                ),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                            ),
                          ),
                          height: 75,
                          width: 75,
                        ),
                      ],
                    ),
                    height: 150,
                    width: 325,
                  ),
                  top: screenMiddleHeight - 150,
                  left: (screenWidth - 325) / 2,
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
                  top: screenMiddleHeight,
                ),
                Positioned(
                  child: SizedBox(
                    child: Column(
                      children: [
                        OptionButton(
                          label: isUS
                              ? 'Hacia cuenta LLEGA en U.S.A.'
                              : 'Hacia cuenta Llega',
                          onPress: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LocalTransferForm(),
                              ),
                            );
                          },
                        ),
                        OptionButton(
                          label: isUS
                              ? 'Hacia tarjetas VISA, MC, UPAY'
                              : 'Hacia Tarjeta Visa',
                          onPress: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const VisaTransferForm(),
                              ),
                            );
                          },
                        ),
                        isUS
                            ? OptionButton(
                                label: 'Hacia Banco USA',
                                onPress: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const BankTransferForm(),
                                    ),
                                  );
                                },
                              )
                            : const Text(''),
                        isUS
                            ? OptionButton(
                                label: 'Hacia cuenta LLEGA/TIGO Money\n en GUATEMALA',
                                onPress: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const InternationalCardTransfer(),
                                    ),
                                  );
                                },
                              )
                            : const Text(''),
                        isUS
                            ? OptionButton(
                              label: 'Hacia Tarjeta Virtual',
                              onPress: () {
                               Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const VirtualTransferForm(),
                              ),
                            );
                          },
                        )
                            : const Text(''),
                        isUS
                            ? OptionButton(
                              label: 'Desde Tarjeta Visa Canada',
                              onPress: () {
                              Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                const VisaTransferFrom(),
                              ),
                            );
                          },
                        )
                            : const Text(''),
                      ],
                    ),
                    width: 325.0,
                  ),
                  top: screenMiddleHeight + 10,
                  left: cardLeftDistance,
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
      onWillPop: () async => true,
    );
  }
}
