import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:flutter_app/udm/warranty_complaint_summary/model/Pop_up_functionality.dart';
import 'package:flutter_app/udm/warranty_complaint_summary/model/cmplaintSource.dart';
import 'package:flutter_app/udm/warranty_complaint_summary/model/consignee_codegenComplaint.dart';
import 'package:flutter_app/udm/warranty_complaint_summary/model/level_count.dart';
import 'package:flutter_app/udm/warranty_complaint_summary/model/rlyList.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum WarrantyComplaintState {Idle, Busy, Finished, FinishedWithError}

class WarrantyComplaintRepository {

  WarrantyComplaintRepository._privateConstructor();
  static final WarrantyComplaintRepository _instance = WarrantyComplaintRepository._privateConstructor();
  static WarrantyComplaintRepository get instance => _instance;

  List<LevelCountData> levelCountDatalistData = [];
  List<PopupFuncData> popupFuncDatalistData = [];
  List<ComplaintSource> complaintSourcelistData = [];
  List<RlwListData> dropdowndata_UDMRlyList = [];
  List<dynamic> myList_UDMConsignee = [];

  List complaintsummarylist = [
    {
      "complaintsourcevalue": "0",
      "complaintsourcename": "CMM"
    },
    {
      "complaintsourcevalue": "1",
      "complaintsourcename": "FMM"
    },
    {
      "complaintsourcevalue": "2",
      "complaintsourcename": "MU"
    },
    {
      "complaintsourcevalue": '3',
      "complaintsourcename": "WISE"
    }
  ];

  Map<String, String> getAll() {
    var all = {
      'intcode': '-1',
      'value': "All",
    };
    return all;
  }

