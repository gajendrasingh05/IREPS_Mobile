import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/udm/crc_digitally_signed/model/CrcfinalzedData.dart';
import 'package:flutter_app/udm/crc_digitally_signed/repo/CrcRepository.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/utils/UdmUtilities.dart';
import 'package:jiffy/jiffy.dart';
import 'package:shared_preferences/shared_preferences.dart';


enum CrcFinalisedViewModelDataState {Idle, Busy, Finished, FinishedWithError}

enum CrcFinalisedCheckMonthState {greater, less}

class CrcfinalizedViewModel with ChangeNotifier{

  CrcFinalisedCheckMonthState _monthCount = CrcFinalisedCheckMonthState.less;
  CrcFinalisedViewModelDataState _state = CrcFinalisedViewModelDataState.Idle;
  Error? _error;
  List<CrcfinalzData> _items = [];

  List<CrcfinalzData> _duplicateitems = [];


  Error? get error {
    return _error;
  }

  List<CrcfinalzData> get crcfinaliseddatalist {
    return _items;
  }

  void setCrclistData(List<CrcfinalzData> items){
    _items = items;
  }

  void setState(CrcFinalisedViewModelDataState currentState) {
    _state = currentState;
    notifyListeners();
  }

  CrcFinalisedViewModelDataState get state {
    return _state;
  }

  void setMonth(CrcFinalisedCheckMonthState monthCount){
    _monthCount = monthCount;
    notifyListeners();
  }

  CrcFinalisedCheckMonthState get monthcountstate{
    return _monthCount;
  }

  void getCrcFinalzedData(String fromdate, String todate, BuildContext context) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(CrcFinalisedViewModelDataState.Busy);
    CrcRepository crcRepository = CrcRepository(context);
    try{
      Future<List<CrcfinalzData>> data = crcRepository.fetchcrcfinalizedData("FINALISEDCRC", prefs.getString("userzone").toString(), prefs.getString("userpostid").toString(), fromdate, todate,  context);
      data.then((value){
        if(value.isEmpty || value.length == 0){
          setState(CrcFinalisedViewModelDataState.Idle);
          IRUDMConstants().showSnack('Data not found.', context);
        }
        else if(value.isNotEmpty || value.length != 0){
          _items.clear();
          _duplicateitems.addAll(value);
          setCrclistData(value);
          setState(CrcFinalisedViewModelDataState.Finished);
        }
        else{
          setState(CrcFinalisedViewModelDataState.FinishedWithError);
        }
      });
    }
    on Exception catch(err){
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  void getsearchfinalisedcrcData(String query, BuildContext context){
    if(query.isNotEmpty && query.length > 0){
      CrcRepository crcRepository = CrcRepository(context);
      try{
        Future<List<CrcfinalzData>> data = crcRepository.fetchsearchfinalisedcrc(_duplicateitems, query);
        data.then((value) {
          setCrclistData(value);
          setState(CrcFinalisedViewModelDataState.Finished);
        });
      }
      on Exception catch(err){}
    }
    else if(query.isEmpty || query.length == 0 || query == ""){
      setCrclistData(_duplicateitems);
      setState(CrcFinalisedViewModelDataState.Finished);
    }
    else{
      setCrclistData(_duplicateitems);
      setState(CrcFinalisedViewModelDataState.Finished);
    }
  }

  checkdateDiff(String fromdate, String todate, DateFormat formatter, BuildContext context){

    DateTime dt1 = DateTime.parse(fromdate.split('-').reversed.join('-')); // Convert to yyyy-MM-dd
    DateTime dt2 = DateTime.parse(todate.split('-').reversed.join('-')); // Convert to yyyy-MM-dd

    // Calculate the difference in days
    int days = dt2.difference(dt1).inDays;
    if(days >= 210){
      setMonth(CrcFinalisedCheckMonthState.greater);
      UdmUtilities.showAlertDialog(context);
    }
    else{
      setMonth(CrcFinalisedCheckMonthState.less);
    }
  }
}