import 'package:flutter/material.dart';

class ChangeScrollVisibilityProvider with ChangeNotifier{

  bool awaitUiscrollValue = false;
  bool awaitUivisibiltyValue = false;

  bool fwdUiscrollValue = false;
  bool fwdUivisibiltyValue = false;

  bool dashUiscrollValue = false;
  bool dashUivisibilityValue = false;

  //--- DashBoard UI
  bool get getDashUiScrollValue => dashUiscrollValue;
  void setdashScrollValue(bool value){
    dashUiscrollValue = value;
    notifyListeners();
  }

  bool get getdashUiVisibilityValue => dashUivisibilityValue;
  void setdashUiVisibilityValue(bool value){
    dashUivisibilityValue = value;
    notifyListeners();
  }

  //--- Await UI

  bool get getAwaitUiScrollValue => awaitUiscrollValue;

  void setAwaitScrollValue(bool value){
    awaitUiscrollValue = value;
    notifyListeners();
  }

  bool get getawaitUiVisibilityValue => awaitUivisibiltyValue;
  void setAwaitVisibilityValue(bool value){
    awaitUivisibiltyValue = value;
    notifyListeners();
  }

  //---- Fwd UI
  bool get getFwdUiScrollValue => fwdUiscrollValue;

  void setfwdScrollValue(bool value){
    fwdUiscrollValue = value;
    notifyListeners();
  }

  bool get getFwdVisibilityValue => fwdUivisibiltyValue;

  void setFwdVisibilityValue(bool value){
    fwdUivisibiltyValue = value;
    notifyListeners();
  }

}