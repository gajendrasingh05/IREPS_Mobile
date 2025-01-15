import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:flutter_app/udm/helpers/database_helper.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/models/item_summary.dart';
import 'package:flutter_app/udm/onlineBillStatus/actionModel.dart';
import 'package:flutter_app/udm/onlineBillStatus/statusModel.dart';
import 'package:flutter_app/udm/onlineBillSummary/summaryLinkDisplayModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import '../models/item.dart';
import '../helpers/error.dart';

enum SummaryLinkState { Idle, Busy, Finished, FinishedWithError }

class SummaryLinkDisplayProvider with ChangeNotifier {
  List<OpenBalance>? _items;
  // List<ItemSummary>? _itemSummary;
  var stkValue=0.0;
  Error? _error;
  int? countData;
  bool countVis=false;
  List<Map<String, dynamic>>? dbResult;

  SummaryLinkState _state = SummaryLinkState.Idle;
// LoginState get state => _state;
  void setState(SummaryLinkState currentState) {
    _state = currentState;
    notifyListeners();
  }

  SummaryLinkState get state {
    return _state;
  }

  Error? get error {
    return _error;
  }

  List<OpenBalance>? get itemList {
    return _items;
  }

  Future<void> deletItem() async {
    try {
      DatabaseHelper dbHelper = DatabaseHelper.instance;
      dbResult = await dbHelper.fetchSaveLoginUser();
    } catch (err) {
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      setState(SummaryLinkState.FinishedWithError);
    }
  }

  /*void storeInDB() async {
    DatabaseHelper databaseHelper = DatabaseHelper.instance;
    await databaseHelper.deleteItems();
    try {
      // _items.forEach((element) async {
     await databaseHelper.insertItem(_items);
      // });
    } catch (err) {
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      setState(StatusListState.FinishedWithError);
    }
  }
  _setHeaders() => {
    'Content-type' : 'application/json',
    'Accept' : 'application/json',
    //  'Authorization' : 'Bearer $token'
  };*/

