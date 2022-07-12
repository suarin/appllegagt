import 'package:appllegagt/models/general/visa_balance_response.dart';
import 'package:appllegagt/models/general/visa_card.dart';
import 'package:appllegagt/models/general/visa_cards_response.dart';
import 'package:appllegagt/services/general_services.dart';
import 'package:appllegagt/services/system_errors.dart';
import 'package:flutter/material.dart';

class VisaBalanceForm extends StatefulWidget {
  const VisaBalanceForm({Key? key}) : super(key: key);

  @override
  _VisaBalanceFormState createState() => _VisaBalanceFormState();
}

class _VisaBalanceFormState extends State<VisaBalanceForm>  with WidgetsBindingObserver{
  //Variables
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldStateKey = GlobalKey<ScaffoldState>();
  final _visaCardController = TextEditingController();
  VisaCardsResponse? cards;
  bool visaCardsLoaded = false;
  bool isProcessing = false;
  VisaCard? selectedVisaCard;
  VisaBalanceResponse? visaBalanceResponse;
  var screenWidth, screenHeight;

  //function to obtain Visa Cards for picker
  _getVisaCards() async {
    await GeneralServices.getVisaCards().then((list) => {
          setState(() {
            cards = VisaCardsResponse.fromJson(list);
            visaCardsLoaded = true;
          })
        });
  }

  //functions for dialogs
  _showSuccessResponse(BuildContext context, VisaBalanceResponse visaBalanceResponse){

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
                                'Balance',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              width: 150,
                            ),
                            SizedBox(
                              child: Text(visaBalanceResponse.balance.toString()),
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

  _showErrorResponse(BuildContext context, String errorMessage){
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
                  child: Text(errorMessage, style: const TextStyle(color: Colors.white),),
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
  _checkResponse(BuildContext context, dynamic json) async{
    if(json['ErrorCode'] == 0){

      VisaBalanceResponse  visaBalanceResponse = VisaBalanceResponse.fromJson(json);
      _showSuccessResponse(context, visaBalanceResponse);

    } else{
      String errorMessage = await SystemErrors.getSystemError(json['ErrorCode']);
      _showErrorResponse(context, errorMessage);
    }
  }

  //Reset form
  _resetForm(){
    setState(() {
      isProcessing = false;
      _visaCardController.text='';
    });
  }
  //Execute registration
  _executeTransaction(BuildContext context) async {
    setState(() {
      isProcessing = true;
    });
    await GeneralServices.getVisaBalance(selectedVisaCard.toString())
        .then((response) => {
      if(response['ErrorCode'] != null){
        _checkResponse(context, response),
      }
    }).catchError((error){
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


  @override
  void initState() {
    _getVisaCards();
    super.initState();
  }

  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitar balance Visa'),
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
                                  padding: const EdgeInsets.only(
                                      left: 5.0),
                                  width: 250,
                                  child: Text(
                                    '${visaCard.cardNo}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily:
                                      'VarelaRoundRegular',
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
                       Visibility(
                         child:  Container(
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
                             borderRadius: BorderRadius.all(Radius.circular(10.0)),
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
                          decoration: const BoxDecoration(
                              color: Colors.grey
                          ),
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
