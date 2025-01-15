import 'package:flutter/material.dart';

class SearchScreenProvider with ChangeNotifier{
  bool _searchvalue = false;

  bool get getSearchValue => _searchvalue;

  void updateScreen(bool useraction){
    _searchvalue = useraction;
    notifyListeners();
  }
}