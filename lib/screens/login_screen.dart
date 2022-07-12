import 'package:appllegagt/models/general/login_success_response.dart';
import 'package:appllegagt/screens/principal_screen.dart';
import 'package:appllegagt/services/general_services.dart';
import 'package:appllegagt/services/system_errors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  //Variables
  var screenSize, screenHeight, screenWidth, logoLeftDistance, startSesionText, startSesionTextLeftDistance, powerByBottomDistance, startSesionLabelLeftDistance;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldStateKey = GlobalKey<ScaffoldState>();
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();
  String userID = '';
  bool isProcessing = false;
  bool isGT = false;
  bool isUS = false;

  //Load Country Scope
  _getCountryScope() async {
    final prefs = await SharedPreferences.getInstance();
    String countryScope =  prefs.getString('countryScope')!;
    if(countryScope=='GT'){
      setState(() {
        isGT = true;
      });
    }

    if(countryScope=='US'){
      setState(() {
        isUS = true;
      });
    }
  }

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

      LoginSuccessResponse  loginSuccessResponse =  LoginSuccessResponse.fromJson(json);
      final prefs = await SharedPreferences.getInstance();

      await prefs.setInt('cHolderID', loginSuccessResponse.cHolderID!);
      await prefs.setString('userID', userID);
      await prefs.setString('userName', loginSuccessResponse.userName!);
      await prefs.setString('cardNo', loginSuccessResponse.cardNo!);
      await prefs.setString('currency', loginSuccessResponse.currency!);
      await prefs.setString('balance', loginSuccessResponse.balance!);
      await prefs.setBool('isScanning',false);

      Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=> const PrincipalScreen())
      );

    } else{
      String errorMessage = await SystemErrors.getSystemError(json['ErrorCode']);
      _showErrorResponse(context, errorMessage);
    }
  }

  //reset form
  _resetForm(){

    setState(() {
      isProcessing = false;
      _userController.text = '';
      _passwordController.text = '';
    });

  }

  //Execute registration
  _executeTransaction(BuildContext context) async {
    setState(() {
      isProcessing = true;
      userID = _userController.text;
    });
    await GeneralServices.getLogin(_userController.text, _passwordController.text)
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
        ),);
      _resetForm();
    });
    _resetForm();
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
    powerByBottomDistance = screenHeight- 80;
    startSesionLabelLeftDistance = (screenWidth - 120) / 2;

    return WillPopScope(
        child: Scaffold(
          backgroundColor: const Color(0XFF0E325F),
          key: scaffoldStateKey,
          body: Builder(
            builder: (context)=> Form(
              key: _formKey,
              child: SizedBox(
                child: SafeArea(
                  child: Stack(
                    children: [
                      Positioned(
                        child: Image.asset(
                          'images/llega_logo_blanco_1024x1024.png',
                          height: 300,
                          width: 300,
                        ),
                        left: logoLeftDistance,
                      ),
                      Positioned(
                        child: Container(
                          child: const Text(
                            'Iniciar Sesión',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                          width: 150,
                          height: 50,

                        ),
                        top: 230,
                        left:  startSesionLabelLeftDistance,
                      ),
                      Positioned(
                        child:  Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                          child:  TextFormField(
                            decoration: const InputDecoration(
                              hintText: 'Usuario',
                              border: InputBorder.none,
                            ),
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              fontSize: 24.0,
                            ),
                            validator: (value){
                              if(value == null || value.isEmpty){
                                return 'Campo obligatorio';
                              }
                            },
                            controller: _userController,
                          ),
                          padding: const EdgeInsets.all(5),
                          width: 300,
                          height: 50,
                        ),
                        top: 290,
                        left:  startSesionTextLeftDistance,
                      ),
                      Positioned(
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                          child: TextFormField(
                            decoration: const InputDecoration(
                                hintText: 'Contraseña',
                              border: InputBorder.none,
                            ),
                            obscureText: true,
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                fontSize: 24.0
                            ),
                            validator: (value){
                              if(value == null || value.isEmpty){
                                return 'Campo obligatorio';
                              }
                            },
                            controller: _passwordController,
                          ),
                          padding: const EdgeInsets.all(5),
                          width: 300,
                          height: 50,
                        ),
                        top: 350,
                        left: startSesionTextLeftDistance,
                      ),
                      Positioned(
                        child: Visibility(
                          child: TextButton(
                            child: const Text('Ingreso a tu cuenta'),
                            onPressed: (){
                              _executeTransaction(context);
                            },
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              primary: Colors.white,
                              backgroundColor: const Color(0xFF4F81BD),
                              minimumSize: const Size(300.0,50.0),
                              textStyle: const TextStyle(
                                fontSize: 20,
                              ),
                            ),

                          ),
                          visible: !isProcessing,
                        ),
                        top: 450,
                        left: startSesionTextLeftDistance,
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
                        top: screenHeight - 130.0,
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
                        top: powerByBottomDistance,
                        left: startSesionTextLeftDistance,
                      ):const Text(''),
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
                        top: powerByBottomDistance,
                        left: startSesionTextLeftDistance,
                      ):const Text(''),
                    ],
                  ),
                ),
                height: screenHeight,
                width:  screenWidth,
              ),
            ),
          ),
        ),
        onWillPop: () async => true
    );
  }
}
