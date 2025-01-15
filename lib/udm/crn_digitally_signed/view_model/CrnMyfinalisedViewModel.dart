import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter_app/udm/crn_digitally_signed/model/crn_myfinalised_data.dart';
import 'package:flutter_app/udm/crn_digitally_signed/repo/CrnRepository.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/utils/UdmUtilities.dart';
import 'package:jiffy/jiffy.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum CrnMyfinalisedViewModelState {Idle, Busy, Finished, FinishedWithError}

enum CrnMyfinalisedCheckMonthState {greater, less}

class CrnMyfinalisedViewModel with ChangeNotifier{

  CrnMyfinalisedCheckMonthState _monthCount = CrnMyfinalisedCheckMonthState.less;
  CrnMyfinalisedViewModelState _state = CrnMyfinalisedViewModelState.Idle;
  Error? _error;
  List<MyfinalisedCrnData> _items = [];

  List<MyfinalisedCrnData> _duplicateitems = [];


  Error? get error {
    return _error;
  }

  List<MyfinalisedCrnData> get crnmyfinalisedlistdata {
    return _items;
  }

  void setCrnlistData(List<MyfinalisedCrnData> items){
    _items = items;
  }

  void setState(CrnMyfinalisedViewModelState currentState) {
    _state = currentState;
    notifyListeners();
  }

  CrnMyfinalisedViewModelState get state {
    return _state;
  }

  void setMonth(CrnMyfinalisedCheckMonthState monthCount){
    _monthCount = monthCount;
    notifyListeners();
  }

  CrnMyfinalisedCheckMonthState get monthcountstate{
    return _monthCount;
  }

  void getCrnMyfinalisedData(String fromdate, String todate, BuildContext context) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(CrnMyfinalisedViewModelState.Busy);
    CrnRepository crnRepository = CrnRepository(context);
    try{
      Future<List<MyfinalisedCrnData>> data = crnRepository.fetchcrnmyfinalisedData("MyFinalizedClassCRN", prefs.getString("userzone").toString(), prefs.getString("consigneecode").toString(), prefs.getString("subconsigneecode").toString(), fromdate, todate,  context);
      data.then((value){
        if(value.isEmpty || value.length == 0){
          setState(CrnMyfinalisedViewModelState.Idle);
          IRUDMConstants().showSnack('Data not found.', context);
        }
        else if(value.isNotEmpty || value.length != 0){
          _items.clear();
          _duplicateitems.addAll(value);
          setCrnlistData(value);
          setState(CrnMyfinalisedViewModelState.Finished);
        }
        else{
          setState(CrnMyfinalisedViewModelState.FinishedWithError);
        }
      });
    }
    on Exception catch(err){
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  void getsearchMyfinalisedcrnData(String query, BuildContext context){
    if(query.isNotEmpty && query.length > 0){
      CrnRepository crnRepository = CrnRepository(context);
      try{
        Future<List<MyfinalisedCrnData>> data = crnRepository.fetchsearchmyfinalisedcrn(_duplicateitems, query);
        data.then((value) {
          setCrnlistData(value);
          setState(CrnMyfinalisedViewModelState.Finished);
        });
      }
      on Exception catch(err){}
    }
    else if(query.isEmpty || query.length == 0 || query == ""){
      setCrnlistData(_duplicateitems);
      setState(CrnMyfinalisedViewModelState.Finished);
    }
    else{
      setCrnlistData(_duplicateitems);
      setState(CrnMyfinalisedViewModelState.Finished);
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
      setMonth(CrnMyfinalisedCheckMonthState.greater);
      UdmUtilities.showAlertDialog(context);
    }
    else{
      setMonth(CrnMyfinalisedCheckMonthState.less);
    }
    //dt1.add(months: month);

    //var days = dt2.diff(dt1, Units.DAY);
  }

}
