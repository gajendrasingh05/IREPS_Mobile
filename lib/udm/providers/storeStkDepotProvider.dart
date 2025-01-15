import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:flutter_app/udm/helpers/database_helper.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/models/stock.dart';
import 'package:flutter_app/udm/models/storeStockDepot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/item.dart';
import '../helpers/error.dart';

enum StoreStkDepotState { Idle, Busy, Finished, FinishedWithError }

class StoreStkDepotStateProvider with ChangeNotifier{
  List<StoreStkDepot>? _items;
  List<StoreStkDepot>? _duplicatesitems;
  Error? _error;
  List<Map<String, dynamic>>? dbResult;
  StoreStkDepotState _state = StoreStkDepotState.Idle;
  int? countData;
  bool countVis=false;
  void setState(StoreStkDepotState currentState) {
    _state = currentState;
    notifyListeners();
  }

  StoreStkDepotState get state {
    return _state;
  }

  Error? get error {
    return _error;
  }

  List<StoreStkDepot>? get storeStkDptkList {
    return _items;
  }

  void storeInDB(var json) async {
    DatabaseHelper databaseHelper = DatabaseHelper.instance;
    await databaseHelper.deleteStoreStockDepotItems();
    try {
      //_items.forEach((element) async {
        await databaseHelper.insertStoreStk(_items);
     // });
    } catch (err) {
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      setState(StoreStkDepotState.FinishedWithError);
    }
  }

  _setHeaders() => {
    'Content-type' : 'application/json',
    'Accept' : 'application/json',
    //  'Authorization' : 'Bearer $token'
  };


  Future<void> fetchAndStoreItemsListwithdata(railway,division,unitType,BuildContext context) async {
    setState(StoreStkDepotState.Busy);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      countData=0;
      countVis=false;

     // var summaryResponse = await Network().postDataWithAPIM('UDM/StoreDepotStock/StoresDepotStockResult/V1.0.0/StoresDepotStockResult','StoresDepotStockResult',
       //   railway+"~"+division +"~"+unitType,prefs.getString('token'));
     /* var response = await http.post(url,
      body: jsonEncode({'input_type':'StoresDepotStockResult','input':railway+"~"+division +"~"+unitType}),
          headers: _setHeaders());
*/
      var response = await Network.postDataWithAPIM('UDM/StoreDepotStock/V1.0.0/StoresDepotStockResult','StoresDepotStockResult',
          railway+"~"+division +"~"+unitType,prefs.getString('token'));


      if (response.statusCode == 200) {
         print(response.body);
        var listdata = json.decode(response.body);
        if (listdata['status']=='OK') {
          var listJson=listdata['data'];
          if (listJson != null) {
            _items = listJson.map<StoreStkDepot>((val) => StoreStkDepot.fromJson(val)).toList();
            storeInDB(listJson);
            _duplicatesitems = _items;
            countData=_items!.length;
            setState(StoreStkDepotState.Finished);
          } else {
            countData=0;
            _error = Error("Exception",
                "Something Unexpected happened! Please try again.");
            setState(StoreStkDepotState.Idle);
            IRUDMConstants().showSnack(listdata['message'], context);
            //setState(StoreStkDepotState.FinishedWithError);
          }
        } else {
          _error = Error("Exception", "No data found");
          setState(StoreStkDepotState.Idle);
          IRUDMConstants().showSnack('No data found', context);
        //  showInSnackBar("Data not found", context);
        }
      } else {
        _error = Error(
            "Exception", "Something Unexpected happened! Please try again.");
        //setState(StoreStkDepotState.FinishedWithError);
        setState(StoreStkDepotState.Idle);
        IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
      }
    } on HttpException {
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      // print("Exception "+err.toString());
      //setState(StoreStkDepotState.FinishedWithError);
      setState(StoreStkDepotState.Idle);

      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } on SocketException {
      print('No Internet connection 😑');
      _error = Error("Connectivity Error",
          "No connectivity. Please check your connection.");
      // print("Error "+err.toString());
      //setState(StoreStkDepotState.FinishedWithError);
      setState(StoreStkDepotState.Idle);
      IRUDMConstants().showSnack('No connectivity. Please check your connection.', context);
    } on FormatException {
      print("Bad response format 👎");
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      // print("Error "+err.toString());
      //setState(StoreStkDepotState.FinishedWithError);
      setState(StoreStkDepotState.Idle);
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } catch (err) {
      setState(StoreStkDepotState.Idle);
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    }
  }

  void showInSnackBar(String value, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
        content: new Text(value)
    ));
  }

  Future<void> searchDescription(String query) async {
    var dbItems = await DatabaseHelper.instance.fetchSavedStoreStockDepotItem();
    if (query.isNotEmpty) {
      // _items = dbItems.where((row) => row[DatabaseHelper.Tbl6_orgZone].toString().toLowerCase().contains(query.toLowerCase())
      //    || row[DatabaseHelper.Tbl6_ward].toString().toLowerCase().contains(query.toLowerCase())
      // ||row[DatabaseHelper.Tbl6_ItemCode].toString().toLowerCase().contains(query.toLowerCase())
      // ||row[DatabaseHelper.Tbl6_stkqty].toString().toLowerCase().contains(query.toLowerCase())
      //     ||row[DatabaseHelper.Tbl6_unit].toString().toLowerCase().contains(query.toLowerCase())
      //     ||row[DatabaseHelper.Tbl6_rate].toString().toLowerCase().contains(query.toLowerCase())
      //     ||row[DatabaseHelper.Tbl6_StoreDepot].toString().toLowerCase().contains(query.toLowerCase())
      // ||row[DatabaseHelper.Tbl6_itemDescr].toString().toLowerCase().contains(query.toLowerCase()))
      //     .map<StoreStkDepot>((e) => StoreStkDepot.fromJson(e))
      //     .toList();
      _items = _duplicatesitems!.where((element) => element.orgZone.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.cat.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.storeDepot.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.ward.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.rate.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.orgZone.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.itemCode.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.itemDesc.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.unit.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.stkqty.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
      ).toList();
      countData=_items!.length;
      countVis=true;
    }else{
      countVis=false;
      dbItems.forEach((row) => print(row));
      _items=await DatabaseHelper.instance.getStoreStockDepotItemList();
      countData=_items!.length;
    }
    setState(StoreStkDepotState.Finished);
  }
}
