import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:flutter_app/udm/helpers/database_helper.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';

import 'package:flutter_app/udm/models/summaryStock.dart';
import 'package:flutter_app/udm/screens/summaryAction.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/error.dart';

enum SummaryStockState { Idle, Busy, Finished, FinishedWithError }
enum SummaryStockResultState { Idle, Busy, Finished, FinishedWithError }
enum SummaryActionStockState { Idle, Busy, Finished, FinishedWithError }

class SummaryStockProvider with ChangeNotifier{
  List<SummaryStock>? _items;
  List<SummaryStock>? _duplicatesitems;
  Error? _error;
  List<Map<String, dynamic>>? dbResult;
  SummaryStockState _state = SummaryStockState.Idle;
  int? countData;
  bool countVis=false;

  var headerData,footerData,from_Date,to_Date;
  var issuValue,recQty,recValue,issueQty;

  //Summary Result Data
  SummaryStockResultState _summaryStockResultState = SummaryStockResultState.Idle;
  List<dynamic> summaryresultData = [];

  void setSummaryStockResultState(SummaryStockResultState currentState){
    _summaryStockResultState = currentState;
    notifyListeners();
  }

  SummaryStockResultState get summarystockresultstate => _summaryStockResultState;

  void setSummaryStockResultData(List<dynamic> data){
    summaryresultData = data;
  }

  List<dynamic> get summarystockresultData => summaryresultData;

  // Summary Action of Summary Stock

  SummaryActionStockState _summaryActionStockState = SummaryActionStockState.Idle;

  List<Post>? _summaryitems = [];
  List<Post>? _duplicatesummaryitems = [];
  var totalStkValue = 0.0;

  void setsummaryactionState(SummaryActionStockState currentState){
    _summaryActionStockState = currentState;
    notifyListeners();
  }

  SummaryActionStockState get summaryactionstate{
    return _summaryActionStockState;
  }

  List<Post> get summaryactionitem {
    return _summaryitems!;
  }

  void setsummaryactionitem(List<Post> data){
    _summaryitems = data;
  }

  void setState(SummaryStockState currentState) {
    _state = currentState;
    notifyListeners();
  }

  SummaryStockState get state {
    return _state;
  }

  Error? get error {
    return _error;
  }

  List<SummaryStock>? get stockist {
    return _items;
  }

  Future<void> deletItem() async {
    try {
      DatabaseHelper dbHelper = DatabaseHelper.instance;
      dbResult = await dbHelper.fetchSavedSummaryStockItem();
    } catch (err) {
      _error = Error("Exception", "Something Unexpected happened! Please try again.");
      setState(SummaryStockState.FinishedWithError);
    }
  }

  void storeInDB() async {
    DatabaseHelper databaseHelper = DatabaseHelper.instance;
    await databaseHelper.deleteSummaryStock();
    try {
      await databaseHelper.insertSummaryStock(_items);
    } catch (err) {
      _error = Error("Exception", "Something Unexpected happened! Please try again.");
      setState(SummaryStockState.FinishedWithError);
    }
  }

