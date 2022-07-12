import 'package:appllegagt/screens/startup_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectCountryScreen extends StatefulWidget {
  const SelectCountryScreen({Key? key}) : super(key: key);

  @override
  _SelectCountryScreenState createState() => _SelectCountryScreenState();
}

class _SelectCountryScreenState extends State<SelectCountryScreen> {

  _saveCountryScope(String merchantScope, String tokenScope, String baseUrlScope, String countryScope) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('merchantId', merchantScope);
    await prefs.setString('token',tokenScope);
    await prefs.setString('baseUrl',baseUrlScope);
    await prefs.setString('countryScope',countryScope);
  }

  _setCountryScope(String countrySelected) async{
    if(countrySelected == 'GT'){
      await _saveCountryScope('GT_MERCHANT_ID', 'GT_MERCHANT_TOKEN','GT_BASE_URL','GT');
    }
    if(countrySelected == 'US'){
      await _saveCountryScope('US_MERCHANT_ID', 'US_MERCHANT_TOKEN','US_BASE_URL','US');
    }
  }
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFF0E2238),
      body: Stack(
        children: [
          Positioned(
            child: Column(
              children: [
                SizedBox(
                  child: Image.asset('images/llega_logo_blanco_1024x1024.png'),
                  height: 200,
                  width: 175,
                ),
                Container(
                  child: const Text(
                    'Seleccione País',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20
                    ),
                  ),
                  margin: const EdgeInsets.only(bottom: 20.0),
                ),
                SizedBox(
                  child: IconButton(
                    icon: Image.asset('images/guatemala_flag.jpg'),
                    onPressed: () async{
                      await _setCountryScope('GT');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context)=>const StartupScreen(),
                          )
                      );
                    },
                  ),
                  height: 75,
                  width: 175,
                ),
                SizedBox(
                  child: IconButton(
                    icon: Image.asset('images/usa_flag.png'),
                    onPressed: ()async{
                      await _setCountryScope('US');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context)=>const StartupScreen(),
                          )
                      );
                    },
                  ),
                  height: 75,
                  width: 175,
                )
              ],
            ),
            top: screenHeight / 6,
            left: (screenWidth - 175)/2,
          ),
        ],
      )
    );
  }
}
