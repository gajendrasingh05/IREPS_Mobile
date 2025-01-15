import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/udm/utils/UdmUtilities.dart';
import 'package:jiffy/jiffy.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/shared_data.dart';
import '../model/CrnfinalizedData.dart';
import '../repo/CrnRepository.dart';

enum CrnFinalisedViewModelDataState {Idle, Busy, Finished, FinishedWithError}
enum CrnFinalisedCheckMonthState {greater, less}

class CrnfinalizedViewModel with ChangeNotifier{

  CrnFinalisedCheckMonthState _monthCount = CrnFinalisedCheckMonthState.less;

  CrnFinalisedViewModelDataState _state = CrnFinalisedViewModelDataState.Idle;
  Error? _error;
  List<CrnfinalzData> _items = [];

  List<CrnfinalzData> _duplicateitems = [];


  Error? get error {
    return _error;
  }

  List<CrnfinalzData> get crnfinaliseddatalist {
    return _items;
  }

  void setCrnlistData(List<CrnfinalzData> items){
    _items = items;
  }

  void setState(CrnFinalisedViewModelDataState currentState) {
     _state = currentState;
     notifyListeners();
  }

  CrnFinalisedViewModelDataState get state {
    return _state;
  }

  void setMonth(CrnFinalisedCheckMonthState monthCount){
    _monthCount = monthCount;
    notifyListeners();
  }

  CrnFinalisedCheckMonthState get monthcountstate{
    return _monthCount;
  }

  void getCrnFinalzedData(String fromdate, String todate, BuildContext context) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(CrnFinalisedViewModelDataState.Busy);
    CrnRepository crnRepository = CrnRepository(context);
    try{
      Future<List<CrnfinalzData>> data = crnRepository.fetchcrnfinalizedData("FINALISEDCRN", prefs.getString("userzone").toString(), prefs.getString("userpostid").toString(), fromdate, todate,  context);
      data.then((value){
        if(value.isEmpty || value.length == 0){
          setState(CrnFinalisedViewModelDataState.Idle);
          IRUDMConstants().showSnack('Data not found.', context);
        }
        else if(value.isNotEmpty || value.length != 0){
          _items.clear();
          _duplicateitems.addAll(value);
          setCrnlistData(value);
          setState(CrnFinalisedViewModelDataState.Finished);
        }
        else{
          setState(CrnFinalisedViewModelDataState.FinishedWithError);
        }
      });
    }
    on Exception catch(err){
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  void getsearchfinalisedcrnData(String query, BuildContext context){
    if(query.isNotEmpty && query.length > 0){
      CrnRepository crnRepository = CrnRepository(context);
      try{
        Future<List<CrnfinalzData>> data = crnRepository.fetchsearchfinalisedcrn(_duplicateitems, query);
        data.then((value) {
          setCrnlistData(value);
          setState(CrnFinalisedViewModelDataState.Finished);
        });
      }
      on Exception catch(err){}
    }
    else if(query.isEmpty || query.length == 0 || query == ""){
      setCrnlistData(_duplicateitems);
      setState(CrnFinalisedViewModelDataState.Finished);
    }
    else{
      setCrnlistData(_duplicateitems);
      setState(CrnFinalisedViewModelDataState.Finished);
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
      setMonth(CrnFinalisedCheckMonthState.greater);
      UdmUtilities.showAlertDialog(context);
    }
    else{
      setMonth(CrnFinalisedCheckMonthState.less);
    }
    //dt1.add(months: month);

    //var days = dt2.diff(dt1, Units.DAY);
  }
}