  Future<void> fetchAndStoreItemsListwithdata(railway,unitType,division,department,userDepot,userSubDepot,itemUsage,itemUnit,itemCategory,stkNstk,BuildContext context) async {
    print("Summary stock...... calling now");
    setState(SummaryStockState.Busy);
    try {
      countData=0;
      countVis=false;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print("request parameter : ${railway+"~"+unitType +"~"+division+"~"+department+"~"+userDepot+"~"+userSubDepot+"~"+itemUnit+"~"+itemUsage+"~"+itemCategory+"~"+stkNstk}");
      var response = await Network.postDataWithAPIM('UDM/summarystock/UDMStockSummaryResult/V1.0.0/UDMStockSummaryResult','UDMStockSummaryResult', railway+"~"+unitType +"~"+division+"~"+department+"~"+userDepot +
              "~"+ userSubDepot
              +"~"+itemUnit+"~"+itemUsage+"~"+itemCategory+"~"+stkNstk, prefs.getString('token'));
      print("Summary stock response...... ${json.decode(response.body)}");
      if(response.statusCode == 200) {
        var listdata = json.decode(response.body);
        print("Summary stock...... $listdata");
        if (listdata['status']=='OK') {
          var listJson=listdata['data'];
          if (listJson != null) {
            _items = listJson.map<SummaryStock>((val) => SummaryStock.fromJson(val)).toList();
            storeInDB();
            _duplicatesitems = _items;
            countData=_items!.length;
            setState(SummaryStockState.Finished);
          } else {
            countData=0;
            _error = Error("Exception", "Something Unexpected happened! Please try again.");
            setState(SummaryStockState.Idle);
            IRUDMConstants().showSnack(listdata['message'], context);
            //setState(SummaryStockState.FinishedWithError);
          }
        } else {
          _error = Error("Exception", "No data found");
          setState(SummaryStockState.Idle);
          IRUDMConstants().showSnack('No data found', context);
        //  showInSnackBar("Data not found", context);

        }
      } else {
        _error = Error("Exception", "Something Unexpected happened! Please try again.");
        //setState(SummaryStockState.FinishedWithError);
        setState(SummaryStockState.Idle);
        IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
      }
    } on HttpException {
      _error = Error("Exception", "Something Unexpected happened! Please try again.");
      setState(SummaryStockState.Idle);
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } on SocketException {
      print('No Internet connection 😑');
      _error = Error("Connectivity Error", "No connectivity. Please check your connection.");
      setState(SummaryStockState.Idle);
      IRUDMConstants().showSnack('No connectivity. Please check your connection.', context);
    } on FormatException {
      print("Bad response format 👎");
      _error = Error("Exception", "Something Unexpected happened! Please try again.");
      setState(SummaryStockState.Idle);
      IRUDMConstants().showSnack('Bad response format 👎', context);
    } catch (err) {
      setState(SummaryStockState.Idle);
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    }
  }

