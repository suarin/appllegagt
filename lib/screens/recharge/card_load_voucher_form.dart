import 'dart:convert';
import 'package:appllegagt/models/general/login_success_response.dart';
import 'package:appllegagt/models/general/visa_card.dart';
import 'package:appllegagt/models/general/visa_cards_response.dart';
import 'package:appllegagt/models/payment_type.dart';
import 'package:appllegagt/models/recharge/card_load_voucher_response.dart';
import 'package:appllegagt/services/general_services.dart';
import 'package:appllegagt/services/recharge_services.dart';
import 'package:appllegagt/services/system_errors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardLoadVoucherForm extends StatefulWidget {
  const CardLoadVoucherForm({Key? key}) : super(key: key);

  @override
  _CardLoadVoucherFormState createState() => _CardLoadVoucherFormState();
}

class _CardLoadVoucherFormState extends State<CardLoadVoucherForm>
    with WidgetsBindingObserver {
  //Variables
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldStateKey = GlobalKey<ScaffoldState>();
  final _mobileController = TextEditingController();
  final _voucherController = TextEditingController();
  final _virtualCardController = TextEditingController();
  final _merchantController = TextEditingController();
  VisaCard? selectedVisaCard;
  VisaCardsResponse? visaCardsResponse;
  PaymentType? selectedPaymentType;
  List<PaymentType> paymentTypes = <PaymentType>[];
  CardLoadVoucherResponse cardLoadVoucherResponse = CardLoadVoucherResponse();
  bool isProcessing = false;
  bool visaCardsLoaded = false;
  bool showMobileField = false;
  var screenWidth, screenHeight;

  //function to obtain Visa Cards for picker
  _getVirtualCards() async {
    await GeneralServices.getVirtualCards().then((list) => {
          setState(() {
            visaCardsResponse = VisaCardsResponse.fromJson(list);
            visaCardsLoaded = true;
          })
        });
  }

  //Get user data
  _getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    LoginSuccessResponse loginSuccessResponse = LoginSuccessResponse(
        errorCode: 0,
        cHolderID: prefs.getInt('cHolderID'),
        userName: prefs.getString('userName'),
        cardNo: prefs.getString('cardNo'),
        currency: prefs.getString('currency'),
        balance: prefs.getString('balance'));
    setState(() {
      _virtualCardController.text = loginSuccessResponse.cardNo.toString();
    });
  }

  //functions for data pickers
  _loadPaymentTypes() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString('assets/payment_types.json');
    final jsonResult = jsonDecode(data);
    setState(() {
      for (int i = 0; i < jsonResult.length; i++) {
        PaymentType paymentType = PaymentType.fromJson(jsonResult[i]);
        paymentTypes.add(paymentType);
      }
    });
  }

  //functions for dialogs
  _showSuccessResponse(
      BuildContext context, CardLoadVoucherResponse cardLoadVoucherResponse) {
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
                                'Monto Acreditado',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              width: 150,
                            ),
                            SizedBox(
                              child: Text(cardLoadVoucherResponse.amountLoad
                                  .toString()),
                              width: 150,
                            ),
                          ],
                        ),
                      ],
                    ),
                    margin: const EdgeInsets.only(left: 40),
                  ),
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
                              child: Text(
                                  cardLoadVoucherResponse.authNo.toString()),
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
      CardLoadVoucherResponse cardLoadVoucherResponse =
          CardLoadVoucherResponse.fromJson(json);
      _showSuccessResponse(context, cardLoadVoucherResponse);
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
      _voucherController.text = '';
      _mobileController.text = '';
      _merchantController.text = '';
      _virtualCardController.text = '';
    });
  }

  //Execute registration
  _executeTransaction(BuildContext context) async {
    setState(() {
      isProcessing = true;
    });
    await RechargeServices.getCardLoadVoucher(
            _merchantController.text,
            selectedPaymentType!.typeId.toString(),
            _voucherController.text,
            _virtualCardController.text,
            _mobileController.text)
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
    _getVirtualCards();
    _loadPaymentTypes();
    _getUserData();
    _setLastPage();
    super.initState();
  }

  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recarga en Comercio'),
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
                          child: DropdownButton<PaymentType>(
                            hint: const Text('Seleccionar Tipo'),
                            value: selectedPaymentType,
                            onChanged: (PaymentType? value) {
                              setState(() {
                                selectedPaymentType = value;
                                if (value!.typeId == 'P') {
                                  showMobileField = true;
                                  _mobileController.text = '';
                                } else {
                                  showMobileField = false;
                                  _mobileController.text = '0';
                                }
                              });
                            },
                            items: paymentTypes.map((PaymentType payment) {
                              return DropdownMenuItem<PaymentType>(
                                value: payment,
                                child: Container(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  width: 250,
                                  child: Text(
                                    payment.type.toString(),
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          height: 50.0,
                          margin: const EdgeInsets.only(bottom: 5.0),
                          padding: const EdgeInsets.only(left: 10.0),
                          width: 250,
                        ),
                        Container(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Codigo de comercio *',
                              errorStyle: TextStyle(
                                fontSize: 8,
                              ),
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo obligatorio';
                              }
                            },
                            controller: _merchantController,
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
                              hintText: 'Numero de Cuenta *',
                              errorStyle: TextStyle(
                                fontSize: 8,
                              ),
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo obligatorio';
                              }
                            },
                            controller: _virtualCardController,
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
                              hintText: 'No Voucher *',
                              errorStyle: TextStyle(
                                fontSize: 8,
                              ),
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo obligatorio';
                              }
                            },
                            controller: _voucherController,
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
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Telefono *',
                                errorStyle: TextStyle(
                                  fontSize: 8,
                                ),
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Campo obligatorio';
                                }
                              },
                              controller: _mobileController,
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
                          visible: showMobileField,
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
