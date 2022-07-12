import 'dart:convert';
import 'package:appllegagt/models/bank.dart';
import 'package:appllegagt/models/general/authorization_response.dart';
import 'package:appllegagt/services/recharge_services.dart';
import 'package:appllegagt/services/system_errors.dart';
import 'package:flutter/material.dart';

class BankDepositForm extends StatefulWidget {
  const BankDepositForm({Key? key}) : super(key: key);

  @override
  _BankDepositFormState createState() => _BankDepositFormState();
}

class _BankDepositFormState extends State<BankDepositForm> with WidgetsBindingObserver {

  //Variables
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldStateKey = GlobalKey<ScaffoldState>();
  final _passwordController = TextEditingController();
  final _amountController = TextEditingController();
  final _referenceController = TextEditingController();
  bool isProcessing = false;
  bool bankLoaded = false;
  AuthorizationResponse? authorizationResponse;
  Bank? selectedBank;
  List<Bank> banks = <Bank>[];
  var screenWidth, screenHeight;

  //functions for data pickers
  _loadBanks() async{
    String data = await DefaultAssetBundle.of(context).loadString('assets/banks.json');
    final jsonResult =jsonDecode(data);
    setState(() {
      for (int i = 0; i < jsonResult.length; i++) {
        Bank bank = Bank.fromJson(jsonResult[i]);
          banks.add(bank);
      }
      bankLoaded = true;
    });
  }

  //functions for dialogs
  _showSuccessResponse(BuildContext context, AuthorizationResponse authorizationResponse){

    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.greenAccent,
          child: Center(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              child: Text(
                                'Autorizacion',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              width: 150,
                            ),
                            SizedBox(
                              child: Text(authorizationResponse.authNo.toString()),
                              width: 150,
                            ),
                          ],
                        ),
                      ],
                    ),
                    margin: const EdgeInsets.only(left: 40),
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
          ),
        );
      },
    );

  }

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
  _checkResponse(BuildContext context, dynamic json) async{
    if(json['ErrorCode'] == 0){

      AuthorizationResponse  authorizationResponse = AuthorizationResponse.fromJson(json);
      _showSuccessResponse(context, authorizationResponse);

    } else{
      String errorMessage = await SystemErrors.getSystemError(json['ErrorCode']);
      _showErrorResponse(context, errorMessage);
    }
  }

  //Reset form
  _resetForm(){
    setState(() {
      isProcessing = false;
      _referenceController.text ='';
      _amountController.text ='';
      _passwordController.text = '';
    });
  }

  //Execute registration
  _executeTransaction(BuildContext context) async {
    setState(() {
      isProcessing = true;
    });
    await RechargeServices.getLoadBank(_passwordController.text,selectedBank!.bankId.toString(),_amountController.text,_referenceController.text)
        .then((response) => {
      if(response['ErrorCode'] != null){
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
  void initState(){
    _loadBanks();
    super.initState();
  }
  Widget build(BuildContext context) {

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transferencia / Zelle'),
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
                          child: const Text('Cuenta ZELLE a Transferir: pagos@bgipay.me'),
                          decoration: const BoxDecoration(
                            color: Color(0XFFEFEFEF),
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                          height: 50.0,
                          margin: const EdgeInsets.only(bottom: 5.0),
                          padding: const EdgeInsets.only(left: 10.0),
                        ),
                        bankLoaded ? Container(
                          child: DropdownButton<Bank>(
                            hint: const Text('Seleccionar Banco'),
                            value: selectedBank,
                            onChanged: (Bank? value){
                              setState(() {
                                selectedBank = value;
                              });
                            },
                            items: banks.map((Bank bank) {
                              return DropdownMenuItem<Bank>(
                                value: bank,
                                child: Container(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  width: 250,
                                  child: Text(
                                    bank.bankName!,
                                    style: const TextStyle(
                                      fontSize: 20.0,
                                      fontFamily: "NanumGothic Bold",
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          decoration: const BoxDecoration(
                            color: Color(0XFFEFEFEF),
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                          height: 50.0,
                          margin: const EdgeInsets.only(bottom: 5.0),
                          padding: const EdgeInsets.only(left: 10.0),
                          width: 250,
                        ): const Text('No hay Bancos Disponibles'),
                        Container(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Referencia Zelle ',
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value){
                              if(value == null || value.isEmpty){
                                return 'Campo obligatorio';
                              }
                            },
                            controller: _referenceController,
                          ),
                          decoration: const BoxDecoration(
                            color: Color(0XFFEFEFEF),
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                          height: 50.0,
                          margin: const EdgeInsets.only(bottom: 5.0),
                          padding: const EdgeInsets.only(left: 10.0),
                        ),
                        Container(
                          child: TextFormField(
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Monto Transferido'
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
                          margin: const EdgeInsets.only(bottom: 5.0),
                          padding: const EdgeInsets.only(left: 10.0),
                        ),
                        Container(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'PIN WEB',
                            ),
                            validator: (value){
                              if(value == null || value.isEmpty){
                                return 'Campo obligatorio';
                              }
                            },
                            controller: _passwordController,
                          ),
                          decoration: const BoxDecoration(
                            color: Color(0XFFEFEFEF),
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                          height: 50.0,
                          margin: const EdgeInsets.only(bottom: 5.0),
                          padding: const EdgeInsets.only(left: 10.0),
                        ),
                        Visibility(
                          child: Container(
                            child: TextButton(
                              child: const Text(
                                'Recargar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                              onPressed: (){
                                if(_formKey.currentState!.validate()){
                                  _executeTransaction(context);
                                }
                              },
                            ),
                            decoration: const BoxDecoration(
                              color: Color(0XFF0E325F),
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            width: screenWidth,
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
                margin: const EdgeInsets.only(top: 50.0),
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
