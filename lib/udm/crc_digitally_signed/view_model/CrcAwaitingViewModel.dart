import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/udm/crc_digitally_signed/model/CrcAwaitingData.dart';
import 'package:flutter_app/udm/crc_digitally_signed/repo/CrcRepository.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/utils/UdmUtilities.dart';
import 'package:jiffy/jiffy.dart';
import 'package:shared_preferences/shared_preferences.dart';


enum CrcAwaitingViewModelDataState {Idle, Busy, Finished, FinishedWithError}

enum CrcAwaitCheckMonthState {greater, less}

class CrcAwaitingViewModel with ChangeNotifier{

  CrcAwaitCheckMonthState _monthCount = CrcAwaitCheckMonthState.less;
  CrcAwaitingViewModelDataState _state = CrcAwaitingViewModelDataState.Idle;
  Error? _error;
  List<CrcAwaitData> _items = [];
  List<CrcAwaitData> _duplicateitems = [];


  Error? get error {
    return _error;
  }

  List<CrcAwaitData> get crcawaitingdatalist {
    return _items;
  }

  void setCrclistData(List<CrcAwaitData> items){
    _items = items;
  }

  void setState(CrcAwaitingViewModelDataState currentState) {
    _state = currentState;
    notifyListeners();
  }

  CrcAwaitingViewModelDataState get state {
    return _state;
  }

  void setMonth(CrcAwaitCheckMonthState monthCount){
    _monthCount = monthCount;
    notifyListeners();
  }

  CrcAwaitCheckMonthState get monthcountstate{
    return _monthCount;
  }

  void getCrcAwaitData(String fromdate, String todate, BuildContext context) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(CrcAwaitingViewModelDataState.Busy);
    CrcRepository crcRepository = CrcRepository(context);
    try{
      Future<List<CrcAwaitData>> data = crcRepository.fetchcrcawaitData("AWAITINGCRC", prefs.getString("userzone").toString(), prefs.getString("userpostid").toString(), fromdate, todate,  context);
      data.then((value){
        if(value.isEmpty || value.length == 0){
          setState(CrcAwaitingViewModelDataState.Idle);
          IRUDMConstants().showSnack('Data not found.', context);
        }
        else if(value.isNotEmpty || value.length != 0){
          _items.clear();
          _duplicateitems.addAll(value);
          setCrclistData(value);
          setState(CrcAwaitingViewModelDataState.Finished);
        }
        else{
          setState(CrcAwaitingViewModelDataState.FinishedWithError);
        }
      });
    }
    on Exception catch(err){
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  void getsearchAwaitcrcData(String query, BuildContext context){
    if(query.isNotEmpty && query.length > 0){
      CrcRepository crcRepository = CrcRepository(context);
      try{
        Future<List<CrcAwaitData>> data = crcRepository.fetchsearchawaitingcrc(_duplicateitems, query);
        data.then((value) {
          setCrclistData(value);
          setState(CrcAwaitingViewModelDataState.Finished);
        });
      }
      on Exception catch(err){}
    }
    else if(query.isEmpty || query.length == 0 || query == ""){
      setCrclistData(_duplicateitems);
      setState(CrcAwaitingViewModelDataState.Finished);
    }
    else{
      setCrclistData(_duplicateitems);
      setState(CrcAwaitingViewModelDataState.Finished);
    }
  }

  checkdateDiff(String fromDate, String toDate, DateFormat formatter, BuildContext context){

    // Parse the dates using DateTime
    DateTime dt1 = DateTime.parse(fromDate.split('-').reversed.join('-')); // Convert to yyyy-MM-dd
    DateTime dt2 = DateTime.parse(toDate.split('-').reversed.join('-')); // Convert to yyyy-MM-dd

    // Calculate the difference in days
    int days = dt2.difference(dt1).inDays;
    if(days >= 210){
      setMonth(CrcAwaitCheckMonthState.greater);
      UdmUtilities.showAlertDialog(context);
    }
    else{
      setMonth(CrcAwaitCheckMonthState.less);
    }
  }

}