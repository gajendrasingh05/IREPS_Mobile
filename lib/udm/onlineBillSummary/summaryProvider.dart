import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:flutter_app/udm/helpers/database_helper.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/models/item_summary.dart';
//import 'package:flutter_app/udm/onlineBillStatus/statusModel.dart';
import 'package:flutter_app/udm/onlineBillSummary/summaryModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import '../models/item.dart';
import '../helpers/error.dart';

enum StatusListState1 { Idle, Busy, Finished, FinishedWithError }

class SummaryProvider with ChangeNotifier {
  //===============================
  List<Summary>? _items;
  List<Summary>? _duplicatesitems;
  var stkValue=0.0;
  Error? _error;
  int? countData;
  bool countVis=false;
  List<Map<String, dynamic>>? dbResult;

  StatusListState1 _state = StatusListState1.Idle;
  void setState(StatusListState1 currentState) {
    _state = currentState;
    notifyListeners();
  }

  StatusListState1 get state {
    return _state;
  }

  Error? get error {
    return _error;
  }

  /*List<ItemSummary>? get summaryList {
    return _itemSummary;
  }*/

  List<Summary>? get itemList {
    return _items;
  }

  Future<void> deletItem() async {
    try {
      DatabaseHelper dbHelper = DatabaseHelper.instance;
      dbResult = await dbHelper.fetchSaveLoginUser();
    } catch (err) {
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      setState(StatusListState1.FinishedWithError);
    }
  }

  void storeInDB() async {
    DatabaseHelper databaseHelper = DatabaseHelper.instance;
    await databaseHelper.deleteonlineSummary();
    try {
      await databaseHelper.insertonlineSummary(_items);
    } catch (err) {
      _error = Error("Exception", "Something Unexpected happened! Please try again.");
      setState(StatusListState1.FinishedWithError);
    }
  }


  Future<void> fetchAndStoreItemsListwithdata(

      String railway ,
      Frmdt,Todt,
      String  unitType,
      String unitName,
      String department,
      String userDepot,
      String payingAuth,
      BuildContext context) async {
    setState(StatusListState1.Busy);
    String FromDate=DateFormat('dd-MM-yyyy').format(Frmdt);
    String ToDate=DateFormat('dd-MM-yyyy').format(Todt);
    countData=0;
    countVis=false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var response = await Network.postDataWithAPIM(
          'UDM/Bill/V1.0.0/GetData',
          'OnlineBillSummary',FromDate +"~"+ ToDate +"~"+ railway +"~"+ unitType +"~"+ unitName
          +"~"+ department +"~"+ userDepot +"~"+
          payingAuth,prefs.getString('token'));


      print("ritu testing"+response.toString());
      if (response.statusCode == 200) {
        print(response.body);
        var listdata = json.decode(response.body);
        if (listdata['status']=='OK') {
          var listJson=listdata['data'];
          if (listJson != null) {
            _items = listJson.map<Summary>((val) => Summary.fromJson(val)).toList();
            _duplicatesitems = _items;
            countData=_items!.length;
            setState(StatusListState1.Finished);
          } else {
             //countData=0;
            _error = Error("Exception",
                "Something Unexpected happened! Please try again.");
            setState(StatusListState1.Idle);
            IRUDMConstants().showSnack(listdata['message'], context);
          }
        } else {
          _error = Error("Exception", "No data found");
          setState(StatusListState1.Idle);
          IRUDMConstants().showSnack('No data found', context);
        }
      } else {
        _error = Error(
            "Exception", "Something Unexpected happened! Please try again.");
        //setState(ConsAnalysistate.FinishedWithError);
        setState(StatusListState1.Idle);
        IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
      }
    } on HttpException {
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      setState(StatusListState1.Idle);

      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } on SocketException {
      print('No Internet connection 😑');
      _error = Error("Connectivity Error",
          "No connectivity. Please check your connection.");

      setState(StatusListState1.Idle);
      IRUDMConstants().showSnack('No connectivity. Please check your connection.', context);
    } on FormatException {
      print("Bad response format 👎");
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");

      setState(StatusListState1.Idle);
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } catch (err) {
      setState(StatusListState1.Idle);
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    }
  }
  void showInSnackBar(String value, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(value)
    ));
  }


  // Future<void> searchDescription(String query) async {
  //   var dbItems = await DatabaseHelper.instance.fetchonlineSummary();
  //   print("items list length: ${dbItems.length}");
  //   if (query.isNotEmpty) {
  //     print("get data from database");
  //     print("get data from database"+dbItems.toString());
  //     _items = dbItems.where((row) => row[DatabaseHelper.Tbl14cONSECODE].toString().toLowerCase().contains(query.toLowerCase())||
  //         row[DatabaseHelper.Tbl14pAYAUTHCODE].toString().toLowerCase().contains(query.toLowerCase())
  //         ||row[DatabaseHelper.Tbl14cONSIGNEE].toString().toLowerCase().contains(query.toLowerCase())
  //         ||row[DatabaseHelper.Tbl14pAUAUTH].toString().toLowerCase().contains(query.toLowerCase())
  //         ||row[DatabaseHelper.Tbl14uNITTYPE].toString().toLowerCase().contains(query.toLowerCase()))
  //         .map<Summary>((e) => Summary.fromJson(e))
  //         .toList();
  //     countData=_items!.length;
  //     countVis=true;
  //   }else{
  //     countVis=false;
  //     var dbItems = await DatabaseHelper.instance.fetchonlineSummary();
  //     dbItems.forEach((row) => print(row));
  //     _items=dbItems.map<Summary>((e) => Summary.fromJson(e)).toList();
  //     countData=_items!.length;
  //   }
  //   setState(StatusListState1.Finished);
  // }

  Future<void> searchDescription(String query) async{
    if (query.isNotEmpty){
      //_items!.clear();
      _items = _duplicatesitems!.where((element) => element.pONUMBER.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pOSR.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pAYAUTHCODE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.cONSECODE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.rAILNAME.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.uNITTYPE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.uNITNAME.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.dEPARTMENT.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.cONSIGNEE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pAUAUTH.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.oPENBAL.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.bILLRECIVED.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.bILLRETURENED.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.bILLPASSED.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.tOTALPENDING.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pENDSEVENDAYS.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pENDFIFTEENDAYS.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pENDTHIRTYDAYS.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pENDMORETHIRTY.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.uNIT.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.tODATE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.fROMDATE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.rAILCODE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
      ).toList();
      countData=_items!.length;
      setState(StatusListState1.Finished);
    }
    else{
      _items = _duplicatesitems;
      countData=_items!.length;
      setState(StatusListState1.Finished);
    }
  }
}
