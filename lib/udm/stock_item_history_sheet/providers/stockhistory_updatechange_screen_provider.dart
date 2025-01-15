import 'package:flutter/material.dart';


class StockHistoryupdateChangesScreenProvider with ChangeNotifier{

  bool _searchvalue = false;

  bool _updatebtn = false;

  bool get getSearchValue => _searchvalue;

  bool get getUpdateBtnValue => _updatebtn;

  void updateScreen(bool useraction){
     _searchvalue = useraction;
     notifyListeners();
  }

  void updateBtn(bool useractionbtn){
    _updatebtn = useractionbtn;
    notifyListeners();
  }

}