  WarrantyComplaintRepository(BuildContext context);


//LevelCountData
  Future<List<LevelCountData>> fetchLevelCountDatalist(String? inputtype,String? rlycode,String? consigneecode,String? rlycode1,String?
  consigneecode1,String? complaintsourcecode,String? fromdate,String? todate, BuildContext context) async{
    print("rlycode $rlycode");
    print("consigneecode $consigneecode");
    print("rlycode1 $rlycode1");
    print("consigneecode1 $consigneecode1");
    print("complaintsourcecode $complaintsourcecode");
    print("fromdate $fromdate");
    print("todate $todate");
    print("inputtype $inputtype");
    print("$rlycode~$consigneecode~$rlycode1~$consigneecode1~$complaintsourcecode~$fromdate~$todate");
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var result_LevelCountData = await Network().postDataWithPro(IRUDMConstants.webnsDemnadSummaryUrl,inputtype,"$rlycode~$consigneecode~$rlycode1~$consigneecode1~$complaintsourcecode~$fromdate~$todate", prefs.getString('token'));
      if(result_LevelCountData.statusCode == 200) {
        levelCountDatalistData.clear();
        var listdata = json.decode(result_LevelCountData.body);
        print("level count -- $result_LevelCountData");
        if(listdata['status'] == "OK") {
          var listJson = listdata['data'];
          if(listJson != null) {
            levelCountDatalistData = listJson.map<LevelCountData>((val) => LevelCountData.fromJson(val)).toList();
            //buyerDetailsDatalistData.sort((a, b) => a.plNo!.compareTo(b.plNo!));
            return levelCountDatalistData;
          } else {
            IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return levelCountDatalistData;
            //setState(ItemListState.FinishedWithError);
          }
        } else {
          //IRUDMConstants().showSnack('Data not found.', context);
        }
      }
      else{
        levelCountDatalistData.clear();
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
    return levelCountDatalistData;
  }

  //search level count
  Future<List<LevelCountData>> fetchsearchingDataLevelCount(List<LevelCountData> data, String query) async{
    if(query.isNotEmpty){
      levelCountDatalistData = data.where((element) => element.compsource.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.rlygencomplaint.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.rlygencomplaintcode.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.rlylodgecliam.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.rlylodgeclaimcode.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.total.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.claimlodgedvendor.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.claiminitiatedvendor.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.complaintreturned.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.advicenoteinitiated.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.advicenotefinalized.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.advicenotereturned.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.actionpending.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
      ).toList();
      return levelCountDatalistData;
    }
    else{
      return data;
    }
  }

  //PopupFuncData
  Future<List<PopupFuncData>> fetchPopupFuncDatalist(String? inputtype,String? rlycode,String? consigneecode,String? rlycode1,String? consigneecode1,String? complaintsourcecode,String? fromdate,String? todate,String? query, BuildContext context) async{
    print("input type $inputtype");
    print("rlycode $rlycode");
    print("consigneecode $consigneecode");
    print("rlycode1 $rlycode1");
    print("complaintsourcecode $complaintsourcecode");
    print("consigneecode1 $consigneecode1");
    print("fromdate $fromdate");
    print("todate $todate");
    print("query$query");
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var result_PopupFuncData = await Network().postDataWithPro(IRUDMConstants.webnsDemnadSummaryUrl,inputtype,"$rlycode~$consigneecode~$rlycode1~$consigneecode1~$complaintsourcecode~$fromdate~$todate~$query", prefs.getString('token'));
      print("response  $result_PopupFuncData");
      if(result_PopupFuncData.statusCode == 200) {
        popupFuncDatalistData.clear();
        var listdata = json.decode(result_PopupFuncData.body);
        print("listdata$listdata");
        if(listdata['status'] == "OK") {
          var listJson = listdata['data'];
          print("listJson$listJson");
          if(listJson != null) {
            popupFuncDatalistData = listJson.map<PopupFuncData>((val) => PopupFuncData.fromJson(val)).toList();
            return popupFuncDatalistData;
          } else {
            IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return popupFuncDatalistData;
          }
        } else {
        }
      }
      else{
        popupFuncDatalistData.clear();
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
    return popupFuncDatalistData;
  }

  //search popup function
  Future<List<PopupFuncData>> fetchsearchingPopupFunc(List<PopupFuncData> data, String query) async{
    if(query.isNotEmpty){
      popupFuncDatalistData = data.where((element) => element.compsource.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
        //  || element.sender_zone.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.comprly.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.conscoderejdatasendor.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
        //  || element.sender_ccode.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.compconsignee.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.comp_address.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.claimrly.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.claimrlycode.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.claimconscode.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.claimconsignee.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.claimaddress.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.rejrefno.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.rejdate.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.plno.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.itemdesc.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.qty.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.vendorname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.transstatus.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.vrno.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.vrdate.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.claimamount.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.transtrkey.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
      ).toList();
      return popupFuncDatalistData;
    }
    else{
      return data;
    }
  }

  //complaint source
  Future<List<ComplaintSource>> fetchComplaintSourceData() async {
    complaintSourcelistData = complaintsummarylist.map<ComplaintSource>((val) => ComplaintSource.fromJson(val)).toList();
    return complaintSourcelistData;
  }

  //railway
  Future<List<RlwListData>> fetchraillistData(BuildContext context) async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var result_UDMRlyList = await Network().postDataWithAPIMList('UDMAppList','UDMRlyList','', prefs.getString('token'));
      if(result_UDMRlyList.statusCode == 200) {
        dropdowndata_UDMRlyList.clear();
        var listdata = json.decode(result_UDMRlyList.body);
        if(listdata['status'] == "OK") {
          var listJson = listdata['data'];
          if(listJson != null) {
            dropdowndata_UDMRlyList = listJson.map<RlwListData>((val) => RlwListData.fromJson(val)).toList();
            dropdowndata_UDMRlyList.sort((a, b) => a.value!.compareTo(b.value!));
            return dropdowndata_UDMRlyList;
          } else {
            IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return dropdowndata_UDMRlyList;
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

  //consignee
  Future<dynamic> fetchConsigneeComplaint(String? rai, String? ccode, BuildContext context) async {
    print("ccode here $ccode");
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      myList_UDMConsignee.clear();
        var result_UDMUserDepot = await Network().postDataWithAPIMList('UDMAppList','Consignee',rai,prefs.getString('token'));
        var UDMUserConsignee_body = json.decode(result_UDMUserDepot.body);
        print("Hello Consignee..... $UDMUserConsignee_body");
        if(UDMUserConsignee_body['status'] != 'OK') {
          print("consignee error here");
          myList_UDMConsignee.add(getAll());
          return myList_UDMConsignee;
        }
        else {
          if(UDMUserConsignee_body['message'] != "Success!"){
             myList_UDMConsignee.add(getAll());
             return myList_UDMConsignee;
          }
          else{
            var depoData = UDMUserConsignee_body['data'];
            myList_UDMConsignee.add(getAll());
            depoData.forEach((item) {
              if(item['intcode'].toString() == prefs.getString('consigneecode')){
                myList_UDMConsignee.addAll(depoData);
              }
              else{
                if(myList_UDMConsignee.isEmpty || myList_UDMConsignee.length == 1){
                  myList_UDMConsignee.addAll(depoData);
                }
              }
            });
            return myList_UDMConsignee;
          }
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
}
