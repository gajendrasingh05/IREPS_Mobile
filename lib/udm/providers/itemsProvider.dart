import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:flutter_app/udm/helpers/database_helper.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/models/item_summary.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/item.dart';
import '../helpers/error.dart';

enum ItemListState { Idle, Busy, Finished, FinishedWithError }

class ItemListProvider with ChangeNotifier {
  List<Item>? _items;
  List<Item>? _duplicatesitems;
  List<ItemSummary>? _itemSummary;
  var stkValue=0.0;
  Error? _error;
  int? countData;
  bool countVis=false;
  List<Map<String, dynamic>>? dbResult;

  ItemListState _state = ItemListState.Idle;

  void setState(ItemListState currentState) {
    _state = currentState;
    notifyListeners();
  }

  ItemListState get state {
    return _state;
  }

  Error? get error {
    return _error;
  }

  List<ItemSummary>? get summaryList {
    return _itemSummary;
  }

  List<Item>? get itemList {
    return _items;
  }

  Future<void> deletItem() async {
    try {
      DatabaseHelper dbHelper = DatabaseHelper.instance;
      dbResult = await dbHelper.fetchSaveLoginUser();
    } catch (err) {
      _error = Error("Exception", "Something Unexpected happened! Please try again.");
      setState(ItemListState.FinishedWithError);
    }
  }

  void storeInDB() async {
    DatabaseHelper databaseHelper = DatabaseHelper.instance;
    await databaseHelper.deleteItems();
    try {
     // _items.forEach((element) async {
        await databaseHelper.insertItem(_items);
     // });
    } catch (err) {
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      setState(ItemListState.FinishedWithError);
    }
  }


  Future<void> fetchAndStoreItemsListwithdata(
      String railway,
      String unitName,
      String division,
      String department,
      String userDepot,
      String descriptiont,BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print( prefs.getString('token'));
    countData=0;
    countVis=false;
    setState(ItemListState.Busy);
    try {
      print(jsonEncode({'input_type':'ItemSearchResultSummary','input':railway +
          "~" +
          unitName +
          "~" +
          division +
          "~" +
          department +
          "~" +
          userDepot +
          "~" +
          descriptiont}));
      print(jsonEncode({'input_type':'UDMItemsResult','input':railway +
          "~" +
          unitName +
          "~" +
          division +
          "~" +
          department +
          "~" +
          userDepot +
          "~" +
          descriptiont}));
      var summaryResponse = await Network.postDataWithAPIM('Items/ItemSearchResultSummary/V1.0.0/ItemSearchResultSummary','ItemSearchResultSummary',
          railway +
              "~" +
              unitName +
              "~" +
              division +
              "~" +
              department +
              "~" +
              userDepot +
              "~" +
              descriptiont,prefs.getString('token'));

      print("Item Search ${json.decode(summaryResponse.body)}");
      var summayData = json.decode(summaryResponse.body);
      if(summayData.toString().contains('data')){
        var summayDataJson=summayData['data'];
        _itemSummary = summayDataJson.map<ItemSummary>((val) => ItemSummary.fromJson(val)).toList();
        stkValue=0.0;
        for(int i=0;i<_itemSummary!.length;i++){
          stkValue = stkValue+double.parse(_itemSummary![i].totalval!);
          assert(stkValue is double);
        }
      }else{
        stkValue=0.0;
        countData=0;
        _itemSummary!.clear();
      }
      var response=await Network.postDataWithAPIM('Items/UDMItemsResult/V1.0.0/UDMItemsResult','UDMItemsResult',
          railway +
              "~" +
              unitName +
              "~" +
              division +
              "~" +
              department +
              "~" +
              userDepot +
              "~" +
              descriptiont,prefs.getString('token'));

      print(jsonEncode({'input_type':'UDMItemsResult','input': railway +
          "~" +
          unitName +
          "~" +
          division +
          "~" +
          department +
          "~" +
          userDepot +
          "~" +
          descriptiont}));
      if(response.statusCode == 200) {
        var listdata = json.decode(response.body);
        if(listdata['status']=="OK") {
          var listJson=listdata['data'];
          if (listJson != null) {
            _items = listJson.map<Item>((val) => Item.fromJson(val)).toList();
            _duplicatesitems = _items;
            storeInDB();
            countData=_items!.length;
            setState(ItemListState.Finished);
          } else {
            _error = Error("Exception",
                listdata['message'] );
            setState(ItemListState.Idle);
            IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            //setState(ItemListState.FinishedWithError);
          }
        } else {
          _error = Error("Exception", listdata['message']);
          setState(ItemListState.Idle);
          IRUDMConstants().showSnack('No data found', context);
        //  showInSnackBar("Data not found", context);

        }
      } else {
        _error = Error(
            "Exception", "Something Unexpected happened! Please try again.");
        //setState(ItemListState.FinishedWithError);
        setState(ItemListState.Idle);
        IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
      }
    } on HttpException {
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      // print("Exception "+err.toString());
      //setState(ItemListState.FinishedWithError);
      setState(ItemListState.Idle);

      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } on SocketException {
      print('No Internet connection 😑');
      _error = Error("Connectivity Error",
          "No connectivity. Please check your connection.");
      // print("Error "+err.toString());
      //setState(ItemListState.FinishedWithError);
      setState(ItemListState.Idle);
      IRUDMConstants().showSnack('No connectivity. Please check your connection.', context);
    } on FormatException {
      print("Bad response format 👎");
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      // print("Error "+err.toString());
      //setState(ItemListState.FinishedWithError);
      setState(ItemListState.Idle);
      IRUDMConstants().showSnack('Bad response format 👎', context);
    } catch (err) {
      setState(ItemListState.Idle);
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    }
  }

  void showInSnackBar(String value, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(value)
    ));
  }


  Future<void> searchDescription(String query) async {
    //var dbItems = await DatabaseHelper.instance.fetchSavedItem();
    if(query.isNotEmpty) {
      _items = _duplicatesitems!.where((element) => element.ledger_name.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.item_code.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
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
          || element.stoqQty.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.unitCode.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.unit.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.booavgrat.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
      ).toList();
      countData=_items!.length;
      countVis=true;
    }else{
      countVis=false;
      _items=await DatabaseHelper.instance.getItemList();
      countData=_items!.length;
    }
    setState(ItemListState.Finished);
  }
}
