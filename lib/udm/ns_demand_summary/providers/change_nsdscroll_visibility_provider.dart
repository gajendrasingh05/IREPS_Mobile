import 'package:flutter/material.dart';

class ChangeNSDScrollVisibilityProvider with ChangeNotifier{

  bool nsdUishowscroll = false;
  bool nsdUiscrollValue = false;

  bool nsdlinkUishowscroll = false;
  bool nsdlinkUiscrollValue = false;

  bool _nsdPdfView = true;

  //--- NS Demand UI
  bool get getNSDUiScrollValue => nsdUiscrollValue;
  void setRWADCScrollValue(bool value){
    nsdUiscrollValue = value;
    notifyListeners();
  }

  bool get getNSDUiShowScroll => nsdUishowscroll;
  void setNSDShowScroll(bool value){
    nsdUishowscroll = value;
    notifyListeners();
  }

  bool get getNSDlinkUiScrollValue => nsdlinkUiscrollValue;
  void setRWADClinkScrollValue(bool value){
    nsdlinkUiscrollValue = value;
    notifyListeners();
  }

  bool get getNSDlinkUiShowScroll => nsdlinkUishowscroll;
  void setNSDlinkShowScroll(bool value){
    nsdlinkUishowscroll = value;
    notifyListeners();
  }

  bool get getNSDpdfViewValue => _nsdPdfView;
  void setNSDpdfView(bool value){
    _nsdPdfView = value;
    notifyListeners();
  }
}