  Future<void> fetchBillPassed(
      //================================
      String cONSIGNEE ,
      String rAILCODE,
      String pAYAUTHCODE ,
      String fromdate,
      String todate,

      BuildContext context) async {
    setState(SummaryLinkState.Busy);

    countData=0;
    countVis=false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var response = await Network.postDataWithAPIM(
          'UDM/Bill/V1.0.0/GetData','BillPassed',
          cONSIGNEE+"~"+rAILCODE+"~"+pAYAUTHCODE+"~"+fromdate+"~"+todate
          ,prefs.getString('token'));

      if(response.statusCode == 200) {
        print("hdhdhdhd "+response.body.toString());
        var listdata = json.decode(response.body);
        if (listdata['status']=='OK') {
          var listJson=listdata['data'];
          if (listJson != null) {
            _items = listJson.map<OpenBalance>((val) => OpenBalance.fromJson(val)).toList();
            print(_items!.length);
            // storeInDB();
            countData=_items!.length;
            setState(SummaryLinkState.Finished);
          }

          else {
            countData=0;
            _error = Error("Exception",
                "Something Unexpected happened! Please try again.");
            setState(SummaryLinkState.Idle);
            IRUDMConstants().showSnack(listdata['message'], context);
            //setState(ConsAnalysistate.FinishedWithError);
          }
        } else {
          _error = Error("Exception", "No data found");
          setState(SummaryLinkState.Idle);
          IRUDMConstants().showSnack('No data found', context);
          //  showInSnackBar("Data not found", context);

        }
      } else {
        _error = Error(
            "Exception", "Something Unexpected happened! Please try again.");
        //setState(ConsAnalysistate.FinishedWithError);
        setState(SummaryLinkState.Idle);
        IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
      }
    } on HttpException {
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      // print("Exception "+err.toString());
      //setState(ConsAnalysistate.FinishedWithError);
      setState(SummaryLinkState.Idle);

      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } on SocketException {
      print('No Internet connection 😑');
      _error = Error("Connectivity Error",
          "No connectivity. Please check your connection.");
      // print("Error "+err.toString());
      //setState(ConsAnalysistate.FinishedWithError);
      setState(SummaryLinkState.Idle);
      IRUDMConstants().showSnack('No connectivity. Please check your connection.', context);
    } on FormatException {
      print("Bad response format 👎");
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      // print("Error "+err.toString());
      //setState(ConsAnalysistate.FinishedWithError);
      setState(SummaryLinkState.Idle);
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } catch (err) {
      setState(SummaryLinkState.Idle);
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    }
  }

  Future<void> fetchPending7days(
      //================================
      String cONSIGNEE ,
      String rAILCODE,
      String pAYAUTHCODE ,
      String fromdate,

      BuildContext context) async {
    setState(SummaryLinkState.Busy);
    //String FromDate=DateFormat('dd-MM-yyyy').format(fromdate);

    countData=0;
    countVis=false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {

/*
       print(jsonEncode({'input_type':'OnlineBillStatus','input':
      pONUMBER+"~"+ pOSR}));*/


      var response = await Network.postDataWithAPIM(
          'UDM/Bill/V1.0.0/GetData','Pending7days',
          cONSIGNEE+"~"+rAILCODE+"~"+pAYAUTHCODE+"~"+fromdate
          ,prefs.getString('token'));

      if(response.statusCode == 200) {
        print("hdhdhdhd "+response.body.toString());
        var listdata = json.decode(response.body);
        if (listdata['status']=='OK') {
          var listJson=listdata['data'];
          if (listJson != null) {
            _items = listJson.map<OpenBalance>((val) => OpenBalance.fromJson(val)).toList();
            print(_items!.length);
            // storeInDB();
            countData=_items!.length;
            setState(SummaryLinkState.Finished);
          }

          else {
            countData=0;
            _error = Error("Exception",
                "Something Unexpected happened! Please try again.");
            setState(SummaryLinkState.Idle);
            IRUDMConstants().showSnack(listdata['message'], context);
            //setState(ConsAnalysistate.FinishedWithError);
          }
        } else {
          _error = Error("Exception", "No data found");
          setState(SummaryLinkState.Idle);
          IRUDMConstants().showSnack('No data found', context);
          //  showInSnackBar("Data not found", context);

        }
      } else {
        _error = Error(
            "Exception", "Something Unexpected happened! Please try again.");
        //setState(ConsAnalysistate.FinishedWithError);
        setState(SummaryLinkState.Idle);
        IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
      }
    } on HttpException {
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      // print("Exception "+err.toString());
      //setState(ConsAnalysistate.FinishedWithError);
      setState(SummaryLinkState.Idle);

      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } on SocketException {
      print('No Internet connection 😑');
      _error = Error("Connectivity Error",
          "No connectivity. Please check your connection.");
      // print("Error "+err.toString());
      //setState(ConsAnalysistate.FinishedWithError);
      setState(SummaryLinkState.Idle);
      IRUDMConstants().showSnack('No connectivity. Please check your connection.', context);
    } on FormatException {
      print("Bad response format 👎");
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      // print("Error "+err.toString());
      //setState(ConsAnalysistate.FinishedWithError);
      setState(SummaryLinkState.Idle);
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } catch (err) {
      setState(SummaryLinkState.Idle);
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    }
  }
  Future<void> fetchPending15days(
      //================================
      String cONSIGNEE ,
      String rAILCODE,
      String pAYAUTHCODE ,
      String fromdate,

      BuildContext context) async {
    setState(SummaryLinkState.Busy);
    //String FromDate=DateFormat('dd-MM-yyyy').format(fromdate);

    countData=0;
    countVis=false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {

/*
       print(jsonEncode({'input_type':'OnlineBillStatus','input':
      pONUMBER+"~"+ pOSR}));*/


      var response = await Network.postDataWithAPIM(
          'UDM/Bill/V1.0.0/GetData','Pending15days',
          cONSIGNEE+"~"+rAILCODE+"~"+pAYAUTHCODE+"~"+fromdate
          ,prefs.getString('token'));

      if(response.statusCode == 200) {
        print("hdhdhdhd "+response.body.toString());
        var listdata = json.decode(response.body);
        if (listdata['status']=='OK') {
          var listJson=listdata['data'];
          if (listJson != null) {
            _items = listJson.map<OpenBalance>((val) => OpenBalance.fromJson(val)).toList();
            print(_items!.length);
            // storeInDB();
            countData=_items!.length;
            setState(SummaryLinkState.Finished);
          }

          else {
            countData=0;
            _error = Error("Exception",
                "Something Unexpected happened! Please try again.");
            setState(SummaryLinkState.Idle);
            IRUDMConstants().showSnack(listdata['message'], context);
            //setState(ConsAnalysistate.FinishedWithError);
          }
        } else {
          _error = Error("Exception", "No data found");
          setState(SummaryLinkState.Idle);
          IRUDMConstants().showSnack('No data found', context);
          //  showInSnackBar("Data not found", context);

        }
      } else {
        _error = Error(
            "Exception", "Something Unexpected happened! Please try again.");
        //setState(ConsAnalysistate.FinishedWithError);
        setState(SummaryLinkState.Idle);
        IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
      }
    } on HttpException {
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      // print("Exception "+err.toString());
      //setState(ConsAnalysistate.FinishedWithError);
      setState(SummaryLinkState.Idle);

      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } on SocketException {
      print('No Internet connection 😑');
      _error = Error("Connectivity Error",
          "No connectivity. Please check your connection.");
      // print("Error "+err.toString());
      //setState(ConsAnalysistate.FinishedWithError);
      setState(SummaryLinkState.Idle);
      IRUDMConstants().showSnack('No connectivity. Please check your connection.', context);
    } on FormatException {
      print("Bad response format 👎");
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      // print("Error "+err.toString());
      //setState(ConsAnalysistate.FinishedWithError);
      setState(SummaryLinkState.Idle);
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } catch (err) {
      setState(SummaryLinkState.Idle);
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    }
  }

  Future<void> fetchPending16_30days(
      //================================
      String cONSIGNEE ,
      String rAILCODE,
      String pAYAUTHCODE ,
      String fromdate,

      BuildContext context) async {
    setState(SummaryLinkState.Busy);
    //String FromDate=DateFormat('dd-MM-yyyy').format(fromdate);

    countData=0;
    countVis=false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {

/*
       print(jsonEncode({'input_type':'OnlineBillStatus','input':
      pONUMBER+"~"+ pOSR}));*/


      var response = await Network.postDataWithAPIM(
          'UDM/Bill/V1.0.0/GetData','Pending16_30days',
          cONSIGNEE+"~"+rAILCODE+"~"+pAYAUTHCODE+"~"+fromdate
          ,prefs.getString('token'));

      if(response.statusCode == 200) {
        print("hdhdhdhd "+response.body.toString());
        var listdata = json.decode(response.body);
        if (listdata['status']=='OK') {
          var listJson=listdata['data'];
          if (listJson != null) {
            _items = listJson.map<OpenBalance>((val) => OpenBalance.fromJson(val)).toList();
            print(_items!.length);
            // storeInDB();
            countData=_items!.length;
            setState(SummaryLinkState.Finished);
          }

          else {
            countData=0;
            _error = Error("Exception",
                "Something Unexpected happened! Please try again.");
            setState(SummaryLinkState.Idle);
            IRUDMConstants().showSnack(listdata['message'], context);
            //setState(ConsAnalysistate.FinishedWithError);
          }
        } else {
          _error = Error("Exception", "No data found");
          setState(SummaryLinkState.Idle);
          IRUDMConstants().showSnack('No data found', context);
          //  showInSnackBar("Data not found", context);

        }
      } else {
        _error = Error(
            "Exception", "Something Unexpected happened! Please try again.");
        //setState(ConsAnalysistate.FinishedWithError);
        setState(SummaryLinkState.Idle);
        IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
      }
    } on HttpException {
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      // print("Exception "+err.toString());
      //setState(ConsAnalysistate.FinishedWithError);
      setState(SummaryLinkState.Idle);

      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } on SocketException {
      print('No Internet connection 😑');
      _error = Error("Connectivity Error",
          "No connectivity. Please check your connection.");
      // print("Error "+err.toString());
      //setState(ConsAnalysistate.FinishedWithError);
      setState(SummaryLinkState.Idle);
      IRUDMConstants().showSnack('No connectivity. Please check your connection.', context);
    } on FormatException {
      print("Bad response format 👎");
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      // print("Error "+err.toString());
      //setState(ConsAnalysistate.FinishedWithError);
      setState(SummaryLinkState.Idle);
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } catch (err) {
      setState(SummaryLinkState.Idle);
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    }
  }

  Future<void> fetchPendingmore30days(
      //================================
      String cONSIGNEE ,
      String rAILCODE,
      String pAYAUTHCODE ,
      String fromdate,

      BuildContext context) async {
    setState(SummaryLinkState.Busy);
    //String FromDate=DateFormat('dd-MM-yyyy').format(fromdate);

    countData=0;
    countVis=false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {

/*
       print(jsonEncode({'input_type':'OnlineBillStatus','input':
      pONUMBER+"~"+ pOSR}));*/


      var response = await Network.postDataWithAPIM(
          'UDM/Bill/V1.0.0/GetData','Pending >30 days',
          cONSIGNEE+"~"+rAILCODE+"~"+pAYAUTHCODE+"~"+fromdate
          ,prefs.getString('token'));

      if(response.statusCode == 200) {
        print("hdhdhdhd "+response.body.toString());
        var listdata = json.decode(response.body);
        if (listdata['status']=='OK') {
          var listJson=listdata['data'];
          if (listJson != null) {
            _items = listJson.map<OpenBalance>((val) => OpenBalance.fromJson(val)).toList();
            print(_items!.length);
            // storeInDB();
            countData=_items!.length;
            setState(SummaryLinkState.Finished);
          }

          else {
            countData=0;
            _error = Error("Exception",
                "Something Unexpected happened! Please try again.");
            setState(SummaryLinkState.Idle);
            IRUDMConstants().showSnack(listdata['message'], context);
            //setState(ConsAnalysistate.FinishedWithError);
          }
        } else {
          _error = Error("Exception", "No data found");
          setState(SummaryLinkState.Idle);
          IRUDMConstants().showSnack('No data found', context);
          //  showInSnackBar("Data not found", context);

        }
      } else {
        _error = Error(
            "Exception", "Something Unexpected happened! Please try again.");
        //setState(ConsAnalysistate.FinishedWithError);
        setState(SummaryLinkState.Idle);
        IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
      }
    } on HttpException {
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      // print("Exception "+err.toString());
      //setState(ConsAnalysistate.FinishedWithError);
      setState(SummaryLinkState.Idle);

      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } on SocketException {
      print('No Internet connection 😑');
      _error = Error("Connectivity Error",
          "No connectivity. Please check your connection.");
      // print("Error "+err.toString());
      //setState(ConsAnalysistate.FinishedWithError);
      setState(SummaryLinkState.Idle);
      IRUDMConstants().showSnack('No connectivity. Please check your connection.', context);
    } on FormatException {
      print("Bad response format 👎");
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      // print("Error "+err.toString());
      //setState(ConsAnalysistate.FinishedWithError);
      setState(SummaryLinkState.Idle);
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } catch (err) {
      setState(SummaryLinkState.Idle);
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    }
  }


  Future<void> fetchReturnBill(
      //================================
      String cONSIGNEE ,
      String rAILCODE,
      String pAYAUTHCODE ,
      String fromdate,

      BuildContext context) async {
    setState(SummaryLinkState.Busy);
    //String FromDate=DateFormat('dd-MM-yyyy').format(fromdate);

    countData=0;
    countVis=false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {

/*
       print(jsonEncode({'input_type':'OnlineBillStatus','input':
      pONUMBER+"~"+ pOSR}));*/


      var response = await Network.postDataWithAPIM(
          'UDM/Bill/V1.0.0/GetData','ReturnedBill',
          cONSIGNEE+"~"+rAILCODE+"~"+pAYAUTHCODE+"~"+fromdate+"~"+fromdate
          ,prefs.getString('token'));

      if(response.statusCode == 200) {
        print("hdhdhdhd "+response.body.toString());
        var listdata = json.decode(response.body);
        if (listdata['status']=='OK') {
          var listJson=listdata['data'];
          if (listJson != null) {
            _items = listJson.map<OpenBalance>((val) => OpenBalance.fromJson(val)).toList();
            print(_items!.length);
            // storeInDB();
            countData=_items!.length;
            setState(SummaryLinkState.Finished);
          }

          else {
            countData=0;
            _error = Error("Exception",
                "Something Unexpected happened! Please try again.");
            setState(SummaryLinkState.Idle);
            IRUDMConstants().showSnack(listdata['message'], context);
            //setState(ConsAnalysistate.FinishedWithError);
          }
        } else {
          _error = Error("Exception", "No data found");
          setState(SummaryLinkState.Idle);
          IRUDMConstants().showSnack('No data found', context);
          //  showInSnackBar("Data not found", context);

        }
      } else {
        _error = Error(
            "Exception", "Something Unexpected happened! Please try again.");
        //setState(ConsAnalysistate.FinishedWithError);
        setState(SummaryLinkState.Idle);
        IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
      }
    } on HttpException {
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      // print("Exception "+err.toString());
      //setState(ConsAnalysistate.FinishedWithError);
      setState(SummaryLinkState.Idle);

      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } on SocketException {
      print('No Internet connection 😑');
      _error = Error("Connectivity Error",
          "No connectivity. Please check your connection.");
      // print("Error "+err.toString());
      //setState(ConsAnalysistate.FinishedWithError);
      setState(SummaryLinkState.Idle);
      IRUDMConstants().showSnack('No connectivity. Please check your connection.', context);
    } on FormatException {
      print("Bad response format 👎");
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      // print("Error "+err.toString());
      //setState(ConsAnalysistate.FinishedWithError);
      setState(SummaryLinkState.Idle);
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } catch (err) {
      setState(SummaryLinkState.Idle);
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    }
  }

  Future<void> fetchPendingBill(
      //================================
      String cONSIGNEE ,
      String rAILCODE,
      String pAYAUTHCODE ,
      String fromdate,

      BuildContext context) async {
    setState(SummaryLinkState.Busy);
    //String FromDate=DateFormat('dd-MM-yyyy').format(fromdate);

    countData=0;
    countVis=false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {

/*
       print(jsonEncode({'input_type':'OnlineBillStatus','input':
      pONUMBER+"~"+ pOSR}));*/


      var response = await Network.postDataWithAPIM(
          'UDM/Bill/V1.0.0/GetData','PendingBill',
          cONSIGNEE+"~"+rAILCODE+"~"+pAYAUTHCODE+"~"+fromdate
          ,prefs.getString('token'));

      if(response.statusCode == 200) {
        print("hdhdhdhd "+response.body.toString());
        var listdata = json.decode(response.body);
        if (listdata['status']=='OK') {
          var listJson=listdata['data'];
          if (listJson != null) {
            _items = listJson.map<OpenBalance>((val) => OpenBalance.fromJson(val)).toList();
            print(_items!.length);
            // storeInDB();
            countData=_items!.length;
            setState(SummaryLinkState.Finished);
          }

          else {
            countData=0;
            _error = Error("Exception",
                "Something Unexpected happened! Please try again.");
            setState(SummaryLinkState.Idle);
            IRUDMConstants().showSnack(listdata['message'], context);
            //setState(ConsAnalysistate.FinishedWithError);
          }
        } else {
          _error = Error("Exception", "No data found");
          setState(SummaryLinkState.Idle);
          IRUDMConstants().showSnack('No data found', context);
          //  showInSnackBar("Data not found", context);

        }
      } else {
        _error = Error(
            "Exception", "Something Unexpected happened! Please try again.");
        //setState(ConsAnalysistate.FinishedWithError);
        setState(SummaryLinkState.Idle);
        IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
      }
    } on HttpException {
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      // print("Exception "+err.toString());
      //setState(ConsAnalysistate.FinishedWithError);
      setState(SummaryLinkState.Idle);

      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } on SocketException {
      print('No Internet connection 😑');
      _error = Error("Connectivity Error",
          "No connectivity. Please check your connection.");
      // print("Error "+err.toString());
      //setState(ConsAnalysistate.FinishedWithError);
      setState(SummaryLinkState.Idle);
      IRUDMConstants().showSnack('No connectivity. Please check your connection.', context);
    } on FormatException {
      print("Bad response format 👎");
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      // print("Error "+err.toString());
      //setState(ConsAnalysistate.FinishedWithError);
      setState(SummaryLinkState.Idle);
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } catch (err) {
      setState(SummaryLinkState.Idle);
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    }
  }

  Future<void> fetchBillRecived(
      //================================
      String cONSIGNEE ,
      String rAILCODE,
      String pAYAUTHCODE ,
      String fromdate,

      BuildContext context) async {
    setState(SummaryLinkState.Busy);
    //String FromDate=DateFormat('dd-MM-yyyy').format(fromdate);

    countData=0;
    countVis=false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {


      /* print(jsonEncode({'input_type':'OnlineBillStatus','input':
      pONUMBER+"~"+ pOSR}));*/


      var response = await Network.postDataWithAPIM(
          'UDM/Bill/V1.0.0/GetData','BillReceived',
          cONSIGNEE+"~"+rAILCODE+"~"+pAYAUTHCODE+"~"+fromdate+"~"+fromdate
          ,prefs.getString('token'));

      if(response.statusCode == 200) {
        print("hdhdhdhd "+response.body.toString());
        var listdata = json.decode(response.body);
        if (listdata['status']=='OK') {
          var listJson=listdata['data'];
          if (listJson != null) {
            _items = listJson.map<OpenBalance>((val) => OpenBalance.fromJson(val)).toList();
            print(_items!.length);
            // storeInDB();
            countData=_items!.length;
            setState(SummaryLinkState.Finished);
          }

          else {
            countData=0;
            _error = Error("Exception",
                "Something Unexpected happened! Please try again.");
            setState(SummaryLinkState.Idle);
            IRUDMConstants().showSnack(listdata['message'], context);
            //setState(ConsAnalysistate.FinishedWithError);
          }
        } else {
          _error = Error("Exception", "No data found");
          setState(SummaryLinkState.Idle);
          IRUDMConstants().showSnack('No data found', context);
          //  showInSnackBar("Data not found", context);

        }
      } else {
        _error = Error(
            "Exception", "Something Unexpected happened! Please try again.");
        //setState(ConsAnalysistate.FinishedWithError);
        setState(SummaryLinkState.Idle);
        IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
      }
    } on HttpException {
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      // print("Exception "+err.toString());
      //setState(ConsAnalysistate.FinishedWithError);
      setState(SummaryLinkState.Idle);

      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } on SocketException {
      print('No Internet connection 😑');
      _error = Error("Connectivity Error",
          "No connectivity. Please check your connection.");
      // print("Error "+err.toString());
      //setState(ConsAnalysistate.FinishedWithError);
      setState(SummaryLinkState.Idle);
      IRUDMConstants().showSnack('No connectivity. Please check your connection.', context);
    } on FormatException {
      print("Bad response format 👎");
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      // print("Error "+err.toString());
      //setState(ConsAnalysistate.FinishedWithError);
      setState(SummaryLinkState.Idle);
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } catch (err) {
      setState(SummaryLinkState.Idle);
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    }
  }

  Future<void> fetchOpeningBalance(
      //================================
      String cONSIGNEE ,
      String rAILCODE,
      String pAYAUTHCODE ,
      String fromdate,

      BuildContext context) async {
    setState(SummaryLinkState.Busy);
    //String FromDate=DateFormat('dd-MM-yyyy').format(fromdate);

    countData=0;
    countVis=false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {


      /* print(jsonEncode({'input_type':'OnlineBillStatus','input':
      pONUMBER+"~"+ pOSR}));*/


      var response = await Network.postDataWithAPIM(
          'UDM/Bill/V1.0.0/GetData','BillOpeningBalance',
          cONSIGNEE+"~"+rAILCODE+"~"+pAYAUTHCODE+"~"+fromdate+"~"+fromdate
          ,prefs.getString('token'));



      /* var response=await
      Network().postDataWithAPIM('UDM/Bill/V1.0.0/GetData','OnlineBillStatusDTLS',
          widget.pONUMBER! +
              "~" +
              widget.pOSR!,prefs.getString('token'));*/


//=========================================
      /* var response=await Network().postDataWithAPIM('UDM/Bill/V1.0.0/GetData
       ','OnlineBillStatus',
          fromDate+"~"+toDate+"~" +
               railway +
               "~" +
               consignee +"~" +
              payingAuthority +"~"+description,prefs.getString('token'));*/

      if(response.statusCode == 200) {
        print("hdhdhdhd "+response.body.toString());
        var listdata = json.decode(response.body);
        if (listdata['status']=='OK') {
          var listJson=listdata['data'];
          if (listJson != null) {
            _items = listJson.map<OpenBalance>((val) => OpenBalance.fromJson(val)).toList();
            print(_items!.length);
            // storeInDB();
            countData=_items!.length;
            setState(SummaryLinkState.Finished);
          }

          else {
            countData=0;
            _error = Error("Exception",
                "Something Unexpected happened! Please try again.");
            setState(SummaryLinkState.Idle);
            IRUDMConstants().showSnack(listdata['message'], context);
            //setState(ConsAnalysistate.FinishedWithError);
          }
        } else {
          _error = Error("Exception", "No data found");
          setState(SummaryLinkState.Idle);
          IRUDMConstants().showSnack('No data found', context);
          //  showInSnackBar("Data not found", context);

        }
      } else {
        _error = Error(
            "Exception", "Something Unexpected happened! Please try again.");
        //setState(ConsAnalysistate.FinishedWithError);
        setState(SummaryLinkState.Idle);
        IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
      }
    } on HttpException {
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      // print("Exception "+err.toString());
      //setState(ConsAnalysistate.FinishedWithError);
      setState(SummaryLinkState.Idle);

      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } on SocketException {
      print('No Internet connection 😑');
      _error = Error("Connectivity Error",
          "No connectivity. Please check your connection.");
      // print("Error "+err.toString());
      //setState(ConsAnalysistate.FinishedWithError);
      setState(SummaryLinkState.Idle);
      IRUDMConstants().showSnack('No connectivity. Please check your connection.', context);
    } on FormatException {
      print("Bad response format 👎");
      _error = Error(
          "Exception", "Something Unexpected happened! Please try again.");
      // print("Error "+err.toString());
      //setState(ConsAnalysistate.FinishedWithError);
      setState(SummaryLinkState.Idle);
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } catch (err) {
      setState(SummaryLinkState.Idle);
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    }
  }
  void showInSnackBar(String value, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(value)
    ));
  }


