import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:flutter_app/udm/helpers/database_helper.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/models/non_moving.dart';
import 'package:flutter_app/udm/models/valueWise.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/item.dart';
import '../helpers/error.dart';

enum ValueWiseState { Idle, Busy, Finished, FinishedWithError }

class ValueWiseProvider with ChangeNotifier{
  List<ValueWise>? _items;
  List<ValueWise>? _duplicatesitems;
  Error? _error;
  List<Map<String, dynamic>>? dbResult;
  ValueWiseState _state = ValueWiseState.Idle;
  int? countData;
  bool countVis=false;
  void setState(ValueWiseState currentState) {
    _state = currentState;
    notifyListeners();
  }

  ValueWiseState get state {
    return _state;
  }

  Error? get error {
    return _error;
  }

  List<ValueWise>? get valueWiseList {
    return _items;
  }

  Future<void> deletItem() async {
    try {
      DatabaseHelper dbHelper = DatabaseHelper.instance;
      dbResult = await dbHelper.fetchSaveLoginUser();
    } catch (err) {
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      setState(ValueWiseState.FinishedWithError);
    }
  }

  void storeInDB() async {
    DatabaseHelper databaseHelper = DatabaseHelper.instance;
    await databaseHelper.deleteValueViseStock();
    try {
        await databaseHelper.insertValueViseStock(_items);
    } catch (err) {
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      setState(ValueWiseState.FinishedWithError);
    }
  }

  Future<void> fetchAndStoreItemsListwithdata(railway,unitType,division,department,userDepot
  ,userSubDepot
  ,itemUsage
  ,itemUnit
  ,itemCategory
  ,stkNstk
  ,stkAvl
  ,stkAvlValue,context) async {
    setState(ValueWiseState.Busy);
    countData=0;
    countVis=false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var response = await Network.postDataWithAPIM('UDM/vws/ValueWiseStockResult/V1.0.0/ValueWiseStockResult','ValueWiseStockResult',
          railway+"~"+unitType +"~"+division+"~"+department+"~"+userDepot +
              "~"+ userSubDepot
              +"~"+itemUnit+"~"+itemUsage+"~"+itemCategory+"~"+stkNstk+"~"+stkAvl+"~"+stkAvlValue,prefs.getString('token'));
      if (response.statusCode == 200) {
        var listdata = json.decode(response.body);
        if (listdata['status']=='OK') {
          var listJson=listdata['data'];
          if (listJson != null) {
            _items = listJson.map<ValueWise>((val) => ValueWise.fromJson(val)).toList();
            storeInDB();
            _duplicatesitems = _items;
            countData=_items!.length;
            setState(ValueWiseState.Finished);
          } else {
            countData=0;
            _error = Error("Exception",
                "Something Unexpected happened! Please try again.");
            setState(ValueWiseState.Idle);
            IRUDMConstants().showSnack(listdata['message'], context);
            //setState(ValueWiseState.FinishedWithError);
          }
        } else {
          _error = Error("Exception", "No data found");
          setState(ValueWiseState.Idle);
          IRUDMConstants().showSnack('No data found', context);
        //  showInSnackBar("Data not found", context);

        }
      } else {
        _error = Error(
            "Exception", "Something Unexpected happened! Please try again.");
        //setState(ValueWiseState.FinishedWithError);
        setState(ValueWiseState.Idle);
        IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
      }
    } on HttpException {
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      setState(ValueWiseState.Idle);

      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } on SocketException {
      print('No Internet connection 😑');
      _error = Error("Connectivity Error",
          "No connectivity. Please check your connection.");
      setState(ValueWiseState.Idle);
      IRUDMConstants().showSnack('No connectivity. Please check your connection.', context);
    } on FormatException {
      print("Bad response format 👎");
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      setState(ValueWiseState.Idle);
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } catch (err) {
      setState(ValueWiseState.Idle);
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    }
  }

  void showInSnackBar(String value, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
        content: Text(value)
    ));
  }

  Future<void> searchDescription(String query) async {
    var dbItems = await DatabaseHelper.instance.fetchSavedValueViseStock();
    if (query.isNotEmpty) {
      // _items = dbItems.where((row) => row[DatabaseHelper.Tbl10_thresholdlimit].toString().toLowerCase().contains(query.toLowerCase())||row[DatabaseHelper.Tbl10_ledgerfolioplno].toString().toLowerCase().contains(query.toLowerCase())||
      //     row[DatabaseHelper.Tbl10_stkvalue].toString().toLowerCase().contains(query.toLowerCase())
      // ||row[DatabaseHelper.Tbl10_ledgerfolioshortdesc].toString().toLowerCase().contains(query.toLowerCase())
      // ||row[DatabaseHelper.Tbl10_stkqty].toString().toLowerCase().contains(query.toLowerCase())
      //     ||row[DatabaseHelper.Tbl10_ledgerno].toString().toLowerCase().contains(query.toLowerCase())
      //     ||row[DatabaseHelper.Tbl10_vs].toString().toLowerCase().contains(query.toLowerCase())
      //     ||row[DatabaseHelper.Tbl10_consumind].toString().toLowerCase().contains(query.toLowerCase())
      //     ||row[DatabaseHelper.Tbl10_stkunit].toString().toLowerCase().contains(query.toLowerCase())
      //     ||row[DatabaseHelper.Tbl10_issueccode].toString().toLowerCase().contains(query.toLowerCase())
      //     ||row[DatabaseHelper.Tbl10_stkitem].toString().toLowerCase().contains(query.toLowerCase())
      // ||row[DatabaseHelper.Tbl10_issconsgdept].toString().toLowerCase().contains(query.toLowerCase()))
      //     .map<ValueWise>((e) => ValueWise.fromJson(e))
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
      var dbItems = await DatabaseHelper.instance.fetchSavedValueViseStock();
      _items=dbItems.map<ValueWise>((e) => ValueWise.fromJson(e)).toList();
      countData=_items!.length;
    }
    setState(ValueWiseState.Finished);
  }
}
