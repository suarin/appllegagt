import 'package:appllegagt/screens/recharge/paysafecash_web_view.dart';
import 'package:appllegagt/services/recharge_services.dart';
import 'package:appllegagt/services/system_errors.dart';
import 'package:flutter/material.dart';

class CardLoadPaySafeForm extends StatefulWidget {
  const CardLoadPaySafeForm({Key? key}) : super(key: key);

  @override
  _CardLoadPaySafeFormState createState() => _CardLoadPaySafeFormState();
}

class _CardLoadPaySafeFormState extends State<CardLoadPaySafeForm> with WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldStateKey = GlobalKey<ScaffoldState>();
  final _amountController = TextEditingController();
  bool isProcessing = false;
  String paySafeUrl= '';
  var screenWidth, screenHeight;

//functions for dialogs
  _showErrorResponse(BuildContext context, String errorMessage){
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.red,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: Text(errorMessage, style: const TextStyle(color: Colors.white),),
                  margin: const EdgeInsets.only(left: 40.0),
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

  //Check response
  _checkResponse(BuildContext context, String json) async{
    if(json.contains('https://customer.cc.at.paysafecard.com/rest/payment/panel?')){

      const start = "https://customer.cc.at.paysafecard.com/rest/payment/panel?";

      final startIndex = json.indexOf(start);
      paySafeUrl = json.substring(startIndex, json.length);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaySafeCashWebView(paySafeUrl: paySafeUrl)
        ),
      );
    } else{
      String errorMessage = await SystemErrors.getSystemError(0);
      _showErrorResponse(context, errorMessage);
    }
  }

  //Reset form
  _resetForm(){
    setState(() {
      isProcessing = false;
      _amountController.text ='';
    });
  }

  //Execute registration
  _executeTransaction(BuildContext context) async {
    setState(() {
      isProcessing = true;
    });
    await RechargeServices.getLoadPaySafe(_amountController.text)
        .then((response) => {
      if(response.contains('https://customer.cc.at.paysafecard.com/rest/payment/panel?')){
        _checkResponse(context, response),
      }
    }).catchError((error){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.toString(),
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
      _resetForm();
    });
    _resetForm();
  }

  @override
  void initState() {
    super.initState();
  }
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recarga PaySafe'),
        backgroundColor: const Color(0XFF0E325F),
      ),
      backgroundColor: const Color(0XFFAFBECC),
      key: scaffoldStateKey,
      body: Builder(
        builder: (context) => Form(
          key: _formKey,
          child: SizedBox(
            child: SafeArea(
              child: Container(
                child: Stack(
                  children: [
                    ListView(
                      children: [
                        Container(
                          child: TextFormField(
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Monto *',
                                errorStyle: TextStyle(
                                  fontSize: 8,
                                )
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value){
                              if(value == null || value.isEmpty){
                                return 'Campo obligatorio';
                              }
                            },
                            controller: _amountController,
                          ),
                          decoration: const BoxDecoration(
                            color: Color(0XFFEFEFEF),
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                          height: 50.0,
                          margin: const EdgeInsets.only(bottom: 5.0, top: 10.0),
                          padding: const EdgeInsets.only(left: 10.0),
                        ),
                       Visibility(
                         child:  Container(
                           child: TextButton(
                             child: const Text(
                               'Recargar',
                               style: TextStyle(
                                 color: Colors.white,
                                 fontSize: 20.0,
                               ),
                             ),
                             onPressed: () {
                               _executeTransaction(context);
                             },
                           ),
                           decoration: const BoxDecoration(
                             color: Color(0XFF0E325F),
                             borderRadius: BorderRadius.all(Radius.circular(10.0)),
                           ),
                           width: screenWidth,
                           margin: const EdgeInsets.only(bottom: 5.0),
                         ),
                         visible: !isProcessing,
                       ),
                      ],
                    ),
                    Positioned(
                      child: Visibility(
                        child: Container(
                          child: const Text(
                            'Procesando...',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          decoration: const BoxDecoration(
                              color: Colors.grey
                          ),
                          height: 50.0,
                          width: screenWidth,
                          padding: const EdgeInsets.all(10.0),
                        ),
                        visible: isProcessing,
                      ),
                      top: screenHeight - 180.0,
                    ),
                  ],
                ),
                margin: const EdgeInsets.only(top: 10.0),
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              ),
            ),
            height: screenHeight,
            width: screenWidth,
          ),
        ),
      ),
    );
  }
}

