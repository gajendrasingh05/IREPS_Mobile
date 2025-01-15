import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:flutter_app/udm/helpers/database_helper.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/models/poSearch.dart';
import 'package:flutter_app/udm/models/stock.dart';
import 'package:flutter_app/udm/models/storeStockDepot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/item.dart';
import '../helpers/error.dart';

enum PoSearchState { Idle, Busy, Finished, FinishedWithError }

class PoSearchStateProvider with ChangeNotifier{
  List<POSearch>? _items;
  List<POSearch>? _duplicatesitems;
  Error? _error;
  List<Map<String, dynamic>>? dbResult;
  PoSearchState _state = PoSearchState.Idle;
  String bodyData1='',bodyData2='', bodyData3 = '',datef='',dateTo='';
  int? countData;
  bool countVis=false;

  bool _isScrolling = false;
  bool _showFAB = false;

  void setFabState(bool showFab){
    _showFAB = showFab;
    //_isScrolling = isScroll;
    notifyListeners();
  }
  bool get showFabStateValue{
    return _showFAB;
  }
  // bool get isScrollValue{
  //   return _isScrolling;
  // }

  void setState(PoSearchState currentState) {
    _state = currentState;
    notifyListeners();
  }

  PoSearchState get state {
    return _state;
  }

  Error? get error {
    return _error;
  }

  List<POSearch>? get poSearchList {
    return _items;
  }

  void storeInDB(var json) async {
    DatabaseHelper databaseHelper = DatabaseHelper.instance;
    await databaseHelper.deletePOSearchItems();
    try {
        await databaseHelper.insertPOSearch(_items);
    } catch (err) {
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      setState(PoSearchState.FinishedWithError);
    }
  }


  Future<void> fetchAndStoreItemsListwithdata(String railway,String sns,String consignee,String stkstrdpt,String plno,
      String itemdesc1,String itemdesc2,String poplacing,String purchase,String covrstats,String tendrtype,
      String inspection,String industrytype,String potype,String pono,String vendorname,
      String povaluefrom,String povalueto,String podatefrom,String podateto, BuildContext context,String ao, String deptcode)async {
    setState(PoSearchState.Busy);
    try {
      countData=0;
      countVis=false;
      datef=podatefrom;
      dateTo=podateto;
      bodyData1=railway+"~"+deptcode+"~"+stkstrdpt+"~"+purchase+"~"+sns+"~"+plno+"~"+covrstats+"~"+povaluefrom+"~"+povalueto+"~"+pono+"~"+industrytype+"~"+tendrtype+"~"+datef+"~"+dateTo+"~"+potype+"~"+vendorname+"~"+consignee+"~"+inspection+"~"+itemdesc1+"~"+itemdesc2+"~"+ao+"~"+poplacing;

      bodyData2= railway+"~"+deptcode+"~"+stkstrdpt+"~"+purchase+"~"+sns+"~"+plno+"~"+covrstats+"~"+povaluefrom+"~"+povalueto+"~"+pono+"~"+industrytype+"~"+tendrtype+"~";
      bodyData3 = "~"+potype+"~"+vendorname+"~"+consignee+"~"+inspection+"~"+itemdesc1+"~"+itemdesc2+"~"+ao+"~"+poplacing;

      SharedPreferences prefs = await SharedPreferences.getInstance();
    // var response = await Network.postDataWithAPIM('UDM/SearchPO/GetPOResult/V1.0.0/GetPOResult','GetPOResult',
    //     railway+"~"+stkstrdpt+"~"+poplacing+"~"+sns+"~"+plno+"~"+covrstats+"~"+povaluefrom+"~"+povalueto+"~"+pono+"~"+industrytype+"~"+tendrtype+"~"+
    //         podatefrom+"~"+podateto+"~"+potype+"~"+vendorname+"~"+consignee+"~"+inspection+"~"+itemdesc1+"~"+itemdesc2+"~"+ao+"~"+purchase,
    //     prefs.getString('token'));

    var response = await Network().postDataWithPro('https://ireps.gov.in/EPSApi/UDM/SearchPO/GetPOResult','GetPOResult2', bodyData1, prefs.getString('token'));

      print(jsonEncode({'input_type':'GetPOResult2','input': bodyData1}));
      if(response.statusCode == 200) {
        print(response.body);
        var listdata = json.decode(response.body);
        if(listdata['status'] =='OK') {
          var listJson = listdata['data'];
          if(listJson != null) {
            _items = listJson.map<POSearch>((val) => POSearch.fromJson(val)).toList();
            storeInDB(listJson);
            _duplicatesitems = _items;
            countData=_items!.length;
            setState(PoSearchState.Finished);
          } else {
            print(0);
            countData=0;
            _error = Error("Exception", listdata['message']);
            setState(PoSearchState.Idle);
            IRUDMConstants().showSnack(listdata['message'], context);
            //setState(PoSearchState.FinishedWithError);
          }
        }
        else {
          _error = Error("Exception", listdata['message']);
          setState(PoSearchState.Idle);
         // IRUDMConstants().showSnack(listdata['message'], context);
        }
      }
      else {
        print(400);
        _error = Error("Exception", "Something Unexpected happened! Please try again.");
        setState(PoSearchState.Idle);
        IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
      }
    } on HttpException {
      _error = Error("Exception", "Something Unexpected happened! Please try again.");
      setState(PoSearchState.Idle);
      IRUDMConstants().showSnack('HTTP exception! Please try again.', context);
    } on SocketException {
      print('No Internet connection 😑');
      _error = Error("Connectivity Error", "No connectivity. Please check your connection.");
      setState(PoSearchState.Idle);
      IRUDMConstants().showSnack('No connectivity. Please check your connection.', context);
    } on FormatException {
      print("Bad response format 👎");
      _error = Error("Exception", "Bad response format! Please try again.");
      setState(PoSearchState.Idle);
      IRUDMConstants().showSnack('Bad response format! Please try again.', context);
    } catch (err) {
      setState(PoSearchState.Idle);
      print(err);
      IRUDMConstants().showSnack(err.toString().substring(0,75), context);
    }
  }


