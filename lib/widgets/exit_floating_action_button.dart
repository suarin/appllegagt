import 'package:flutter/material.dart';
import 'package:appllegagt/screens/startup_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExitFloatingActionButton extends StatelessWidget {
  final BuildContext context;
  const ExitFloatingActionButton({Key? key, required this.context})
      : super(key: key);

  _cleanPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('cHolderID', 0);
    await prefs.setString('userID', '');
    await prefs.setString('userName', '');
    await prefs.setString('cardNo', '');
    await prefs.setString('currency', '');
    await prefs.setString('balance', '');
    await prefs.setBool('isScanning', false);
  }

  _logOut() async {
    _cleanPreferences();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const StartupScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: _logOut,
      tooltip: 'Salir',
      child: const Icon(Icons.exit_to_app),
      backgroundColor: const Color(0xFF0E2238),
    );
  }
}
