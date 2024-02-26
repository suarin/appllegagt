import 'package:appllegagt/models/general/transaction.dart';
import 'package:appllegagt/models/general/virtual_card.dart';
import 'package:appllegagt/models/general/virtual_cards_response.dart';
import 'package:appllegagt/models/shop/virtual_transaction.dart';
import 'package:appllegagt/models/shop/virtual_transactions_response.dart';
import 'package:appllegagt/services/general_services.dart';
import 'package:appllegagt/services/purchase_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VirtualTransactionsScreen extends StatefulWidget {
  const VirtualTransactionsScreen({Key? key}) : super(key: key);

  @override
  _VirtualTransactionsScreenState createState() =>
      _VirtualTransactionsScreenState();
}

class _VirtualTransactionsScreenState extends State<VirtualTransactionsScreen>
    with WidgetsBindingObserver {
  //Variables
  final GlobalKey<ScaffoldState> scaffoldStateKey = GlobalKey<ScaffoldState>();
  final _endDateController = TextEditingController();
  bool transactionsLoaded = false;
  bool isProcessing = false;
  bool showButton = true;
  bool virtualCardsLoaded = false;
  Transaction? transaction;
  VirtualTransactionsResponse? virtualTransactionsResponse;
  VirtualCard? selectedVirtualCard;
  VirtualCardsResponse? cards;
  bool isGT = false;
  bool isUS = false;
  var screenWidth, screenHeight;

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
  _getVirtualCards() async {
    await GeneralServices.getVirtualCards().then((list) => {
          setState(() {
            cards = VirtualCardsResponse.fromJson(list);
            virtualCardsLoaded = true;
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
    await PurchaseService.getVirtualTransactions(
            selectedVirtualCard!.cardNo.toString(), _endDateController.text)
        .then((list) => {
              virtualTransactionsResponse =
                  VirtualTransactionsResponse.fromJson(list),
              setState(() {
                transactionsLoaded = true;
              })
            })
        .catchError((error) {
      _showErrorResponse(context, error.toString());
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
    _getCountryScope();
    _setLastPage();
    super.initState();
  }

  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Transacciones \n Tarjeta Virtual',
          style: TextStyle(fontSize: 16.0),
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
                  child: virtualCardsLoaded
                      ? Container(
                          child: DropdownButton<VirtualCard>(
                            hint: const Text(
                              'Seleccionar Tarjeta',
                              style: TextStyle(
                                color: Colors.black26,
                                fontFamily: 'VarelaRoundRegular',
                              ),
                            ),
                            value: selectedVirtualCard,
                            onChanged: (VirtualCard? value) {
                              setState(() {
                                selectedVirtualCard = value;
                              });
                            },
                            items: cards!.virtualCards!.map((VirtualCard virtualCard) {
                              return DropdownMenuItem<VirtualCard>(
                                value: virtualCard,
                                child: Container(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  width: 250,
                                  child: Text(
                                    '${virtualCard.cardNo}',
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
                  visible: !transactionsLoaded),
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
                          itemCount: virtualTransactionsResponse!
                              .transacciones!.length,
                          itemBuilder: (context, index) {
                            VirtualTransaction virtualTransaction =
                                virtualTransactionsResponse!
                                    .transacciones![index];
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
                                            virtualTransaction.id.toString(),
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
                                            virtualTransaction.description
                                                .toString(),
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
                                            'Referencia: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          width: 100,
                                        ),
                                        SizedBox(
                                          child: Text(
                                            virtualTransaction.reference
                                                .toString(),
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
                                            'Monto: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          width: 100,
                                        ),
                                        SizedBox(
                                          child: Text(
                                            '${isUS ? "USD " : "Q "} ${virtualTransaction.amt.toString()}',
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
                                            virtualTransaction.inserted
                                                .toString(),
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
                                            'Comercio ID: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          width: 100,
                                        ),
                                        SizedBox(
                                          child: Text(
                                            virtualTransaction.merchant
                                                .toString(),
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
                                            'Autorizacion: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          width: 100,
                                        ),
                                        SizedBox(
                                          child: Text(
                                            virtualTransaction.authno
                                                .toString(),
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