  Future<void> fetchData(BuildContext context) async {
    setState(PoSearchState.Busy);
    try {
    var inputFormat=DateFormat('dd-MM-yyyy');
    var dateFro=inputFormat.parse(datef).subtract(const Duration(days: 366));
    var datetodata=inputFormat.parse(dateTo).subtract(const Duration(days: 366));
    String fDate=DateFormat('dd-MM-yyyy').format(dateFro);
    String tDate=DateFormat('dd-MM-yyyy').format(datetodata);
    debugPrint(jsonEncode({'input_type':'GetPOResult2','input':bodyData2+fDate+"~"+tDate+bodyData3}));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    //bodyData1=railway+"~"+deptcode+"~"+stkstrdpt+"~"+purchase+"~"+sns+"~"+plno+"~"+covrstats+"~"+povaluefrom+"~"+povalueto+"~"+pono+"~"+industrytype+"~"+tendrtype+"~"+datef+"~"+dateTo+"~"+potype+"~"+vendorname+"~"+consignee+"~"+inspection+"~"+itemdesc1+"~"+itemdesc2+"~"+ao+"~"+poplacing;
    var response = await Network().postDataWithPro('https://ireps.gov.in/EPSApi/UDM/SearchPO/GetPOResult','GetPOResult2', bodyData2+fDate+"~"+tDate+bodyData3, prefs.getString('token'));
    if (response.statusCode == 200) {
      var listdata = json.decode(response.body);
        if (listdata['status']=='OK') {
          var listJson=listdata['data'];
          if (listJson != null) {
            _items = listJson.map<POSearch>((val) => POSearch.fromJson(val)).toList();
            _duplicatesitems = _items;
            countData=_items!.length;
            storeInDB(listJson);
            setState(PoSearchState.Finished);
          } else {
            print(200);
            datef=fDate;
            _error = Error("Exception", listdata['message']);
            setState(PoSearchState.Idle);
          }
        } else {
          print(400);
          datef=fDate;
          _error = Error("Exception", listdata['message']);
          setState(PoSearchState.Idle);
        }
      } else {
        _error = Error("Exception", "Something Unexpected happened! Please try again.");
        setState(PoSearchState.Idle);
        IRUDMConstants().showSnack(response.body, context);
      }
    } on HttpException {
      _error = Error("Exception", "Something Unexpected happened! Please try again.");
      setState(PoSearchState.Idle);
      IRUDMConstants().showSnack('HTTP exception! Please try again.', context);
    } on SocketException {
      print('No Internet connection 😑');
      _error = Error("Connectivity Error",
          "No connectivity. Please check your connection.");
      setState(PoSearchState.Idle);
      IRUDMConstants().showSnack('No connectivity. Please check your connection.', context);
    } on FormatException {
      print("Bad response format 👎");
      _error = Error(
          "Exception", "Bad response format! Please try again.");
      setState(PoSearchState.Idle);
      IRUDMConstants().showSnack('Bad response format! Please try again.', context);
    } catch (err) {
      setState(PoSearchState.Idle);
      print(err);
      IRUDMConstants().showSnack(err.toString().substring(0,75), context);
    }
  }

