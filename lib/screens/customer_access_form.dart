import 'dart:convert';
import 'package:appllegagt/models/document_type.dart';
import 'package:appllegagt/models/general/customer_access_response.dart';
import 'package:appllegagt/services/general_services.dart';
import 'package:appllegagt/services/system_errors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerAccessForm extends StatefulWidget {
  const CustomerAccessForm({Key? key}) : super(key: key);

  @override
  _CustomerAccessFormState createState() => _CustomerAccessFormState();
}

class _CustomerAccessFormState extends State<CustomerAccessForm> {
  //Variables
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldStateKey = GlobalKey<ScaffoldState>();
  DocumentType? selectedDocumentType;
  List<DocumentType> documentTypes = <DocumentType>[];
  final _identificationNumberController = TextEditingController();
  final _cardNumber = TextEditingController();
  final _birtDateController = TextEditingController();
  CustomerAccessResponse? _customerAccessResponse;

  bool isGT = false;
  bool isUS = false;
  bool isProcessing = false;

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

  _showSuccessResponse(BuildContext context, dynamic json) {
    _customerAccessResponse = CustomerAccessResponse.fromJson(json);
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
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
                        const SizedBox(
                          child: Text(
                            'Resultado',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          width: 150,
                        ),
                        SizedBox(
                          child: Text(
                              'Usuario: ${_customerAccessResponse!.iDAcceso}'),
                          width: 150,
                        ),
                        SizedBox(
                          child: Text(
                              'Contraseña: ${_customerAccessResponse!.contrasena}'),
                          width: 150,
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

  //Check response
  _checkResponse(BuildContext context, dynamic json) async {
    if (json['ErrorCode'] == 0) {
      _showSuccessResponse(context, json);
    } else {
      String errorMessage =
          await SystemErrors.getSystemError(json['ErrorCode']);
      _showErrorResponse(context, errorMessage);
    }
  }

  //reset form
  _resetForm() {
    setState(() {
      isProcessing = false;
      _birtDateController.text = '';
      _cardNumber.text = '';
      _identificationNumberController.text = '';
    });
  }

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

  //Load Document Types
  _loadDocumentTypes() async {
    String data = isUS
        ? await DefaultAssetBundle.of(context)
            .loadString("assets/document_types.json")
        : await DefaultAssetBundle.of(context)
            .loadString("assets/guatemala_document_type.json");
    final jsonResult = jsonDecode(data);
    setState(() {
      for (int i = 0; i < jsonResult.length; i++) {
        DocumentType documentType = DocumentType.fromJson(jsonResult[i]);
        documentTypes.add(documentType);
      }
    });
  }

  //Execute registration
  _executeTransaction(BuildContext context) async {
    setState(() {
      isProcessing = true;
    });

    await GeneralServices.getCustomerAccess(
      selectedDocumentType!.ID.toString(),
      _identificationNumberController.text,
      _cardNumber.text,
      _birtDateController.text,
    )
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

  @override
  void initState() {
    _getCountryScope();
    _loadDocumentTypes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Recuperar Acceso'),
          backgroundColor: const Color(0XFF0E325F),
        ),
        backgroundColor: const Color(0xFFAFBECC),
        key: scaffoldStateKey,
        body: Builder(
          builder: (context) => Form(
            key: _formKey,
            child: SizedBox(
              child: SafeArea(
                child: Stack(
                  children: [
                    Positioned(
                      child: Container(
                        child: ListView(
                          children: [
                            Container(
                              child: DropdownButton<DocumentType>(
                                hint: const Text('Tipo de documento'),
                                value: selectedDocumentType,
                                onChanged: (DocumentType? value) {
                                  setState(() {
                                    selectedDocumentType = value;
                                  });
                                },
                                items: documentTypes
                                    .map((DocumentType documentType) {
                                  return DropdownMenuItem<DocumentType>(
                                    value: documentType,
                                    child: Container(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      width: 250,
                                      child: Text(
                                        '${documentType.ID} ${documentType.description}',
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
                                  hintText: 'Numero de identificacion',
                                  errorStyle: TextStyle(
                                    fontSize: 8,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Campo obligatorio';
                                  }
                                },
                                controller: _identificationNumberController,
                              ),
                              decoration: const BoxDecoration(
                                color: Color(0XFFEFEFEF),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              height: 50.0,
                              margin: const EdgeInsets.only(bottom: 5.0),
                              padding: const EdgeInsets.only(left: 10.0),
                            ),
                            Container(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText:
                                      'Numero de cuenta \n 6123456789011234',
                                  errorStyle: TextStyle(
                                    fontSize: 8.0,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Campo obligatorio';
                                  }
                                },
                                controller: _cardNumber,
                              ),
                              decoration: const BoxDecoration(
                                color: Color(0xFFEFEFEF),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              height: 50.0,
                              margin: const EdgeInsets.only(bottom: 5.0),
                              padding: const EdgeInsets.only(left: 10.0),
                            ),
                            Container(
                              child: TextButton(
                                child: TextFormField(
                                  controller: _birtDateController,
                                  decoration: const InputDecoration(
                                      hintText:
                                          'Fecha de nacimiento mm/dd/yyyy'),
                                  enabled: false,
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                onPressed: () async {
                                  DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: new DateTime.now(),
                                    firstDate: new DateTime(1920),
                                    lastDate: new DateTime(2030),
                                  );
                                  if (picked != null) {
                                    setState(() {
                                      _birtDateController.text =
                                          picked.month.toString() +
                                              '/' +
                                              picked.day.toString() +
                                              '/' +
                                              picked.year.toString();
                                    });
                                  }
                                },
                              ),
                              decoration: const BoxDecoration(
                                color: Color(0XFFEFEFEF),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              height: 50.0,
                              margin: const EdgeInsets.only(bottom: 10.0),
                              padding: const EdgeInsets.only(left: 10.0),
                              width: 325.0,
                            ),
                            Visibility(
                              child: Container(
                                child: TextButton(
                                  child: const Text(
                                    'Recuperar Acceso',
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
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                                width: screenWidth,
                              ),
                              visible: !isProcessing,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        height: 600,
                        width: screenWidth,
                      ),
                      top: 5.0,
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
              ),
            ),
          ),
        ));
  }
}
