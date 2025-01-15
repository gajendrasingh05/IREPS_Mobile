
import 'package:flutter/material.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/utils/UdmUtilities.dart';
import 'package:jiffy/jiffy.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/CrnAwaitingData.dart';
import '../repo/CrnRepository.dart';

enum CrnAwaitingViewModelDataState {Idle, Busy, Finished, FinishedWithError}

enum CrnAwaitCheckMonthState {greater, less}

class CrnAwaitingViewModel with ChangeNotifier {

  CrnAwaitCheckMonthState _monthCount = CrnAwaitCheckMonthState.less;
  CrnAwaitingViewModelDataState _state = CrnAwaitingViewModelDataState.Idle;
  Error? _error;
  List<CrnawaitData> _items = [];
  List<CrnawaitData> _duplicateitems = [];

  Error? get error {
    return _error;
  }

  List<CrnawaitData> get crnawaitingdatalist {
    return _items;
  }

  void setCrnlistData(List<CrnawaitData> items){
      _items = items;
  }

  void setState(CrnAwaitingViewModelDataState currentState) {
    _state = currentState;
    notifyListeners();
  }

  CrnAwaitingViewModelDataState get state {
    return _state;
  }


  void setMonth(CrnAwaitCheckMonthState monthCount){
    _monthCount = monthCount;
    notifyListeners();
  }

  CrnAwaitCheckMonthState get monthcountstate{
    return _monthCount;
  }

  void getCrnAwaitData(String fromdate, String todate, BuildContext context) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(CrnAwaitingViewModelDataState.Busy);
    CrnRepository crnRepository = CrnRepository(context);
    try{
      Future<List<CrnawaitData>> data = crnRepository.fetchcrnawaitData("AWAITINGCRN", prefs.getString("userzone").toString(), prefs.getString("userpostid").toString(), fromdate, todate,  context);
      data.then((value){
        if(value.isEmpty || value.length == 0){
          setState(CrnAwaitingViewModelDataState.Idle);
          IRUDMConstants().showSnack('Data not found.', context);
        }
        else if(value.isNotEmpty || value.length != 0){
          _items.clear();
          _duplicateitems.addAll(value);
          setCrnlistData(value);
          setState(CrnAwaitingViewModelDataState.Finished);
        }
        else{
          setState(CrnAwaitingViewModelDataState.FinishedWithError);
        }
      });
    }
    on Exception catch(err){
      IRUDMConstants().showSnack(err.toString(), context);
    }

  }

  void getsearchAwaitcrnData(String query, BuildContext context){
    if(query.isNotEmpty && query.length > 0){
      CrnRepository crnRepository = CrnRepository(context);
      try{
        Future<List<CrnawaitData>> data = crnRepository.fetchsearchawaitingcrn(_duplicateitems, query);
        data.then((value) {
          setCrnlistData(value);
          setState(CrnAwaitingViewModelDataState.Finished);
        });
      }
      on Exception catch(err){}
    }
    else if(query.isEmpty || query.length == 0 || query == ""){
      setCrnlistData(_duplicateitems);
      setState(CrnAwaitingViewModelDataState.Finished);
    }
    else{
      setCrnlistData(_duplicateitems);
      setState(CrnAwaitingViewModelDataState.Finished);
    }
  }

  checkdateDiff(String fromDate, String toDate, DateFormat formatter, BuildContext context){

    // Parse the dates using DateTime
    DateTime dt1 = DateTime.parse(fromDate.split('-').reversed.join('-')); // Convert to yyyy-MM-dd
    DateTime dt2 = DateTime.parse(toDate.split('-').reversed.join('-')); // Convert to yyyy-MM-dd

    // Calculate the difference in days
    int days = dt2.difference(dt1).inDays;

    //int month = int.parse("${dt2.diff(dt1, Units.MONTH)}");
    if(days >= 210){
      setMonth(CrnAwaitCheckMonthState.greater);
      UdmUtilities.showAlertDialog(context);
    }
    else{
      setMonth(CrnAwaitCheckMonthState.less);
    }
  }
}