import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:flutter_app/udm/helpers/database_helper.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/models/cons_analysis.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/error.dart';

enum ConsAnalysistate { Idle, Busy, Finished, FinishedWithError }

class ConsAnalysisProvider with ChangeNotifier{
  List<ConsAnalysis>? _items;
  List<ConsAnalysis>? _duplicatesitems;
  Error? _error;
  List<Map<String, dynamic>>? dbResult;
  ConsAnalysistate _state = ConsAnalysistate.Idle;
  int? countData;
  bool countVis=false;
  void setState(ConsAnalysistate currentState) {
    _state = currentState;
    notifyListeners();
  }

  ConsAnalysistate get state {
    return _state;
  }

  Error? get error {
    return _error;
  }

  List<ConsAnalysis>? get consAnalysisList {
    return _items;
  }

  Future<void> deletItem() async {
    try {
      DatabaseHelper dbHelper = DatabaseHelper.instance;
      dbResult = await dbHelper.fetchSaveLoginUser();
    } catch (err) {
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      setState(ConsAnalysistate.FinishedWithError);
    }
  }

  void storeInDB() async {
    DatabaseHelper databaseHelper = DatabaseHelper.instance;
    await databaseHelper.deleteConsAnalysis();
    try {
        await databaseHelper.insertConsAnalysis( _items);
        //print(await databaseHelper.insertConsAnalysis(_items));
    } catch (err) {
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      setState(ConsAnalysistate.FinishedWithError);
    }
  }

  Future<void> fetchAndStoreItemsListwithdata(railway,department,userDepot
  ,userSubDepot
  ,itemUsage,itemUnit
  ,cFrom,cTo,pFrom,pTo
  ,perc,by,context) async {
    setState(ConsAnalysistate.Busy);
    countData=0;
    countVis=false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var response = await Network.postDataWithAPIM('UDM/consanalysis/ConsumptionAnalysisResult/V1.0.0/ConsumptionAnalysisResult','ConsumptionAnalysisResult',
          railway+"~"+department+"~"+userDepot +
              "~"+ userSubDepot
              +"~"+itemUsage+"~"+itemUnit+"~"+cFrom+"~"+cTo+"~"+pFrom+"~"+pTo+"~"+perc+"~"+by,prefs.getString('token'));

      if (response.statusCode == 200) {
        var listdata = json.decode(response.body);
        if (listdata['status']=='OK') {
          var listJson=listdata['data'];
          if (listJson != null) {
            _items = listJson.map<ConsAnalysis>((val) => ConsAnalysis.fromJson(val)).toList();
            storeInDB();
            _duplicatesitems = _items;
            countData=_items!.length;
            setState(ConsAnalysistate.Finished);
          } else {
            countData=0;
            _error = Error("Exception",
                "Something Unexpected happened! Please try again.");
            setState(ConsAnalysistate.Idle);
            IRUDMConstants().showSnack(listdata['message'], context);
          }
        } else {
          _error = Error("Exception", "No data found");
          setState(ConsAnalysistate.Idle);
          IRUDMConstants().showSnack('No data found', context);
        }
      } else {
        _error = Error(
            "Exception", "Something Unexpected happened! Please try again.");
        setState(ConsAnalysistate.Idle);
        IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
      }
    } on HttpException {
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      setState(ConsAnalysistate.Idle);

      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } on SocketException {
      print('No Internet connection 😑');
      _error = Error("Connectivity Error",
          "No connectivity. Please check your connection.");
      setState(ConsAnalysistate.Idle);
      IRUDMConstants().showSnack('No connectivity. Please check your connection.', context);
    } on FormatException {
      print("Bad response format 👎");
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      setState(ConsAnalysistate.Idle);
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } catch (err) {
      setState(ConsAnalysistate.Idle);
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    }
  }

  void showInSnackBar(String value, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
        content: new Text(value)
    ));
  }

  Future<void> searchDescription(String query) async {
    var dbItems = await DatabaseHelper.instance.fetchConsAnalysis();
    if (query.isNotEmpty) {
      // _items = dbItems.where((row) => row[DatabaseHelper.Tbl12_ledgerfolioplno].toString().toLowerCase().contains(query.toLowerCase())||
      // row[DatabaseHelper.Tbl12_ledgerfolioshortdesc].toString().toLowerCase().contains(query.toLowerCase())
      //     ||row[DatabaseHelper.Tbl10_vs].toString().toLowerCase().contains(query.toLowerCase())
      //     ||row[DatabaseHelper.Tbl10_consumind].toString().toLowerCase().contains(query.toLowerCase())
      //     ||row[DatabaseHelper.Tbl12_ledgerno].toString().toLowerCase().contains(query.toLowerCase())
      //     ||row[DatabaseHelper.Tbl12_stkunit].toString().toLowerCase().contains(query.toLowerCase())
      //     ||row[DatabaseHelper.Tbl12_issuecode].toString().toLowerCase().contains(query.toLowerCase())
      // ||row[DatabaseHelper.Tbl12_issconsgdept].toString().toLowerCase().contains(query.toLowerCase()))
      //     .map<ConsAnalysis>((e) => ConsAnalysis.fromJson(e))
      //     .toList();
      _items = _duplicatesitems!.where((element) => element.pacfirm.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.monthlypreviousconsumption.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.depodetail.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.issconsgdept.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.rlyname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.consumind.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.issconsgdept.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.ledgerno.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.vs.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.consumind.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.ledgername.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.ledgerfoliono.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.ledgerfolioname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.ledgerfolioplno.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.ledgerfolioshortdesc.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.monthlycurrentconsumption.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.consumppercentage.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.ledgerfolioshortdesc.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.stkunit.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
      ).toList();
      countData=_items!.length;
      countVis=true;
    }else{
      countVis=false;
      var dbItems = await DatabaseHelper.instance.fetchConsAnalysis();
      dbItems.forEach((row) => print(row));
      _items=dbItems.map<ConsAnalysis>((e) => ConsAnalysis.fromJson(e)).toList();
      countData=_items!.length;
    }
    setState(ConsAnalysistate.Finished);
  }
}
