import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:appllegagt/services/api_resources.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:enough_convert/enough_convert.dart';

class GeneralServices {

  static Future<dynamic> getCHolderID() async{
    String reqCHolderID='0';
    final prefs = await SharedPreferences.getInstance();
    if (prefs.get('cHolderID') != null) {
      reqCHolderID = prefs.get('cHolderID').toString();
    }
    return reqCHolderID;
  }
  static Future<dynamic> reqMerchantID() async{
    var merchantScope='0';
    final prefs = await SharedPreferences.getInstance();
    if (prefs.get('merchantId') != null) {
      merchantScope = dotenv.env[prefs.getString('merchantId')]!;
    }
    return merchantScope;
  }
  static Future<dynamic> reqToken() async{
    var tokenScope='0';
    final prefs = await SharedPreferences.getInstance();
    if (prefs.get('token') != null) {
      tokenScope = dotenv.env[prefs.getString('token')]!;
    }
    return tokenScope;
  }
  static Future<dynamic> getBaseUrl() async{
    var baseUrlScope='0';
    final prefs = await SharedPreferences.getInstance();
    if (prefs.get('baseUrl') != null) {
      baseUrlScope = dotenv.env[prefs.getString('baseUrl')]!;
    }
    return baseUrlScope;
  }

  static Future<dynamic> getCustomerRegistration(
      String reqPromotionCode,
      String reqFirstName,
      String reqLastName,
      String reqMobileNo,
      String reqEmail,
      String reqCountryID,
      String reqSINTypeID,
      String reqSIN) async {
    var merchantId = await reqMerchantID();
    var token = await reqToken();
    var baseUrl = await getBaseUrl();
    //Prepare Uri
    var url = Uri.parse('${baseUrl + ApiResources.registrationUri}?ReqMerchantID=$merchantId&ReqToken=$token&ReqPromotionCode=$reqPromotionCode&ReqFirstName=$reqFirstName&ReqLastName=$reqLastName&ReqMobileNo=$reqMobileNo&ReqEmail=$reqEmail&ReqCountryID=$reqCountryID&ReqSINTypeID=$reqSINTypeID&ReqSIN=$reqSIN');
    //send get for registration with parameters ReqMerchantID, ReqToken, ReqFirstName, ReqLastName, ReqMobileNo, ReqEmail, ReqCountryID, ReqSINTypeID, ReqSIN
    http.Response response;
    try{
      response = await http.get(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
        },
      );
    }catch(e){
      return 'Error en el envio http ${e.toString()}';
    }

