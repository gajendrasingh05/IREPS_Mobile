import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:flutter_app/udm/helpers/database_helper.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/models/item_summary.dart';
import 'package:flutter_app/udm/onlineBillStatus/statusModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import '../models/item.dart';
import '../helpers/error.dart';

enum StatusListState { Idle, Busy, Finished, FinishedWithError }

class StatusProvider with ChangeNotifier {
  List<Status>? _items;
  List<Status>? _duplicatesitems;
  var stkValue=0.0;
  Error? _error;
  int? countData;
  bool countVis=false;
  List<Map<String, dynamic>>? dbResult;

  StatusListState _state = StatusListState.Idle;

  void setState(StatusListState currentState) {
    _state = currentState;
    notifyListeners();
  }

  StatusListState get state {
    return _state;
  }

  Error? get error {
    return _error;
  }

  List<Status>? get itemList {
    return _items;
  }

  Future<void> deletItem() async {
    try {
      DatabaseHelper dbHelper = DatabaseHelper.instance;
      dbResult = await dbHelper.fetchSaveLoginUser();
    } catch (err) {
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      setState(StatusListState.FinishedWithError);
    }
  }

  void storeInDB() async {
    DatabaseHelper databaseHelper = DatabaseHelper.instance;
    await databaseHelper.deleteItems();
    try {
      // _items.forEach((element) async {
     await databaseHelper.insertonlineStatus(_items);
      // });
    } catch (err) {
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      setState(StatusListState.FinishedWithError);
    }
  }


