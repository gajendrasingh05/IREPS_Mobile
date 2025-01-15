import 'package:flutter/material.dart';

class SearchNSDScreenProvider with ChangeNotifier{
  bool _rwadsearchvalue = false;
  bool _nsdlinksearchvalue = false;
  bool _nsdtextchangelistener = false;
  bool _showhidemicglow = false;

  bool get getrwadSearchValue => _rwadsearchvalue;

  bool get getnsdlinksearchValue => _nsdlinksearchvalue;

  bool get getchangetextlistener => _nsdtextchangelistener;

  bool get getshowhidemicglow => _showhidemicglow;

  void updateScreen(bool useraction){
    _rwadsearchvalue = useraction;
    notifyListeners();
  }

  void updatelinkScreen(bool useraction){
    _nsdlinksearchvalue = useraction;
    notifyListeners();
  }

  void updatetextchangeScreen(bool useraction){
    _nsdtextchangelistener = useraction;
    notifyListeners();
  }

  void showhidemicglow(bool useraction){
    _showhidemicglow = useraction;
    notifyListeners();
  }
}