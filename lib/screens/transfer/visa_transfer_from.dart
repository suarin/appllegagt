import 'package:appllegagt/models/general/authorization_response.dart';
import 'package:appllegagt/models/general/visa_card.dart';
import 'package:appllegagt/models/general/visa_cards_response.dart';
import 'package:appllegagt/services/general_services.dart';
import 'package:appllegagt/services/system_errors.dart';
import 'package:appllegagt/services/transfer_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VisaTransferFrom extends StatefulWidget {
  const VisaTransferFrom({Key? key}) : super(key: key);

  @override
  _VisaTransferFromState createState() => _VisaTransferFromState();
}

class _VisaTransferFromState extends State<VisaTransferFrom>
    with WidgetsBindingObserver {
  //Variables
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldStateKey = GlobalKey<ScaffoldState>();
  final _passwordController = TextEditingController();
  final _amountController = TextEditingController();
  final _visaCardController = TextEditingController();
  var screenWidth, screenHeight;
  bool isProcessing = false;
  AuthorizationResponse authorizationResponse = AuthorizationResponse();
  VisaCardsResponse? cards;
  VisaCard? selectedVisaCard;
  bool visaCardsLoaded = false;
  bool _termsAndConditionsAccepted = false;

  //function to obtain Visa Cards for picker
  _getVisaCards() async {
    await GeneralServices.getVisaCards().then((list) => {
          setState(() {
            cards = VisaCardsResponse.fromJson(list);
            visaCardsLoaded = true;
          })
        });
  }

  // Function to toggle the acceptance of terms and conditions
  void _toggleTermsAndConditions(bool? newValue) {
    if(newValue != null) {
      setState(() {
        _termsAndConditionsAccepted = newValue;
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
    try {
      if (json['ErrorCode'] == 0) {
        AuthorizationResponse authorizationResponse =
            AuthorizationResponse.fromJson(json);
        _showSuccessResponse(context, authorizationResponse);
      } else {
        String errorMessage =
            await SystemErrors.getSystemError(json['ErrorCode']);
        _showErrorResponse(context, errorMessage);
      }
    } catch (e) {
      _showErrorResponse(context, e.toString());
    }
  }

  //Reset From
  _resetForm() {
    setState(() {
      isProcessing = false;
      _passwordController.text = '';
      _amountController.text = '';
      _visaCardController.text = '';
    });
  }

  //Execute registration
  _executeTransaction(BuildContext context) async {
    setState(() {
      isProcessing = true;
    });
    await TransferServices.getVisaUnload(_passwordController.text,
            _amountController.text, selectedVisaCard!.cardNo.toString())
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
    _getVisaCards();
    _setLastPage();
    super.initState();
  }

  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Transferencia desde \n Tarjeta Visa',
          style: TextStyle(fontSize: 16),
        ),
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
                        visaCardsLoaded
                            ? Container(
                                child: DropdownButton<VisaCard>(
                                  hint: const Text(
                                    'Seleccionar Tarjeta',
                                    style: TextStyle(
                                      color: Colors.black26,
                                      fontFamily: 'VarelaRoundRegular',
                                    ),
                                  ),
                                  value: selectedVisaCard,
                                  onChanged: (VisaCard? value) {
                                    setState(() {
                                      selectedVisaCard = value;
                                    });
                                  },
                                  items: cards!.visaCards!
                                      .map((VisaCard visaCard) {
                                    return DropdownMenuItem<VisaCard>(
                                      value: visaCard,
                                      child: Container(
                                        padding:
                                            const EdgeInsets.only(left: 5.0),
                                        width: 250,
                                        child: Text(
                                          '${visaCard.cardNo}',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'VarelaRoundRegular',
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(30.0))),
                                margin: const EdgeInsets.only(bottom: 15.0),
                                padding: const EdgeInsets.only(left: 10.0),
                                width: 300,
                              )
                            : Container(
                                child: const TextField(
                                  decoration: InputDecoration(
                                      label: Text(
                                        'Sin Tarjetas',
                                        style: TextStyle(
                                          color: Colors.black26,
                                          fontFamily: 'VarelaRoundRegular',
                                        ),
                                      ),
                                      border: InputBorder.none),
                                  keyboardType: TextInputType.phone,
                                ),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(30.0))),
                                margin: const EdgeInsets.only(bottom: 15.0),
                                padding: const EdgeInsets.only(left: 10.0),
                                width: 300,
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
                        // Add CheckboxListTile for terms and conditions
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: Colors.black),
                          ),
                          padding: EdgeInsets.all(10.0),
                          margin: EdgeInsets.only(bottom: 10.0),
                          child: Row(
                            children: [
                              Checkbox(
                                value: _termsAndConditionsAccepted,
                                onChanged: _toggleTermsAndConditions,
                              ),
                              Text(
                                "Solicito y autorizo a GPS PAY (LLEGA) \n "
                                    "a debitar de mi Tarjeta VISA DCBank \n"
                                    "el equivalente en CAD Dollar del Monto \n"
                                    "aqui solicitado.",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          child: Container(
                            child: TextButton(
                              child: const Text(
                                'Transferir',
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
                          visible: _termsAndConditionsAccepted || isProcessing,
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
