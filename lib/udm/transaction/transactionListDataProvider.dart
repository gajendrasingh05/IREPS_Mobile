import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:flutter_app/udm/helpers/database_helper.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/models/stock.dart';
import 'package:flutter_app/udm/models/summaryStock.dart';
import 'package:flutter_app/udm/transaction/transactionListDataModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/item.dart';
import '../helpers/error.dart';

enum TransactionListDataState { Idle, Busy, Finished, FinishedWithError }

class TransactionListDataProvider with ChangeNotifier{
  List<TransactionListDataModel>? _items;
  static List<TransactionListDataModel>? _duplicatesitems;

  Error? _error;
  var headerData,footerData,from_Date,to_Date;
  List<Map<String, dynamic>>? dbResult;
  var issueQty;
  var issuValue,recQty,recValue;
  TransactionListDataState _state = TransactionListDataState.Idle;

  int? countData;
  bool countVis=false;

// LoginState get state => _state;
  void setState(TransactionListDataState currentState) {
    _state = currentState;
    notifyListeners();
  }

  TransactionListDataState get state {
    return _state;
  }

  Error? get error {
    return _error;
  }

  List<TransactionListDataModel>? get transactionList {
    return _items;
  }

  void storeInDB(List<TransactionListDataModel>? _items) async {
    DatabaseHelper databaseHelper = DatabaseHelper.instance;
    await databaseHelper.deleteTransactionsData();
    try {
      await databaseHelper.insertTransactionsData(_items);
    } catch (err) {
      _error = Error("Exception", "Something Unexpected happened! Please try again.");
      setState(TransactionListDataState.FinishedWithError);
    }
  }

  Future<void> fetchTransactionListData(railway,unitType,division,department,userDepot,userSubDepot, ledgerNo, folioNo, ledgerFolioPlNo, fromDate,toDate,BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(TransactionListDataState.Busy);
    String fDate=DateFormat('dd-MM-yyyy').format(fromDate);
    String tDate=DateFormat('dd-MM-yyyy').format(toDate);
    issueQty='';issuValue='';recQty='';recValue='';
    try {
      from_Date=fDate;
      to_Date=tDate;
      var headerResponse = await Network.postDataWithAPIM('UDM/transaction/V1.0.0/transaction', 'TransactionDetails', railway+"~"+userDepot + "~"+userSubDepot+"~"+ledgerNo +"~"+folioNo+"~"+ledgerFolioPlNo,prefs.getString('token'));
      if(headerResponse.statusCode==200){
        var headerjsonData = json.decode(headerResponse.body);
        headerData=headerjsonData['data'];
        print(headerResponse.body);
      }
      print("input data ${railway+"~"+userDepot+"~"+userSubDepot+"~"+ledgerNo+"~"+folioNo+"~"+ledgerFolioPlNo+"~"+fDate+"~"+tDate}");
      var response = await Network.postDataWithAPIM('UDM/transaction/V1.0.0/transaction', 'TransactionResult', railway+"~"+userDepot+"~"+userSubDepot+"~"+ledgerNo+"~"+folioNo+"~"+ledgerFolioPlNo+"~"+fDate+"~"+tDate, prefs.getString('token'));
      if(response.statusCode == 200) {
        var listdata = json.decode(response.body);
        print("txn Detail Data....$listdata");
        if(listdata['status']=='OK') {
          var listJson=listdata['data'];
          if(listJson != null) {
            _items = listJson.map<TransactionListDataModel>((val) => TransactionListDataModel.fromJson(val)).toList();
            _duplicatesitems = _items;
            for(int i=0;i<listJson.length;i++){
              if(listJson[i]['issuetotalvalue']!=null){
                issueQty=listJson[i]['issuetotalqty'];
                issuValue=listJson[i]['issuetotalvalue'];
              }
              if(listJson[i]['receipttotalqty']!=null){
                recQty=listJson[i]['receipttotalqty'];
                recValue=listJson[i]['receipttotalvalue'];
              }
            }
            setState(TransactionListDataState.Finished);
          } else {
            _error = Error("Exception","Something Unexpected happened! Please try again.");
            setState(TransactionListDataState.Idle);
            IRUDMConstants().showSnack('No Data', context);
          }
        } else {
          _error = Error("Exception", "No data found");
          IRUDMConstants().showSnack('No data found', context);
          setState(TransactionListDataState.Idle);
        }
      } else {
        _error = Error("Exception", "Something Unexpected happened! Please try again.");
        setState(TransactionListDataState.Idle);
        IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
      }
    } on HttpException {
      _error = Error("Exception", "Something Unexpected happened! Please try again.");
      setState(TransactionListDataState.Idle);
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } on SocketException {
      print('No Internet connection 😑');
      _error = Error("Connectivity Error", "No connectivity. Please check your connection.");
      setState(TransactionListDataState.Idle);
      IRUDMConstants().showSnack('No connectivity. Please check your connection.', context);
    } on FormatException {
      print("Bad response format 👎");
      _error = Error("Exception", "Something Unexpected happened! Please try again.");
      setState(TransactionListDataState.Idle);
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } catch (err) {
      setState(TransactionListDataState.Idle);
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    }
  }

  void showInSnackBar(String value, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
        content: Text(value)
    ));
  }

  Future<void> searchDescription(String query) async{
    if(query.isNotEmpty){
      _items = _duplicatesitems!.where((element) => element.mACHINEDTLS.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.sTKVERIFIERUSERNAME.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.sTKVERIFIERPOST.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.tRANSUSERNAME.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.uSERTYPE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.tRANSREMARKS.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.rEFTRANSKEY.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.tRANSKEY.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.rEJIND.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.tHRESHOLDLIMIT.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.cANCELLEDVOUCHERNO.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.cANCELLEDVOUCHERDATE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.tRANSSTATUS.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.iSSEDEPOTTYPE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pONO.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.lOANBALQTY.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.lOANINDDESC.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.tRANSTYPEDESCRIPTION.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.tRANSCARDCODEDESC.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.rEMARKS.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.aCKNOWLEDGEFLAG.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.cARDCODE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.oPENBALSTKQTY.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.cLOSINGBALSTKQTY.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.oPENBALVALUE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.cLOSINGBALVALUE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.sTKQTY.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.sTKVALUE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.bAR.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.oRG_ZONE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.rLYNAME.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.cONS_CODE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.lEDGERNO.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.lEDGERNAME.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.lEDGERFOLIONO.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.lEDGERFOLIONAME.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.lEDGERFOLIOPLNO.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.tRANSUNIT.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.lEDGERFOLIOSHORTDESC.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.tRANSTYPE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pO_TYPE.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.vOUCHERNO.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.tRANSQTY.toString().trim().contains(query.toString().trim())
      ).toList();
      setState(TransactionListDataState.Finished);
    }
    else{
      _items = _duplicatesitems;
      setState(TransactionListDataState.Finished);
    }
  }
}
