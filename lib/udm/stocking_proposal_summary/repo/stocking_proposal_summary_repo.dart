import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/stocking_proposal_summary/models/stockingProposalData.dart';
import 'package:flutter_app/udm/stocking_proposal_summary/models/stockingProposallinkData.dart';
import 'package:flutter_app/udm/stocking_proposal_summary/models/stockproposalsummary_railwaylistdata.dart';
import 'package:flutter_app/udm/stocking_proposal_summary/models/unifyingRailwayData.dart';
import 'package:flutter_app/udm/stocking_proposal_summary/models/unitInitiatingProposalData.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StockingProposalSummaryRepo{

  StockingProposalSummaryRepo._privateConstructor();
  static final StockingProposalSummaryRepo _instance = StockingProposalSummaryRepo._privateConstructor();
  static StockingProposalSummaryRepo get instance => _instance;

  List<StockProposalSummryRlwData> dropdowndata_UDMRlyList = [];
  List<UnifyingrlyData> unifying_UDMRlyList = [];
  List<UnitinitPrpData> unitprp_UDMList = [];
  List<dynamic> storedepot_UDMList = [];
  var myList_UDMDept = [];

  List<StkPrpData> stkproposallistData = [];
  List<StkprplinkData> stkproposallinklistData = [];

   var all = {
      'intcode': '-1',
      'value': "All"
  };

  var storedepotAll = {
    'name' : 'All'
  };

  Future<List<StockProposalSummryRlwData>> fetchrailwaylistData(BuildContext context) async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var result_UDMRlyList = await Network().postDataWithAPIMList('UDMAppList','UDMRlyList','', prefs.getString('token'));
      if(result_UDMRlyList.statusCode == 200) {
        dropdowndata_UDMRlyList.clear();
        var listdata = json.decode(result_UDMRlyList.body);
        if(listdata['status'] == "OK") {
          var listJson = listdata['data'];
          if(listJson != null) {
            dropdowndata_UDMRlyList = listJson.map<StockProposalSummryRlwData>((val) => StockProposalSummryRlwData.fromJson(val)).toList();
            dropdowndata_UDMRlyList.sort((a, b) => a.value!.compareTo(b.value!));
            return dropdowndata_UDMRlyList;
          } else {
            IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return dropdowndata_UDMRlyList;
            //setState(ItemListState.FinishedWithError);
          }
        } else {
          //IRUDMConstants().showSnack('Data not found.', context);
        }
      }
      else{
        dropdowndata_UDMRlyList.clear();
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

    return dropdowndata_UDMRlyList;
  }

  Future<dynamic> def_depart_result(BuildContext context) async {
    try {
      myList_UDMDept.clear();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var result_UDMDept=await Network().postDataWithAPIMList('UDMAppList','UDMDept','', prefs.getString('token'));
      var UDMDept_body = json.decode(result_UDMDept.body);
      if(UDMDept_body['status'] != 'OK'){
        return myList_UDMDept;
      }
      else{
        var deptData = UDMDept_body['data'];
        myList_UDMDept.addAll(deptData);
        //myList_UDMDept.sort((a, b) => a['value']!.compareTo(b['value']!));
        return myList_UDMDept;
      }

    } on HttpException {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    } on SocketException {
      IRUDMConstants().showSnack("No connectivity. Please check your connection.", context);
    } on FormatException {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    } catch (err) {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    }
  }

  Future<List<UnifyingrlyData>> fetchunifyingRlyData(BuildContext context) async {
     try{
       unifying_UDMRlyList.clear();
       SharedPreferences prefs = await SharedPreferences.getInstance();
       var result_UnifyingrlyUDM=await Network().postDataWithPro(IRUDMConstants.webStockingPropSummaryUrl,'Unifying_Railway','', prefs.getString('token'));
       if(result_UnifyingrlyUDM.statusCode == 200){
         var listdata = json.decode(result_UnifyingrlyUDM.body);
         if(listdata['status'] == "OK"){
           var listJson = listdata['data'];
           if(listJson != null) {
             unifying_UDMRlyList = listJson.map<UnifyingrlyData>((val) => UnifyingrlyData.fromJson(val)).toList();
             //dropdowndata_UDMRlyList.sort((a, b) => a.value!.compareTo(b.value!));
             return unifying_UDMRlyList;
           } else {
             IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
             return unifying_UDMRlyList;
             //setState(ItemListState.FinishedWithError);
           }
         }
       }
     }
     on HttpException {
       IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
     } on SocketException {
       IRUDMConstants().showSnack("No connectivity. Please check your connection.", context);
     } on FormatException {
       IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
     } catch (err) {
       IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
     }

     return unifying_UDMRlyList;
  }

  Future<List<UnitinitPrpData>> fetchunitinitprpData(String? rly, String? dept,BuildContext context) async {
    try{
      unitprp_UDMList.clear();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var result_UnitinitprpUDM=await Network().postDataWithPro(IRUDMConstants.webStockingPropSummaryUrl,'Unit_Initiating_Proposal','$rly~$dept', prefs.getString('token'));
      if(result_UnitinitprpUDM.statusCode == 200){
        var listdata = json.decode(result_UnitinitprpUDM.body);
        if(listdata['status'] == "OK"){
          var listJson = listdata['data'];
          if(listJson != null) {
            unitprp_UDMList = listJson.map<UnitinitPrpData>((val) => UnitinitPrpData.fromJson(val)).toList();
            unitprp_UDMList = [UnitinitPrpData(intCode: "-1", value: "All"), ...unitprp_UDMList];
            //unitprp_UDMList.insert(0, UnitinitPrpData(intCode: "-1", value: "All"));
            //dropdowndata_UDMRlyList.sort((a, b) => a.value!.compareTo(b.value!));
            return unitprp_UDMList;
          } else {
            unitprp_UDMList = [UnitinitPrpData(intCode: "-1", value: "All"), ...unitprp_UDMList];
            return unitprp_UDMList;
            //setState(ItemListState.FinishedWithError);
          }
        }
        else{
          unitprp_UDMList = [UnitinitPrpData(intCode: "-1", value: "All"), ...unitprp_UDMList];
          return unitprp_UDMList;
        }
      }
    }
    on HttpException {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    } on SocketException {
      IRUDMConstants().showSnack("No connectivity. Please check your connection.", context);
    } on FormatException {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    } catch (err) {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    }

    return unitprp_UDMList;
  }

  Future<dynamic> fetchStoreDepotData(String? rly, BuildContext context) async {
    storedepot_UDMList.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var result_StotresDepotUDM=await Network().postDataWithPro(IRUDMConstants.webStockingPropSummaryUrl,'Stores_Depot','$rly', prefs.getString('token'));
    if(result_StotresDepotUDM.statusCode == 200){
      var listdata = json.decode(result_StotresDepotUDM.body);
      if(listdata['status'] == "OK"){
        var listJson = listdata['data'];
        if(listJson != null) {
          //unitprp_UDMList.add(UnitinitPrpData(intCode: "-1", value: "All"));
          storedepot_UDMList.addAll(listJson);
          storedepot_UDMList = [storedepotAll, ...storedepot_UDMList];
          //unitprp_UDMList = listJson.map<UnitinitPrpData>((val) => UnitinitPrpData.fromJson(val)).toList();
          //dropdowndata_UDMRlyList.sort((a, b) => a.value!.compareTo(b.value!));
          return storedepot_UDMList;
        } else {
          storedepot_UDMList = [storedepotAll, ...storedepot_UDMList];
          return storedepot_UDMList;
          //setState(ItemListState.FinishedWithError);
        }
      }
    }
  }

  Future< List<StkPrpData>> fetchStkproposallistData(String rly, String storedepot,String unitprp,String dept,String unifyingrly, String fromdate, String todate, BuildContext context) async{
    try{
      stkproposallistData.clear();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print('$rly~$storedepot~$dept~$unitprp~$unifyingrly~$fromdate~$todate');
      var result_stkproposalDataUDM=await Network().postDataWithPro(IRUDMConstants.webStockingPropSummaryUrl,'Summary_Stocking_Proposals','$rly~$storedepot~$dept~$unitprp~$unifyingrly~$fromdate~$todate', prefs.getString('token'));
      if(result_stkproposalDataUDM.statusCode == 200){
        var listdata = json.decode(result_stkproposalDataUDM.body);
        if(listdata['status'] == "OK"){
          var listJson = listdata['data'];
          if(listJson != null) {
            stkproposallistData = listJson.map<StkPrpData>((val) => StkPrpData.fromJson(val)).toList();
            //dropdowndata_UDMRlyList.sort((a, b) => a.value!.compareTo(b.value!));
            return stkproposallistData;
          } else {
            IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return stkproposallistData;
            //setState(ItemListState.FinishedWithError);
          }
        }
      }
    }
    on HttpException {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    } on SocketException {
      IRUDMConstants().showSnack("No connectivity. Please check your connection.", context);
    } on FormatException {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    } catch (err) {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    }

    return stkproposallistData;
  }

  Future< List<StkprplinkData>> fetchStkproposallinklistData(String rly, String dept,String unifyingrly,String unitprp,String storedepot, String fromdate, String todate, String status, BuildContext context) async{
    print('$rly~$storedepot~$dept~$unitprp~$unifyingrly~$fromdate~$todate~$status');
    try{
      stkproposallinklistData.clear();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if(unifyingrly == null || unifyingrly == "null"){
        var result_stkproposallinkDataUDM=await Network().postDataWithPro(IRUDMConstants.webStockingPropSummaryUrl,'List_Stocking_Proposals','$rly~$storedepot~$dept~$unitprp~ ~$fromdate~$todate~$status', prefs.getString('token'));
        if(result_stkproposallinkDataUDM.statusCode == 200){
          var listdata = json.decode(result_stkproposallinkDataUDM.body);
          if(listdata['status'] == "OK"){
            var listJson = listdata['data'];
            if(listJson != null) {
              stkproposallinklistData = listJson.map<StkprplinkData>((val) => StkprplinkData.fromJson(val)).toList();
              //dropdowndata_UDMRlyList.sort((a, b) => a.value!.compareTo(b.value!));
              return stkproposallinklistData;
            } else {
              IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
              return stkproposallinklistData;
              //setState(ItemListState.FinishedWithError);
            }
          }
        }
      }
      else{
        var result_stkproposallinkDataUDM=await Network().postDataWithPro(IRUDMConstants.webStockingPropSummaryUrl,'List_Stocking_Proposals','$rly~$storedepot~$dept~$unitprp~$unifyingrly~$fromdate~$todate~$status', prefs.getString('token'));
        if(result_stkproposallinkDataUDM.statusCode == 200){
          var listdata = json.decode(result_stkproposallinkDataUDM.body);
          if(listdata['status'] == "OK"){
            var listJson = listdata['data'];
            if(listJson != null) {
              stkproposallinklistData = listJson.map<StkprplinkData>((val) => StkprplinkData.fromJson(val)).toList();
              //dropdowndata_UDMRlyList.sort((a, b) => a.value!.compareTo(b.value!));
              return stkproposallinklistData;
            } else {
              IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
              return stkproposallinklistData;
              //setState(ItemListState.FinishedWithError);
            }
          }
        }
      }
    }
    on HttpException {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    } on SocketException {
      IRUDMConstants().showSnack("No connectivity. Please check your connection.", context);
    } on FormatException {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    } catch (err) {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    }

    return stkproposallinklistData;
  }

  Future<List<StkPrpData>> fetchSearchStkproposallistData(List<StkPrpData> data, String query) async{
    if(query.isNotEmpty){
      stkproposallistData = data.where((element) => element.rlyname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.subUnitName.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.unitName.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.uplrly.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.status.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.cnt.toString().trim().contains(query.toString().trim())
      ).toList();
      return stkproposallistData;
    }
    else{
      return data;
    }
  }

  Future<List<StkprplinkData>> fetchSearchStkproposallinklistData(List<StkprplinkData> data, String query) async{
    if(query.isNotEmpty){
      stkproposallinklistData = data.where((element) => element.rlyname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.subUnitName.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.unitName.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.plNo.toString().trim().contains(query.toString().trim())
          || element.status.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.storesDepot.toString().trim().contains(query.toString().trim())
          || element.postName.toString().trim().contains(query.toString().trim())
          || element.forwardUserName.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.des.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.username.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.grpName.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.formNo.toString().trim().contains(query.toString().trim())
          || element.uplRly.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
      ).toList();
      return stkproposallinklistData;
    }
    else{
      return data;
    }
  }
}