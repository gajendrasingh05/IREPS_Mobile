import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:flutter_app/udm/helpers/database_helper.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/models/stock.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/item.dart';
import '../helpers/error.dart';

enum StockListState { Idle, Busy, Finished, FinishedWithError }

class StockListProvider with ChangeNotifier{
  List<Stock>? _items;
  List<Stock>? _duplicatesitems;
  Error? _error;
  List<Map<String, dynamic>>? dbResult;
  StockListState _state = StockListState.Idle;
  int? countData;
  bool countVis=false;
  void setState(StockListState currentState) {
    _state = currentState;
    notifyListeners();
  }

  StockListState get state {
    return _state;
  }

  Error? get error {
    return _error;
  }

  List<Stock>? get Stockist {
    return _items;
  }

  Future<void> deletItem() async {
    try {
      DatabaseHelper dbHelper = DatabaseHelper.instance;
      dbResult = await dbHelper.fetchSaveLoginUser();
    } catch (err) {
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      setState(StockListState.FinishedWithError);
    }
  }

  void storeInDB() async {
    DatabaseHelper databaseHelper = DatabaseHelper.instance;
    await databaseHelper.deleteStockItems();
    try {
    //  _items.forEach((element) async {
        await databaseHelper.insertStockItem(_items);
       // print(await databaseHelper.insertStockItem(_items));
     // });
    } catch (err) {
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      setState(StockListState.FinishedWithError);
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
  ,repotCrit
  ,stkAvl
  ,stkAvlValue,BuildContext context) async {
    setState(StockListState.Busy);
    countData=0;
    countVis=false;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print(jsonEncode({'input_type':'UDMStockAvlResult','input':railway+"~"+unitType +"~"+division+"~"+department+"~"+userDepot +
          "~"+ userSubDepot
          +"~"+itemUnit+"~"+itemUsage+"~"+itemCategory+"~"+stkNstk+"~"+repotCrit+"~"+stkAvl+"~"+stkAvlValue}));
      var response=await Network.postDataWithAPIM('stock/UDMStockAvlResult/V1.0.0/UDMStockAvlResult','UDMStockAvlResult',
          railway+"~"+unitType +"~"+division+"~"+department+"~"+userDepot +
              "~"+ userSubDepot
              +"~"+itemUnit+"~"+itemUsage+"~"+itemCategory+"~"+stkNstk+"~"+repotCrit+"~"+stkAvl+"~"+stkAvlValue,prefs.getString('token'));
      if (response.statusCode == 200) {
         print(response.body);
        var listdata = json.decode(response.body);
        if (listdata['status']=='OK') {
          var listJson=listdata['data'];
          if (listJson != null) {
            _items = listJson.map<Stock>((val) => Stock.fromJson(val)).toList();
            _duplicatesitems = _items;
            countData=_items!.length;
            storeInDB();
            setState(StockListState.Finished);
          } else {
            countData=0;
            _error = Error("Exception",
                "Something Unexpected happened! Please try again.");
            setState(StockListState.Idle);
            IRUDMConstants().showSnack(listdata['message'], context);
            //setState(StockListState.FinishedWithError);
          }
        } else {
          _error = Error("Exception", "No data found");
          setState(StockListState.Idle);
          IRUDMConstants().showSnack('No data found', context);
        //  showInSnackBar("Data not found", context);

        }
      } else {
        _error = Error(
            "Exception", "Something Unexpected happened! Please try again.");
        //setState(StockListState.FinishedWithError);
        setState(StockListState.Idle);
        IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
      }
    } on HttpException {
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      // print("Exception "+err.toString());
      //setState(StockListState.FinishedWithError);
      setState(StockListState.Idle);

      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } on SocketException {
      print('No Internet connection 😑');
      _error = Error("Connectivity Error",
          "No connectivity. Please check your connection.");
      // print("Error "+err.toString());
      //setState(StockListState.FinishedWithError);
      setState(StockListState.Idle);
      IRUDMConstants().showSnack('No connectivity. Please check your connection.', context);
    } on FormatException {
      print("Bad response format 👎");
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      // print("Error "+err.toString());
      //setState(StockListState.FinishedWithError);
      setState(StockListState.Idle);
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } catch (err) {
      setState(StockListState.Idle);
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    }
  }

  void showInSnackBar(String value, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
        content: new Text(value)
    ));
  }

  Future<void> searchDescription(String query) async {
    var dbItems = await DatabaseHelper.instance.fetchSavedStockItem();
    if (query.isNotEmpty) {
      // _items = dbItems.where((row) => row[DatabaseHelper.Tbl5_aac].toString().toLowerCase().contains(query.toLowerCase())||row[DatabaseHelper.Tbl5_ledgerFolioPlNo].toString().toLowerCase().contains(query.toLowerCase())||
      //     row[DatabaseHelper.Tbl5_stkValue].toString().toLowerCase().contains(query.toLowerCase())
      // ||row[DatabaseHelper.Tbl5_ledgerFolioDesc].toString().toLowerCase().contains(query.toLowerCase())
      // ||row[DatabaseHelper.Tbl5_stkQty].toString().toLowerCase().contains(query.toLowerCase())
      //     ||row[DatabaseHelper.Tbl5_ledgerNo].toString().toLowerCase().contains(query.toLowerCase())
      //     ||row[DatabaseHelper.Tbl5_stkUnit].toString().toLowerCase().contains(query.toLowerCase())
      //     ||row[DatabaseHelper.Tbl5_isseCCode].toString().toLowerCase().contains(query.toLowerCase())
      //     ||row[DatabaseHelper.Tbl5_stkItem].toString().toLowerCase().contains(query.toLowerCase())
      // ||row[DatabaseHelper.Tbl5_issueConsDept].toString().toLowerCase().contains(query.toLowerCase()))
      //     .map<Stock>((e) => Stock.fromJson(e))
      //     .toList();
      _items = _duplicatesitems!.where((element) => element.itemCat.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.aac.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.depotDetail.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.issueCode.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.railway.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.stkItem.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.issueConsgDept.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.ledgerNo.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.vs.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.consumInd.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.ledgerType.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.ledgerName.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.ledgerFolioNo.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.ledgerFolioName.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.ledgerFolioPlNo.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.ledgerFolioShortDesc.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.stkqty.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.bar.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.stkValue.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.stkUnit.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.thresholdLimit.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.lmrdt.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.lmidt.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
      ).toList();
      countData=_items!.length;
      countVis=true;
    }else{
      countVis=false;
      _items=await DatabaseHelper.instance.getStockItemList();
      countData=_items!.length;
    }
    setState(StockListState.Finished);
  }
}
