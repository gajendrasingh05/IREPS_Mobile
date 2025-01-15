import 'package:flutter/material.dart';

class ChangeRWFCScrollVisibilityProvider with ChangeNotifier{

  bool rwfcUishowscroll = false;
  bool rwfcUiscrollValue = false;

  //--- Rejection Warranty UI
  bool get getRWFCUiScrollValue => rwfcUiscrollValue;
  void setRWFCScrollValue(bool value){
    rwfcUiscrollValue = value;
    notifyListeners();
  }

  bool get getRWFCUiShowScroll => rwfcUishowscroll;
  void setRWFCShowScroll(bool value){
    rwfcUishowscroll = value;
    notifyListeners();
  }
}