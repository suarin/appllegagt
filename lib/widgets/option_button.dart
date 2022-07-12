import 'package:flutter/material.dart';
import 'package:appllegagt/widgets/constants.dart';

class OptionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPress;

  const OptionButton({
    Key? key,
    required this.label,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        child: Text(
          label,
          style: kOptionButtonTextStyle,
        ),
        onPressed: onPress,
      ),
      decoration: kOptionContainerStyle,
      width: 325.0,
      margin: const EdgeInsets.only(bottom: 5.0),
    );
  }
}
