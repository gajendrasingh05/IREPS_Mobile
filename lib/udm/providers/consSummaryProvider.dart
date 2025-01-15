import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:flutter_app/udm/helpers/database_helper.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/models/cons_summary.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/error.dart';

enum ConsSummarytate { Idle, Busy, Finished, FinishedWithError }

class ConsSummaryProvider with ChangeNotifier{
  List<ConsSummary>? _items;
  List<ConsSummary>? _duplicatesitems;
  Error? _error;
  List<Map<String, dynamic>>? dbResult;
  ConsSummarytate _state = ConsSummarytate.Idle;
  int? countData;
  bool countVis=false;
  void setState(ConsSummarytate currentState) {
    _state = currentState;
    notifyListeners();
  }

  ConsSummarytate get state {
    return _state;
  }

  Error? get error {
    return _error;
  }

  List<ConsSummary>? get consSummaryList {
    return _items;
  }

  Future<void> deletItem() async {
    try {
      DatabaseHelper dbHelper = DatabaseHelper.instance;
      dbResult = await dbHelper.fetchSaveLoginUser();
    } catch (err) {
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      setState(ConsSummarytate.FinishedWithError);
    }
  }

  void storeInDB() async {
    DatabaseHelper databaseHelper = DatabaseHelper.instance;
    await databaseHelper.deleteConsSummary();
    try {
        await databaseHelper.insertConsSummary( _items);
        //print(await databaseHelper.insertConsSummary(_items));
    } catch (err) {
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      setState(ConsSummarytate.FinishedWithError);
    }
  }
  _setHeaders() => {
    'Content-type' : 'application/json',
    'Accept' : 'application/json',
    //  'Authorization' : 'Bearer $token'
  };

  Future<void> fetchAndStoreItemsListwithdata(lable,cFrom,cTo,railway,department,userDepot
  ,userSubDepot
  ,itemUsage,itemUnit
  ,dynamicValue,context) async {
    setState(ConsSummarytate.Busy);
    countData=0;
    countVis=false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {

      var response = await Network.postDataWithAPIM('UDM/consummary/ConsumptionSummaryResult/V1.0.0/ConsumptionSummaryResult','ConsumptionSummaryResult',
          lable+"~"+cFrom+"~"+cTo+"~"+railway+"~"+department+"~"+userDepot +
              "~"+ userSubDepot
              +"~"+itemUsage+"~"+itemUnit+"~"+dynamicValue,prefs.getString('token'));
      print(jsonEncode({'input_type':'ConsumptionSummaryResult','input':lable+"~"+cFrom+"~"+cTo+"~"+railway+"~"+department+"~"+userDepot +
          "~"+ userSubDepot
          +"~"+itemUsage+"~"+itemUnit+"~"+dynamicValue}));
      if (response.statusCode == 200) {
        var listdata = json.decode(response.body);
        if (listdata['status']=='OK') {
          var listJson=listdata['data'];
          if (listJson != null) {
            _items = listJson.map<ConsSummary>((val) => ConsSummary.fromJson(val)).toList();
            storeInDB();
            _duplicatesitems = _items;
            countData=_items!.length;
            setState(ConsSummarytate.Finished);
          } else {
            countData=0;
            _error = Error("Exception",
                "Something Unexpected happened! Please try again.");
            setState(ConsSummarytate.Idle);
            IRUDMConstants().showSnack(listdata['message'], context);
            //setState(ConsSummarytate.FinishedWithError);
          }
        } else {
          _error = Error("Exception", "No data found");
          setState(ConsSummarytate.Idle);
          IRUDMConstants().showSnack('No data found', context);
        //  showInSnackBar("Data not found", context);

        }
      } else {
        _error = Error(
            "Exception", "Something Unexpected happened! Please try again.");
        //setState(ConsSummarytate.FinishedWithError);
        setState(ConsSummarytate.Idle);
        IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
      }
    } on HttpException {
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      // print("Exception "+err.toString());
      //setState(ConsSummarytate.FinishedWithError);
      setState(ConsSummarytate.Idle);

      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } on SocketException {
      print('No Internet connection 😑');
      _error = Error("Connectivity Error",
          "No connectivity. Please check your connection.");
      // print("Error "+err.toString());
      //setState(ConsSummarytate.FinishedWithError);
      setState(ConsSummarytate.Idle);
      IRUDMConstants().showSnack('No connectivity. Please check your connection.', context);
    } on FormatException {
      print("Bad response format 👎");
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      // print("Error "+err.toString());
      //setState(ConsSummarytate.FinishedWithError);
      setState(ConsSummarytate.Idle);
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } catch (err) {
      setState(ConsSummarytate.Idle);
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    }
  }

  void showInSnackBar(String value, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
        content: new Text(value)
    ));
  }

  Future<void> searchDescription(String query) async {
    var dbItems = await DatabaseHelper.instance.fetchConsSummary();
    if (query.isNotEmpty) {
      // _items = dbItems.where((row) => row[DatabaseHelper.Tbl13_ledgerfolioplno].toString().toLowerCase().contains(query.toLowerCase())||
      // row[DatabaseHelper.Tbl13_ledgerfolioshortdesc].toString().toLowerCase().contains(query.toLowerCase())
      //     ||row[DatabaseHelper.Tbl10_vs].toString().toLowerCase().contains(query.toLowerCase())
      //     ||row[DatabaseHelper.Tbl10_consumind].toString().toLowerCase().contains(query.toLowerCase())
      //     ||row[DatabaseHelper.Tbl13_ledgerno].toString().toLowerCase().contains(query.toLowerCase())
      //     ||row[DatabaseHelper.Tbl13_stkunit].toString().toLowerCase().contains(query.toLowerCase())
      //     ||row[DatabaseHelper.Tbl13_issueccode].toString().toLowerCase().contains(query.toLowerCase())
      // ||row[DatabaseHelper.Tbl13_issconsgdept].toString().toLowerCase().contains(query.toLowerCase()))
      //     .map<ConsSummary>((e) => ConsSummary.fromJson(e))
      //     .toList();
      _items = _duplicatesitems!.where((element) => element.pacfirm.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.aac.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.depodetail.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.issueccode.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.rlyname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.issconsgdept.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.issconsgdept.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.ledgerno.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.vs.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.consumind.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.ledgername.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.ledgerfoliono.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.ledgerfolioname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.ledgerfolioplno.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.ledgerfolioshortdesc.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.consumptionvalue.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.consumptionqty.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.ledgerfolioplno.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.ledgerfolioshortdesc.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.stkunit.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.stkunit.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
      ).toList();
      countData=_items!.length;
      countVis=true;
    }else{
      countVis=false;
      var dbItems = await DatabaseHelper.instance.fetchConsSummary();
      _items=dbItems.map<ConsSummary>((e) => ConsSummary.fromJson(e)).toList();
      countData=_items!.length;
    }
    setState(ConsSummarytate.Finished);
  }
}
