import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:flutter_app/udm/helpers/database_helper.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/onlineBillStatus/actionModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/error.dart';

enum ActionListState { Idle, Busy, Finished, FinishedWithError }

class ActionProvider with ChangeNotifier {
  List<ActionModel>? _items;
  List<ActionModel>? _duplicatesitems;

  var stkValue=0.0;
  Error? _error;
  int? countData;
  bool countVis=false;
  List<Map<String, dynamic>>? dbResult;

  ActionListState _state = ActionListState.Idle;

  void setState(ActionListState currentState) {
    _state = currentState;
    notifyListeners();
  }

  ActionListState get state {
    return _state;
  }

  Error? get error {
    return _error;
  }

  List<ActionModel>? get itemList {
    return _items;
  }

  Future<void> deletItem() async {
    try {
      DatabaseHelper dbHelper = DatabaseHelper.instance;
      dbResult = await dbHelper.fetchSaveLoginUser();
    } catch (err) {
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      setState(ActionListState.FinishedWithError);
    }
  }

  void storeInDB() async {
    DatabaseHelper databaseHelper = DatabaseHelper.instance;
    await databaseHelper.deleteItems();
    try {
     await databaseHelper.insertonlineStatusAction(_items);
    } catch (err) {
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      setState(ActionListState.FinishedWithError);
    }
  }

  Future<void> fetchActionData(String rlyCode, String pONUMBER , String pOSR, BuildContext context) async {
    setState(ActionListState.Busy);

    countData=0;
    countVis=false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var response = await Network.postDataWithAPIM('UDM/Bill/V1.0.0/GetData','OnlineBillStatusDTLS', rlyCode+"~"+pONUMBER+"~"+pOSR,prefs.getString('token'));
      if (response.statusCode == 200) {
        var listdata = json.decode(response.body);
        if (listdata['status']=='OK') {
          var listJson=listdata['data'];
          if(listJson != null) {
            _items = listJson.map<ActionModel>((val) => ActionModel.fromJson(val)).toList();
            _duplicatesitems = _items;
            countData=_items!.length;
            setState(ActionListState.Finished);
          }
          else {
            countData=0;
            _error = Error("Exception", "Something Unexpected happened! Please try again.");
            setState(ActionListState.Idle);
            IRUDMConstants().showSnack(listdata['message'], context);
          }
        } else {
          _error = Error("Exception", "No data found");
          setState(ActionListState.Idle);
          IRUDMConstants().showSnack('No data found', context);
        }
      } else {
        _error = Error("Exception", "Something Unexpected happened! Please try again.");
        setState(ActionListState.Idle);
        IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
      }
    } on HttpException {
      _error = Error("Exception", "Something Unexpected happened! Please try again.");
      setState(ActionListState.Idle);
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } on SocketException {
      _error = Error("Connectivity Error", "No connectivity. Please check your connection.");
      setState(ActionListState.Idle);
      IRUDMConstants().showSnack('No connectivity. Please check your connection.', context);
    } on FormatException {
      _error = Error("Exception", "Something Unexpected happened! Please try again.");
      setState(ActionListState.Idle);
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } catch (err) {
      setState(ActionListState.Idle);
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    }
  }
  void showInSnackBar(String value, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(value)
    ));
  }

  Future<void> searchDescription(String query) async{
    if (query.isNotEmpty){
      _items = _duplicatesitems!.where((element) => element.pONUMBER.toString().trim().contains(query.toString().trim())
          || element.unit.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.bILLDATE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.bILLNO.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.dOCTYPE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.rLY.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pAYINGAUTHORITY.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.dOCDATE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.dOCNO.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.iTEMDESC.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.vENDORNAME.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.iREPSBILLDATE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.iREPSBILLNO.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.cO6NO.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.bILLAMOUNTFORITEM.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.iTEMNOOFBILL.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pAYMENTPERCENTAGE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pAYMENTTYPE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.bILLTYPE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.rETURNREASON.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.cO7NO.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.cO6DATE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.bILLAMOUNTFORITEM.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.iTEMNOOFBILL.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pAYMENTPERCENTAGE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pAYMENTTYPE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.bILLTYPE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.rETURNREASON.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pAIDAMOUNTFORBILL.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.dEDUCTEDAMOUNTFORBILL.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pASSEDAMOUNTFORBILL.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.tOTALAMOUNTFORBILL.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pAYMENTRETURNDATE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pASSEDAMOUNTFORITEM.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.cO7DATE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pOSR.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pAYAUTH.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.qty.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pODATE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.cARDCODE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.qTYRECEIVED.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.qTYACCEPTED.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.rNOTEDATE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.rNOTENO.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || (element.qty.toString().trim().toLowerCase()+element.unit.toString().trim().toLowerCase()).contains(query.toString().trim().toLowerCase())
          || (element.qty.toString().trim()+element.unit.toString().trim()).contains(query.toString().trim())
      ).toList();
      countData=_items!.length;
      setState(ActionListState.Finished);
    }
    else{
      _items = _duplicatesitems;
      countData=_items!.length;
      setState(ActionListState.Finished);
    }
  }

}
