import 'package:flutter/material.dart';

class InternationalTransferForm extends StatefulWidget {
  const InternationalTransferForm({Key? key}) : super(key: key);

  @override
  _InternationalTransferFormState createState() => _InternationalTransferFormState();
}

class _InternationalTransferFormState extends State<InternationalTransferForm> with WidgetsBindingObserver {

  var screenWidth, screenHeight;

  @override
  Widget build(BuildContext context) {

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transferencia a cuenta \n Llega Internacional'),
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
                      hintText: 'Número de tarjeta destino',
                    ),
                    keyboardType: TextInputType.phone,
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
                  child: const TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Monto',
                    ),
                    keyboardType: TextInputType.phone,
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
                  child: const TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Nota',
                    ),
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
                  child: const TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Código de seguridad de la cuenta',
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
                      'Transferir',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    onPressed: (){},
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
