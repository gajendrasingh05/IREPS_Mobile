import 'package:flutter/material.dart';

class ChangeRWADCScrollVisibilityProvider with ChangeNotifier{

  bool rwadcUishowscroll = false;
  bool rwadcUiscrollValue = false;

  //--- Rejection Warranty UI
  bool get getRWADCUiScrollValue => rwadcUiscrollValue;
  void setRWADCScrollValue(bool value){
    rwadcUiscrollValue = value;
    notifyListeners();
  }

  bool get getRWADCUiShowScroll => rwadcUishowscroll;
  void setRWADCShowScroll(bool value){
    rwadcUishowscroll = value;
    notifyListeners();
  }
}