  void showInSnackBar(String value, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(value)
    ));
  }

  Future<void> searchDescription(String query) async {
    var dbItems = await DatabaseHelper.instance.fetchSavedPOSearchItem();
    if(query.isNotEmpty) {
      // print("items list length: ${dbItems.length}");
      //  _items = dbItems.where((row) => row[DatabaseHelper.Tbl7_poNo].toString().toLowerCase().contains(query.toLowerCase())
      //     || row[DatabaseHelper.Tbl7_poDate].toString().toLowerCase().contains(query.toLowerCase())
      //  ||row[DatabaseHelper.Tbl7_vName].toString().toLowerCase().contains(query.toLowerCase())
      //  ||row[DatabaseHelper.Tbl7_consg].toString().toLowerCase().contains(query.toLowerCase())
      //      ||row[DatabaseHelper.Tbl7_posr].toString().toLowerCase().contains(query.toLowerCase())
      //      ||row[DatabaseHelper.Tbl7_poValue].toString().toLowerCase().contains(query.toLowerCase())
      //      ||row[DatabaseHelper.Tbl7_des].toString().toLowerCase().contains(query.toLowerCase())
      //  ||row[DatabaseHelper.Tbl7_splQty].toString().toLowerCase().contains(query.toLowerCase())
      //      ||row[DatabaseHelper.Tbl7_paidValue].toString().toLowerCase().contains(query.toLowerCase())
      //      ||row[DatabaseHelper.Tbl7_itemCode].toString().toLowerCase().contains(query.toLowerCase())
      //      ||row[DatabaseHelper.Tbl7_poQty].toString().toLowerCase().contains(query.toLowerCase()))
      //    .map<POSearch>((e) => POSearch.fromJson(e))
      //      .toList();
      _items = _duplicatesitems!.where((element) => element.cANCELLATIONQTY.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.cONSG.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.cONSIGNEENAME.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.dELIVERYPERIOD.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.dES.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.iNSPECTIONACGENCY.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.iTEMCODE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pAIDVALUE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pODATE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pOKEY.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pONO.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pOQTY.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pOSR.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pOSTATUS.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pOVALUE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.rLY.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.rLYNAME.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.sTKNS.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.sUPPLYQTY.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.uNIT.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.vNAME.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.itemRate.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
      ).toList();
      countData=_items!.length;
      countVis=true;
    }
    else{
      countData=0;
      countVis=false;
      var dbItems = await DatabaseHelper.instance.fetchSavedPOSearchItem();
      dbItems.forEach((row) => print(row));
      _items = dbItems.map<POSearch>((e) => POSearch.fromJson(e)).toList();
      countData=_items!.length;
      print(_items);
    }
    setState(PoSearchState.Finished);
  }
}
