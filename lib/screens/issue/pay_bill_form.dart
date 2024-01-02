import 'dart:convert';

import 'package:appllegagt/models/general/bill.dart';
import 'package:appllegagt/models/general/bill_payment_response.dart';
import 'package:appllegagt/models/general/visa_card.dart';
import 'package:appllegagt/models/general/visa_cards_response.dart';
import 'package:appllegagt/models/rush_payment.dart';
import 'package:appllegagt/services/general_services.dart';
import 'package:appllegagt/services/system_errors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PayBillForm extends StatefulWidget {
  final Bill? bill;
  const PayBillForm({Key? key, @required this.bill}) : super(key: key);

  @override
  _PayBillFormState createState() {
    return _PayBillFormState(bill: this.bill);
  }
}

class _PayBillFormState extends State<PayBillForm> with WidgetsBindingObserver {
  //Constructor
  _PayBillFormState({Key? key, @required this.bill});
  //Variables
  final Bill? bill;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldStateKey = GlobalKey<ScaffoldState>();
  final _passwordController = TextEditingController();
  VisaCardsResponse? visaCardsResponse;
  BillPaymentResponse? _billPaymentResponse;
  bool visaCardsLoaded = false;
  bool rushPaymentsLoaded = false;
  bool isProcessing = false;
  VisaCard? selectedVisaCard;
  RushPayment? _selectedRushPayment;
  final List<RushPayment> _rushPayments = <RushPayment>[];

  var screenWidth, screenHeight;

  //functions for data pickers
  _loadRushPayment() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString('assets/rush_payment.json');
    final jsonResult = jsonDecode(data);
    setState(() {
      for (int i = 0; i < jsonResult.length; i++) {
        RushPayment rushPayment = RushPayment.fromJson(jsonResult[i]);
        _rushPayments.add(rushPayment);
        rushPaymentsLoaded = true;
      }
    });
  }

  //function to obtain Visa Cards for picker
  _getVisaCards() async {
    await GeneralServices.getVirtualCards().then((list) => {
          setState(() {
            visaCardsResponse = VisaCardsResponse.fromJson(list);
            visaCardsLoaded = true;
          })
        });
  }

  //functions for dialogs
  _showSuccessResponse(
      BuildContext context, BillPaymentResponse billPaymentResponse) {
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
                                  Text(billPaymentResponse.authNo.toString()),
                              width: 150,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              child: Text(
                                'Proveedor',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              width: 150,
                            ),
                            SizedBox(
                              child: Text(
                                  billPaymentResponse.billerName.toString()),
                              width: 150,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              child: Text(
                                'Costo del Producto',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              width: 150,
                            ),
                            SizedBox(
                              child: Text(
                                  billPaymentResponse.productCost.toString()),
                              width: 150,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              child: Text(
                                'Pagado',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              width: 150,
                            ),
                            SizedBox(
                              child: Text(
                                  billPaymentResponse.totalPaid.toString()),
                              width: 150,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              child: Text(
                                'Comision',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              width: 150,
                            ),
                            SizedBox(
                              child: Text(billPaymentResponse.fee.toString()),
                              width: 150,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              child: Text(
                                'No Cuenta',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              width: 150,
                            ),
                            SizedBox(
                              child: Text(
                                  billPaymentResponse.accountNo.toString()),
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
      BillPaymentResponse billPaymentResponse =
          BillPaymentResponse.fromJson(json);
      _showSuccessResponse(context, billPaymentResponse);
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
      _passwordController.text = '';
    });
  }

  //Execute registration
  _executeTransaction(BuildContext context) async {
    setState(() {
      isProcessing = true;
    });
    await GeneralServices.getPayBill(
            bill!.invoiceNo.toString(),
            selectedVisaCard!.cardNo.toString(),
            _passwordController.text,
            bill!.amount.toString(),
            bill!.billerId.toString(),
            bill!.acoountNo.toString(),
            _selectedRushPayment!.optionId.toString())
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
    _loadRushPayment();
    _setLastPage();
    _getVisaCards();
    super.initState();
  }

  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagar Factura'),
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
                          child: Text(
                            'Factura: ${bill!.invoiceNo.toString()}',
                            style: const TextStyle(fontSize: 20.0),
                          ),
                          decoration: const BoxDecoration(
                            color: Color(0XFFEFEFEF),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          height: 50.0,
                          margin: const EdgeInsets.only(bottom: 5.0),
                          padding: const EdgeInsets.only(left: 30.0, top: 10.0),
                        ),
                        Container(
                          child: Text(
                            'Monto: ${bill!.amount.toString()}',
                            style: const TextStyle(fontSize: 20),
                          ),
                          decoration: const BoxDecoration(
                            color: Color(0XFFEFEFEF),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          height: 50.0,
                          margin: const EdgeInsets.only(bottom: 5.0),
                          padding: const EdgeInsets.only(left: 30.0, top: 10),
                        ),
                        Container(
                          child: Text(
                            'ID Proveedor: ${bill!.billerId.toString()}',
                            style: const TextStyle(fontSize: 20.0),
                          ),
                          decoration: const BoxDecoration(
                            color: Color(0XFFEFEFEF),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          height: 50.0,
                          margin: const EdgeInsets.only(bottom: 5.0),
                          padding: const EdgeInsets.only(left: 30.0, top: 10),
                        ),
                        Container(
                          child: Text(
                            'No Cuenta: ${bill!.acoountNo.toString()}',
                            style: const TextStyle(fontSize: 20.0),
                          ),
                          decoration: const BoxDecoration(
                            color: Color(0XFFEFEFEF),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          height: 50.0,
                          margin: const EdgeInsets.only(bottom: 5.0),
                          padding: const EdgeInsets.only(left: 30.0, top: 10),
                        ),
                        rushPaymentsLoaded
                            ? Container(
                                child: DropdownButton<RushPayment>(
                                  hint: const Text(
                                      'Seleccione Si o No para Agilizar'),
                                  value: _selectedRushPayment,
                                  onChanged: (RushPayment? value) {
                                    setState(() {
                                      _selectedRushPayment = value;
                                    });
                                  },
                                  items: _rushPayments
                                      .map((RushPayment rushPayment) {
                                    return DropdownMenuItem<RushPayment>(
                                      value: rushPayment,
                                      child: Container(
                                        padding:
                                            const EdgeInsets.only(left: 5.0),
                                        width: 250,
                                        child: Text(
                                          rushPayment.optionName.toString(),
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
                              )
                            : Container(
                                child: const Text('Sin Tarjetas'),
                                decoration: const BoxDecoration(
                                  color: Color(0XFFEFEFEF),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                height: 50.0,
                                margin: const EdgeInsets.only(bottom: 5.0),
                                padding: const EdgeInsets.only(left: 10.0),
                              ),
                        visaCardsLoaded
                            ? Container(
                                child: DropdownButton<VisaCard>(
                                  hint: const Text('Seleccionar Tarjeta'),
                                  value: selectedVisaCard,
                                  onChanged: (VisaCard? value) {
                                    setState(() {
                                      selectedVisaCard = value;
                                    });
                                  },
                                  items: visaCardsResponse!.visaCards!
                                      .map((VisaCard visaCard) {
                                    return DropdownMenuItem<VisaCard>(
                                      value: visaCard,
                                      child: Container(
                                        padding:
                                            const EdgeInsets.only(left: 5.0),
                                        width: 250,
                                        child: Text(
                                          visaCard.cardNo.toString(),
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
                              )
                            : Container(
                                child: const Text('Sin Tarjetas'),
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
                      top: screenHeight - 130.0,
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
