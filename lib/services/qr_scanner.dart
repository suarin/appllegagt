import 'package:flutter/services.dart';
import 'package:barcode_scan2/barcode_scan2.dart';

class QRScanner {
  String result;

  QRScanner({
    required this.result
  });

  static Future<dynamic> scanQR() async{
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      var result = await BarcodeScanner.scan();
      return result.rawContent;
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    return barcodeScanRes;
  }
}

