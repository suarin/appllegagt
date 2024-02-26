import 'package:appllegagt/models/general/authorization_response.dart';
import 'package:appllegagt/services/recharge_services.dart';
import 'package:appllegagt/services/system_errors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaySafeCodeRequestForm extends StatefulWidget {
  const PaySafeCodeRequestForm({Key? key}) : super(key: key);

  @override
  _PaySafeCodeRequestFormState createState() => _PaySafeCodeRequestFormState();
}

class _PaySafeCodeRequestFormState extends State<PaySafeCodeRequestForm> {
  //Variables
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldStateKey = GlobalKey<ScaffoldState>();
  final _amountController = TextEditingController();
  final _depositTokenController = TextEditingController();
  bool isProcessing = false;
  bool bankLoaded = false;
  bool _amountTextFieldEnabled = false;
  bool _tokenFieldEnabled = false;
  bool _sendButtonEnabled = false;
  bool _processingEnabled = false;
  AuthorizationResponse? authorizationResponse;

  //Load token and amount values
  _loadFormValues() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('paySafeAmount') != null) {
      setState(() {
        _amountController.text = prefs.getString('paySafeAmount').toString();
        _amountTextFieldEnabled = true;
      });
    }

    if (prefs.getString('paySafeToken') != null) {
      setState(() {
        _depositTokenController.text =
            prefs.getString('paySafeToken').toString();
        _tokenFieldEnabled = true;
      });
    }
    if (_amountTextFieldEnabled && _tokenFieldEnabled) {
      setState(() {
        _sendButtonEnabled = true;
      });
    }
  }

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
    _resetForm();
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
  _resetForm() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('paySafeAmount') != null) {
      prefs.remove('paySafeAmount');
      _amountTextFieldEnabled = false;
    }
    if (prefs.getString('paySafeToken') != null) {
      prefs.remove('paySafeToken');
      _tokenFieldEnabled = false;
    }
    setState(() {
      isProcessing = false;
      _depositTokenController.text = '';
      _amountController.text = '';
      _amountTextFieldEnabled = false;
      _tokenFieldEnabled = false;
      _sendButtonEnabled = false;
      _processingEnabled = false;
    });
  }

  //Execute registration
  _executeTransaction(BuildContext context) async {
    setState(() {
      _processingEnabled = true;
      _sendButtonEnabled = false;
    });
    await RechargeServices.getLoadPaySafeCode(
            _amountController.text, _depositTokenController.text)
        .then((response) => {
              if (response['ErrorCode'] != null)
                {
                  _checkResponse(context, response),
                }
            })
        .catchError((error) {
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
  }

  _setLastPage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastPage', 'principalScreen');
  }

  @override
  void initState() {
    _loadFormValues();
    _setLastPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitar \nCódigo PaySafe'),
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
                        Visibility(
                          child: Container(
                            child: const Text('Solicitar código PaySafe'),
                            decoration: const BoxDecoration(
                              color: Color(0XFFEFEFEF),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            height: 50.0,
                            margin: const EdgeInsets.only(bottom: 5.0),
                            padding: const EdgeInsets.only(left: 10.0),
                          ),
                          visible:
                              !_tokenFieldEnabled && !_amountTextFieldEnabled,
                        ),
                        Visibility(
                          child: Container(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Monto *',
                                  errorStyle: TextStyle(
                                    fontSize: 8,
                                  )),
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
                            margin:
                                const EdgeInsets.only(bottom: 5.0, top: 10.0),
                            padding: const EdgeInsets.only(left: 10.0),
                          ),
                          visible: _amountTextFieldEnabled,
                        ),
                        Visibility(
                          child: Container(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Token *',
                                  errorStyle: TextStyle(
                                    fontSize: 8,
                                  )),
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Campo obligatorio';
                                }
                              },
                              controller: _depositTokenController,
                            ),
                            decoration: const BoxDecoration(
                              color: Color(0XFFEFEFEF),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            height: 50.0,
                            margin:
                                const EdgeInsets.only(bottom: 5.0, top: 10.0),
                            padding: const EdgeInsets.only(left: 10.0),
                          ),
                          visible: _tokenFieldEnabled,
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
                            margin: const EdgeInsets.only(bottom: 5.0),
                          ),
                          visible: _sendButtonEnabled,
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
                        visible: _processingEnabled,
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
