import 'package:flutter/material.dart';

class SearchRWScreenProvider with ChangeNotifier{
  bool _searchvalue = false;

  bool get getSearchValue => _searchvalue;

  void updateScreen(bool useraction){
    _searchvalue = useraction;
    notifyListeners();
  }
}