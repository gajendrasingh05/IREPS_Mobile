import 'package:flutter/material.dart';

class CustomRadioController extends ChangeNotifier {
  int index;
  bool isFocus = false;
  CustomRadioController(this.index);

  setValue(int index) {
    this.index = index;
    notifyListeners();
  }

  setFocus() {
    this.isFocus = true;
    notifyListeners();
  }

  removeFocus() {
    this.isFocus = false;
    notifyListeners();
  }

  reset() {
    this.index = 0;
    notifyListeners();
  }
}
