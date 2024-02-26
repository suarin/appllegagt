import 'package:appllegagt/models/recharge/zelle_info_response.dart';
import 'package:appllegagt/screens/recharge/bank_deposit_form.dart';
import 'package:appllegagt/services/recharge_services.dart';
import 'package:flutter/material.dart';

class ZelleAlert extends StatefulWidget {
  @override
  _ZelleAlertState createState() => _ZelleAlertState();
}

class _ZelleAlertState extends State<ZelleAlert> {
  ZelleInfoResponse? zelleInfoResponse;
  bool infoLoaded = false;
  //function to get Zelle Info fo the Alert
  _loadZelleInfo() async {
    await RechargeServices.getZelleInfo().then((info) => {
          setState(() {
            zelleInfoResponse = ZelleInfoResponse.fromJson(info);
            infoLoaded = true;
          }),
        });
  }

  @override
  void initState() {
    _loadZelleInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(10.0),
          height: 300.0,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
              shape: BoxShape.rectangle,
              color: Color(0XFFFDFDF5)),
          child: ListTile(
            title: const Text(
              'INFORMACIÓN PARA REALIZAR LA TRANSFERENCIA ZELLE',
            ),
            subtitle: Column(
              children: [
                const SizedBox(
                  height: 10.0,
                ),
                const Text(
                    'Antes de realizar una Transferencia Zelle para recargas tu cuenta GPS revisa cuidadosamente la siguiente información:'),
                const SizedBox(
                  height: 5.0,
                ),
                Text(
                  'Correo: ${infoLoaded ? zelleInfoResponse!.zelleEmail : "Sin dato"}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Text(
                  'A Nombre De: ${infoLoaded ? zelleInfoResponse!.companyName : "Sin dato"}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                const Text(
                  'OBLIGATORIO: PONER EN REFERENCIA *GPS',
                  style: TextStyle(color: Colors.redAccent),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Visibility(
                  visible: infoLoaded,
                  child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        color: Colors.lightBlueAccent),
                    child: TextButton(
                      child: const Text(
                        'Cerrar',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const BankDepositForm()));
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
