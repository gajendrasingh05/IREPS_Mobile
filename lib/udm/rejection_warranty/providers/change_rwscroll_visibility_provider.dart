import 'package:flutter/material.dart';

class ChangeRWScrollVisibilityProvider with ChangeNotifier{

  bool rwUiscrollValue = false;

  //--- Rejection Warranty UI
  bool get getRWUiScrollValue => rwUiscrollValue;
  void setRWScrollValue(bool value){
    rwUiscrollValue = value;
    notifyListeners();
  }
}