import 'package:flutter/material.dart';
import 'package:to_do_test/page/home/home.dart';
import 'package:to_do_test/provider/sf_provider.dart';

class PinCodeController extends ChangeNotifier {
  PinCodeController(this.context);
  SFProvider sfProvider = SFProvider();

  final BuildContext context;
  String enteredPin = '';

  setValue(String val) async {
    if (enteredPin.length < 6) {
      enteredPin += val;
      notifyListeners();

      if (enteredPin.length == 6 && enteredPin == '123456') {
        sfProvider.addStringToSF(SFProvider.sfPinCodeKey, enteredPin);
        await Future.delayed(const Duration(milliseconds: 300));
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
                (route) => false);
      }
    }
  }

  deleteValue() async {
    if (enteredPin.length > 0) {
      enteredPin = enteredPin.split('').sublist(0, enteredPin.length - 1).join('');
      notifyListeners();
    }
  }
}