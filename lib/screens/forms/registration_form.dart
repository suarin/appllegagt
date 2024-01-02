import 'dart:convert';

import 'package:appllegagt/models/country.dart';
import 'package:appllegagt/models/document_type.dart';
import 'package:appllegagt/models/general/cooperative.dart';
import 'package:appllegagt/models/general/registration_success_response.dart';
import 'package:appllegagt/screens/forms/registrarion_results_screen.dart';
import 'package:appllegagt/services/general_services.dart';
import 'package:appllegagt/services/system_errors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({Key? key}) : super(key: key);

  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm>
    with WidgetsBindingObserver {
  //Variables
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldStateKey = GlobalKey<ScaffoldState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _identificationNumberController = TextEditingController();
  final _recomendationNumberController = TextEditingController();
  final _gtText =
      '\nAL FINALIZAR EL REGISTRO NO PODRAS INGRESAR A TU CUENTA, HASTA QUE ENVÍES COPIA DE LOS SIGUIENTES DOCUMENTOS:\n'
      '1. DOCUMENTO DE IDENTIFICACION.'
      '2.RECIBO DE SERVICIOS QUE DEMUESTRE TU DIRECCION, ENVIALOS AL WHATSAPP, NUMERO 502 5465 0585.\n'
      'CUANDO ENVIE LAS IMAGENES RECUERDE HACER REFERENCIA DE TU NOMBRE EN EL RECUADRO QUE APARECE EN WHATSAPP "Añade un comentario"\n'
      '3.LLENAR FORMULARIO FEIC\n'
      'QUE PODRAS BAJAR DESDE ESTE LINK https://n9.cl/llega\n'
      'Y ENVÍA POR WHATSAPP O A NUESTRO CORREO ELECTRÓNICO cumplimiento@llegagt.com\n';

  final _usText =
      '\nAL CERRAR ESTA NOTIFICACION, SIGUE LOS PASOS QUE TE SOLICITA EL DEPARTAMENTO DE CUMPLIMIENTO\n'
      'O SI PREFIERES ENVIANOS COPIA DE LOS MISMOS DOCUMENTOS MENCIONADOS ARRIBA, AL WHATSAPP, NUMERO 502 5465 0585\n'
      'CUANDO ENVIE LAS IMAGENES RECUERDE HACER REFERENCIA DE TU NOMBRE EN EL RECUADRO QUE APARECE EN WHATSAPP\n'
      '"Añade un comentario".';

  bool isProcessing = false;
  bool isGT = false;
  bool isUS = false;
  bool termsConditionAccepted = false;
  bool registrationDone = false;
  bool cooperativesLoaded = false;

  List<Cooperative>? cooperatives = <Cooperative>[];
  Cooperative? selectedCooperative;
  String promoCode = "";

  List<Country> countries = <Country>[];
  List<DocumentType> documentTypes = <DocumentType>[];
  Country? selectedCountry;
  DocumentType? selectedDocumentType;
  RegistrationSuccessResponse registrationSuccessResponse =
      RegistrationSuccessResponse();

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

  //function to obtain Cooperatives
  _getCooperatives() async {
    await GeneralServices.getCooperatives().then((list) => {
          setState(() {
            for (int i = 0; i < list.length; i++) {
              Cooperative cooperative = Cooperative.fromJson(list[i]);
              cooperatives!.add(cooperative);
            }
            cooperativesLoaded = true;
          })
        });
  }

  //functions for data pickers
  _loadCountries() async {
    String data = isUS
        ? await DefaultAssetBundle.of(context)
            .loadString('assets/countries.json')
        : await DefaultAssetBundle.of(context)
            .loadString('assets/guatemala_countries.json');
    final jsonResult = jsonDecode(data);
    setState(() {
      for (int i = 0; i < jsonResult.length; i++) {
        Country country = Country.fromJson(jsonResult[i]);
        countries.add(country);
      }
    });
  }

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
      RegistrationSuccessResponse registrationSuccessResponse =
          RegistrationSuccessResponse.fromJson(json);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RegistrationResultsScreen(
                  registrationSuccessResponse: registrationSuccessResponse)));
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
      _emailController.text = '';
      _identificationNumberController.text = '';
      _mobileNumberController.text = '';
      _lastNameController.text = '';
      _firstNameController.text = '';
      _recomendationNumberController.text = "";
      termsConditionAccepted = false;
    });
  }

  //Execute registration
  _executeTransaction(BuildContext context) async {
    setState(() {
      isProcessing = true;
    });

    if (isGT) {
      setState(() {
        promoCode = selectedCooperative!.id.toString();
      });
    }

    if (isUS) {
      setState(() {
        promoCode = _recomendationNumberController.text;
      });
    }
    await GeneralServices.getCustomerRegistration(
            promoCode,
            _firstNameController.text,
            _lastNameController.text,
            _mobileNumberController.text,
            _emailController.text,
            selectedCountry!.alpha3.toString(),
            selectedDocumentType!.ID.toString(),
            _identificationNumberController.text)
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
    _loadCountries();
    _loadDocumentTypes();
    _getCountryScope();
    _getCooperatives();
    super.initState();
  }

  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Registro'),
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
                          cooperativesLoaded && isGT
                              ? Container(
                                  child: DropdownButton<Cooperative>(
                                    hint: const Text(
                                        'Seleccione una para su registro'),
                                    value: selectedCooperative,
                                    onChanged: (Cooperative? value) {
                                      setState(() {
                                        selectedCooperative = value;
                                      });
                                    },
                                    items: cooperatives!
                                        .map((Cooperative cooperative) {
                                      return DropdownMenuItem<Cooperative>(
                                        value: cooperative,
                                        child: Container(
                                          padding:
                                              const EdgeInsets.only(left: 5.0),
                                          width: 250,
                                          child: Text(
                                            cooperative.name.toString(),
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
                              : const SizedBox(
                                  height: 0.001,
                                ),
                          isUS
                              ? Container(
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'No Recomendación *',
                                        errorStyle: TextStyle(
                                          fontSize: 8,
                                        )),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Campo obligatorio';
                                      }
                                    },
                                    controller: _recomendationNumberController,
                                  ),
                                  decoration: const BoxDecoration(
                                    color: Color(0XFFEFEFEF),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                  height: 50.0,
                                  margin: const EdgeInsets.only(
                                      bottom: 5.0, top: 5.0),
                                  padding: const EdgeInsets.only(left: 10.0),
                                )
                              : SizedBox(
                                  height: 0.001,
                                ),
                          Container(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Nombres *',
                                  errorStyle: TextStyle(
                                    fontSize: 8,
                                  )),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Campo obligatorio';
                                }
                              },
                              controller: _firstNameController,
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
                                hintText: 'Apellidos *',
                                errorStyle: TextStyle(
                                  fontSize: 8,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Campo obligatorio';
                                }
                              },
                              controller: _lastNameController,
                            ),
                            decoration: const BoxDecoration(
                                color: Color(0XFFEFEFEF),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            height: 50.0,
                            margin: const EdgeInsets.only(bottom: 5.0),
                            padding: const EdgeInsets.only(left: 10),
                          ),
                          Container(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Teléfono *',
                                  errorStyle: TextStyle(
                                    fontSize: 8,
                                  )),
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Campo obligatorio';
                                }
                              },
                              controller: _mobileNumberController,
                            ),
                            decoration: const BoxDecoration(
                              color: Color(0xFFEFEFEF),
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
                                  hintText: 'Correo Electrónico *',
                                  errorStyle: TextStyle(
                                    fontSize: 8,
                                  )),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Campo obligatorio';
                                }
                              },
                              controller: _emailController,
                            ),
                            decoration: const BoxDecoration(
                              color: Color(0XFFEFEFEF),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            height: 50.0,
                            margin: const EdgeInsets.only(bottom: 5.0),
                            padding: const EdgeInsets.only(left: 5.0),
                          ),
                          Container(
                            child: DropdownButton<Country>(
                              hint: const Text('Seleccionar País'),
                              value: selectedCountry,
                              onChanged: (Country? value) {
                                setState(() {
                                  selectedCountry = value;
                                });
                              },
                              items: countries.map((Country country) {
                                return DropdownMenuItem<Country>(
                                  value: country,
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    width: 250,
                                    child: Text(
                                      country.name,
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
                                  hintText: 'Número de identificación *',
                                  errorStyle: TextStyle(
                                    fontSize: 8,
                                  )),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Campo obligatorio';
                                }
                              },
                              controller: _identificationNumberController,
                            ),
                            decoration: const BoxDecoration(
                              color: Color(0xFFEFEFEF),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            height: 50.0,
                            margin: const EdgeInsets.only(bottom: 5.0),
                            padding: const EdgeInsets.only(left: 10.0),
                          ),
                          Container(
                            child: Row(
                              children: [
                                Checkbox(
                                  value: termsConditionAccepted,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      termsConditionAccepted = value!;
                                    });
                                  },
                                ),
                                Text.rich(TextSpan(children: [
                                  TextSpan(
                                      text:
                                          'Yo acepto los Terminos y \n Condicones del Titular de la Cuenta',
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          String url =
                                              "https://gpspay.io/spa/xcmo/securew/TERMINOS_Y_CONDICIONES_GENERALES_DEL_SISTEMA_GPS.PDF";
                                          if (isUS) {
                                            url =
                                                "https://gpspay.io/spa/xcmo/securew/TERMINOS_Y_CONDICIONES_GENERALES_DEL_SISTEMA_GPS.PDF";
                                          }
                                          if (isGT) {
                                            url =
                                                "https://host2.ypayme.com/spa/xcmo/securew/TERMINOS%20Y%20CONDICIONES%20CON%20LLEGA.PDF";
                                          }
                                          var urlLaunchAble = await canLaunch(
                                              url); //canLaunch is from url_launcher package
                                          if (urlLaunchAble) {
                                            await launch(
                                                url); //launch is from url_launcher package to launch URL
                                          } else {
                                            return;
                                          }
                                        },
                                      style: const TextStyle(
                                          color: Colors.blueAccent,
                                          decoration: TextDecoration.underline))
                                ])),
                              ],
                            ),
                            decoration: const BoxDecoration(
                              color: Color(0xFFEFEFEF),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            height: 90.0,
                            margin: const EdgeInsets.only(bottom: 5.0),
                            padding: const EdgeInsets.only(left: 10.0),
                          ),
                          Visibility(
                            child: Container(
                              child: TextButton(
                                child: const Text(
                                  'Registrarse',
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
                                      BorderRadius.all(Radius.circular(10))),
                              width: screenWidth,
                            ),
                            visible: !isProcessing && termsConditionAccepted,
                          )
                        ],
                      ),
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      height: 600.0,
                      width: screenWidth,
                    ),
                    top: 5.0,
                  ),
                  Positioned(
                    child: Visibility(
                      child: Container(
                        child: const Text(
                          'Espere..\n procesando registro...',
                          style: TextStyle(color: Colors.white, fontSize: 28.0),
                        ),
                        decoration: const BoxDecoration(color: Colors.grey),
                        height: 100.0,
                        width: screenWidth,
                        padding: const EdgeInsets.all(10.0),
                      ),
                      visible: isProcessing,
                    ),
                    top: screenHeight - 180.0,
                  ),
                ],
              )),
              height: screenHeight,
              width: screenWidth,
            ),
          ),
        ));
  }
}
