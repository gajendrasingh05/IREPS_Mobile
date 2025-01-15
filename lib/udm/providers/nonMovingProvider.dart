import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:flutter_app/udm/helpers/database_helper.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/models/non_moving.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/item.dart';
import '../helpers/error.dart';

enum NonMovingState { Idle, Busy, Finished, FinishedWithError }

class NonMovingProvider with ChangeNotifier{
  List<NonMoving>? _items;
  List<NonMoving>? _duplicatesitems;
  Error? _error;
  List<Map<String, dynamic>>? dbResult;
  NonMovingState _state = NonMovingState.Idle;
  int? countData;
  bool countVis=false;
  void setState(NonMovingState currentState) {
    _state = currentState;
    notifyListeners();
  }

  NonMovingState get state {
    return _state;
  }

  Error? get error {
    return _error;
  }

  List<NonMoving>? get nonMovingList {
    return _items;
  }

  Future<void> deletItem() async {
    try {
      DatabaseHelper dbHelper = DatabaseHelper.instance;
      dbResult = await dbHelper.fetchSaveLoginUser();
    } catch (err) {
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      setState(NonMovingState.FinishedWithError);
    }
  }

  void storeInDB() async {
    DatabaseHelper databaseHelper = DatabaseHelper.instance;
    await databaseHelper.deleteNonMoving();
    try {
        await databaseHelper.insertNonMoving(_items);
        //print(await databaseHelper.insertNonMoving(_items));
    } catch (err) {
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      setState(NonMovingState.FinishedWithError);
    }
  }
  _setHeaders() => {
    'Content-type' : 'application/json',
    'Accept' : 'application/json',
    //  'Authorization' : 'Bearer $token'
  };

  Future<void> fetchAndStoreItemsListwithdata(railway,unitType,division,department,userDepot
  ,userSubDepot
  ,itemUsage
  ,itemUnit
  ,itemCategory
  ,stkNstk
  ,stkAvlValue,BuildContext context) async {
    setState(NonMovingState.Busy);
    countData=0;
    countVis=false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      print(jsonEncode({'input_type':'NonMovingItemResult','input':railway+"~"+unitType +"~"+division+"~"+department+"~"+userDepot +
          "~"+ userSubDepot
          +"~"+itemUnit+"~"+itemUsage+"~"+itemCategory+"~"+stkNstk+"~"+stkAvlValue}));

      var response = await Network.postDataWithAPIM('UDM/nmi/NonMovingItemResult/V1.0.0/NonMovingItemResult','NonMovingItemResult',
          railway+"~"+unitType +"~"+division+"~"+department+"~"+userDepot +
              "~"+ userSubDepot
              +"~"+itemUnit+"~"+itemUsage+"~"+itemCategory+"~"+stkNstk+"~"+stkAvlValue,prefs.getString('token'));


      if (response.statusCode == 200) {
         print(response.body);
        var listdata = json.decode(response.body);
        if (listdata['status']=='OK') {
          var listJson=listdata['data'];
          if (listJson != null) {
            _items = listJson.map<NonMoving>((val) => NonMoving.fromJson(val)).toList();
            storeInDB();
            _duplicatesitems = _items;
            countData=_items!.length;
            setState(NonMovingState.Finished);
          } else {
            countData=0;
            _error = Error("Exception",
                "Something Unexpected happened! Please try again.");
            setState(NonMovingState.Idle);
            IRUDMConstants().showSnack(listdata['message'], context);
            //setState(NonMovingState.FinishedWithError);
          }
        } else {
          _error = Error("Exception", "No data found");
          setState(NonMovingState.Idle);
          IRUDMConstants().showSnack('No data found', context);
        //  showInSnackBar("Data not found", context);

        }
      } else {
        _error = Error(
            "Exception", "Something Unexpected happened! Please try again.");
        //setState(NonMovingState.FinishedWithError);
        setState(NonMovingState.Idle);
        IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
      }
    } on HttpException {
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      // print("Exception "+err.toString());
      //setState(NonMovingState.FinishedWithError);
      setState(NonMovingState.Idle);

      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } on SocketException {
      print('No Internet connection 😑');
      _error = Error("Connectivity Error",
          "No connectivity. Please check your connection.");
      // print("Error "+err.toString());
      //setState(NonMovingState.FinishedWithError);
      setState(NonMovingState.Idle);
      IRUDMConstants().showSnack('No connectivity. Please check your connection.', context);
    } on FormatException {
      print("Bad response format 👎");
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      // print("Error "+err.toString());
      //setState(NonMovingState.FinishedWithError);
      setState(NonMovingState.Idle);
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } catch (err) {
      setState(NonMovingState.Idle);
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    }
  }

  void showInSnackBar(String value, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
        content: new Text(value)
    ));
  }

  Future<void> searchDescription(String query) async {
    var dbItems = await DatabaseHelper.instance.fetchSavedNonMovingItem();
    if (query.isNotEmpty) {
      // _items = dbItems.where((row) => row[DatabaseHelper.Tbl9_thresholdlimit].toString().toLowerCase().contains(query.toLowerCase())||row[DatabaseHelper.Tbl9_ledgerfolioplno].toString().toLowerCase().contains(query.toLowerCase())||
      //     row[DatabaseHelper.Tbl9_stkvalue].toString().toLowerCase().contains(query.toLowerCase())
      // ||row[DatabaseHelper.Tbl9_ledgerfolioshortdesc].toString().toLowerCase().contains(query.toLowerCase())
      // ||row[DatabaseHelper.Tbl9_stkqty].toString().toLowerCase().contains(query.toLowerCase())
      //     ||row[DatabaseHelper.Tbl10_vs].toString().toLowerCase().contains(query.toLowerCase())
      //     ||row[DatabaseHelper.Tbl10_consumind].toString().toLowerCase().contains(query.toLowerCase())
      //     ||row[DatabaseHelper.Tbl9_ledgerno].toString().toLowerCase().contains(query.toLowerCase())
      //     ||row[DatabaseHelper.Tbl9_stkunit].toString().toLowerCase().contains(query.toLowerCase())
      //     ||row[DatabaseHelper.Tbl9_issueccode].toString().toLowerCase().contains(query.toLowerCase())
      //     ||row[DatabaseHelper.Tbl9_stkitem].toString().toLowerCase().contains(query.toLowerCase())
      // ||row[DatabaseHelper.Tbl9_issconsgdept].toString().toLowerCase().contains(query.toLowerCase()))
      //     .map<NonMoving>((e) => NonMoving.fromJson(e))
      //     .toList();
      _items = _duplicatesitems!.where((element) => element.pacfirm.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.itemcat.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.depodetail.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.issueccode.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.rlyname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.stkitem.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.issconsgdept.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.ledgerno.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.vs.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.consumind.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.ledgername.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.ledgerfoliono.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.ledgerfolioname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.ledgerfolioplno.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.ledgerfolioshortdesc.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.lmrdt.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.lmidt.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.stkqty.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.bar.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.stkvalue.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.stkunit.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.thresholdlimit.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
      ).toList();
      countData=_items!.length;
      countVis=true;
    }else{
      countVis=false;
      var dbItems = await DatabaseHelper.instance.fetchSavedNonMovingItem();
      dbItems.forEach((row) => print(row));
      _items=dbItems.map<NonMoving>((e) => NonMoving.fromJson(e)).toList();
      countData=_items!.length;
    }
    setState(NonMovingState.Finished);
  }
}
