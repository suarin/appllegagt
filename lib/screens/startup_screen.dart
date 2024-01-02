import 'package:appllegagt/screens/forms/registration_form.dart';
import 'package:appllegagt/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class StartupScreen extends StatefulWidget {
  const StartupScreen({Key? key}) : super(key: key);

  @override
  _StartupScreenState createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen>
    with WidgetsBindingObserver {
  //Variables to store Screen dimensions
  bool isGT = false;
  bool isUS = false;
  double showOptionHeight = 200.0;

  //Open Confirmation Form
  _openConfirmationURL() async {
    final Uri _url = Uri.parse(
        "https://host2.ypayme.com/spa/xcmo/securew/customer_online_request.asp");
    if (await canLaunchUrl(_url)) {
      await launchUrl(_url);
    } else {
      throw 'Could not launch ${_url.toString()}';
    }
  }

  _openURL() async {
    //phone=50236074219'
    final Uri _url = Uri.parse(
        "whatsapp://send?phone=50236074219&text&type=phone_number&app_absent=0");
    if (await canLaunchUrl(_url)) {
      await launchUrl(_url);
    } else {
      throw 'Could not launch ${_url.toString()}';
    }
  }

  _openCoopUrl() async {
    final Uri _url = Uri.parse("https://gpspay.io/llega/");
    if (await canLaunchUrl(_url)) {
      await launchUrl(_url);
    } else {
      throw 'Could not launch ${_url.toString()}';
    }
  }

  _call() async {
    final Uri params = Uri(scheme: 'tel', path: '17864754440');
    if (await canLaunchUrl(params)) {
      await launchUrl(params);
    } else {
      throw 'Could not launch ${params.toString()}';
    }
  }

  _openEmail(BuildContext context) async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: 'soporte@lacas.org',
      queryParameters: {'subject': 'Ayuda', 'body': 'Escribir mensaje'},
    );

    if (await canLaunchUrl(params)) {
      await launchUrl(params);
    } else {
      throw 'Could not launch ${params.toString()}';
    }
  }

  _showHelpOptions(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: showOptionHeight,
          color: Colors.greenAccent,
          child: Center(
            child: Column(
              children: <Widget>[
                const Text(
                  '¿Cómo quiere contactarnos?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      _openEmail(context);
                    },
                    icon: const Icon(Icons.attach_email)),
                IconButton(
                    onPressed: () {
                      _openURL();
                    },
                    icon: SizedBox(
                      child: Image.asset('images/icons/whatsapp_logo.png'),
                      height: 75.0,
                      width: 75.0,
                    )),
                isUS
                    ? IconButton(
                        onPressed: () {
                          _call();
                        },
                        icon: const Icon(Icons.phone))
                    : const SizedBox(
                        height: 1.0,
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

  //Load Country Scope
  _getCountryScope() async {
    final prefs = await SharedPreferences.getInstance();
    String countryScope = prefs.getString('countryScope')!;
    if (countryScope == 'GT') {
      setState(() {
        isGT = true;
        showOptionHeight = 200.0;
      });
    }

    if (countryScope == 'US') {
      setState(() {
        isUS = true;
        showOptionHeight = 250.0;
      });
    }
  }

  _setLastPage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastPage', 'principalScreen');
  }

  @override
  void initState() {
    _getCountryScope();
    _setLastPage();
    super.initState();
  }

  Widget build(BuildContext context) {
    // getting the size of the device windows
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    var logoLeftDistance = (screenWidth - 300) / 2;
    var startSesionTextLeftDistance = (screenWidth - 300) / 2;
    var powerByBottomDistance = screenHeight - (screenHeight - 10);

    return WillPopScope(
        child: Scaffold(
          backgroundColor: Color(0xff11273f),
          body: SizedBox(
            child: SafeArea(
              child: Stack(
                children: [
                  Positioned(
                    child: Image.asset(
                      'images/llega_logo_blanco_1024x1024.png',
                      height: 300,
                      width: 300,
                    ),
                    top: 25,
                    left: logoLeftDistance,
                  ),
                  Positioned(
                    child: TextButton(
                      child: const Text('Iniciar Sesión'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: const Color(0xFF0e325f),
                        minimumSize: const Size(300.0, 50.0),
                        textStyle: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    top: 300,
                    left: startSesionTextLeftDistance,
                  ),
                  Positioned(
                    child: TextButton(
                      child: const Text('Crear Cuenta'),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const RegistrationForm()));
                      },
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: const Color(0xFF0e325f),
                        minimumSize: const Size(300.0, 50.0),
                        textStyle: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    top: 360,
                    left: startSesionTextLeftDistance,
                  ),
                  isGT
                      ? Positioned(
                          child: TextButton(
                            child: const Text('Confirmar Registro'),
                            onPressed: () {
                              _openConfirmationURL();
                            },
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: const Color(0xFF0e325f),
                              minimumSize: const Size(300.0, 50.0),
                              textStyle: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          top: 420,
                          left: startSesionTextLeftDistance,
                        )
                      : const SizedBox(
                          height: 0.001,
                        ),
                  Positioned(
                    child: TextButton(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Image.asset('images/icons/help_icon.png'),
                            width: 40.0,
                            height: 40.0,
                            margin:
                                const EdgeInsets.only(top: 25.0, bottom: 10.0),
                          ),
                          const Text(
                            'Presiona para obtener ayuda',
                            style:
                                TextStyle(color: Colors.white, fontSize: 14.0),
                          )
                        ],
                      ),
                      onPressed: () {
                        _showHelpOptions(context);
                      },
                      style: TextButton.styleFrom(
                        primary: const Color(0xFF235483),
                        minimumSize: const Size(300.0, 50.0),
                        textStyle: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    top: 460,
                    left: startSesionTextLeftDistance,
                  ),
                  isUS
                      ? Positioned(
                          child: TextButton(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Image.asset(
                                      'images/logos/cooperative_logo_500x500.png'),
                                  width: 40.0,
                                  height: 40.0,
                                  margin: const EdgeInsets.only(
                                      top: 25.0, bottom: 10.0),
                                ),
                                const Text(
                                  'Presiona para ver listado de cooperativas',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14.0),
                                )
                              ],
                            ),
                            onPressed: () {
                              _openCoopUrl();
                            },
                            style: TextButton.styleFrom(
                              primary: const Color(0xFF235483),
                              minimumSize: const Size(300.0, 50.0),
                              textStyle: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          top: 525,
                          left: startSesionTextLeftDistance,
                        )
                      : const SizedBox(
                          height: 0.01,
                        ),
                  isUS
                      ? Positioned(
                          child: Container(
                            child: const Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Powered by GPS PAY WALLET',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: const Color(0xFFAFBECC),
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            padding: const EdgeInsets.all(10.0),
                            width: 300,
                            height: 50,
                          ),
                          bottom: powerByBottomDistance,
                          left: startSesionTextLeftDistance,
                        )
                      : const Text(''),
                  isGT
                      ? Positioned(
                          child: Container(
                            child: const Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Powered by YPayme',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: const Color(0xFFAFBECC),
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            padding: const EdgeInsets.all(10.0),
                            width: 300,
                            height: 50,
                          ),
                          bottom: powerByBottomDistance,
                          left: startSesionTextLeftDistance,
                        )
                      : const Text(''),
                ],
              ),
            ),
            height: screenHeight,
            width: screenWidth,
          ),
        ),
        onWillPop: () async => true);
  }
}
