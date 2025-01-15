import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/rejection_warranty/models/rejectionwarrantyapproveddropped.dart';
import 'package:flutter_app/udm/rejection_warranty/models/rejectionwarrantyforwarded.dart';
import 'package:flutter_app/udm/rejection_warranty/models/status_data.dart';
import 'package:flutter_app/udm/rejection_warranty/providers/change_rwadscroll_visibility_provider.dart';
import 'package:flutter_app/udm/rejection_warranty/providers/change_rwfcscroll_visibility_provider.dart';
import 'package:flutter_app/udm/rejection_warranty/repo/rejectionwarranty_repo.dart';
import 'package:flutter_app/udm/utils/UdmUtilities.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

enum RwDataState {Idle, Busy, Finished, NoData, FinishedWithError}
enum RwStatusDataState {Idle, Busy, Finished, FinishedWithError}
enum RwfcDataState {Idle, Busy, Finished, NoData, FinishedWithError}
enum RwadcDataState {Idle, Busy, Finished, NoData, FinishedWithError}
enum RWfcCheckMonthState {greater, less}
enum RWadcCheckMonthState {greater, less}

class RejectionWarrantyViewModel with ChangeNotifier{

  RwStatusDataState _statusDataState = RwStatusDataState.Idle;
  RwDataState _rwDataState = RwDataState.Idle;

  RwfcDataState _rwfcDataState = RwfcDataState.Idle;
  RwadcDataState _rwadcDataState = RwadcDataState.Idle;

  RWfcCheckMonthState _fcmonthCount = RWfcCheckMonthState.less;
  RWadcCheckMonthState _adcmonthCount = RWadcCheckMonthState.less;

  List<Status> _statusitems = [];
  List<dynamic> _rwitems = [];

  //----- Rejection Warranty Forwarded Claims ------
  List<WarrantyforwardedData> _rwfcitems = [];
  List<WarrantyforwardedData> _duplicaterwfcitems = [];
  int _rwfctotalcount = 0;
  double _rwfctotalvalue = 0.0;

  //----- Rejection Warranty Approved/Dropped Claims ------
  List<ApprovedDroppedData> _rwadcitems = [];
  List<ApprovedDroppedData> _duplicaterwadcitems = [];
  int _rwadctotalcount = 0;
  double _rwadctotalvalue = 0.0;

  // --- Status Data ---
  List<Status> get statusitems => _statusitems;
  void setStatusData(List<Status> items){
    _statusitems = items;
  }
  RwStatusDataState get statusstate => _statusDataState;
  void setStatusState(RwStatusDataState currentState) {
    _statusDataState = currentState;
    notifyListeners();
  }

  // ---- RW Data ---
  List<dynamic> get rwitems => _rwitems;
  void setRWData(List<dynamic> items){
    _rwitems = items;
  }

  RwDataState get rwstate => _rwDataState;
  void setRWState(RwDataState currentState) {
    _rwDataState = currentState;
    notifyListeners();
  }

  // --- RW Forwarded Claims Data ----
  List<WarrantyforwardedData> get rwfcitems => _rwfcitems;
  void setRWFCData(List<WarrantyforwardedData> items){
    _rwfcitems = items;
  }

  int get rwfctotcount => _rwfctotalcount;
  void setrwfctotcount(int totcount){
    _rwfctotalcount = totcount;
    notifyListeners();
  }

  double get rwfctotvalue => _rwfctotalvalue;
  void setrwfctotvalue(double totvalue){
    _rwfctotalvalue = totvalue;
    notifyListeners();
  }

  RwfcDataState get rwfcstate => _rwfcDataState;
  void setRWFCState(RwfcDataState currentState) {
    _rwfcDataState = currentState;
    notifyListeners();
  }

  // --- RW Approved/Dropped Claims Data ----
  List<ApprovedDroppedData> get rwadcitems => _rwadcitems;
  void setRWADCData(List<ApprovedDroppedData> items){
    _rwadcitems = items;
  }

  int get rwadctotcount => _rwadctotalcount;
  void setrwadctotcount(int totcount){
    _rwadctotalcount = totcount;
    notifyListeners();
  }

  double get rwadctotvalue => _rwadctotalvalue;
  void setrwadctotvalue(double totvalue){
    _rwadctotalvalue = totvalue;
    notifyListeners();
  }

  RwadcDataState get rwadcstate => _rwadcDataState;
  void setRWADCState(RwadcDataState currentState) {
    _rwadcDataState = currentState;
    notifyListeners();
  }

