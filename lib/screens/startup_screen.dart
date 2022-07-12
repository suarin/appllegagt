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

class _StartupScreenState extends State<StartupScreen>  with WidgetsBindingObserver {
  //Variables to store Screen dimensions
  var screenSize, screenHeight, screenWidth, logoLeftDistance, startSesionText, startSesionTextLeftDistance, powerByBottomDistance;
  bool isGT = false;
  bool isUS = false;
  double showOptionHeight = 200.0;

  _openURL() async {
    var url = 'https://wa.me/50222214775';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _call() async {
    var url = 'tel:7864754440';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _openEmail() async {
    launch(
        "mailto:info@llegagt.com?subject=Ayuda Email&body=");
  }

  _showHelpOptions(BuildContext context){

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
                IconButton(onPressed: (){
                  _openEmail();
                }, icon: const Icon(Icons.attach_email)),
                IconButton(onPressed: (){
                  _openURL();
                }, icon:  SizedBox(
                  child: Image.asset('images/icons/whatsapp_logo.png'),
                  height: 75.0,
                  width: 75.0,
                )),
                isUS ? IconButton(onPressed: (){
                  _call();
                }, icon: const Icon(Icons.phone)): const SizedBox(height: 1.0,),
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
    String countryScope =  prefs.getString('countryScope')!;
    if(countryScope=='GT'){
      setState(() {
        isGT = true;
        showOptionHeight = 200.0;
      });
    }

    if(countryScope=='US'){
      setState(() {
        isUS = true;
        showOptionHeight = 250.0;
      });
    }
  }

  @override
  void initState(){
    _getCountryScope();
    super.initState();
  }
  Widget build(BuildContext context) {
    // getting the size of the device windows
    screenSize = MediaQuery.of(context).size;
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    logoLeftDistance = (screenWidth - 300)/2;
    startSesionTextLeftDistance =  (screenWidth - 300 )/2;
    powerByBottomDistance = screenHeight -  (screenHeight- 10);

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
                    onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=> const LoginScreen())
                      );
                    },
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: const Color(0xFF0e325f),
                      minimumSize: const Size(300.0,50.0),
                      textStyle: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  top: 300,
                  left:  startSesionTextLeftDistance,
                ),
                Positioned(
                  child: TextButton(
                    child: const Text('Crear Cuenta'),
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)=> const RegistrationForm())
                      );
                    },
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: const Color(0xFF0e325f),
                      minimumSize: const Size(300.0,50.0),
                      textStyle: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  top: 360,
                  left: startSesionTextLeftDistance,
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
                          margin: const EdgeInsets.only(top: 25.0,bottom: 10.0),
                        ),
                        const Text(
                            'Presiona para obtener ayuda',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0
                          ),
                        )
                      ],
                    ),
                    onPressed: (){
                      _showHelpOptions(context);
                    },
                    style: TextButton.styleFrom(
                      primary: const Color(0xFF235483),
                      minimumSize: const Size(300.0,50.0),
                      textStyle: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  top: 410,
                  left: startSesionTextLeftDistance,
                ),
                isUS ? Positioned(
                  child: Container(
                    child: const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Powered by GPay',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color:  const Color(0xFFAFBECC),
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(10))
                    ),
                    padding: const EdgeInsets.all(10.0),
                    width: 300,
                    height: 50,
                  ),
                  bottom: powerByBottomDistance,
                  left: startSesionTextLeftDistance,
                ): const Text(''),
                isGT ? Positioned(
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
                          color:  const Color(0xFFAFBECC),
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(10))
                    ),
                    padding: const EdgeInsets.all(10.0),
                    width: 300,
                    height: 50,
                  ),
                  bottom: powerByBottomDistance,
                  left: startSesionTextLeftDistance,
                ): const Text(''),
              ],
            ),
          ),
          height: screenHeight,
          width:  screenWidth,
        ),
      ),
      onWillPop: () async => true
    );
  }
}
