import 'package:appllegagt/models/general/login_success_response.dart';
import 'package:appllegagt/screens/customer_access_form.dart';
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
  var screenSize,
      screenHeight,
      screenWidth,
      logoLeftDistance,
      startSesionText,
      startSesionTextLeftDistance,
      powerByBottomDistance,
      startSesionLabelLeftDistance;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldStateKey = GlobalKey<ScaffoldState>();
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();
  String userID = '';
  bool isProcessing = false;
  bool isGT = false;
  bool isUS = false;
  bool _submitted = false;

  //Load Country Scope
  _getCountryScope() async {
    final prefs = await SharedPreferences.getInstance();
    String countryScope = prefs.getString('countryScope')!;
    if (countryScope == 'GT') {
      setState(() {
        isGT = true;
      });
    }

    if (countryScope == 'US') {
      setState(() {
        isUS = true;
      });
    }
  }

  //functions for dialogs
  _showErrorResponse(BuildContext context, String errorMessage) {
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
                  child: Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.white),
                  ),
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
  _checkResponse(BuildContext context, dynamic json) async {
    if (json['ErrorCode'] == 0) {
      LoginSuccessResponse loginSuccessResponse =
      LoginSuccessResponse.fromJson(json);
      final prefs = await SharedPreferences.getInstance();

      await prefs.setInt('cHolderID', loginSuccessResponse.cHolderID!);
      await prefs.setString('userID', userID);
      await prefs.setString('userName', loginSuccessResponse.userName!);
      await prefs.setString('cardNo', loginSuccessResponse.cardNo!);
      await prefs.setString('currency', loginSuccessResponse.currency!);
      await prefs.setString('balance', loginSuccessResponse.balance!);
      await prefs.setBool('isScanning', false);

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const PrincipalScreen()));
    } else {
      String errorMessage =
      await SystemErrors.getSystemError(json['ErrorCode']);
      _showErrorResponse(context, errorMessage);
    }
  }

  //reset form
  _resetForm() {
    setState(() {
      isProcessing = false;
      _userController.text = '';
      _passwordController.text = '';
    });
  }

  //Execute registration
  // Update the _executeTransaction method to set _submitted flag and validate the form
  Future<void> _executeTransaction(BuildContext context) async {
    // Set _submitted to true to trigger validation for all fields
    setState(() {
      _submitted = true;
    });

    if (_formKey.currentState!.validate()) {
      // Form is valid, proceed with the transaction
      setState(() {
        isProcessing = true;
        userID = _userController.text;
      });
      try {
        var response = await GeneralServices.getLogin(
            _userController.text, _passwordController.text);
        if (response['ErrorCode'] != null) {
          _checkResponse(context, response);
        }
      } catch (error) {
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
      } finally {
        // Reset the form and processing state
        _resetForm();
      }
    }
  }




  @override
  void initState() {
    _getCountryScope();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // getting the size of the device windows
    screenSize = MediaQuery.of(context).size;
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    logoLeftDistance = (screenWidth - 300) / 2;
    startSesionTextLeftDistance = (screenWidth - 300) / 2;
    powerByBottomDistance = screenHeight - 80;
    startSesionLabelLeftDistance = (screenWidth - 120) / 2;

    return WillPopScope(
        child: Scaffold(
          backgroundColor: const Color(0xFF42A5F5),
          key: scaffoldStateKey,
          body: Builder(
            builder: (context) => Form(
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
                        left: startSesionLabelLeftDistance,
                      ),
                      Positioned(
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.all(Radius.circular(10))),
                          child: TextFormField(
                              decoration: const InputDecoration(
                                hintText: 'No. Celular *',
                                border: InputBorder.none,
                              ),
                              keyboardType: TextInputType.phone,
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontSize: 24.0,
                              ),
                              validator: (value) {
                                if (_submitted && (value == null || value.isEmpty)) {
                                  return 'Campo obligatorio';
                                }
                                if (_submitted && (value?.length ?? 0) < 8) {
                                  return 'Mínimo 8 caracteres';
                                }
                                if (_submitted && (value?.length ?? 0) > 10) {
                                  return 'Máximo 10 caracteres';
                                }
                                return null; // Return null if validation succeeds
                              },
                              controller: _userController
                              ),
                          padding: const EdgeInsets.all(5),
                          width: 300,
                          height: 50,
                        ),
                        top: 290,
                        left: startSesionTextLeftDistance,
                      ),
                      Positioned(
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.all(Radius.circular(10))),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              hintText: 'PIN de Acceso *',
                              border: InputBorder.none,
                            ),
                            keyboardType: TextInputType.phone,
                            obscureText: true,
                            textAlign: TextAlign.start,
                            style: const TextStyle(fontSize: 24.0),
                            validator: (value) {
                              if (_submitted && (value == null || value.isEmpty)) {
                                return 'Campo obligatorio';
                              }
                              if (_submitted && (value?.length ?? 0) < 4) {
                                return 'Mínimo 4 caracteres';
                              }
                              if (_submitted && (value?.length ?? 0) > 4) {
                                return 'Máximo 4 caracteres';
                              }
                              return null; // Return null if validation succeeds
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
                            onPressed: () {
                              _executeTransaction(context);
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              backgroundColor: const Color(0xFF4F81BD),
                              minimumSize: const Size(300.0, 50.0),
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
                        child: TextButton(
                          child: const Text('Recuperar acceso'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                const CustomerAccessForm(),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            backgroundColor: const Color(0xFF4F81BD),
                            minimumSize: const Size(300.0, 50.0),
                            textStyle: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        top: 510,
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
                            decoration: const BoxDecoration(color: Colors.grey),
                            height: 50.0,
                            width: screenWidth,
                            padding: const EdgeInsets.all(10.0),
                          ),
                          visible: isProcessing,
                        ),
                        top: screenHeight - 130.0,
                      ),
                      isUS
                          ? Positioned(
                            child: Container(
                              child: const Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Powered by GPS PAY WALLET',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: const Color(0xFFAFBECC),
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              padding: const EdgeInsets.all(10.0),
                              width: 300,
                              height: 50,
                            ),
                            top: powerByBottomDistance,
                            left: startSesionTextLeftDistance,
                          )
                          : const Text(''),
                      isGT
                          ? Positioned(
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
                                    color: const Color(0xFFAFBECC),
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              padding: const EdgeInsets.all(10.0),
                              width: 300,
                              height: 50,
                            ),
                        top: powerByBottomDistance,
                        left: startSesionTextLeftDistance,
                      )
                          : const Text(''),
                    ],
                  ),
                ),
                height: screenHeight,
                width: screenWidth,
              ),
            ),
          ),
        ),
        onWillPop: () async => true);
  }
}
