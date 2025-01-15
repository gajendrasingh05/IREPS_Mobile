import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/udm/crn_digitally_signed/model/crn_myforwarded_data.dart';
import 'package:flutter_app/udm/crn_digitally_signed/repo/CrnRepository.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/utils/UdmUtilities.dart';
import 'package:jiffy/jiffy.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum CrnMyforwardedViewModelState {Idle, Busy, Finished, FinishedWithError}

enum CrnMyforwardedCheckMonthState {greater, less}

class CrnMyforwardedViewModel with ChangeNotifier{

  CrnMyforwardedCheckMonthState _monthCount = CrnMyforwardedCheckMonthState.less;
  CrnMyforwardedViewModelState _state = CrnMyforwardedViewModelState.Idle;
  Error? _error;
  List<MyforwardedCrnData> _items = [];

  List<MyforwardedCrnData> _duplicateitems = [];


  Error? get error {
    return _error;
  }

  List<MyforwardedCrnData> get crnmyforwdedlistadata {
    return _items;
  }

  void setCrnlistData(List<MyforwardedCrnData> items){
    _items = items;
  }

  void setState(CrnMyforwardedViewModelState currentState) {
    _state = currentState;
    notifyListeners();
  }

  CrnMyforwardedViewModelState get state {
    return _state;
  }

  void setMonth(CrnMyforwardedCheckMonthState monthCount){
    _monthCount = monthCount;
    notifyListeners();
  }

  CrnMyforwardedCheckMonthState get monthcountstate{
    return _monthCount;
  }

  void getCrnMyforwardedData(String fromdate, String todate, BuildContext context) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(CrnMyforwardedViewModelState.Busy);
    CrnRepository crnRepository = CrnRepository(context);
    try{
      Future<List<MyforwardedCrnData>> data = crnRepository.fetchcrnmyforwardedData("MyForwardedCRN", prefs.getString("userzone").toString(), prefs.getString("consigneecode").toString(), prefs.getString("subconsigneecode").toString(), fromdate, todate,  context);
      data.then((value){
        if(value.isEmpty || value.length == 0){
          setState(CrnMyforwardedViewModelState.Idle);
          IRUDMConstants().showSnack('Data not found.', context);
        }
        else if(value.isNotEmpty || value.length != 0){
          _items.clear();
          _duplicateitems.addAll(value);
          setCrnlistData(value);
          setState(CrnMyforwardedViewModelState.Finished);
        }
        else{
          setState(CrnMyforwardedViewModelState.FinishedWithError);
        }
      });
    }
    on Exception catch(err){
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  void getsearchMyforwardedcrnData(String query, BuildContext context){
    if(query.isNotEmpty && query.length > 0){
      CrnRepository crnRepository = CrnRepository(context);
      try{
        Future<List<MyforwardedCrnData>> data = crnRepository.fetchsearchmyforwardedcrn(_duplicateitems, query);
        data.then((value) {
           setCrnlistData(value);
           setState(CrnMyforwardedViewModelState.Finished);
        });
      }
      on Exception catch(err){}
    }
    else if(query.isEmpty || query.length == 0 || query == ""){
      setCrnlistData(_duplicateitems);
      setState(CrnMyforwardedViewModelState.Finished);
    }
    else{
      setCrnlistData(_duplicateitems);
      setState(CrnMyforwardedViewModelState.Finished);
    }

  }


  checkdateDiff(String fromDate, String toDate, DateFormat formatter, BuildContext context){

    // Parse the dates using DateTime
    DateTime dt1 = DateTime.parse(fromDate.split('-').reversed.join('-')); // Convert to yyyy-MM-dd
    DateTime dt2 = DateTime.parse(toDate.split('-').reversed.join('-')); // Convert to yyyy-MM-dd

    // Calculate the difference in days
    int days = dt2.difference(dt1).inDays;
    if(days >= 210){
      setMonth(CrnMyforwardedCheckMonthState.greater);
      UdmUtilities.showAlertDialog(context);
    }
    else{
      setMonth(CrnMyforwardedCheckMonthState.less);
    }
  }

}