    //Validates that http response is ok code 200
    if (response.statusCode == 200) {
      //if is ok return the decoded body of response, returns: CHolderID, UserName, CardNo, Currency and Balance
      const codec = Windows1252Codec(allowInvalid: false);

      final decoded = codec.decode(response.bodyBytes);

      try{
        return json.decode(decoded);
      }catch(e){
        return 'Error en el objeto: ${e.toString()}';
      }
    } else {
      return 'Error en el servidor: ${response.body}';
    }
  }

  static Future<dynamic> getLogin(
      String reqUserID,
      String reqPassword) async {
    var merchantId = await reqMerchantID();
    var token = await reqToken();
    var baseUrl = await getBaseUrl();
    //Prepare Uri
    var url = Uri.parse('${baseUrl + ApiResources.loginUri}?ReqMerchantID=$merchantId&ReqToken=$token&ReqUserID=$reqUserID&ReqPassword=$reqPassword');
    //send get for registration with parameters ReqMerchantID, ReqToken, ReqUserID, ReqPassword
    http.Response response;
    try{
      response = await http.get(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
        },
      );
    }catch(e){
      return 'Error en el envio http ${e.toString()}';
    }

    //Validates that http response is ok code 200

    if (response.statusCode == 200) {
      //if is ok return the decoded body of response, returns: CHolderID, UserName, CardNo, Currency and Balance
      const codec = Windows1252Codec(allowInvalid: false);
      final decoded = codec.decode(response.bodyBytes);
      try{
        return json.decode(decoded);
      }catch(e){
        return 'Error en el objeto: ${e.toString()}';
      }
    } else {
      return 'Error en el servidor: ${response.body}';
    }
  }

  static Future<dynamic> getWebPinChange(
      String reqPassword,
      String reqPIN1,
      String reqPIN2) async{
    var merchantId = await reqMerchantID();
    var token = await reqToken();
    var baseUrl = await getBaseUrl();
    //get CHolderID
    var reqCHolderID = await getCHolderID();
    //Prepare Uri
    var url = Uri.parse('${baseUrl + ApiResources.webPinChangeUri}?ReqMerchantID=$merchantId&ReqToken=$token&ReqCHolderID=$reqCHolderID&ReqPassword=$reqPassword&ReqPIN1=$reqPIN1&ReqPIN2=$reqPIN2');
    //Send card transfer
    http.Response response;
    try{
      response = await http.get(
          url,
          headers: {
            HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
          }
      );
    }catch(e){
      return 'Error: ${e.toString()}';
    }
    //validates that http response is ok code 200
    if (response.statusCode == 200) {
      //if is ok return the decoded body of response, returns: CHolderID, UserName, CardNo, Currency and Balance
      const codec = Windows1252Codec(allowInvalid: false);
      final decoded = codec.decode(response.bodyBytes);
      try{
        return json.decode(decoded);
      }catch(e){
        return 'Error json deoce: ${e.toString()}';
      }
    } else {
      return 'Error en el servidor: ${response.body}';
    }
  }

  static Future<dynamic> getPasswordChange(
      String reqPIN1,
      String reqPIN2) async{
    var merchantId = await reqMerchantID();
    var token = await reqToken();
    var baseUrl = await getBaseUrl();
    //get CHolderID
    var reqCHolderID = await getCHolderID();
    //Prepare Uri
    var url = Uri.parse('${baseUrl + ApiResources.passwordChangeUri}?ReqMerchantID=$merchantId&ReqToken=$token&ReqCHolderID=$reqCHolderID&ReqPIN1=$reqPIN1&ReqPIN2=$reqPIN2');
    //Send card transfer
    http.Response response;
    try{
      response = await http.get(
          url,
          headers: {
            HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
          }
      );
    }catch(e){
      return 'Error: ${e.toString()}';
    }
    //validates that http response is ok code 200
    if (response.statusCode == 200) {
      //if is ok return the decoded body of response, returns: CHolderID, UserName, CardNo, Currency and Balance
      const codec = Windows1252Codec(allowInvalid: false);
      final decoded = codec.decode(response.bodyBytes);
      try{
        return json.decode(decoded);
      }catch(e){
        return 'Error json decode: ${e.toString()}';
      }
    } else {
      return 'Error en el servidor: ${response.body}';
    }

  }

  static Future<dynamic> getVisaRequest(
      String reqPassword,
      String reqAddress,
      String reqCityID,
      String reqProvinceID,
      String reqZipCode,
      String reqPhone) async{
    var merchantId = await reqMerchantID();
    var token = await reqToken();
    var baseUrl = await getBaseUrl();
    //get CHolderID
    var reqCHolderID = await getCHolderID();
    //Prepare Uri
    var url = Uri.parse('${baseUrl + ApiResources.visaRequestUri}?ReqMerchantID=$merchantId&ReqToken=$token&ReqCHolderID=$reqCHolderID&ReqPassword=$reqPassword&ReqAddress=$reqAddress&ReqCityID=$reqCityID&ReqProvinceID=$reqProvinceID&ReqZipCode=$reqProvinceID&ReqPhone=$reqPhone');
    //Send card transfer
    http.Response response;
    try{
      response = await http.get(
          url,
          headers: {
            HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
          }
      );
    }catch(e){
      return 'Error: ${e.toString()}';
    }
    //validates that http response is ok code 200
    if (response.statusCode == 200) {
      //if is ok return the decoded body of response, returns: CHolderID, UserName, CardNo, Currency and Balance
      const codec = Windows1252Codec(allowInvalid: false);
      final decoded = codec.decode(response.bodyBytes);
      try{
        return json.decode(decoded);
      }catch(e){
        return 'Error json decode: ${e.toString()}';
      }
    } else {
      return 'Error en el servidor: ${response.body}';
    }
  }

  static Future<dynamic> getVisaBalance(
      String reqVisaCardNo) async{
    var merchantId = await reqMerchantID();
    var token = await reqToken();
    var baseUrl = await getBaseUrl();
    //get CHolderID
    var reqCHolderID = await getCHolderID();
    //Prepare Uri
    var url = Uri.parse('${baseUrl + ApiResources.visaBalanceUri}?ReqMerchantID=$merchantId&ReqToken=$token&ReqVisaCardNo=$reqVisaCardNo');
    //Send card transfer
    http.Response response;
    try{
      response = await http.get(
          url,
          headers: {
            HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
          }
      );
    }catch(e){
      return 'Error: ${e.toString()}';
    }
    //validates that http response is ok code 200
    if (response.statusCode == 200) {
      //if is ok return the decoded body of response, returns: CHolderID, UserName, CardNo, Currency and Balance
      const codec = Windows1252Codec(allowInvalid: false);
      final decoded = codec.decode(response.bodyBytes);
      try{
        return json.decode(decoded);
      }catch(e){
        return 'Error json decode: ${e.toString()}';
      }
    } else {
      return 'Error en el servidor: ${response.body}';
    }

  }

  static Future<dynamic> getVisaCards() async{
    var merchantId = await reqMerchantID();
    var token = await reqToken();
    var baseUrl = await getBaseUrl();
    //get CHolderID
    var reqCHolderID = await getCHolderID();
    //Prepare Uri
    var url = Uri.parse('${baseUrl + ApiResources.visaCardsUri}?ReqMerchantID=$merchantId&ReqToken=$token&ReqCHolderID=$reqCHolderID');
    //Send card transfer
    http.Response response;
    try{
      response = await http.get(
          url,
          headers: {
            HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
          }
      );
    }catch(e){
      return 'Error: ${e.toString()}';
    }
    //validates that http response is ok code 200
    if (response.statusCode == 200) {
      //if is ok return the decoded body of response, returns: CHolderID, UserName, CardNo, Currency and Balance
      const codec = Windows1252Codec(allowInvalid: false);
      final decoded = codec.decode(response.bodyBytes);
      try{
        return json.decode(decoded);
      }catch(e){
        return 'Error json decode: ${e.toString()}';
      }
    } else {
      return 'Error en el servidor: ${response.body}';
    }


  }

  static Future<dynamic> getCardTransactions(
      String reqPassword) async{
    var merchantId = await reqMerchantID();
    var token = await reqToken();
    var baseUrl = await getBaseUrl();
    //get CHolderID
    var reqCHolderID = await getCHolderID();
    //Prepare Uri
    var url = Uri.parse('${baseUrl + ApiResources.cardTransactionsUri}?ReqMerchantID=$merchantId&ReqToken=$token&ReqCHolderID=$reqCHolderID&ReqPassword=$reqPassword');
    //Send card transfer
    http.Response response;
    try{
      response = await http.get(
          url,
          headers: {
            HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
          }
      );
    }catch(e){
      return 'Error: ${e.toString()}';
    }
    //validates that http response is ok code 200
    if (response.statusCode == 200) {
      //if is ok return the decoded body of response, returns: CHolderID, UserName, CardNo, Currency and Balance
      const codec = Windows1252Codec(allowInvalid: true);
      final decoded = codec.decode(response.bodyBytes);

      try{
        return json.decode(decoded);
      }catch(e){
        return 'Error json decode: ${e.toString()}';
      }
    } else {
      return 'Error en el servidor: ${response.body}';
    }


  }

  static Future<dynamic> getVirtualCardBalance(
      String reqVisaCardNo) async{
    var merchantId = await reqMerchantID();
    var token = await reqToken();
    var baseUrl = await getBaseUrl();
    //get CHolderID
    var reqCHolderID = await getCHolderID();
    //Prepare Uri
    var url = Uri.parse('${baseUrl + ApiResources.virtualCardBalanceUri}?ReqMerchantID=$merchantId&ReqToken=$token&ReqVirtualCardNo=$reqVisaCardNo');
    //Send card transfer
    http.Response response;
    try{
      response = await http.get(
          url,
          headers: {
            HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
          }
      );
    }catch(e){
      return 'Error: ${e.toString()}';
    }
    //validates that http response is ok code 200
    if (response.statusCode == 200) {
      //if is ok return the decoded body of response, returns: CHolderID, UserName, CardNo, Currency and Balance
      const codec = Windows1252Codec(allowInvalid: false);
      final decoded = codec.decode(response.bodyBytes);
      try{
        return json.decode(decoded);
      }catch(e){
        return 'Error json decode: ${e.toString()}';
      }
    } else {
      return 'Error en el servidor: ${response.body}';
    }

  }

  static Future<dynamic> getVirtualCards() async{
    var merchantId = await reqMerchantID();
    var token = await reqToken();
    var baseUrl = await getBaseUrl();
    //get CHolderID
    var reqCHolderID = await getCHolderID();
    //Prepare Uri
    var url = Uri.parse('${baseUrl + ApiResources.virtualCardsUri}?ReqMerchantID=$merchantId&ReqToken=$token&ReqCHolderID=$reqCHolderID');
    //Send card transfer
    http.Response response;
    try{
      response = await http.get(
          url,
          headers: {
            HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
          }
      );
    }catch(e){
      return 'Error: ${e.toString()}';
    }
    //validates that http response is ok code 200
    if (response.statusCode == 200) {
      //if is ok return the decoded body of response, returns: CHolderID, UserName, CardNo, Currency and Balance
      const codec = Windows1252Codec(allowInvalid: false);
      final decoded = codec.decode(response.bodyBytes);
      try{
        return json.decode(decoded);
      }catch(e){
        return 'Error json decode: ${e.toString()}';
      }
    } else {
      return 'Error en el servidor: ${response.body}';
    }


  }

  static Future<dynamic> getBills() async{
    var merchantId = await reqMerchantID();
    var token = await reqToken();
    var baseUrl = await getBaseUrl();
    //get CHolderID
    var reqCHolderID = await getCHolderID();
    //Prepare Uri
    var url = Uri.parse('${baseUrl + ApiResources.billsUri}?ReqMerchantID=$merchantId&ReqToken=$token&ReqCardHolderID=$reqCHolderID');
    //Send card transfer
    http.Response response;
    try{
      response = await http.get(
          url,
          headers: {
            HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
          }
      );
    }catch(e){
      return 'Error: ${e.toString()}';
    }
    //validates that http response is ok code 200
    if (response.statusCode == 200) {
      //if is ok return the decoded body of response, returns: CHolderID, UserName, CardNo, Currency and Balance
      const codec = Windows1252Codec(allowInvalid: false);
      final decoded = codec.decode(response.bodyBytes);
      try{
        return json.decode(decoded);
      }catch(e){
        return 'Error json decode: ${e.toString()}';
      }
    } else {
      return 'Error en el servidor: ${response.body}';
    }

  }

  static Future<dynamic> getPayBill(
      String reqInvoiceNo,
      String reqCardNumber,
      String reqPassword,
      String reqAmount,
      String reqBillerID,
      String reqAccountNo,
      String reqRushPayment,
      ) async{
    var merchantId = await reqMerchantID();
    var token = await reqToken();
    var baseUrl = await getBaseUrl();
    //get CHolderID
    var reqCHolderID = await getCHolderID();
    //Prepare Uri
    var url = Uri.parse('${baseUrl + ApiResources.payBillUri}?ReqMerchantID=$merchantId&ReqToken=$token&ReqInvoiceNo=$reqInvoiceNo&ReqCardNumber=$reqCardNumber&ReqPassword=$reqPassword&ReqAmount=$reqAmount&ReqBillerID=$reqBillerID&ReqAccountNo=$reqAccountNo&ReqRushPayment=$reqRushPayment');
    //Send card transfer
    http.Response response;
    try{
      response = await http.get(
          url,
          headers: {
            HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
          }
      );
    }catch(e){
      return 'Error: ${e.toString()}';
    }
    //validates that http response is ok code 200
    if (response.statusCode == 200) {
      //if is ok return the decoded body of response, returns: CHolderID, UserName, CardNo, Currency and Balance
      const codec = Windows1252Codec(allowInvalid: false);
      final decoded = codec.decode(response.bodyBytes);
      try{
        return json.decode(decoded);
      }catch(e){
        return 'Error json decode: ${e.toString()}';
      }
    } else {
      return 'Error en el servidor: ${response.body}';
    }

  }

  static Future<dynamic> getAddAccounts(
      String setMethod,
      String reqUserID,
      String reqFirstName,
      String reqLastName
      ) async {

    //get CHolderID
    var reqCHolderID = await getCHolderID();
    var merchantId = await reqMerchantID();
    var token = await reqToken();
    var baseUrl = await getBaseUrl();

    //Prepare Uri
    var methodUri = setMethod == 'US' ? ApiResources.addAccounts : ApiResources.addAccountsYPayMe;
    var url = Uri.parse('${baseUrl + methodUri}?ReqMerchantID=$merchantId&ReqToken=$token&ReqCHolderID=$reqCHolderID&ReqUserID=$reqUserID&ReqFirstName=$reqFirstName&ReqLastName=$reqLastName');
    //Add account
    http.Response response;

    try{
      response = await http.get(
          url,
          headers: {
            HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
          }
      );
    }catch(e){
      return 'Error: ${e.toString()}';
    }

    //Validates that http response is ok code 200
    if(response.statusCode == 200){
      //if is ok return the decoded body of response returs the result of adding account
      const codec = Windows1252Codec(allowInvalid: false);
      final decoded = codec.decode(response.bodyBytes);
      try{
        return json.decode(decoded);
      }catch(e){
        return 'Error json decode: ${e.toString()}';
      }
    }

  }

}