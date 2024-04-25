import 'package:appllegagt/services/system_errors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:appllegagt/models/general/authorization_response.dart';
import 'package:appllegagt/services/recharge_services.dart';


class PaypalTransferForm extends StatefulWidget {
  const PaypalTransferForm({Key? key}) : super(key: key);

  @override
  _PaypalTransferFormState createState() => _PaypalTransferFormState();
}

class _PaypalTransferFormState extends State<PaypalTransferForm> {
  //Variables
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldStateKey = GlobalKey<ScaffoldState>();
  final _amountController = TextEditingController();
  final _referenceController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isProcessing = false;
  AuthorizationResponse? authorizationResponse;
  bool isGT = false;
  bool isUS = false;
  var screenWidth, screenHeight;

  //functions for dialogs
  _showSuccessResponse(
      BuildContext context, AuthorizationResponse authorizationResponse) {
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
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              width: 150,
                            ),
                            SizedBox(
                              child:
                                  Text(authorizationResponse.authNo.toString()),
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
  _checkResponse(BuildContext context, dynamic json) async {
    if (json['ErrorCode'] == 0) {
      AuthorizationResponse authorizationResponse =
      AuthorizationResponse.fromJson(json);
      _showSuccessResponse(context, authorizationResponse);
    } else {
      String errorMessage =
          await SystemErrors.getSystemError(json['ErrorCode']);
      _showErrorResponse(context, errorMessage);
    }
  }

  //Reset form
  _resetForm() {
    setState(() {
      isProcessing = false;
      _referenceController.text = '';
      _amountController.text = '';
      _passwordController.text = '';
    });
  }

  //Execute registration
  _executeTransaction(BuildContext context) async {
    setState(() {
      isProcessing = true;
    });

    try {
      final response = await RechargeServices.getLoadPayPal(
          _passwordController.text,
          _amountController.text,
          _referenceController.text);

      // Check if response is a Map
      if (response is Map<String, dynamic>) {
        if (response.containsKey('ErrorCode')) {
          _checkResponse(context, response);
        } else {
          _showErrorResponse(context, 'Invalid response format');
        }
      } else {
        _showErrorResponse(context, 'Invalid response format');
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
      _resetForm();
    }

    _resetForm();
  }


  _setLastPage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastPage', 'principalScreen');
  }

  @override
  void initState() {
    _setLastPage();
    super.initState();
  }

  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recarga PayPal'),
        backgroundColor: const Color(0XFF0E325F),
      ),
      backgroundColor: const Color(0XFFAFBECC),
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
                          decoration: BoxDecoration(
                            color: Color(0XFFEFEFEF),
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                          height: 50.0,
                          margin: const EdgeInsets.only(bottom: 1.0),
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            'Para hacer la solicitud debe haber realizado su Transferencia en PayPal',
                            style: TextStyle(
                              fontSize: 18.0, // Adjust the font size as desired
                              color: Colors.redAccent, // Adjust the text color
                              fontFamily: 'Calibri', // Specify the desired font family
                              fontWeight: FontWeight.bold, // Add bold style
                            ),
                          ),
                        ),
                        Container(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Referencia PayPal *',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo obligatorio *';
                              }
                            },
                            controller: _referenceController,
                          ),
                          decoration: const BoxDecoration(
                            color: Color(0XFFEFEFEF),
                            borderRadius:
                            BorderRadius.all(Radius.circular(10.0)),
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
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo obligatorio';
                              }
                            },
                            controller: _amountController,
                          ),
                          decoration: const BoxDecoration(
                            color: Color(0XFFEFEFEF),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          height: 50.0,
                          margin: const EdgeInsets.only(bottom: 5.0),
                          padding: const EdgeInsets.only(left: 10.0),
                        ),
                        Container(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'PIN WEB *',
                            ),
                            keyboardType: TextInputType.phone,
                            obscureText: true,
                            inputFormatters: [LengthLimitingTextInputFormatter(4)],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo obligatorio';
                              }
                            },
                            controller: _passwordController,
                          ),
                          decoration: const BoxDecoration(
                            color: Color(0XFFEFEFEF),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          height: 50.0,
                          margin: const EdgeInsets.only(bottom: 5.0),
                          padding: const EdgeInsets.only(left: 10.0),
                        ),
                        Visibility(
                          child: Container(
                            child: TextButton(
                              child: const Text(
                                'Solicitar',
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
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
                          decoration: const BoxDecoration(color: Colors.grey),
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
