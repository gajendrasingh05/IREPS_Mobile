import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ChangeVisibilityProvider with ChangeNotifier{

    bool visibilityValue = true;

    bool scrollValue = false;
    bool scrollBottomValue = false;

    bool changeColorValue = false;

    bool get getVisibility{
      return visibilityValue;
    }

    void setVisibility(bool value){
      visibilityValue = value;
      notifyListeners();
    }

    bool get getScrollValue{
      return scrollValue;
    }

    void setScrollValue(bool value){
      scrollValue = value;
      notifyListeners();
    }

    bool get getScrollBottomValue{
      return scrollBottomValue;
    }

    void setScrollBottomValue(bool value){
      scrollBottomValue = value;
      notifyListeners();
    }

    bool get getChangeColorValue{
      return changeColorValue;
    }

    void setChangeColorValue(bool value){
      changeColorValue = value;
      notifyListeners();
    }
}