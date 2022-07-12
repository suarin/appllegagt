import 'package:appllegagt/models/general/login_success_response.dart';
import 'package:appllegagt/models/general/visa_card.dart';
import 'package:appllegagt/models/general/visa_cards_response.dart';
import 'package:appllegagt/models/recharge/card_load_cash_response.dart';
import 'package:appllegagt/services/general_services.dart';
import 'package:appllegagt/services/qr_scanner.dart';
import 'package:appllegagt/services/recharge_services.dart';
import 'package:appllegagt/services/system_errors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class CardLoadCashForm extends StatefulWidget {
  const CardLoadCashForm({Key? key}) : super(key: key);

  @override
  _CardLoadCashFormState createState() => _CardLoadCashFormState();
}

class _CardLoadCashFormState extends State<CardLoadCashForm>  with WidgetsBindingObserver{

  //Variables
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldStateKey = GlobalKey<ScaffoldState>();
  final _merchantController = TextEditingController();
  final _passwordController = TextEditingController();
  final _mobileController = TextEditingController();
  final _amountController = TextEditingController();
  final _virtualCardController = TextEditingController();
  VisaCard? selectedVisaCard;
  VisaCardsResponse? visaCardsResponse;
  bool isProcessing = false;
  bool visaCardsLoaded = false;
  CardLoadCashResponse cardLoadCashResponse = CardLoadCashResponse();
  var screenWidth, screenHeight;

  //function to Scan QR
  _scanQR(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isScanning',true);
    await QRScanner.scanQR().then((result) => {
    setState(() {
      _merchantController.text = result.toString();
    }),
    });

  }

  //Get user data
  _getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    LoginSuccessResponse  loginSuccessResponse = LoginSuccessResponse(
        errorCode: 0,
        cHolderID: prefs.getInt('cHolderID'),
        userName: prefs.getString('userName'),
        cardNo: prefs.getString('cardNo'),
        currency: prefs.getString('currency'),
        balance: prefs.getString('balance')
    );
    setState(() {
      _virtualCardController.text = loginSuccessResponse.cardNo.toString();
    });
  }
  //function to obtain Visa Cards for picker
  _getVirtualCards() async {
    await GeneralServices.getVirtualCards().then((list) => {
      setState(() {
        visaCardsResponse = VisaCardsResponse.fromJson(list);
        visaCardsLoaded = true;
      })
    });
  }

  //functions for dialogs
  _showSuccessResponse(BuildContext context, CardLoadCashResponse cardLoadCashResponse){

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
                                'Balance',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              width: 150,
                            ),
                            SizedBox(
                              child: Text(
                                'USD ${cardLoadCashResponse.balance.toString()}'
                              ),
                              width: 150,
                            ),
                          ],
                        ),
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
                              child: Text(
                                  'USD ${cardLoadCashResponse.authno.toString()}'
                              ),
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

      CardLoadCashResponse  cardLoadCashResponse = CardLoadCashResponse.fromJson(json);
      _showSuccessResponse(context, cardLoadCashResponse);

    } else{
      String errorMessage = await SystemErrors.getSystemError(json['ErrorCode']);
      _showErrorResponse(context, errorMessage);
    }
  }

  //Reset form
  _resetForm(){
    setState(() {
      isProcessing = false;
      _mobileController.text='';
      _merchantController.text ='';
      _passwordController.text = '';
      _amountController.text ='';
      _virtualCardController.text ='';
    });
  }

  //Execute registration
  _executeTransaction(BuildContext context) async {
    setState(() {
      isProcessing = true;
    });
    await RechargeServices.getCardLoadCash(_merchantController.text,_passwordController.text,_virtualCardController.text,_mobileController.text, _amountController.text)
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
    _getVirtualCards();
    _getUserData();
    super.initState();
  }
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recarga con QR'),
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
                          child: Row(
                            children: [
                              SizedBox(
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Comercio *',
                                    errorStyle: TextStyle(
                                      fontSize: 8,
                                    ),
                                  ),
                                  keyboardType: TextInputType.phone,
                                  validator: (value){
                                    if(value == null || value.isEmpty){
                                      return 'Campo obligatorio';
                                    }
                                  },
                                  controller: _merchantController,
                                ),
                                width: 250,
                              ),
                              SizedBox(
                                child: IconButton(
                                  icon: Image.asset('images/icons/qr_scan_icon.png'),
                                  onPressed: (){
                                    _scanQR(context);
                                  },
                                ),
                                width: 50,
                                height: 50,
                              )
                            ],
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
                              hintText: 'Cuenta GPS *',
                              errorStyle: TextStyle(
                                fontSize: 8,
                              ),
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value){
                              if(value == null || value.isEmpty){
                                return 'Campo obligatorio';
                              }
                            },
                            controller: _virtualCardController,
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
                              hintText: 'Solicitar contraseña a comercio *',
                              errorStyle: TextStyle(
                                fontSize: 8,
                              ),
                            ),
                            obscureText: true,
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
                        Container(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Telefono *',
                              errorStyle: TextStyle(
                                fontSize: 8,
                              ),
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value){
                              if(value == null || value.isEmpty){
                                return 'Campo obligatorio';
                              }
                            },
                            controller: _mobileController,
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
                              hintText: 'Monto *',
                              errorStyle: TextStyle(
                                fontSize: 8,
                              ),
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
                        Visibility(
                          child:  Container(
                            child: TextButton(
                              child: const Text(
                                'Solicitar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                              onPressed: () {
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
