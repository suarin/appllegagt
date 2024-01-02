import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QrRequestForm extends StatefulWidget {
  const QrRequestForm({Key? key}) : super(key: key);

  @override
  _QrRequestFormState createState() => _QrRequestFormState();
}

class _QrRequestFormState extends State<QrRequestForm>
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
        title: const Text('Solicitar QR'),
        backgroundColor: const Color(0XFF0E325F),
      ),
      backgroundColor: const Color(0XFFAFBECC),
      body: SizedBox(
        child: SafeArea(
          child: Container(
            child: ListView(
              children: [
                Container(
                  child: const TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Web Pin',
                    ),
                    obscureText: true,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0XFFEFEFEF),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  height: 40.0,
                  margin: const EdgeInsets.only(bottom: 5.0),
                  padding: const EdgeInsets.only(left: 10.0),
                ),
                Container(
                  child: TextButton(
                    child: const Text(
                      'Solicitar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    onPressed: () {},
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0XFF0E325F),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  width: screenWidth,
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
