import 'package:flutter/material.dart';

class SearchRWADCScreenProvider with ChangeNotifier{
  bool _rwadsearchvalue = false;

  bool get getrwadSearchValue => _rwadsearchvalue;

  void updateScreen(bool useraction){
    _rwadsearchvalue = useraction;
    notifyListeners();
  }
}