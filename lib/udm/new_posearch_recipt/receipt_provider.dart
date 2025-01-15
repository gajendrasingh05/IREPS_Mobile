import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:flutter_app/udm/helpers/database_helper.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/new_posearch_recipt/receipt_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/error.dart';


enum ReceiptState { Idle, Busy, Finished, FinishedWithError }

class ReceiptProvider with ChangeNotifier{
  List<ReceiptModel>? _items;
  static List<ReceiptModel>? _duplicatesitems;
  Error? _error;
  List<Map<String, dynamic>>? dbResult;
  ReceiptState _state = ReceiptState.Idle;
  String bodyData1='',bodyData2='',datef='',dateTo='';
  int? countData;
  bool countVis=false;
  void setState(ReceiptState currentState) {
    _state = currentState;
    notifyListeners();
  }

  ReceiptState get state {
    return _state;
  }

  Error? get error {
    return _error;
  }

  List<ReceiptModel>? get poSearchList {
    return _items;
  }


  Future<void> fetchAndStoreReceiptData(String pONO , String pOSR , String rLY, BuildContext context) async {
    setState(ReceiptState.Busy);
    countData=0;
    countVis=false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      print(jsonEncode({'input_type':'List_transaction','input': pONO+ "~" + pOSR + "~" + rLY}));
      var response = await Network.postDataWithAPIM('UDM/Bill/V1.0.0/GetData', 'List_transaction', pONO+ "~" + pOSR + "~" + rLY,prefs.getString('token'));
      if (response.statusCode == 200) {
        print(response.body);
        var listdata = json.decode(response.body);
        if (listdata['status']=='OK') {
          var listJson=listdata['data'];
          if (listJson != null) {
            _items = listJson.map<ReceiptModel>((val) => ReceiptModel.fromJson(val)).toList();
            _duplicatesitems = _items;
            print(_items!.length);
            // storeInDB();
            countData=_items!.length;
            setState(ReceiptState.Finished);
          } else {
            countData=0;
            _error = Error("Exception",
                "Something Unexpected happened! Please try again.");
            setState(ReceiptState.Idle);
            IRUDMConstants().showSnack(listdata['message'], context);
            //setState(ReceiptState.FinishedWithError);
          }
        } else {
          _error = Error("Exception", "No data found");
          setState(ReceiptState.Idle);
          IRUDMConstants().showSnack('No data found', context);
          //  showInSnackBar("Data not found", context);
        }
      } else {
        _error = Error(
            "Exception", "Something Unexpected happened! Please try again.");
        //setState(ReceiptState.FinishedWithError);
        setState(ReceiptState.Idle);
        IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
      }
    } on HttpException {
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      setState(ReceiptState.Idle);

      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } on SocketException {
      print('No Internet connection 😑');
      _error = Error("Connectivity Error",
          "No connectivity. Please check your connection.");
      setState(ReceiptState.Idle);
      IRUDMConstants().showSnack('No connectivity. Please check your connection.', context);
    } on FormatException {
      print("Bad response format 👎");
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      setState(ReceiptState.Idle);
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } catch (err) {
      setState(ReceiptState.Idle);
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    }
  }

  void showInSnackBar(String value, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(value)
    ));
  }

  Future<void> searchReciptScreen(String query) async{
    if (query.isNotEmpty){
      //_items!.clear();
      _items = _duplicatesitems!.where((element) => element.railway.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.ponumber.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.cname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.conscode.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.poqty.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pounitrate.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.podate.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.accountname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.posr.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pounitdesc.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.itemdescription.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.expirtydate.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.warrepflag.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.rnoteurl.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.reftranskey.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.transreinspectiondesc.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.rejtranskey.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.transkey.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.totalreinspqty.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.totalreturnedqty.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.reinspflag.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.unitname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.trunit.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.transstatus.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.voucherno.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.transdate.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.qtydispatched.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.qtyreceived.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.qtyaccepted.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.qtyrejected.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.challandate.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.challanno.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.curmakebrand.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.curproductsrno.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.billno.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.billdate.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.cardcode.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.rejind.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.issuemakebrand.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.issueproductsrno.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.issueexpirydate.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.expritydate.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.receiptexpritydate.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.sortaccountaldate.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.vouchernumber.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.accountaldat.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.makebrand.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.productsrno.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.trqty.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.renspectionremark.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.issuevrno.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.issuevrdate.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.issueqty.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.issueunit.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.issuetransdetails.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.receiptbalqty.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.receiptmakebrand.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.receiptprductsrno.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
      ).toList();
      setState(ReceiptState.Finished);
    }
    else{
      _items = _duplicatesitems;
      setState(ReceiptState.Finished);
    }
  }
}