  Future<void> fetchAndStoreItemsListwithdata(String railway ,
      fDate,tDate,
      String consignee,
      String payingAuthority,
      String description,
      BuildContext context) async {
    setState(StatusListState.Busy);
    String fromDate=DateFormat('dd-MM-yyyy').format(fDate);
    String toDate=DateFormat('dd-MM-yyyy').format(tDate);
    countData=0;
    countVis=false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
     var response = await Network.postDataWithAPIM('UDM/Bill/V1.0.0/GetData', 'OnlineBillStatus', fromDate+"~"+toDate+"~" + railway +"~" +consignee +"~" +payingAuthority + "~" +description,prefs.getString('token'));
     if (response.statusCode == 200) {
        print(response.body);
        var listdata = json.decode(response.body);
        if (listdata['status']=='OK') {
          var listJson=listdata['data'];
          if (listJson != null) {
            _items = listJson.map<Status>((val) => Status.fromJson(val)).toList();
            _duplicatesitems = _items;
            //storeInDB();
            countData=_items!.length;
            setState(StatusListState.Finished);
          } else {
            countData=0;
            _error = Error("Exception", "Something Unexpected happened! Please try again.");
            setState(StatusListState.Idle);
            IRUDMConstants().showSnack(listdata['message'], context);
          }
        } else {
          _error = Error("Exception", "No data found");
          setState(StatusListState.Idle);
          IRUDMConstants().showSnack('No data found', context);
        }
      } else {
        _error = Error("Exception", "Something Unexpected happened! Please try again.");
        setState(StatusListState.Idle);
        IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
      }
    } on HttpException {
      _error = Error("Exception", "Something Unexpected happened! Please try again.");
      setState(StatusListState.Idle);

      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } on SocketException {
      print('No Internet connection 😑');
      _error = Error("Connectivity Error",
          "No connectivity. Please check your connection.");
      // print("Error "+err.toString());
      //setState(ConsAnalysistate.FinishedWithError);
      setState(StatusListState.Idle);
      IRUDMConstants().showSnack('No connectivity. Please check your connection.', context);
    } on FormatException {
      print("Bad response format 👎");
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      // print("Error "+err.toString());
      //setState(ConsAnalysistate.FinishedWithError);
      setState(StatusListState.Idle);
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } catch (err) {
      setState(StatusListState.Idle);
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    }
  }


  void showInSnackBar(String value, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
        content: new Text(value)
    ));
  }


  // Future<void> searchDescription(String query) async {
  //   var dbItems = await DatabaseHelper.instance.fetchonlineStatus();
  //   if (query.isNotEmpty) {
  //     print("items list length: ${dbItems.length}");
  //     _items = dbItems.where((row) => row[DatabaseHelper.Tbl15rlyCode].toString().toLowerCase().contains(query.toLowerCase())|| row[DatabaseHelper.Tbl15cONSNAME].toString().toLowerCase().contains(query.toLowerCase())||
  //         row[DatabaseHelper.Tbl15cONSRLY].toString().toLowerCase().contains(query.toLowerCase())
  //         ||row[DatabaseHelper.Tbl15pONUMBER].toString().toLowerCase().contains(query.toLowerCase())
  //         ||row[DatabaseHelper.Tbl15pODATE].toString().toLowerCase().contains(query.toLowerCase())
  //         || row[DatabaseHelper.Tbl15cONSIGNEE].toString().toLowerCase().contains(query.toLowerCase())
  //         || row[DatabaseHelper.Tbl15pOSR].toString().toLowerCase().contains(query.toLowerCase())
  //         || row[DatabaseHelper.Tbl15iTEMDESCRIPTION].toString().toLowerCase().contains(query.toLowerCase())
  //         ||row[DatabaseHelper.Tbl15aCCOUNTNAME].toString().toLowerCase().contains(query.toLowerCase())).map<Status>((e) => Status.fromJson(e)).toList();
  //     countData=_items!.length;
  //     countVis=true;
  //   }else{
  //     countVis=false;
  //     dbItems.forEach((row) => print(row));
  //     _items=await DatabaseHelper.instance.getOnlineBillStatusItemList();
  //     countData=_items!.length;
  //     print(_items);
  //   }
  //   setState(StatusListState.Finished);
  // }

  Future<void> searchDescription(String query) async{
    if (query.isNotEmpty){
      //_items!.clear();
      _items = _duplicatesitems!.where((element) => element.cONSNAME.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.cONSRLY.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pONUMBER.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pODATE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.cONSIGNEE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.aCCOUNTNAME.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pOSR.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.iTEMDESCRIPTION.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
         /* || element.item_code.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.ledger_name.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.unit.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pONO.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.fROMBILL.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.vENDORNAME.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.iTEMDESC.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.dOCNO.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.dOCDATE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pAYINGRLY.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pAYINGAUTHORITY.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.rLY.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.dOCTYPE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.bILLNO.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.bILLDATE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.iREPSBILLNO.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.iREPSBILLDATE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.bILLTYPE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pAYMENTTYPE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pAYMENTPERCENTAGE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.iTEMNOOFBILL.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.bILLAMOUNTFORITEM.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.cO6NO.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.cO6DATE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.cO7NO.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.cO7DATE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pASSEDAMOUNTFORITEM.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pAYMENTRETURNDATE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.tOTALAMOUNTFORBILL.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pASSEDAMOUNTFORBILL.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.dEDUCTEDAMOUNTFORBILL.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pAIDAMOUNTFORBILL.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.rETURNREASON.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.rNOTENO.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.rNOTEDATE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.qTYACCEPTED.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.qTYRECEIVED.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.cARDCODE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pAYAUTH.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.cO6STATUS.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.description.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.qty.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.rate.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.orgZone.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.subConsCode.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.plumber.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.depoDetail.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.issueDept.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.issuediv.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.itemcat.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.cons_code.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.issuecode.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.issueconsg.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.rlyName.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.divName.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.isscongDept.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.ledgerName.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.ledgerNo.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.postName.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.folioName.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.plimagePath.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.stoqQty.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.unitCode.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.booavgrat.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())*/
      ).toList();
      countData=_items!.length;
      setState(StatusListState.Finished);
    }
    else{
      _items = _duplicatesitems;
      countData=_items!.length;
      setState(StatusListState.Finished);
    }
  }
}
