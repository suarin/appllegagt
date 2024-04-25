import 'package:appllegagt/models/general/authorization_response.dart';
import 'package:appllegagt/services/general_services.dart';
import 'package:appllegagt/services/system_errors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VisaRequestForm extends StatefulWidget {
  const VisaRequestForm({Key? key}) : super(key: key);

  @override
  _VisaRequestFormState createState() => _VisaRequestFormState();
}

class _VisaRequestFormState extends State<VisaRequestForm>
    with WidgetsBindingObserver {
  //Variables
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldStateKey = GlobalKey<ScaffoldState>();
  final _passwordController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _provinceController = TextEditingController();
  final _zipController = TextEditingController();
  final _phoneController = TextEditingController();
  var screenWidth, screenHeight;
  bool isProcessing = false;
  AuthorizationResponse authorizationResponse = AuthorizationResponse();

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
                                'No Autorizacion',
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
      _phoneController.text = '';
      _zipController.text = '';
      _provinceController.text = '';
      _cityController.text = '';
      _addressController.text = '';
      _passwordController.text = '';
    });
  }

  //Execute registration
  _executeTransaction(BuildContext context) async {
    setState(() {
      isProcessing = true;
    });
    await GeneralServices.getVisaRequest(
            _passwordController.text,
            _addressController.text,
            _cityController.text,
            _provinceController.text,
            _zipController.text,
            _phoneController.text)
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

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitar tarjeta Visa'),
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
                          child: const Text('A donde se envía tarjeta'),
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
                              hintText: 'Direccion *',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo obligatorio';
                              }
                            },
                            controller: _addressController,
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
                              hintText: 'Ciudad *',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo obligatorio';
                              }
                            },
                            controller: _cityController,
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
                              hintText: 'Provincia *',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo obligatorio';
                              }
                            },
                            controller: _provinceController,
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
                              hintText: 'Codigo Postal *',
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo obligatorio';
                              }
                            },
                            controller: _zipController,
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
                              hintText: 'Telefono *',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo obligatorio';
                              }
                            },
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
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
                              hintText: 'Web Pin *',
                            ),
                            obscureText: true,
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
                                if (_formKey.currentState!.validate()) {
                                  _executeTransaction(context);
                                }
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