  void showInSnackBar(String value, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(value)
    ));
  }


  Future<void> fetchSummaryDetail(railway,unitType,division,department,userDepot,userSubDepot,ledgerNo,folioNo, ledgerFolioPlNo, fromDate,toDate,BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setSummaryStockResultState(SummaryStockResultState.Busy);
    //String fDate=DateFormat('dd-MM-yyyy').format(fromDate);
    //String tDate=DateFormat('dd-MM-yyyy').format(toDate);
    issueQty='';issuValue='';recQty='';recValue='';
    try {
      //from_Date=fDate;
      //to_Date=tDate;
      var headerResponse = await Network.postDataWithAPIM('UDM/transaction/V1.0.0/transaction', 'TransactionDetails', railway+"~"+userDepot+"~"+userSubDepot+"~"+ledgerNo +"~"+folioNo+"~"+ledgerFolioPlNo,prefs.getString('token'));
      if(headerResponse.statusCode==200){
        var headerjsonData = json.decode(headerResponse.body);
        print("header summary Detail Data....$headerjsonData");
        headerData=headerjsonData['data'];
        print(headerResponse.body);
      }
      var response = await Network.postDataWithAPIM('UDM/transaction/V1.0.0/transaction', 'TransactionResult', railway+"~"+userDepot+"~"+userSubDepot+"~"+ledgerNo+"~"+folioNo+"~"+ledgerFolioPlNo+"~"+fromDate+"~"+toDate, prefs.getString('token'));
      if(response.statusCode == 200) {
        var listdata = json.decode(response.body);
        print("summary Detail Data....$listdata");
        if(listdata['status']=='OK') {
          var listJson=listdata['data'];
          if(listJson != null) {
            //_items = listJson.map<TransactionListDataModel>((val) => TransactionListDataModel.fromJson(val)).toList();
            _duplicatesitems = _items;
            for(int i=0;i<listJson.length;i++){
              if(listJson[i]['issuetotalvalue']!=null){
                issueQty=listJson[i]['issuetotalqty'];
                issuValue=listJson[i]['issuetotalvalue'];
              }
              if(listJson[i]['receipttotalqty']!=null){
                recQty=listJson[i]['receipttotalqty'];
                recValue=listJson[i]['receipttotalvalue'];
              }
            }
            setSummaryStockResultState(SummaryStockResultState.Finished);
          } else {
            _error = Error("Exception","Something Unexpected happened! Please try again.");
            setSummaryStockResultState(SummaryStockResultState.Idle);
            IRUDMConstants().showSnack('No Data', context);
          }
        } else {
          _error = Error("Exception", "No data found");
          IRUDMConstants().showSnack('No data found', context);
          setSummaryStockResultState(SummaryStockResultState.Idle);
        }
      } else {
        _error = Error("Exception", "Something Unexpected happened! Please try again.");
        setSummaryStockResultState(SummaryStockResultState.Idle);
        IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
      }
    } on HttpException {
      _error = Error("Exception", "Something Unexpected happened! Please try again.");
      setSummaryStockResultState(SummaryStockResultState.Idle);
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } on SocketException {
      print('No Internet connection 😑');
      _error = Error("Connectivity Error", "No connectivity. Please check your connection.");
      setSummaryStockResultState(SummaryStockResultState.Idle);
      IRUDMConstants().showSnack('No connectivity. Please check your connection.', context);
    } on FormatException {
      print("Bad response format 👎");
      _error = Error("Exception", "Something Unexpected happened! Please try again.");
      //setState(TransactionListDataState.Idle);
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } catch (err) {
      //setState(TransactionListDataState.Idle);
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    }
  }

  Future<void> searchDescription(String query) async {
    var dbItems = await DatabaseHelper.instance.fetchSavedSummaryStockItem();
    if (query.isNotEmpty) {
      // _items = dbItems.where((row) => row[DatabaseHelper.Tbl8_issuecode].toString().toLowerCase().contains(query.toLowerCase())
      //     ||row[DatabaseHelper.Tbl8_issueconsgdept].toString().toLowerCase().contains(query.toLowerCase())||
      //     row[DatabaseHelper.Tbl8_rlyname].toString().toLowerCase().contains(query.toLowerCase())
      // ||row[DatabaseHelper.Tbl8_ledgerno].toString().toLowerCase().contains(query.toLowerCase())
      // ||row[DatabaseHelper.Tbl8_ledgerName].toString().toLowerCase().contains(query.toLowerCase())
      //     ||row[DatabaseHelper.Tbl8_ledgerFolioNo].toString().toLowerCase().contains(query.toLowerCase())
      //     ||row[DatabaseHelper.Tbl8_ledgerFolioName].toString().toLowerCase().contains(query.toLowerCase())
      //     ||row[DatabaseHelper.Tbl8_ledgerFolioPlNo].toString().toLowerCase().contains(query.toLowerCase())
      //     ||row[DatabaseHelper.Tbl8_stkitem].toString().toLowerCase().contains(query.toLowerCase())
      //     ||row[DatabaseHelper.Tbl8_stkQty].toString().toLowerCase().contains(query.toLowerCase())
      //     ||row[DatabaseHelper.Tbl8_stkUnit].toString().toLowerCase().contains(query.toLowerCase())
      //     ||row[DatabaseHelper.Tbl8_stkValue].toString().toLowerCase().contains(query.toLowerCase())
      //     ||row[DatabaseHelper.Tbl8_thershold].toString().toLowerCase().contains(query.toLowerCase())
      //     ||row[DatabaseHelper.Tbl8_lmidt].toString().toLowerCase().contains(query.toLowerCase())
      //     ||row[DatabaseHelper.Tbl8_lmrdt].toString().toLowerCase().contains(query.toLowerCase())
      //     ||row[DatabaseHelper.Tbl8_ledgerFolioShortDesc].toString().toLowerCase().contains(query.toLowerCase()))
      //     .map<SummaryStock>((e) => SummaryStock.fromJson(e))
      //     .toList();
      _items = _duplicatesitems!.where((element) => element.aNTIANNUALCONSUMP.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.bAR.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.cONSUMIND.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.dEPODETAIL.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.iSSCONSGDEPT.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.iSSUECCODE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.iTEMCAT.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.lEDGERFOLIONAME.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.lEDGERFOLIONO.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.lEDGERFOLIOPLNO.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.lEDGERFOLIOSHORTDESC.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.lEDGERNAME.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.lEDGERNO.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.lMIDT.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.lMRDT.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.oRGZONE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pACFIRM.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.rLYNAME.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.sTKITEM.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.sTKQTY.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.sTKUNIT.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.sTKVALUE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.sUBCONSCODE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.tHRESHOLDLIMIT.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.vS.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
      ).toList();
      countData=_items!.length;
      countVis=true;
    }else{
      countVis=false;
      var dbItems = await DatabaseHelper.instance.fetchSavedSummaryStockItem();
      _items = dbItems.map<SummaryStock>((e) => SummaryStock.fromJson(e)).toList();
      countData=_items!.length;
    }
    setState(SummaryStockState.Finished);
  }

  Future<void> createPost(String? rly, String? userdepot, String? userSubDepot, String? unitType, String? unitName, String? dept, String? itemUsage, String? itemtype, String? itemcat, String? sNs, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setsummaryactionState(SummaryActionStockState.Busy);
    print("stock sm reports : ${rly!+"~"+userdepot!+"~"+userSubDepot!+"~"+unitType!+"~"+unitName!+"~"+dept!+"~"+itemtype! + "~" +itemUsage! + "~" + itemcat! + "~" + sNs!}");
    try {
      var response=await Network.postDataWithAPIM('UDM/summarystock/StockSummaryResult/V1.0.0/StockSummaryResult','StockSummaryResult',
              rly! +
              "~" + userdepot! +
              "~" + userSubDepot! +
              "~" + unitType! +
              "~" + unitName! +
              "~" + dept! +
              "~" + itemtype!+
              "~" + itemUsage! +
              "~" + itemcat! +
              "~" + sNs!, prefs.getString('token'));

      var actionData = json.decode(response.body);
      if(actionData['status'] != 'OK') {
        setsummaryactionState(SummaryActionStockState.FinishedWithError);
        IRUDMConstants().showSnack("No Data Found", context);
      } else {
        if(response.statusCode == 200) {
          var data = actionData['data'];
          _summaryitems = data.map<Post>((json) => Post.fromJson(json)).toList();
          var stkValue = 0.0;
          totalStkValue = 0.0;
          for(int i = 0; i < _summaryitems!.length; i++) {
            stkValue = stkValue + double.parse(_summaryitems![i].stkValue);
            assert(stkValue is double);
          }
          totalStkValue = stkValue;
          _duplicatesummaryitems = _summaryitems;
          setsummaryactionitem(_summaryitems!);
          setsummaryactionState(SummaryActionStockState.Finished);
        } else {
          print(response.body);
          throw Exception('Failed to load post');
        }
      }
    } on HttpException {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    } on SocketException {
      IRUDMConstants()
          .showSnack("No connectivity. Please check your connection.", context);
    } on FormatException {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    } catch (err) {
      IRUDMConstants().showSnack(err.toString(), context);
      //  IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    }
  }

  Future<void> searchsummaryactionDescription(String query) async {
    var stkValue = 0.0;
    if(query.isNotEmpty) {
      _summaryitems = _duplicatesummaryitems!.where((element) => element.rlyName.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.issueCode.toString().trim().contains(query.toString().trim())
          || element.depoDetail.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.unitType.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.departName.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.irepsUnitType.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.orgZone.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.unitName.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.stkValue.toString().trim().contains(query.toString().trim())
      ).toList();
      for(int i = 0; i < _summaryitems!.length; i++) {
        stkValue = stkValue + double.parse(_summaryitems![i].stkValue);
        assert(stkValue is double);
      }
      totalStkValue = stkValue;
    }else{
      _summaryitems = _duplicatesummaryitems;
      for(int i = 0; i < _summaryitems!.length; i++) {
        stkValue = stkValue + double.parse(_summaryitems![i].stkValue);
        assert(stkValue is double);
      }
      totalStkValue = stkValue;
    }
    setsummaryactionState(SummaryActionStockState.Finished);
  }
}
