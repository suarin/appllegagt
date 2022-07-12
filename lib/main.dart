import 'package:appllegagt/screens/select_country_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const Llega());
}

class Llega extends StatelessWidget {
  const Llega({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SelectCountryScreen(),
      title: 'LLega',
    );
  }
}
