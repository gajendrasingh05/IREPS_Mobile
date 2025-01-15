import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/udm/crc_digitally_signed/model/crc_myfinalised_data.dart';
import 'package:flutter_app/udm/crc_digitally_signed/repo/CrcRepository.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/utils/UdmUtilities.dart';
import 'package:jiffy/jiffy.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum CrcMyfinalisedViewModelState {Idle, Busy, Finished, FinishedWithError}

enum CrcMyfinalisedCheckMonthState {greater, less}

class CrcMyfinalisedViewModel with ChangeNotifier{

  CrcMyfinalisedCheckMonthState _monthCount = CrcMyfinalisedCheckMonthState.less;
  CrcMyfinalisedViewModelState _state = CrcMyfinalisedViewModelState.Idle;
  Error? _error;
  List<MyfinalisedCrcData> _items = [];

  List<MyfinalisedCrcData> _duplicateitems = [];


  Error? get error {
    return _error;
  }

  List<MyfinalisedCrcData> get crcmyfinaliseddatalist {
    return _items;
  }

  void setCrclistData(List<MyfinalisedCrcData> items){
    _items = items;
  }

  void setState(CrcMyfinalisedViewModelState currentState) {
    _state = currentState;
    notifyListeners();
  }

  CrcMyfinalisedViewModelState get state {
    return _state;
  }

  void setMonth(CrcMyfinalisedCheckMonthState monthCount){
    _monthCount = monthCount;
    notifyListeners();
  }

  CrcMyfinalisedCheckMonthState get monthcountstate{
    return _monthCount;
  }

  void getCrcMyfinalisedData(String fromdate, String todate, BuildContext context) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(CrcMyfinalisedViewModelState.Busy);
    CrcRepository crcRepository = CrcRepository(context);
    try{
      Future<List<MyfinalisedCrcData>> data = crcRepository.fetchcrcmyfinalisedData("MyFinalized_CRC", prefs.getString("userzone").toString(),prefs.getString("consigneecode"), prefs.getString("subconsigneecode").toString(), fromdate, todate,  context);
      data.then((value){
        if(value.isEmpty || value.length == 0){
          setState(CrcMyfinalisedViewModelState.Idle);
          IRUDMConstants().showSnack('Data not found.', context);
        }
        else if(value.isNotEmpty || value.length != 0){
          _items.clear();
          _duplicateitems.addAll(value);
          setCrclistData(value);
          setState(CrcMyfinalisedViewModelState.Finished);
        }
        else{
          setState(CrcMyfinalisedViewModelState.FinishedWithError);
        }
      });
    }
    on Exception catch(err){
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  void getsearchMyfinalisedcrcData(String query, BuildContext context){
    if(query.isNotEmpty && query.length > 0){
      CrcRepository crcRepository = CrcRepository(context);
      try{
        Future<List<MyfinalisedCrcData>> data = crcRepository.fetchsearchmyfinalisedcrc(_duplicateitems, query);
        data.then((value) {
          setCrclistData(value);
          setState(CrcMyfinalisedViewModelState.Finished);
        });
      }
      on Exception catch(err){}
    }
    else if(query.isEmpty || query.length == 0 || query == ""){
      setCrclistData(_duplicateitems);
      setState(CrcMyfinalisedViewModelState.Finished);
    }
    else{
      setCrclistData(_duplicateitems);
      setState(CrcMyfinalisedViewModelState.Finished);
    }

  }

  checkdateDiff(String fromDate, String toDate, DateFormat formatter, BuildContext context){

    DateTime dt1 = DateTime.parse(fromDate.split('-').reversed.join('-')); // Convert to yyyy-MM-dd
    DateTime dt2 = DateTime.parse(toDate.split('-').reversed.join('-')); // Convert to yyyy-MM-dd

    // Calculate the difference in days
    int days = dt2.difference(dt1).inDays;
    //int month = int.parse("${dt2.diff(dt1, Units.MONTH)}");
    if(days >= 210){
      setMonth(CrcMyfinalisedCheckMonthState.greater);
      UdmUtilities.showAlertDialog(context);
    }
    else{
      setMonth(CrcMyfinalisedCheckMonthState.less);
    }
    //dt1.add(months: month);

    //var days = dt2.diff(dt1, Units.DAY);
  }

}
