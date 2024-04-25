import 'package:flutter/material.dart';
import 'package:appllegagt/generated/l10n.dart';

class PaypalDisclosureWidget extends StatelessWidget {
  final String text;

  PaypalDisclosureWidget({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.redAccent,
          fontFamily: 'VarelaRoundRegular',
          fontWeight: FontWeight.bold,
        ),
      ),
      decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0XFF01ACCA),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(30.0))),
      margin: const EdgeInsets.only(bottom: 15.0),
      padding: const EdgeInsets.all(10.0),
      width: 300,
    );
  }
}
