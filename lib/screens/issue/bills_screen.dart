import 'package:appllegagt/models/general/bill.dart';
import 'package:appllegagt/models/general/bills_reponse.dart';
import 'package:appllegagt/screens/issue/pay_bill_form.dart';
import 'package:appllegagt/services/general_services.dart';
import 'package:flutter/material.dart';
class BillsScreen extends StatefulWidget {
  const BillsScreen({Key? key}) : super(key: key);

  @override
  _BillsScreenState createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> with WidgetsBindingObserver {

  //Variables
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldStateKey = GlobalKey<ScaffoldState>();
  bool billsLoaded = false;
  bool isProcessing = false;
  var screenWidth, screenHeight;

  Bill? bill;
  BillsResponse? billsResponse;
  //Function to obtain bills
  _getBills() async{
    await GeneralServices.getBills().then((list) => {
      billsResponse = BillsResponse.fromJson(list),
      setState(() {
        billsLoaded = true;
      })
    });
  }

  @override
  void initState(){
    _getBills();
    super.initState();
  }
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar:  AppBar(
        title: const Text('FACTURAS'),
        backgroundColor: const Color(0XFF0E325F),
      ),
      backgroundColor: const Color(0XFFAFBECC),
      key: scaffoldStateKey,
      body: billsLoaded ? Builder(
        builder: (context) => SizedBox(
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: billsResponse!.bills!.length,
              itemBuilder: (context , index){
                Bill bill = billsResponse!.bills![index];
                return Container(
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                            bill.billerName.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                           'FACTURA: ${bill.invoiceNo.toString()}',
                          style: const TextStyle(
                            letterSpacing: 2.5
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              child: Text(
                                'ID: ${bill.billerId.toString()}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              width: 50,
                            ),
                            SizedBox(
                              child: ElevatedButton(
                                  child: const Text('Pagar'),
                                  style: ElevatedButton.styleFrom(
                                    primary: const Color(0XFF0E325F),
                                  ),
                                  onPressed: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PayBillForm(bill: bill)
                                      )
                                    );
                                  },
                              ),
                              width: 125,
                            ),
                            SizedBox(
                              child: Text(
                                  'USD ${bill.amount}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              width: 75,
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    ),
                  ),
                  decoration:   const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.only(left: 20),
                  width: 200,
                  height: 125,
                );
              }
          ),
          width: screenWidth,
          height: screenHeight - 100,
        ),
      ) : const Text('Sin Facturas'),
    );
  }
}
