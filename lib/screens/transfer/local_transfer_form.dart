import 'package:appllegagt/models/transfer/bgp_account.dart';
import 'package:appllegagt/models/transfer/bgp_accounts.dart';
import 'package:appllegagt/models/transfer/card_transfer_response.dart';
import 'package:appllegagt/services/system_errors.dart';
import 'package:appllegagt/services/transfer_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalTransferForm extends StatefulWidget {
  const LocalTransferForm({Key? key}) : super(key: key);

  @override
  _LocalTransferFormState createState() => _LocalTransferFormState();
}

class _LocalTransferFormState extends State<LocalTransferForm>
    with WidgetsBindingObserver {
  //Variables
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldStateKey = GlobalKey<ScaffoldState>();
  final _passwordController = TextEditingController();
  final _amountController = TextEditingController();
  final _destinationCardController = TextEditingController();
  final _notesController = TextEditingController();
  bool isProcessing = false;
  bool isGT = false;
  bool isUS = false;
  var screenWidth, screenHeight;
  bool accountsLoaded = false;
  BgpAccount? selectedBgpAccount;
  BgpAccounts? bgpAccounts;
  String country = '';

  //function to obtain GPS Accounts
  _getBgpAccounts() async {
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
    await TransferServices.getBgpAccounts(countryScope).then((list) => {
          setState(() {
            bgpAccounts = BgpAccounts.fromJson(list);
            accountsLoaded = true;
          })
        });
  }

  //functions for dialogs
  _showSuccessResponse(
      BuildContext context, CardTransferResponse cardTransferResponse) {
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
                                  Text(cardTransferResponse.authNo.toString()),
                              width: 150,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              child: Text(
                                'Destinatario',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              width: 150,
                            ),
                            SizedBox(
                              child: Text(cardTransferResponse.transferTo
                                  .toString()
                                  .toUpperCase()),
                              width: 150,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              child: Text(
                                'Monto debitado',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              width: 150,
                            ),
                            SizedBox(
                              child: Text(
                                  '${isUS ? "USD " : "Q "} ${cardTransferResponse.debitedAmount.toString()}'),
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
      CardTransferResponse cardTransferResponse =
          CardTransferResponse.fromJson(json);
      _showSuccessResponse(context, cardTransferResponse);
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
      _notesController.text = '';
      _amountController.text = '';
      _destinationCardController.text = '';
    });
  }

  //Execute registration
  _executeTransaction(BuildContext context) async {
    setState(() {
      isProcessing = true;
    });

    await TransferServices.getCardTransfer(
            _passwordController.text,
            selectedBgpAccount!.accountNo.toString(),
            _amountController.text,
            _notesController.text)
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
    _getBgpAccounts();
    _setLastPage();
    super.initState();
  }

  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transferencia a \ncuenta  local'),
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
                        accountsLoaded
                            ? Container(
                                child: DropdownButton<BgpAccount>(
                                  hint: const Text(
                                    'Seleccionar Cuenta',
                                    style: TextStyle(
                                      color: Colors.black26,
                                      fontFamily: 'VarelaRoundRegular',
                                    ),
                                  ),
                                  value: selectedBgpAccount,
                                  onChanged: (BgpAccount? value) {
                                    setState(() {
                                      selectedBgpAccount = value;
                                    });
                                  },
                                  items: bgpAccounts!.accounts!
                                      .map((BgpAccount bgpAccount) {
                                    return DropdownMenuItem<BgpAccount>(
                                      value: bgpAccount,
                                      child: Container(
                                        padding:
                                            const EdgeInsets.only(left: 5.0),
                                        width: 250,
                                        child: Text(
                                          '${bgpAccount.holderName}',
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
                              hintText: 'Nota',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo obligatorio *';
                              }
                            },
                            controller: _notesController,
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
