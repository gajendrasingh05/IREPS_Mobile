import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/udm/crc_digitally_signed/model/crc_myforwarded_data.dart';
import 'package:flutter_app/udm/crc_digitally_signed/repo/CrcRepository.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/utils/UdmUtilities.dart';
import 'package:jiffy/jiffy.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum CrcMyforwardedViewModelState {Idle, Busy, Finished, FinishedWithError}

enum CrcMyforwardedCheckMonthState {greater, less}

class CrcMyforwardedViewModel with ChangeNotifier{

  CrcMyforwardedCheckMonthState _monthCount = CrcMyforwardedCheckMonthState.less;
  CrcMyforwardedViewModelState _state = CrcMyforwardedViewModelState.Idle;
  Error? _error;
  List<MyforwardedCrcData> _items = [];

  List<MyforwardedCrcData> _duplicateitems = [];


  Error? get error {
    return _error;
  }

  List<MyforwardedCrcData> get crcmyforwarededlistdata {
    return _items;
  }

  void setCrclistData(List<MyforwardedCrcData> items){
    _items = items;
  }

  void setState(CrcMyforwardedViewModelState currentState) {
    _state = currentState;
    notifyListeners();
  }

  CrcMyforwardedViewModelState get state {
    return _state;
  }

  void setMonth(CrcMyforwardedCheckMonthState monthCount){
    _monthCount = monthCount;
    notifyListeners();
  }

  CrcMyforwardedCheckMonthState get monthcountstate{
    return _monthCount;
  }

  Future<void> getCrcMyforwardedData(String fromdate, String todate, BuildContext context) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(CrcMyforwardedViewModelState.Busy);
    CrcRepository crcRepository = CrcRepository(context);
    try{
      Future<List<MyforwardedCrcData>> data = crcRepository.fetchcrcmyforwardedData("MyForwardedCRC", prefs.getString("userzone").toString(), prefs.getString("consigneecode"), prefs.getString("subconsigneecode").toString(), fromdate, todate,  context);
      data.then((value){
        if(value.isEmpty || value.length == 0){
          setState(CrcMyforwardedViewModelState.Idle);
          IRUDMConstants().showSnack('Data not found.', context);
        }
        else if(value.isNotEmpty || value.length != 0){
          _items.clear();
          _duplicateitems.addAll(value);
          setCrclistData(value);
          setState(CrcMyforwardedViewModelState.Finished);
        }
        else{
          setState(CrcMyforwardedViewModelState.FinishedWithError);
        }
      });
    }
    on Exception catch(err){
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  Future<void> getsearchMyforwardedcrcData(String query, BuildContext context) async{
    if(query.isNotEmpty && query.length > 0){
      CrcRepository crcRepository = CrcRepository(context);
      try{
        Future<List<MyforwardedCrcData>> data = crcRepository.fetchsearchmyforwardedcrc(_duplicateitems, query);
        data.then((value) {
          setCrclistData(value);
          setState(CrcMyforwardedViewModelState.Finished);
        });
      }
      on Exception catch(err){}
    }
    else if(query.isEmpty || query.length == 0 || query == ""){
      setCrclistData(_duplicateitems);
      setState(CrcMyforwardedViewModelState.Finished);
    }
    else{
      setCrclistData(_duplicateitems);
      setState(CrcMyforwardedViewModelState.Finished);
    }

  }

  checkdateDiff(String fromDate, String toDate, DateFormat formatter, BuildContext context){

    DateTime dt1 = DateTime.parse(fromDate.split('-').reversed.join('-')); // Convert to yyyy-MM-dd
    DateTime dt2 = DateTime.parse(toDate.split('-').reversed.join('-')); // Convert to yyyy-MM-dd

    // Calculate the difference in days
    int days = dt2.difference(dt1).inDays;
    if(days >= 210){
      setMonth(CrcMyforwardedCheckMonthState.greater);
      UdmUtilities.showAlertDialog(context);
    }
    else{
      setMonth(CrcMyforwardedCheckMonthState.less);
    }
  }

}
