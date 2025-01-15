import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/non_stock_demands/models/awaiting_my_action_data.dart';
import 'package:flutter_app/udm/non_stock_demands/models/consignee_data.dart';
import 'package:flutter_app/udm/non_stock_demands/models/dashboard.dart';
import 'package:flutter_app/udm/non_stock_demands/models/forward_finalized_data.dart';
import 'package:flutter_app/udm/non_stock_demands/models/indentor.dart';
import 'package:flutter_app/udm/non_stock_demands/models/status_data.dart';
import 'package:shared_preferences/shared_preferences.dart';


class NonStockDemandRepo {

  NonStockDemandRepo(BuildContext context);

  List<DashBoardData> dashboardDataitems = [];
  List<ConsData> consigneeData = [];
  List<IndentorData> indentorData = [];
  List<Status> statusitems = [];

  List<FwdfndData> fwdfinalizedData = [];

  List<AwaitingActionData> awaitingData = [];

  List statuslist = [
    // {
    //   "statusvalue" : "-1",
    //   "statusname" : "All"
    // },
    {
      "statusvalue": "0",
      "statusname": "Initiated (Draft)"
    },
    {
      "statusvalue": "1",
      "statusname": "Under Fund Certification"
    },
    {
      "statusvalue": "2",
      "statusname": "Fund Certification granted"
    },
    {
      "statusvalue": '3',
      "statusname": "Forwarded for PAC Approval"
    },
    {
      "statusvalue": "4",
      "statusname": "PAC Approved"
    },
    {
      "statusvalue": "7",
      "statusname": "Under Finance Concurrence"
    },
    {
      "statusvalue": "8",
      "statusname": "Finance Concurrence accorded"
    },
    {
      "statusvalue": "9",
      "statusname": "Under Finance Vetting"
    },
    {
      "statusvalue": "10",
      "statusname": "Finance Vetting done"
    },
    {
      "statusvalue": "11",
      "statusname": 'Under Process'
    },
    {
      "statusvalue": '5',
      "statusname": "Under Approval"
    },
    {
      "statusvalue": '6',
      "statusname": "Approved & Forwarded to Purchase"
    },
    {
      "statusvalue": "13",
      "statusname": "Returned by Purchase Unit"
    },
    {
      "statusvalue": "12",
      "statusname": "Dropped"
    }
  ];


