import 'package:appllegagt/models/general/card_transactions_reponse.dart';
import 'package:appllegagt/models/general/transaction.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatefulWidget {
  final CardTransactionsResponse? transactionList;
  const TransactionList({Key? key, @required this.transactionList}) : super(key: key);

  @override
  _TransactionListState createState(){
    return  _TransactionListState(transactionList: this.transactionList);
  }
}

class _TransactionListState extends State<TransactionList>  with WidgetsBindingObserver{
  final CardTransactionsResponse? transactionList;
  _TransactionListState({Key? key, @required this.transactionList});
  var screenWidth, screenHeight;
  bool isGT = false;
  bool isUS = false;
  String titleApp = '';
  String currencyApp = '';
  //Load Country Scope
  _getCountryScope() async {
    final prefs = await SharedPreferences.getInstance();
    String countryScope =  prefs.getString('countryScope')!;
    if(countryScope=='GT'){
      setState(() {
        isGT = true;
        titleApp = 'yPayme';
        currencyApp = 'Q. ';
      });
    }

    if(countryScope=='US'){
      setState(() {
        isUS = true;
        titleApp = 'BGP';
        currencyApp = 'USD ';
      });
    }
  }
  @override
  void initState(){
    _getCountryScope();
    super.initState();
  }
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    var f = NumberFormat("###0.00#", "en_US");
    return Scaffold(
      appBar: AppBar(
        title: Text('Transacciones Cuenta $titleApp'),
        backgroundColor: const Color(0XFF0E325F),
      ),
      backgroundColor: const Color(0XFFAFBECC),
      body: Builder(
        builder: (context)=>SafeArea(
          child: ListView.builder(
            padding: EdgeInsets.only(left: 10.0,right: 10.0),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: transactionList!.transactions!.length,
            itemBuilder: (context,index){
              Transaction transaction = transactionList!.transactions![index];
              return Container(
                padding: EdgeInsets.only(top: 10.0,bottom: 10.0),
                width: 300,
                child: Column(
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          transaction.credito! > 0 ?
                          Text(
                            '+$currencyApp ${f.format(transaction.credito)}',
                            style: const TextStyle(
                                color: Colors.green,
                                fontFamily: 'NanumGothic Bold',
                                fontSize: 20.0
                            ),
                          ):
                          Text(
                            '$currencyApp ${f.format(transaction.debito)}',
                            style: const TextStyle(
                                color: Colors.red,
                                fontFamily: 'NanumGothic Bold',
                                fontSize: 20.0
                            ),
                          ),
                          Text(
                            '${transaction.fecha}',
                            style: const TextStyle(
                                fontFamily: 'NanumGothic Bold',
                                fontSize: 16.0
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${transaction.transaccion}',
                              style: const TextStyle(
                                  fontFamily: 'NanumGothic Bold',
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold
                              ),

                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Saldo: $currencyApp ${f.format(transaction.saldo)}',
                              style: const TextStyle(
                                  fontFamily: 'NanumGothic Bold',
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold
                              ),

                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 2.0,
                      color: Colors.white,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
