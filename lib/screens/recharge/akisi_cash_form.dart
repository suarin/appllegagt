import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AkisiCashForm extends StatefulWidget {
  const AkisiCashForm({Key? key}) : super(key: key);

  @override
  _AkisiCashFormState createState() => _AkisiCashFormState();
}

class _AkisiCashFormState extends State<AkisiCashForm>
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
        title: const Text('Efectivo en Akisi'),
        backgroundColor: const Color(0XFF0E325F),
      ),
      backgroundColor: const Color(0XFFAFBECC),
      body: SizedBox(
        child: SafeArea(
          child: Container(
            child: ListView(
              children: [
                Container(
                  child: const Text(
                    'Acuda a un comercio de Akisi, diga al cajero que quiere recargar su cuenta Llega, dele su número de teléfono, y pague el valor de la recarga',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 24.0,
                    ),
                  ),
                  height: 200.0,
                  margin: const EdgeInsets.only(bottom: 5.0),
                  padding: const EdgeInsets.only(left: 10.0),
                ),
              ],
            ),
            margin: const EdgeInsets.only(top: 50.0),
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          ),
        ),
        height: screenHeight,
        width: screenWidth,
      ),
    );
  }
}
