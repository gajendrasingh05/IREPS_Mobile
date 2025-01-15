import 'package:flutter/material.dart';
import 'package:flutter_app/udm/crc_summary/model/crcsummarydata.dart';
import 'package:flutter_app/udm/crc_summary/model/crcsummarylinkdata.dart';
import 'package:flutter_app/udm/crc_summary/model/railwaylistdata.dart';
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class CrcSummaryRepo {

  CrcSummaryRepo._privateConstructor();
  static final CrcSummaryRepo _instance = CrcSummaryRepo._privateConstructor();
  static CrcSummaryRepo get instance => _instance;

  List<CrcSummaryRlwData> dropdowndata_UDMRlyList = [];

  List<CrcSmryData> crcsummaryData = [];
  List<CrcsumrylinkData> crcsummarylinkData = [];

  var myList_UDMUnitType = [];
  var myList_UDMunitName = [];
  var myList_UDMDept = [];
  List<dynamic> myList_UDMConsignee = [];
  List<dynamic> myList_UDMSubConsignee = [];

  Map<String, String> getAll() {
    var all = {
      'intcode': '-1',
      'value': "All",
    };
    return all;
  }

  Future<List<CrcSummaryRlwData>> fetchrailwaylistData(BuildContext context) async{
    //IRUDMConstants.showProgressIndicator(context);
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var result_UDMRlyList = await Network().postDataWithAPIMList('UDMAppList','UDMRlyList','', prefs.getString('token'));
      if(result_UDMRlyList.statusCode == 200) {
        dropdowndata_UDMRlyList.clear();
        var listdata = json.decode(result_UDMRlyList.body);
        if(listdata['status'] == "OK") {
          var listJson = listdata['data'];
          if(listJson != null) {
            dropdowndata_UDMRlyList = listJson.map<CrcSummaryRlwData>((val) => CrcSummaryRlwData.fromJson(val)).toList();
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
        //IRUDMConstants.removeProgressIndicator(context);
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
    finally {
      //IRUDMConstants.removeProgressIndicator(context);
    }
    return dropdowndata_UDMRlyList;
  }

  Future<dynamic> def_fetchUnit(String? value, String? unit_data, String? depart, String? unitName, String? depot, String? userSubDep, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    myList_UDMUnitType.clear();
    try {
      var result_UDMUnitType = await Network().postDataWithAPIMList('UDMAppList','UDMUnitType',value,prefs.getString('token'));
      var UDMUnitType_body = json.decode(result_UDMUnitType.body);
      if(UDMUnitType_body['status'] != 'OK') {
        //IRUDMConstants.removeProgressIndicator(context);
        myList_UDMUnitType.add(getAll());
        return myList_UDMUnitType;
      } else {
        //IRUDMConstants.removeProgressIndicator(context);
        var unitData = UDMUnitType_body['data'];
        myList_UDMUnitType.add(getAll());
        myList_UDMUnitType.addAll(unitData);
        return myList_UDMUnitType;
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
    finally{
      //IRUDMConstants.removeProgressIndicator(context);
    }
  }

  Future<dynamic> def_fetchunitName(String? rai, String? unit, String? unitName_name, String? depot, String? depart, String? userSubDep, BuildContext context) async {
    myList_UDMunitName.clear();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var result_UDMunitName=await Network().postDataWithAPIMList('UDMAppList','UnitName',rai!+"~"+unit!, prefs.getString('token'));
      var UDMunitName_body = json.decode(result_UDMunitName.body);
      if(UDMunitName_body['status'] != 'OK') {
        //IRUDMConstants.removeProgressIndicator(context);
        myList_UDMunitName.add(getAll());
        return myList_UDMunitName;
      } else {
        //IRUDMConstants.removeProgressIndicator(context);
        var divisionData = UDMunitName_body['data'];
        myList_UDMunitName.add(getAll());
        myList_UDMunitName.addAll(divisionData);
        return myList_UDMunitName;
      }
    } on HttpException {
      IRUDMConstants().showSnack(
          "Something Unexpected happened! Please try again.", context);
    } on SocketException {
      IRUDMConstants().showSnack("No connectivity. Please check your connection.", context);
    } on FormatException {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    } catch (err) {
      IRUDMConstants().showSnack("Something Unexpected happened! Please try again.", context);
    }
    finally{
      //IRUDMConstants.removeProgressIndicator(context);
    }
  }

  Future<dynamic> def_depart_result(BuildContext context) async {
    try {
      myList_UDMDept.clear();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var result_UDMDept=await Network().postDataWithAPIMList('UDMAppList','UDMDept','', prefs.getString('token'));
      var UDMDept_body = json.decode(result_UDMDept.body);
      if(UDMDept_body['status'] != 'OK'){
        //IRUDMConstants.removeProgressIndicator(context);
      }
      else{
        //IRUDMConstants.removeProgressIndicator(context);
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
    finally{
      //IRUDMConstants.removeProgressIndicator(context);
    }
  }

  Future<dynamic> fetchConsignee(String? rai, String? depart, String? unit_typ, String? Unit_Name, String? depot_id, String? userSubDep, BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      myList_UDMConsignee.clear();
      //IRUDMConstants.showProgressIndicator(context);
      var result_UDMUserDepot = await Network().postDataWithAPIMList('UDMAppList','UDMUserDepot' , rai! + "~" + depart! + "~" + unit_typ! + "~" + Unit_Name!, prefs.getString('token'));
      var UDMUserConsignee_body = json.decode(result_UDMUserDepot.body);
      if(UDMUserConsignee_body['status'] != 'OK') {
        myList_UDMConsignee.add(getAll());
        return myList_UDMConsignee;
      } else {
        //IRUDMConstants.removeProgressIndicator(context);
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
    finally{
      //IRUDMConstants.removeProgressIndicator(context);
    }
  }

  Future<dynamic> def_fetchSubDepot(String? rai, String? depot_id, String? userSDepo, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //IRUDMConstants.showProgressIndicator(context);
    myList_UDMSubConsignee.clear();
    try {
      if(depot_id == 'NA') {
        myList_UDMSubConsignee.add(getAll());
        return myList_UDMSubConsignee;
      } else {
        var result_UDMUserDepot = await Network().postDataWithAPIMList('UDMAppList','UserSubDepot' , rai! + "~" + depot_id!,prefs.getString('token'));
        var UDMUserSubDepot_body = json.decode(result_UDMUserDepot.body);
        if(UDMUserSubDepot_body['status'] != 'OK') {
          myList_UDMSubConsignee.add(getAll());
          return myList_UDMSubConsignee;
        } else {
          var subDepotData = UDMUserSubDepot_body['data'];
          if(subDepotData == null){
            myList_UDMSubConsignee.add(getAll());
            return myList_UDMSubConsignee;
          }
          else{
            myList_UDMSubConsignee.add(getAll());
            myList_UDMSubConsignee.addAll(subDepotData);
            return myList_UDMSubConsignee;
          }
        }
      }
    }
    on Exception catch (err) {
      IRUDMConstants().showSnack(err.toString(), context);
    }
    finally{
      //IRUDMConstants.removeProgressIndicator(context);
    }
  }

  // CRC Summary Data
  Future<List<CrcSmryData>> crcSummaryData(String? rai, String? unittype, String? unitname, String? department, String? consignee, String? subconsignee, String? fromdate, String? todate, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    crcsummaryData.clear();
    try {
      var result_UDMCrcsummaryData = await Network().postDataWithPro(IRUDMConstants.webCrcSummary,'crc_summary' , unittype! + "~" + consignee! +
          "~" + subconsignee! + "~" + department! + "~" + unitname! + "~" + rai! + "~" + fromdate! + "~" + todate!,prefs.getString('token'));
      var UDMCrcsummaryData_body = json.decode(result_UDMCrcsummaryData.body);
      if(UDMCrcsummaryData_body['status'] != 'OK') {
        return crcsummaryData;
      } else {
        var crcsmData = UDMCrcsummaryData_body['data'];
        if(crcsmData != null) {
          crcsummaryData = crcsmData.map<CrcSmryData>((val) => CrcSmryData.fromJson(val)).toList();
          //dropdowndata_UDMRlyList.sort((a, b) => a.value!.compareTo(b.value!));
          return crcsummaryData;
        } else {
          IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
          return crcsummaryData;
        }
      }
    }
    on Exception catch (err) {
      IRUDMConstants().showSnack(err.toString(), context);
    }
    return crcsummaryData;
  }

  // Open Balance Data
  Future<List<CrcsumrylinkData>> crcSummaryopenBlncData(String? rly, String? consignee, String? subconsignee, String? fromdate, String? todate, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    crcsummarylinkData.clear();
    try {
      var result_UDMCrcsummarylinkData = await Network().postDataWithPro(IRUDMConstants.webCrcSummary,'opening_balance' , "$consignee~$subconsignee~$rly~$fromdate",prefs.getString('token'));
      var UDMCrcsummarylinkData_body = json.decode(result_UDMCrcsummarylinkData.body);
      if(UDMCrcsummarylinkData_body['status'] != 'OK') {
        return crcsummarylinkData;
      } else {
        var crcsmlinkData = UDMCrcsummarylinkData_body['data'];
        if(crcsmlinkData != null) {
          crcsummarylinkData = crcsmlinkData.map<CrcsumrylinkData>((val) => CrcsumrylinkData.fromJson(val)).toList();
          //crcsummarylinkData.sort((a, b) => a.posr!.compareTo(b.posr!));
          return crcsummarylinkData;
        } else {
          IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
          return crcsummarylinkData;
        }
      }
    }
    on Exception catch (err) {
      IRUDMConstants().showSnack(err.toString(), context);
    }
    return crcsummarylinkData;
  }

  // Crc Cons Rcvd Data
  Future<List<CrcsumrylinkData>> crcSummaryconrcvdData(String? rly, String? consignee, String? subconsignee, String? fromdate, String? todate, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    crcsummarylinkData.clear();
    try {
      var result_UDMCrcsummarylinkData = await Network().postDataWithPro(IRUDMConstants.webCrcSummary,'New_Consignment_Received' , "$consignee~$subconsignee~$rly~$fromdate~$todate",prefs.getString('token'));
      var UDMCrcsummarylinkData_body = json.decode(result_UDMCrcsummarylinkData.body);
      if(UDMCrcsummarylinkData_body['status'] != 'OK') {
        return crcsummarylinkData;
      } else {
        var crcsmlinkData = UDMCrcsummarylinkData_body['data'];
        if(crcsmlinkData != null) {
          crcsummarylinkData = crcsmlinkData.map<CrcsumrylinkData>((val) => CrcsumrylinkData.fromJson(val)).toList();
          //crcsummarylinkData.sort((a, b) => a.posr!.compareTo(b.posr!));
          return crcsummarylinkData;
        } else {
          IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
          return crcsummarylinkData;
        }
      }
    }
    on Exception catch (err) {
      IRUDMConstants().showSnack(err.toString(), context);
    }
    return crcsummarylinkData;
  }

  // Crc Issue Data
  Future<List<CrcsumrylinkData>> crcSummarycrcissueData(String? rly, String? consignee, String? subconsignee, String? fromdate, String? todate, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    crcsummarylinkData.clear();
    try {
      var result_UDMCrcsummarylinkData = await Network().postDataWithPro(IRUDMConstants.webCrcSummary,'Consignments_digitally_crc_issued' , "$consignee~$subconsignee~$rly~$fromdate~$todate",prefs.getString('token'));
      var UDMCrcsummarylinkData_body = json.decode(result_UDMCrcsummarylinkData.body);
      if(UDMCrcsummarylinkData_body['status'] != 'OK') {
        return crcsummarylinkData;
      } else {
        var crcsmlinkData = UDMCrcsummarylinkData_body['data'];
        if(crcsmlinkData != null) {
          crcsummarylinkData = crcsmlinkData.map<CrcsumrylinkData>((val) => CrcsumrylinkData.fromJson(val)).toList();
          //crcsummarylinkData.sort((a, b) => a.posr!.compareTo(b.posr!));
          return crcsummarylinkData;
        } else {
          IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
          return crcsummarylinkData;
        }
      }
    }
    on Exception catch (err) {
      IRUDMConstants().showSnack(err.toString(), context);
    }
    return crcsummarylinkData;
  }

  // Closing Blnc Data
  Future<List<CrcsumrylinkData>> crcSummarycloseblncData(String? rly, String? consignee, String? subconsignee, String? fromdate, String? todate, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    crcsummarylinkData.clear();
    try {
      var result_UDMCrcsummarylinkData = await Network().postDataWithPro(IRUDMConstants.webCrcSummary,'Closing_Balance', "$consignee~$subconsignee~$rly~$todate",prefs.getString('token'));
      var UDMCrcsummarylinkData_body = json.decode(result_UDMCrcsummarylinkData.body);
      if(UDMCrcsummarylinkData_body['status'] != 'OK') {
        return crcsummarylinkData;
      } else {
        var crcsmlinkData = UDMCrcsummarylinkData_body['data'];
        if(crcsmlinkData != null) {
          crcsummarylinkData = crcsmlinkData.map<CrcsumrylinkData>((val) => CrcsumrylinkData.fromJson(val)).toList();
          //crcsummarylinkData.sort((a, b) => a.posr!.compareTo(b.posr!));
          return crcsummarylinkData;
        } else {
          IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
          return crcsummarylinkData;
        }
      }
    }
    on Exception catch (err) {
      IRUDMConstants().showSnack(err.toString(), context);
    }
    return crcsummarylinkData;
  }

  // Less than 7 Days Data
  Future<List<CrcsumrylinkData>> crcSummarylessthnsevenData(String? rly, String? consignee, String? subconsignee, String? fromdate, String? todate, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    crcsummarylinkData.clear();
    try {
      var result_UDMCrcsummarylinkData = await Network().postDataWithPro(IRUDMConstants.webCrcSummary,'Pending_7_days' , "$consignee~$subconsignee~$rly~$todate",prefs.getString('token'));
      var UDMCrcsummarylinkData_body = json.decode(result_UDMCrcsummarylinkData.body);
      if(UDMCrcsummarylinkData_body['status'] != 'OK') {
        return crcsummarylinkData;
      } else {
        var crcsmlinkData = UDMCrcsummarylinkData_body['data'];
        if(crcsmlinkData != null) {
          crcsummarylinkData = crcsmlinkData.map<CrcsumrylinkData>((val) => CrcsumrylinkData.fromJson(val)).toList();
          //crcsummarylinkData.sort((a, b) => a.posr!.compareTo(b.posr!));
          return crcsummarylinkData;
        } else {
          IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
          return crcsummarylinkData;
        }
      }
    }
    on Exception catch (err) {
      IRUDMConstants().showSnack(err.toString(), context);
    }
    return crcsummarylinkData;
  }

  // Seven to fifteen Days Data
  Future<List<CrcsumrylinkData>> crcSummaryseventofifteenData(String? rly, String? consignee, String? subconsignee, String? fromdate, String? todate, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    crcsummarylinkData.clear();
    try {
      var result_UDMCrcsummarylinkData = await Network().postDataWithPro(IRUDMConstants.webCrcSummary,'7_to_15_Days' , "$consignee~$subconsignee~$rly~$todate",prefs.getString('token'));
      var UDMCrcsummarylinkData_body = json.decode(result_UDMCrcsummarylinkData.body);
      print("Hello crc summary 7_to_15_days data..... $UDMCrcsummarylinkData_body");
      if(UDMCrcsummarylinkData_body['status'] != 'OK') {
        return crcsummarylinkData;
      } else {
        var crcsmlinkData = UDMCrcsummarylinkData_body['data'];
        if(crcsmlinkData != null) {
          crcsummarylinkData = crcsmlinkData.map<CrcsumrylinkData>((val) => CrcsumrylinkData.fromJson(val)).toList();
          //crcsummarylinkData.sort((a, b) => a.posr!.compareTo(b.posr!));
          return crcsummarylinkData;
        } else {
          IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
          return crcsummarylinkData;
        }
      }
    }
    on Exception catch (err) {
      IRUDMConstants().showSnack(err.toString(), context);
    }
    return crcsummarylinkData;
  }

  // Fifteen to Thirty Days Data
  Future<List<CrcsumrylinkData>> crcSummaryfifteentothirtyData(String? rly, String? consignee, String? subconsignee, String? fromdate, String? todate, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    crcsummarylinkData.clear();
    try {
      var result_UDMCrcsummarylinkData = await Network().postDataWithPro(IRUDMConstants.webCrcSummary,'15_to_30_Days' , "$consignee~$subconsignee~$rly~$todate",prefs.getString('token'));
      var UDMCrcsummarylinkData_body = json.decode(result_UDMCrcsummarylinkData.body);
      if(UDMCrcsummarylinkData_body['status'] != 'OK') {
        return crcsummarylinkData;
      } else {
        var crcsmlinkData = UDMCrcsummarylinkData_body['data'];
        if(crcsmlinkData != null) {
          crcsummarylinkData = crcsmlinkData.map<CrcsumrylinkData>((val) => CrcsumrylinkData.fromJson(val)).toList();
          return crcsummarylinkData;
        } else {
          IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
          return crcsummarylinkData;
        }
      }
    }
    on Exception catch (err) {
      IRUDMConstants().showSnack(err.toString(), context);
    }
    return crcsummarylinkData;
  }

  // More Than Thirty Days Data
  Future<List<CrcsumrylinkData>> crcSummarymorethirtyData(String? rly, String? consignee, String? subconsignee, String? fromdate, String? todate, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    crcsummarylinkData.clear();
    try {
      var result_UDMCrcsummarylinkData = await Network().postDataWithPro(IRUDMConstants.webCrcSummary,'More_than_30_Days' , "$consignee~$subconsignee~$rly~$todate",prefs.getString('token'));
      var UDMCrcsummarylinkData_body = json.decode(result_UDMCrcsummarylinkData.body);
      if(UDMCrcsummarylinkData_body['status'] != 'OK') {
        return crcsummarylinkData;
      } else {
        var crcsmlinkData = UDMCrcsummarylinkData_body['data'];
        if(crcsmlinkData != null) {
          crcsummarylinkData = crcsmlinkData.map<CrcsumrylinkData>((val) => CrcsumrylinkData.fromJson(val)).toList();
          //crcsummarylinkData.sort((a, b) => a.posr!.compareTo(b.posr!));
          return crcsummarylinkData;
        } else {
          IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
          return crcsummarylinkData;
        }
      }
    }
    on Exception catch (err) {
      IRUDMConstants().showSnack(err.toString(), context);
    }
    return crcsummarylinkData;
  }

  // --- CRC Summary Searching Data ----
  Future<List<CrcSmryData>> fetchSearchCrcsummaryData(List<CrcSmryData> data, String query) async{
    if(query.isNotEmpty){
      crcsummaryData = data.where((element) => element.railname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.unittype.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.unitname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.openbal.toString().trim().contains(query.toString().trim())
          || element.totalpending.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.billreceived.toString().trim().contains(query.toString().trim())
          || element.billpassed.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.consignee.toString().trim().contains(query.toString().trim())
          || element.pendthirtydays.toString().trim().contains(query.toString().trim())
          || element.pendmorethirty.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.conscode.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.department.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.pendfifteendays.toString().trim().contains(query.toString().trim())
          || element.subconsname.toString().trim().contains(query.toString().trim())
          || element.subconscode.toString().trim().contains(query.toString().trim())
      ).toList();
      return crcsummaryData;
    }
    else{
      return data;
    }
  }

  // --- CRC Summary link Searching Data ----
  Future<List<CrcsumrylinkData>> fetchSearchCrcsummarylinkData(List<CrcsumrylinkData> data, String query) async{
    if(query.isNotEmpty){
      crcsummarylinkData = data.where((element) => element.reinspflag.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.rejind.toString().trim().contains(query.toString().trim())
          || element.warrepflag.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.railname.toString().trim().contains(query.toString().trim())
          || element.unittype.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.unitname.toString().trim().contains(query.toString().trim())
          || element.department.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.consdtls.toString().trim().contains(query.toString().trim())
          || element.pono.toString().trim().contains(query.toString().trim())
          || element.podate.toString().trim().contains(query.toString().trim())
          || element.posr.toString().trim().contains(query.toString().trim())
          || element.vrno.toString().trim().contains(query.toString().trim())
          || element.itemdesc.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
          || element.challanno.toString().trim().contains(query.toString().trim())
          || element.challandate.toString().trim().contains(query.toString().trim())
          || element.qtyreceived.toString().trim().contains(query.toString().trim())
          || element.qtyaccepted.toString().trim().contains(query.toString().trim())
          || element.pounit.toString().trim().contains(query.toString().trim())
          || element.povalue.toString().trim().contains(query.toString().trim())
          || element.vendorname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
      ).toList();
      return crcsummarylinkData;
    }
    else{
      return data;
    }
  }
}