  Future<List<ConsData>> fetchConsigneeData(input_type, input, value, token) async {
    try {
      var result_UDMCons = await Network().postDataWithAPIMList(
          input_type, input, value, token);
      if (result_UDMCons.statusCode == 200) {
        consigneeData.clear();
        var listdata = json.decode(result_UDMCons.body);
        if (listdata['status'] == "OK") {
          var listJson = listdata['data'];
          if (listJson != null) {
            consigneeData = listJson.map<ConsData>((val) => ConsData.fromJson(val)).toList();
            //consigneeData.sort((a, b) => a.intcode!.compareTo(b.intcode!));
            return consigneeData;
          } else {
            //IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return consigneeData;
          }
        } else {
          //IRUDMConstants().showSnack('Data not found.', context);
        }
      }
      else {
        consigneeData.clear();
        //IRUDMConstants().showSnack('Data not found.', context);
      }
    }
    on HttpException {
      //IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } on SocketException {
      print('No internet connection 😑');
      //IRUDMConstants().showSnack('No connectivity. Please check your connection.', context);
    } on FormatException {
      print("Bad response format 👎");
      //IRUDMConstants().showSnack('Bad response format 👎', context);
    } catch (err) {
      //IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    }

    return consigneeData;
  }

  Future<List<IndentorData>> fetchIndentorData(input_type, input, token) async {
    try {
      var result_UDMCons = await Network().postDataWithPro(IRUDMConstants.webnonstockdemandUrl, input_type, input, token);
      //var result_UDMCons = await Network().postDataWithAPIMList('UDM/Bill/V1.0.0/GetData', input_type, input, token);
      if (result_UDMCons.statusCode == 200) {
        indentorData.clear();
        var listdata = json.decode(result_UDMCons.body);
        if (listdata['status'] == "OK") {
          var listJson = listdata['data'];
          if (listJson != null) {
            indentorData = listJson.map<IndentorData>((val) => IndentorData.fromJson(val)).toList();
            //consigneeData.sort((a, b) => a.intcode!.compareTo(b.intcode!));
            return indentorData;
          } else {
            //IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return indentorData;
          }
        } else {
          //IRUDMConstants().showSnack('Data not found.', context);
        }
      }
      else {
        indentorData.clear();
        //IRUDMConstants().showSnack('Data not found.', context);
      }
    }
    on HttpException {
      //IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } on SocketException {
      print('No internet connection 😑');
      //IRUDMConstants().showSnack('No connectivity. Please check your connection.', context);
    } on FormatException {
      print("Bad response format 👎");
      //IRUDMConstants().showSnack('Bad response format 👎', context);
    } catch (err) {
      //IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    }

    return indentorData;
  }

  Future<List<Status>> fetchStatusData() async {
    statusitems = statuslist.map<Status>((val) => Status.fromJson(val)).toList();
    //statusitems.sort((a, b) => a.statusvalue!.compareTo(b.statusvalue!));
    return statusitems;
  }

  Future<List<DashBoardData>> fetchNonStockDemandDefaultDashboardData(input_type, userid, deptid, datefrom, todate, token, BuildContext context) async {
    try {
      debugPrint("input $userid~$deptid~$datefrom~$todate");
      var response = await Network().postDataWithPro(IRUDMConstants.webnonstockdemandUrl, input_type, "$userid~$deptid~$datefrom~$todate", token);
      // var response = await Network().postDataWithAPIM(
      //     'UDM/Bill/V1.0.0/GetData',
      //     input_type,
      //     userid + "~" + deptid + "~" + datefrom + "~" + todate,
      //     token);
      if(response.statusCode == 200) {
        dashboardDataitems.clear();
        var listdata = json.decode(response.body);
        if (listdata['status'] == "OK") {
          var listJson = listdata['data'];
          debugPrint("test1 ${response.toString()}");
          if (listJson != null) {
            dashboardDataitems = listJson.map<DashBoardData>((val) => DashBoardData.fromJson(val)).toList();
            return dashboardDataitems;
          } else {
            IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return dashboardDataitems;
          }
        } else {
          //IRUDMConstants().showSnack('Data not found.', context);
        }
      }
      else {
        dashboardDataitems.clear();
        //IRUDMConstants().showSnack('Data not found.', context);
      }
    }
    on HttpException {
      IRUDMConstants().showSnack(
          'Something Unexpected happened! Please try again.', context);
    } on SocketException {
      print('No internet connection 😑');
      IRUDMConstants().showSnack(
          'No connectivity. Please check your connection.', context);
    } on FormatException {
      print("Bad response format 👎");
      IRUDMConstants().showSnack('Bad response format 👎', context);
    } catch (err) {
      IRUDMConstants().showSnack(
          'Something Unexpected happened! Please try again.', context);
    }

    return dashboardDataitems;
  }

  Future<List<DashBoardData>> fetchNonStockDemandDashboardData(input_type, orgcode, deptid, adminunit, status, indentor, userid, demandno, datefrom, todate, consignee, itemdesc, token, BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var response = await Network.postDataWithAPIM(
          'UDM/Bill/V1.0.0/GetData', input_type, orgcode+"~"+deptid+"~"+adminunit+"~"+status+"~"+indentor+"~"+userid+"~"+demandno+"~"+datefrom+"~"+todate+"~"+consignee+"~"+itemdesc,
          prefs.getString('token'));
      if(response.statusCode == 200) {
        dashboardDataitems.clear();
        var listdata = json.decode(response.body);
        if (listdata['status'] == "OK") {
          var listJson = listdata['data'];
          debugPrint("test $listJson");
          if (listJson != null) {
            dashboardDataitems = listJson.map<DashBoardData>((val) => DashBoardData.fromJson(val)).toList();
            return dashboardDataitems;
          } else {
            IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return dashboardDataitems;
          }
        } else {
          //IRUDMConstants().showSnack('Data not found.', context);
        }
      }
      else {
        dashboardDataitems.clear();
        //IRUDMConstants().showSnack('Data not found.', context);
      }
    }
    on HttpException {
      IRUDMConstants().showSnack(
          'Something Unexpected happened! Please try again.', context);
    } on SocketException {
      print('No internet connection 😑');
      IRUDMConstants().showSnack(
          'No connectivity. Please check your connection.', context);
    } on FormatException {
      print("Bad response format 👎");
      IRUDMConstants().showSnack('Bad response format 👎', context);
    } catch (err) {
      IRUDMConstants().showSnack(
          'Something Unexpected happened! Please try again.', context);
    }

    return dashboardDataitems;
  }

  Future<List<FwdfndData>> fetchfwdfinalizedData(input_type, postid, fromdate, todate, token, BuildContext context) async{
    try{
      var response = await Network().postDataWithPro(IRUDMConstants.webnonstockdemandUrl, input_type, postid+"~"+fromdate+"~"+todate, token);
      if(response.statusCode == 200) {
        fwdfinalizedData.clear();
        var listdata = json.decode(response.body);
        if(listdata['status'] == "OK") {
          var listJson = listdata['data'];
          if(listJson != null) {
            fwdfinalizedData = listJson.map<FwdfndData>((val) => FwdfndData.fromJson(val)).toList();
            return fwdfinalizedData;
          } else {
            IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return fwdfinalizedData;
          }
        } else {
          //IRUDMConstants().showSnack('Data not found.', context);
        }
      }
      else{
        fwdfinalizedData.clear();
        //IRUDMConstants().showSnack('Data not found.', context);
      }
    }
    on HttpException {
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } on SocketException {
      print('No internet connection 😑');
      IRUDMConstants().showSnack('No connectivity. Please check your connection.', context);
    } on FormatException {
      print("Bad response format 👎");
      IRUDMConstants().showSnack('Bad response format 👎', context);
    } catch (err) {
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    }

    return fwdfinalizedData;
  }

  Future<List<AwaitingActionData>> fetchAwaitingData(input_type, orgcode, userid, postid, fromdate, todate, token, BuildContext context) async{
    try{
      var response = await Network().postDataWithPro(IRUDMConstants.webnonstockdemandUrl,input_type, "$orgcode~$userid~$postid~$fromdate~$todate", token);
      if(response.statusCode == 200) {
        awaitingData.clear();
        var listdata = json.decode(response.body);
        if(listdata['status'] == "OK") {
          var listJson = listdata['data'];
          if(listJson != null) {
            awaitingData = listJson.map<AwaitingActionData>((val) => AwaitingActionData.fromJson(val)).toList();
            return awaitingData;
          } else {
            IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return awaitingData;
          }
        } else {
          //IRUDMConstants().showSnack('Data not found.', context);
        }
      }
      else{
        awaitingData.clear();
        //IRUDMConstants().showSnack('Data not found.', context);
      }
    }
    on HttpException {
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    } on SocketException {
      print('No internet connection 😑');
      IRUDMConstants().showSnack('No connectivity. Please check your connection.', context);
    } on FormatException {
      print("Bad response format 👎");
      IRUDMConstants().showSnack('Bad response format 👎', context);
    } catch (err) {
      IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
    }

    return awaitingData;
  }


  // Searching Data

  Future<List<DashBoardData>> fetchSearchDBData(List<DashBoardData> data, String query) async{
    if(query.isNotEmpty){
      dashboardDataitems = data.where((element) => element.indentorname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.username.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.itemdescription.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.useremail.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.currentlywith.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.dmdno.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.dmddate.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.approvalvalue.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
      ).toList();
      return dashboardDataitems;
    }
    else{
      return data;
    }
  }

  Future<List<FwdfndData>> fetchSearchFwdFinalData(List<FwdfndData> data, String query) async{
     if(query.isNotEmpty){
       fwdfinalizedData = data.where((element) => element.indentorname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
           || element.username.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
           || element.itemdescription.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
           || element.useremail.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
           || element.currentlywith.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
           || element.dmdno.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
           || element.dmddate.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
           || element.approvalvalue.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
       ).toList();
       return fwdfinalizedData;
     }
     else{
       return data;
     }
    // if(query.isNotEmpty){
    //   fwdfinalizedData.clear();
    //   data.forEach((element) {
    //     if(element.itemdescription.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase()) || element.itemdescription.toString().trim().toLowerCase().startsWith(query.toString().trim().toLowerCase())){
    //       fwdfinalizedData.add(element);
    //     }
    //     else if(element.username.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase()) || element.username.toString().trim().toLowerCase().startsWith(query.toString().trim().toLowerCase())){
    //       fwdfinalizedData.add(element);
    //     }
    //     else if(element.useremail.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase()) || element.useremail.toString().trim().toLowerCase().startsWith(query.toString().trim().toLowerCase())){
    //       fwdfinalizedData.add(element);
    //     }
    //     else if(element.currentlywith.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase()) || element.currentlywith.toString().trim().toLowerCase().startsWith(query.toString().trim().toLowerCase())){
    //       fwdfinalizedData.add(element);
    //     }
    //     else if(element.indentorname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase()) || element.indentorname.toString().trim().toLowerCase().startsWith(query.toString().trim().toLowerCase())){
    //       fwdfinalizedData.add(element);
    //     }
    //     else if(element.dmdno.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase()) || element.dmdno.toString().trim().toLowerCase().startsWith(query.toString().trim().toLowerCase())){
    //       fwdfinalizedData.add(element);
    //     }
    //     else if(element.dmddate.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase()) || element.dmddate.toString().trim().toLowerCase().startsWith(query.toString().trim().toLowerCase())){
    //       fwdfinalizedData.add(element);
    //     }
    //     else if(element.approvalvalue.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase()) || element.approvalvalue.toString().trim().toLowerCase().startsWith(query.toString().trim().toLowerCase())){
    //       fwdfinalizedData.add(element);
    //     }
    //   });
    //   return fwdfinalizedData;
    // }
    // else{
    //   return fwdfinalizedData;
    // }
  }

  Future<List<AwaitingActionData>> fetchSearchawaitData(List<AwaitingActionData> data, String query) async{
    if(query.isNotEmpty){
      awaitingData = data.where((element) => element.itemdescription.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.username.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.useremail.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.currentlywith.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.indentorname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.dmdno.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.dmddate.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.approvalvalue.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
      ).toList();
      return awaitingData;
    }
    else{
      return data;
    }
    // if(query.isNotEmpty){
    //   awaitingData.clear();
    //   data.forEach((element) {
    //     if(element.itemdescription.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase()) || element.itemdescription.toString().trim().toLowerCase().startsWith(query.toString().trim().toLowerCase())){
    //       awaitingData.add(element);
    //     }
    //     else if(element.username.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase()) || element.username.toString().trim().toLowerCase().startsWith(query.toString().trim().toLowerCase())){
    //       awaitingData.add(element);
    //     }
    //     else if(element.useremail.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase()) || element.useremail.toString().trim().toLowerCase().startsWith(query.toString().trim().toLowerCase())){
    //       awaitingData.add(element);
    //     }
    //     else if(element.currentlywith.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase()) || element.currentlywith.toString().trim().toLowerCase().startsWith(query.toString().trim().toLowerCase())){
    //       awaitingData.add(element);
    //     }
    //     else if(element.indentorname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase()) || element.indentorname.toString().trim().toLowerCase().startsWith(query.toString().trim().toLowerCase())){
    //       awaitingData.add(element);
    //     }
    //     else if(element.dmdno.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase()) || element.dmdno.toString().trim().toLowerCase().startsWith(query.toString().trim().toLowerCase())){
    //       awaitingData.add(element);
    //     }
    //     else if(element.dmddate.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase()) || element.dmddate.toString().trim().toLowerCase().startsWith(query.toString().trim().toLowerCase())){
    //       awaitingData.add(element);
    //     }
    //     else if(element.approvalvalue.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase()) || element.approvalvalue.toString().trim().toLowerCase().startsWith(query.toString().trim().toLowerCase())){
    //       awaitingData.add(element);
    //     }
    //   });
    //   return awaitingData;
    // }
    // else{
    //   return awaitingData;
    // }
  }

}