/* Future<void> searchDescription(String query) async {
    var dbItems = await DatabaseHelper.instance.fetchSavedItem();
    if (query.isNotEmpty) {
      print("items list length: ${dbItems.length}");
      _items = dbItems.where((row) => row[DatabaseHelper.Tbl4_col2_ledger_name].toString().toLowerCase().contains(query.toLowerCase())||row[DatabaseHelper.Tbl4_col7_PLNUMBER].toString().toLowerCase().contains(query.toLowerCase())||
          row[DatabaseHelper.Tbl4_col4_rate].toString().toLowerCase().contains(query.toLowerCase())
          ||row[DatabaseHelper.Tbl4_col5_desc].toString().toLowerCase().contains(query.toLowerCase())
          ||row[DatabaseHelper.Tbl4_col8_DEPODETAIL].toString().toLowerCase().contains(query.toLowerCase())
          ||row[DatabaseHelper.Tbl4_col3_stock_qty].toString().toLowerCase().contains(query.toLowerCase())
          ||row[DatabaseHelper.Tbl4_col11_ITEMCAT].toString().toLowerCase().contains(query.toLowerCase()))
          .map<Item>((e) => Item.fromJson(e))
          .toList();*/
/*  countData=_items!.length;
      countVis=true;
    }else{
      countVis=false;
      dbItems.forEach((row) => print(row));
      _items=await DatabaseHelper.instance.getItemList();
      countData=_items!.length;
      print(_items);
    }
    setState(StatusListState.Finished);
  }*/
}