  //--- Forwarded Claims Month State ---
  void setRWFCMonth(RWfcCheckMonthState monthCount){
    _fcmonthCount = monthCount;
    notifyListeners();
  }

  RWfcCheckMonthState get fcmonthcountstate{
    return _fcmonthCount;
  }

  //--- Approved/Dropped Month State ---
  void setRWADCMonth(RWadcCheckMonthState monthCount){
    _adcmonthCount = monthCount;
    notifyListeners();
  }

  RWadcCheckMonthState get adcmonthcountstate{
    return _adcmonthCount;
  }


  Future<void> getStatusData(BuildContext context) async{
    RejectionWarrantyRepo rejectionWarrantyRepo = RejectionWarrantyRepo(context);
    setStatusState(RwStatusDataState.Busy);
    try{
      Future<List<Status>> data = rejectionWarrantyRepo.fetchStatusData();
      data.then((value){
        if(value.isEmpty || value.length == 0){
          setStatusData(value);
          setStatusState(RwStatusDataState.FinishedWithError);
          //IRUDMConstants().showSnack('Data not found.', context);
        }
        else if(value.isNotEmpty || value.length != 0){
          setStatusData(value);
          setStatusState(RwStatusDataState.Finished);
        }
        else{
          setStatusState(RwStatusDataState.FinishedWithError);
        }
      });
    }
    on Exception catch(err){
      setStatusState(RwStatusDataState.FinishedWithError);
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  Future<void> getRWData(BuildContext context) async{
    RejectionWarrantyRepo rejectionWarrantyRepo = RejectionWarrantyRepo(context);
    setRWState(RwDataState.Busy);
    try{
      Future<List<Status>> data = rejectionWarrantyRepo.fetchRWData();
      data.then((value){
        if(value.isEmpty || value.length == 0){
          setRWData(value);
          setRWState(RwDataState.FinishedWithError);
          //IRUDMConstants().showSnack('Data not found.', context);
        }
        else if(value.isNotEmpty || value.length != 0){
          setRWData(value);
          setRWState(RwDataState.NoData);
        }
        else{
          setRWState(RwDataState.FinishedWithError);
        }
      });
    }
    on Exception catch(err){
      setRWState(RwDataState.FinishedWithError);
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  Future<void> getRWFClaimsData(String fromdate, String todate, String query, BuildContext context) async{
    RejectionWarrantyRepo rejectionWarrantyRepo = RejectionWarrantyRepo(context);
    setRWFCState(RwfcDataState.Busy);
    setrwfctotcount(0);
    setrwfctotvalue(0.0);
    Provider.of<ChangeRWFCScrollVisibilityProvider>(context, listen: false).setRWFCShowScroll(false);
    Provider.of<ChangeRWFCScrollVisibilityProvider>(context, listen: false).setRWFCScrollValue(false);
    try{
      Future<List<WarrantyforwardedData>> data = rejectionWarrantyRepo.fetchmyforwardedClaimsData("Warranty_Forwarded", fromdate, todate, query, context);
      data.then((value){
        if(value.isEmpty || value.length == 0){
          setRWFCData(value);
          setRWFCState(RwfcDataState.NoData);
        }
        else if(value.isNotEmpty || value.length != 0){
          data.then((value) {
            value.forEach((element) {
              _rwfctotalvalue = _rwfctotalvalue + double.parse(element.transvalue.toString());
            });
            if(value.length > 2){
              Provider.of<ChangeRWFCScrollVisibilityProvider>(context, listen: false).setRWFCShowScroll(true);
            }
            _duplicaterwfcitems = value;
            setRWFCData(value);
            setrwfctotcount(value.length);
            setrwfctotvalue(_rwfctotalvalue);
            setRWFCState(RwfcDataState.Finished);
          });
        }
        else{
          setRWFCState(RwfcDataState.NoData);
        }
      });
    }
    on Exception catch(err){
      setRWFCState(RwfcDataState.FinishedWithError);
      IRUDMConstants().showSnack(err.toString(), context);
    }
  }

  Future<void> getRWADClaimsData(String fromdate, String todate, String query, BuildContext context) async{
    RejectionWarrantyRepo rejectionWarrantyRepo = RejectionWarrantyRepo(context);
    setRWADCState(RwadcDataState.Busy);
    setrwadctotcount(0);
    setrwadctotvalue(0.0);
    Provider.of<ChangeRWADCScrollVisibilityProvider>(context, listen: false).setRWADCShowScroll(false);
    Provider.of<ChangeRWADCScrollVisibilityProvider>(context, listen: false).setRWADCScrollValue(false);
    try{
      Future<List<ApprovedDroppedData>> data = rejectionWarrantyRepo.fetchmyapproveddroppedClaimsData("Finalized", fromdate, todate, query, context);
      data.then((value){
        if(value.isEmpty || value.length == 0){
          setRWADCData(value);
          setRWADCState(RwadcDataState.NoData);
        }
        else if(value.isNotEmpty || value.length != 0){
          data.then((value) {
            value.forEach((element) {
              _rwadctotalvalue = _rwadctotalvalue + double.parse(element.transvalue.toString());
            });
            if(value.length > 2){
              Provider.of<ChangeRWADCScrollVisibilityProvider>(context, listen: false).setRWADCShowScroll(true);
            }
            _duplicaterwadcitems = value;
            setRWADCData(value);
            setrwadctotcount(value.length);
            setrwadctotvalue(_rwadctotalvalue);
            setRWADCState(RwadcDataState.Finished);
          });
        }
        else{
          setRWADCState(RwadcDataState.NoData);
        }
      });
    }
    on Exception catch(err){
      setRWADCState(RwadcDataState.FinishedWithError);
      IRUDMConstants().showSnack(err.toString(), context);
    }

  }

  //---Search Operation----

  void searchingRWFCData(String query, BuildContext context){
    if(query.isNotEmpty && query.length > 0){
      _rwfctotalvalue = 0.0;
      RejectionWarrantyRepo rejectionWarrantyRepo = RejectionWarrantyRepo(context);
      try{
        Future<List<WarrantyforwardedData>> data = rejectionWarrantyRepo.fetchSearchRWFCData(_duplicaterwfcitems, query);
        data.then((value) {
          value.forEach((element) {
            _rwfctotalvalue = _rwfctotalvalue + double.parse(element.transvalue.toString());
          });
          if(value.length > 2){
            Provider.of<ChangeRWFCScrollVisibilityProvider>(context, listen: false).setRWFCShowScroll(true);
          }
          else{
            Provider.of<ChangeRWFCScrollVisibilityProvider>(context, listen: false).setRWFCShowScroll(false);
          }
          setRWFCData(value);
          setrwfctotcount(value.length);
          setrwfctotvalue(_rwfctotalvalue);
          setRWFCState(RwfcDataState.Finished);
        });
      }
      on Exception catch(err){
      }
    }
    else if(query.isEmpty || query.length == 0 || query == "" || query == null){
      _rwfctotalvalue = 0.0;
      _duplicaterwfcitems.forEach((element) {
        _rwfctotalvalue = _rwfctotalvalue + double.parse(element.transvalue.toString());
      });
      if(_duplicaterwfcitems.length > 2){
        Provider.of<ChangeRWFCScrollVisibilityProvider>(context, listen: false).setRWFCShowScroll(true);
      }
      else{
        Provider.of<ChangeRWFCScrollVisibilityProvider>(context, listen: false).setRWFCShowScroll(false);
      }
      setRWFCData(_duplicaterwfcitems);
      setrwfctotcount(_duplicaterwfcitems.length);
      setrwfctotvalue(_rwfctotalvalue);
      setRWFCState(RwfcDataState.Finished);
    }
    else{
      _rwfctotalvalue = 0.0;
      _duplicaterwfcitems.forEach((element) {
        _rwfctotalvalue = _rwfctotalvalue + double.parse(element.transvalue.toString());
      });
      if(_duplicaterwfcitems.length > 2){
        Provider.of<ChangeRWFCScrollVisibilityProvider>(context, listen: false).setRWFCShowScroll(true);
      }
      else{
        Provider.of<ChangeRWFCScrollVisibilityProvider>(context, listen: false).setRWFCShowScroll(false);
      }
      setRWFCData(_duplicaterwfcitems);
      setrwfctotcount(_duplicaterwfcitems.length);
      setrwfctotvalue(_rwfctotalvalue);
      setRWFCState(RwfcDataState.Finished);
    }
  }

  void searchingRWADCData(String query, BuildContext context) {
    if(query.isNotEmpty && query.length > 0){
      _rwadctotalvalue = 0.0;
      RejectionWarrantyRepo rejectionWarrantyRepo = RejectionWarrantyRepo(context);
      try{
        Future<List<ApprovedDroppedData>> data = rejectionWarrantyRepo.fetchSearchRWADCData(_duplicaterwadcitems, query);
        data.then((value) {
          value.forEach((element) {
            _rwadctotalvalue = _rwadctotalvalue + double.parse(element.transvalue.toString());
          });
          if(value.length > 2){
            Provider.of<ChangeRWADCScrollVisibilityProvider>(context, listen: false).setRWADCShowScroll(true);
          }
          else{
            Provider.of<ChangeRWADCScrollVisibilityProvider>(context, listen: false).setRWADCShowScroll(false);
          }
          setRWADCData(value);
          setrwadctotcount(value.length);
          setrwadctotvalue(_rwadctotalvalue);
          setRWADCState(RwadcDataState.Finished);
        });
      }
      on Exception catch(err){
      }
    }
    else if(query.isEmpty || query.length == 0 || query == "" || query == null){
      _rwadctotalvalue = 0.0;
      _duplicaterwadcitems.forEach((element) {
        _rwadctotalvalue = _rwadctotalvalue + double.parse(element.transvalue.toString());
      });
      if(_duplicaterwadcitems.length > 2){
        Provider.of<ChangeRWADCScrollVisibilityProvider>(context, listen: false).setRWADCShowScroll(true);
      }
      else{
        Provider.of<ChangeRWADCScrollVisibilityProvider>(context, listen: false).setRWADCShowScroll(false);
      }
      setRWADCData(_duplicaterwadcitems);
      setrwadctotcount(_duplicaterwadcitems.length);
      setrwadctotvalue(_rwadctotalvalue);
      setRWADCState(RwadcDataState.Finished);
    }
    else{
      _rwadctotalvalue = 0.0;
      _duplicaterwadcitems.forEach((element) {
        _rwadctotalvalue = _rwadctotalvalue + double.parse(element.transvalue.toString());
      });
      if(_duplicaterwadcitems.length > 2){
        Provider.of<ChangeRWADCScrollVisibilityProvider>(context, listen: false).setRWADCShowScroll(true);
      }
      else{
        Provider.of<ChangeRWADCScrollVisibilityProvider>(context, listen: false).setRWADCShowScroll(false);
      }
      setRWADCData(_duplicaterwadcitems);
      setrwfctotcount(_duplicaterwadcitems.length);
      setrwfctotvalue(_rwadctotalvalue);
      setRWADCState(RwadcDataState.Finished);
    }
  }


  // -- Forwarded Claims Month Difference ----

  checkfcdateDiff(String fromdate, String todate, DateFormat formatter, BuildContext context){

    DateTime dt1 = DateTime.parse(fromdate.split('-').reversed.join('-')); // Convert to yyyy-MM-dd
    DateTime dt2 = DateTime.parse(todate.split('-').reversed.join('-')); // Convert to yyyy-MM-dd

    // Calculate the difference in days
    int days = dt2.difference(dt1).inDays;

    if(days > 180){
      setRWFCMonth(RWfcCheckMonthState.greater);
      UdmUtilities.showAlertDialog(context);
    }
    else{
      setRWFCMonth(RWfcCheckMonthState.less);
    }
    //dt1.add(months: month);

    //var days = dt2.diff(dt1, Units.DAY);
  }

  // --- Approved/Dropped Month Difference ----

  void checkAdcDateDiff(String fromDate, String toDate, DateFormat formatter, BuildContext context) {
    /// Parse the dates using DateTime
    DateTime dt1 = DateTime.parse(fromDate.split('-').reversed.join('-')); // Convert to yyyy-MM-dd
    DateTime dt2 = DateTime.parse(toDate.split('-').reversed.join('-')); // Convert to yyyy-MM-dd

    // Calculate the difference in days
    int days = dt2.difference(dt1).inDays;

    if (days > 180) {
      setRWADCMonth(RWadcCheckMonthState.greater);
      UdmUtilities.showAlertDialog(context); // Show alert for greater than 180 days
    } else {
      setRWADCMonth(RWadcCheckMonthState.less); // Less than or equal to 180 days
    }
  }


  checkadcdateDiff(String fromdate, String todate, DateFormat formatter, BuildContext context){

    // Parse the dates using DateTime
    DateTime dt1 = DateTime.parse(fromdate.split('-').reversed.join('-')); // Convert to yyyy-MM-dd
    DateTime dt2 = DateTime.parse(todate.split('-').reversed.join('-')); // Convert to yyyy-MM-dd

    // Calculate the difference in days
    int days = dt2.difference(dt1).inDays;

    if(days > 180){
      setRWADCMonth(RWadcCheckMonthState.greater);
      UdmUtilities.showAlertDialog(context);
    }
    else{
      setRWADCMonth(RWadcCheckMonthState.less);
    }
    //dt1.add(months: month);

    //var days = dt2.diff(dt1, Units.DAY);
  }
}