import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InsurancePayScreen extends StatefulWidget {
  const InsurancePayScreen({Key? key}) : super(key: key);

  @override
  _InsurancePayScreenState createState() => _InsurancePayScreenState();
}

  class _InsurancePayScreenState extends State<InsurancePayScreen> {
  @override
  void initState() {
  super.initState();
  _openURL(); // Call _openURL when the screen is initialized
  }

  // Function to open the URL with url_launcher
  _openURL() async {
    Uri url = Uri.parse('https://web.llega.com/spa/xpay/securew/naserpagos.html');
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Afiliacion a Repatriacion'),
        backgroundColor: const Color(0xFF0E325F), // Updated color code
      ),
      body: Center(
          child: Text('Abriendo Pagina....'),
        ),
    );
  }
}
