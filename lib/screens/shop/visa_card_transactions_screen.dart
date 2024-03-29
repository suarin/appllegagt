import 'package:appllegagt/models/general/transaction.dart';
import 'package:appllegagt/models/general/visa_card.dart';
import 'package:appllegagt/models/general/visa_cards_response.dart';
import 'package:appllegagt/models/shop/visa_transaction.dart';
import 'package:appllegagt/models/shop/visa_transactions_response.dart';
import 'package:appllegagt/services/general_services.dart';
import 'package:appllegagt/services/purchase_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VisaCardTransactionsScreen extends StatefulWidget {
  const VisaCardTransactionsScreen({Key? key}) : super(key: key);

  @override
  _VisaCardTransactionsScreenState createState() =>
      _VisaCardTransactionsScreenState();
}

class _VisaCardTransactionsScreenState extends State<VisaCardTransactionsScreen>
    with WidgetsBindingObserver {
  //Variables
  final GlobalKey<ScaffoldState> scaffoldStateKey = GlobalKey<ScaffoldState>();
  final _endDateController = TextEditingController();
  bool transactionsLoaded = false;
  bool isProcessing = false;
  bool showButton = true;
  bool visaCardsLoaded = false;
  bool isGT = false;
  bool isUS = false;
  Transaction? transaction;
  VisaTransactionsResponse? visaTransactionsResponse;
  var screenWidth, screenHeight;
  VisaCardsResponse? cards;
  VisaCard? selectedVisaCard;

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

  //function to obtain Visa Cards for picker
  _getVisaCards() async {
    await GeneralServices.getVisaCards().then((list) =>
    {
      setState(() {
        cards = VisaCardsResponse.fromJson(list);
        visaCardsLoaded = true;
      })
    });
  }

  //Functions for dialogs
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
                    backgroundColor: const Color(0XFF0E325F),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  //Reset Form
  _resetForm() {
    setState(() {
      isProcessing = false;
      if (transactionsLoaded) {
        showButton = false;
      } else {
        showButton = true;
      }
    });
  }

  //Function to obtain transactions
  _getTransactions() async {
    setState(() {
      isProcessing = true;
      showButton = false;
    });
    await PurchaseService.getVisaTransactions(
        selectedVisaCard!.cardNo.toString(), _endDateController.text)
        .then((list) =>
    {
      visaTransactionsResponse =
          VisaTransactionsResponse.fromJson(list),
      setState(() {
        transactionsLoaded = true;
      })
    })
        .catchError((Object error) {
      _showErrorResponse(context, error.toString());
      _resetForm();
      return null;
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
    _getCountryScope();
    _setLastPage();
    super.initState();
  }

  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isUS
              ? 'Transacciones \n Tarjeta Plastica'
              : 'Transacciones \n Tarjeta Plastica',
          style: const TextStyle(fontSize: 16.0),
        ),
        backgroundColor: const Color(0XFF0E325F),
      ),
      backgroundColor: const Color(0XFFAFBECC),
      key: scaffoldStateKey,
      body: Builder(
        builder: (context) => SizedBox(
          child: Column(
            children: [
              Visibility(
                child: visaCardsLoaded
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
                    items: cards!.visaCards!.map((VisaCard visaCard) {
                      return DropdownMenuItem<VisaCard>(
                        value: visaCard,
                        child: Container(
                          padding: const EdgeInsets.only(left: 5.0),
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
                      borderRadius:
                      const BorderRadius.all(Radius.circular(30.0))),
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
                      borderRadius:
                      const BorderRadius.all(Radius.circular(30.0))),
                  margin: const EdgeInsets.only(bottom: 15.0),
                  padding: const EdgeInsets.only(left: 10.0),
                  width: 300,
                ),
                visible: !transactionsLoaded,
              ),
              Visibility(
                child: Container(
                  child: TextButton(
                    child: TextFormField(
                      controller: _endDateController,
                      decoration:
                      InputDecoration(hintText: 'Fecha Final de Reporte'),
                      enabled: false,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () async {
                      DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: new DateTime.now(),
                          firstDate: new DateTime(2020),
                          lastDate: new DateTime(2030));
                      if (picked != null)
                        setState(() => _endDateController.text =
                            picked.month.toString() +
                                '/' +
                                picked.day.toString() +
                                '/' +
                                picked.year.toString());
                    },
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0XFFEFEFEF),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  height: 50.0,
                  margin: const EdgeInsets.only(bottom: 10.0),
                  padding: const EdgeInsets.only(left: 10.0),
                  width: 325,
                ),
                visible: !transactionsLoaded,
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
                      _getTransactions();
                    },
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0XFF0E325F),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  width: 325,
                ),
                visible: !isProcessing,
              ),
              transactionsLoaded
                  ? SizedBox(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount:
                      visaTransactionsResponse!.transacciones!.length,
                      itemBuilder: (context, index) {
                        VisaTransaction visaTransaction =
                        visaTransactionsResponse!.transacciones![index];
                      return Container(
                        child: Center(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const SizedBox(
                                    child: Text(
                                      'ID: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    width: 100,
                                  ),
                                  SizedBox(
                                    child: Text(
                                      visaTransaction.id.toString(),
                                    ),
                                  ),
                                ],
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                              ),
                              Row(
                                children: [
                                  const SizedBox(
                                    child: Text(
                                      'Descripcion: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    width: 100,
                                  ),
                                  SizedBox(
                                    child: Text(
                                      visaTransaction.description
                                          .toString(),
                                    ),
                                    width: 200,
                                  ),
                                ],
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                              ),
                              Row(
                                children: [
                                  const SizedBox(
                                    child: Text(
                                      'Referencia: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    width: 100,
                                  ),
                                  SizedBox(
                                    child: Text(
                                      visaTransaction.reference
                                          .toString(),
                                    ),
                                  ),
                                ],
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    child: Text(
                                      'Monto: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: double.parse(
                                            visaTransaction!
                                                .amount!) <
                                            0
                                            ? Colors.redAccent
                                            : Colors.black54,
                                      ),
                                    ),
                                    width: 100,
                                  ),
                                  SizedBox(
                                    child: Text(
                                      visaTransaction.amount.toString(),
                                      style: TextStyle(
                                        color: double.parse(
                                            visaTransaction!
                                                .amount!) <
                                            0
                                            ? Colors.redAccent
                                            : Colors.black54,
                                      ),
                                    ),
                                  ),
                                ],
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                              ),
                              Row(
                                children: [
                                  const SizedBox(
                                    child: Text(
                                      'Balance: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green),
                                    ),
                                    width: 100,
                                  ),
                                  SizedBox(
                                    child: Text(
                                      visaTransaction.balance.toString(),
                                      style: const TextStyle(
                                          color: Colors.green),
                                    ),
                                  ),
                                ],
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                              ),
                              Row(
                                children: [
                                  const SizedBox(
                                    child: Text(
                                      'Insertado: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    width: 100,
                                  ),
                                  SizedBox(
                                    child: Text(
                                      visaTransaction.inserted.toString(),
                                    ),
                                  ),
                                ],
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                              ),
                            ],
                            mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                          ),
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.all(Radius.circular(15)),
                        ),
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.only(left: 10),
                        width: 300,
                        height: 200,
                      );
                    }),
                height: screenHeight - 100,
                width: screenWidth,
              )
                  : const Text('')
            ],
          ),
          width: screenWidth,
          height: screenHeight,
        ),
      ),
    );
  }
}

