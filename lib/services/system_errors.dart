

import 'dart:convert';

import 'package:appllegagt/models/general/system_error.dart';
import 'package:flutter/services.dart';

class SystemErrors{
  //Method for customer verification
  static Future<dynamic> getSystemError(int error) async {
    //Obtain System Erors
    String data =  await getJson();
    var jsonResponse = jsonDecode(data);

    List<SystemError> systemErrors = [];
    for (int i = 0; i < jsonResponse.length; i++) {
      SystemError systemError = SystemError.fromJson(jsonResponse[i]);
      systemErrors.add(systemError);
    }

    //Return System error

    for(int i=0; i< systemErrors.length; i++){
      if(error == systemErrors[i].errorCode){
        return '${systemErrors[i].spanishDescription} / ${systemErrors[i].englishDescription}';
      }
    }

    return "Error no definido/Error undefined";
  }

  static Future<String> getJson() async {
    return await rootBundle.loadString('assets/system_errors.json');
  }
}