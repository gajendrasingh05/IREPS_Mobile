
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/udm/crn_summary/model/crnSummarylinkData.dart';
import 'package:flutter_app/udm/crn_summary/model/crnsummarydata.dart';
import 'package:flutter_app/udm/crn_summary/model/railwaylistdata.dart';
import 'package:flutter_app/udm/helpers/api.dart';
import 'package:flutter_app/udm/helpers/shared_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CrnSummaryRepo {

  CrnSummaryRepo._privateConstructor();
  static final CrnSummaryRepo _instance = CrnSummaryRepo._privateConstructor();
  static CrnSummaryRepo get instance => _instance;

  List<CrnSummaryRlwData> dropdowndata_UDMRlyList = [];

  List<CrnSmryData> crnsummaryData = [];
  List<CrnsumrylinkData> crnsummarylinkData = [];


  //List<NSlinkData> _nsDemandlinkData = [];

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

  Future<List<CrnSummaryRlwData>> fetchrailwaylistData(BuildContext context) async{
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
            dropdowndata_UDMRlyList = listJson.map<CrnSummaryRlwData>((val) => CrnSummaryRlwData.fromJson(val)).toList();
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
    //IRUDMConstants.showProgressIndicator(context);
    try {
      var result_UDMUnitType = await Network().postDataWithAPIMList('UDMAppList','UDMUnitType',value,prefs.getString('token'));
      var UDMUnitType_body = json.decode(result_UDMUnitType.body);
      print("unit type list.... $UDMUnitType_body");
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
    //IRUDMConstants.showProgressIndicator(context);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var result_UDMunitName=await Network().postDataWithAPIMList('UDMAppList','UnitName',rai!+"~"+unit!, prefs.getString('token'));
      var UDMunitName_body = json.decode(result_UDMunitName.body);
      print("unit name list.... $UDMunitName_body");
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
      //IRUDMConstants.showProgressIndicator(context);
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
      print("Hello Consignee..... $UDMUserConsignee_body");
      if(UDMUserConsignee_body['status'] != 'OK') {
        //IRUDMConstants.removeProgressIndicator(context);
        print("consignee error here");
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
    print("railway now $rai");
    print("depot id now $depot_id");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //IRUDMConstants.showProgressIndicator(context);
    myList_UDMSubConsignee.clear();
    try {
      if(depot_id == 'NA') {
        print("Fetch sub depot if condition");
        myList_UDMSubConsignee.add(getAll());
        return myList_UDMSubConsignee;
      } else {
        var result_UDMUserDepot = await Network().postDataWithAPIMList('UDMAppList','UserSubDepot' , rai! + "~" + depot_id!,prefs.getString('token'));
        var UDMUserSubDepot_body = json.decode(result_UDMUserDepot.body);
        print("Hello Sub Consignee..... $UDMUserSubDepot_body");
        if(UDMUserSubDepot_body['status'] != 'OK') {
          //IRUDMConstants.removeProgressIndicator(context);
          myList_UDMSubConsignee.add(getAll());
          return myList_UDMSubConsignee;
        } else {
          //IRUDMConstants.removeProgressIndicator(context);
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

  // CRN Summary Data
  Future<List<CrnSmryData>> crnSummaryData(String? rai, String? unittype, String? unitname, String? department, String? consignee, String? subconsignee, String? fromdate, String? todate, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    crnsummaryData.clear();
    try {
      print("crn request ${unittype! + "~" + consignee! + "~" + subconsignee! + "~" + department! + "~" + unitname! + "~" + rai! + "~" + fromdate! + "~"}");
      var result_UDMCrnsummaryData = await Network().postDataWithPro('https://ireps.gov.in/EPSApi/UDM/Warranty/GetData','Summary_of_Digitally_signed' , unittype! + "~" + consignee! +
            "~" + subconsignee! + "~" + department! + "~" + unitname! + "~" + rai! + "~" + fromdate! + "~" + todate!,prefs.getString('token'));
        var UDMCrnsummaryData_body = json.decode(result_UDMCrnsummaryData.body);
        if(UDMCrnsummaryData_body['status'] != 'OK') {
          //crnsummaryData.add(getAll());
          return crnsummaryData;
        } else {
          var crnsmData = UDMCrnsummaryData_body['data'];
          if(crnsmData != null) {
            crnsummaryData = crnsmData.map<CrnSmryData>((val) => CrnSmryData.fromJson(val)).toList();
            //dropdowndata_UDMRlyList.sort((a, b) => a.value!.compareTo(b.value!));
            return crnsummaryData;
          } else {
            IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
            return crnsummaryData;
            //setState(ItemListState.FinishedWithError);
          }
        }
    }
    on Exception catch (err) {
      IRUDMConstants().showSnack(err.toString(), context);
    }
    return crnsummaryData;
  }

  // Open Balance Data
  Future<List<CrnsumrylinkData>> crnSummaryopenBlncData(String? rly, String? consignee, String? subconsignee, String? fromdate, String? todate, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    crnsummarylinkData.clear();
    try {
      var result_UDMCrnsummarylinkData = await Network().postDataWithPro('https://ireps.gov.in/EPSApi/UDM/Warranty/GetData','Open_Balance_Link' , "$rly~$consignee~$subconsignee~$fromdate",prefs.getString('token'));
      var UDMCrnsummarylinkData_body = json.decode(result_UDMCrnsummarylinkData.body);
      if(UDMCrnsummarylinkData_body['status'] != 'OK') {
        return crnsummarylinkData;
      } else {
        var crnsmlinkData = UDMCrnsummarylinkData_body['data'];
        if(crnsmlinkData != null) {
          crnsummarylinkData = crnsmlinkData.map<CrnsumrylinkData>((val) => CrnsumrylinkData.fromJson(val)).toList();
          //crnsummarylinkData.sort((a, b) => a.posr!.compareTo(b.posr!));
          return crnsummarylinkData;
        } else {
          IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
          return crnsummarylinkData;
        }
      }
    }
    on Exception catch (err) {
      IRUDMConstants().showSnack(err.toString(), context);
    }
    return crnsummarylinkData;
  }

  // Crn Cons Rcvd Data
  Future<List<CrnsumrylinkData>> crnSummaryconrcvdData(String? rly, String? consignee, String? subconsignee, String? fromdate, String? todate, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    crnsummarylinkData.clear();
    try {
      var result_UDMCrnsummarylinkData = await Network().postDataWithPro('https://ireps.gov.in/EPSApi/UDM/Warranty/GetData','Consignment_recvd' , "$rly~$consignee~$subconsignee~$fromdate~$todate",prefs.getString('token'));
      var UDMCrnsummarylinkData_body = json.decode(result_UDMCrnsummarylinkData.body);
      if(UDMCrnsummarylinkData_body['status'] != 'OK') {
        return crnsummarylinkData;
      } else {
        var crnsmlinkData = UDMCrnsummarylinkData_body['data'];
        if(crnsmlinkData != null) {
          crnsummarylinkData = crnsmlinkData.map<CrnsumrylinkData>((val) => CrnsumrylinkData.fromJson(val)).toList();
          //crnsummarylinkData.sort((a, b) => a.posr!.compareTo(b.posr!));
          return crnsummarylinkData;
        } else {
          IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
          return crnsummarylinkData;
        }
      }
    }
    on Exception catch (err) {
      IRUDMConstants().showSnack(err.toString(), context);
    }
    return crnsummarylinkData;
  }

  // Crn Issue Data
  Future<List<CrnsumrylinkData>> crnSummarycrnissueData(String? rly, String? consignee, String? subconsignee, String? fromdate, String? todate, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    crnsummarylinkData.clear();
    try {
      var result_UDMCrnsummarylinkData = await Network().postDataWithPro('https://ireps.gov.in/EPSApi/UDM/Warranty/GetData','CRN_Issued' , "$rly~$consignee~$subconsignee~$fromdate~$todate",prefs.getString('token'));
      var UDMCrnsummarylinkData_body = json.decode(result_UDMCrnsummarylinkData.body);
      if(UDMCrnsummarylinkData_body['status'] != 'OK') {
        return crnsummarylinkData;
      } else {
        var crnsmlinkData = UDMCrnsummarylinkData_body['data'];
        if(crnsmlinkData != null) {
          crnsummarylinkData = crnsmlinkData.map<CrnsumrylinkData>((val) => CrnsumrylinkData.fromJson(val)).toList();
          //crnsummarylinkData.sort((a, b) => a.posr!.compareTo(b.posr!));
          return crnsummarylinkData;
        } else {
          IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
          return crnsummarylinkData;
        }
      }
    }
    on Exception catch (err) {
      IRUDMConstants().showSnack(err.toString(), context);
    }
    return crnsummarylinkData;
  }

  // Closing Blnc Data
  Future<List<CrnsumrylinkData>> crnSummarycloseblncData(String? rly, String? consignee, String? subconsignee, String? fromdate, String? todate, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    crnsummarylinkData.clear();
    try {
      var result_UDMCrnsummarylinkData = await Network().postDataWithPro('https://ireps.gov.in/EPSApi/UDM/Warranty/GetData','Closing_Balance' , "$rly~$consignee~$subconsignee~$todate",prefs.getString('token'));
      var UDMCrnsummarylinkData_body = json.decode(result_UDMCrnsummarylinkData.body);
      if(UDMCrnsummarylinkData_body['status'] != 'OK') {
        return crnsummarylinkData;
      } else {
        var crnsmlinkData = UDMCrnsummarylinkData_body['data'];
        if(crnsmlinkData != null) {
          crnsummarylinkData = crnsmlinkData.map<CrnsumrylinkData>((val) => CrnsumrylinkData.fromJson(val)).toList();
          //crnsummarylinkData.sort((a, b) => a.posr!.compareTo(b.posr!));
          return crnsummarylinkData;
        } else {
          IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
          return crnsummarylinkData;
        }
      }
    }
    on Exception catch (err) {
      IRUDMConstants().showSnack(err.toString(), context);
    }
    return crnsummarylinkData;
  }

  // Less than 7 Days Data
  Future<List<CrnsumrylinkData>> crnSummarylessthnsevenData(String? rly, String? consignee, String? subconsignee, String? fromdate, String? todate, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    crnsummarylinkData.clear();
    try {
      var result_UDMCrnsummarylinkData = await Network().postDataWithPro('https://ireps.gov.in/EPSApi/UDM/Warranty/GetData','less_than_7_days' , "$rly~$consignee~$subconsignee~$todate",prefs.getString('token'));
      var UDMCrnsummarylinkData_body = json.decode(result_UDMCrnsummarylinkData.body);
      if(UDMCrnsummarylinkData_body['status'] != 'OK') {
        return crnsummarylinkData;
      } else {
        var crnsmlinkData = UDMCrnsummarylinkData_body['data'];
        if(crnsmlinkData != null) {
          crnsummarylinkData = crnsmlinkData.map<CrnsumrylinkData>((val) => CrnsumrylinkData.fromJson(val)).toList();
          //crnsummarylinkData.sort((a, b) => a.posr!.compareTo(b.posr!));
          return crnsummarylinkData;
        } else {
          IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
          return crnsummarylinkData;
        }
      }
    }
    on Exception catch (err) {
      IRUDMConstants().showSnack(err.toString(), context);
    }
    return crnsummarylinkData;
  }

  // Seven to fifteen Days Data
  Future<List<CrnsumrylinkData>> crnSummaryseventofifteenData(String? rly, String? consignee, String? subconsignee, String? fromdate, String? todate, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    crnsummarylinkData.clear();
    try {
      var result_UDMCrnsummarylinkData = await Network().postDataWithPro('https://ireps.gov.in/EPSApi/UDM/Warranty/GetData','7_to_15_days' , "$rly~$consignee~$subconsignee~$todate",prefs.getString('token'));
      var UDMCrnsummarylinkData_body = json.decode(result_UDMCrnsummarylinkData.body);
      if(UDMCrnsummarylinkData_body['status'] != 'OK') {
        return crnsummarylinkData;
      } else {
        var crnsmlinkData = UDMCrnsummarylinkData_body['data'];
        if(crnsmlinkData != null) {
          crnsummarylinkData = crnsmlinkData.map<CrnsumrylinkData>((val) => CrnsumrylinkData.fromJson(val)).toList();
          //crnsummarylinkData.sort((a, b) => a.posr!.compareTo(b.posr!));
          return crnsummarylinkData;
        } else {
          IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
          return crnsummarylinkData;
        }
      }
    }
    on Exception catch (err) {
      IRUDMConstants().showSnack(err.toString(), context);
    }
    return crnsummarylinkData;
  }

  // Fifteen to Thirty Days Data
  Future<List<CrnsumrylinkData>> crnSummaryfifteentothirtyData(String? rly, String? consignee, String? subconsignee, String? fromdate, String? todate, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    crnsummarylinkData.clear();
    try {
      var result_UDMCrnsummarylinkData = await Network().postDataWithPro('https://ireps.gov.in/EPSApi/UDM/Warranty/GetData','15_to_30_Days' , "$rly~$consignee~$subconsignee~$todate",prefs.getString('token'));
      var UDMCrnsummarylinkData_body = json.decode(result_UDMCrnsummarylinkData.body);
      if(UDMCrnsummarylinkData_body['status'] != 'OK') {
        return crnsummarylinkData;
      } else {
        var crnsmlinkData = UDMCrnsummarylinkData_body['data'];
        if(crnsmlinkData != null) {
          crnsummarylinkData = crnsmlinkData.map<CrnsumrylinkData>((val) => CrnsumrylinkData.fromJson(val)).toList();
          return crnsummarylinkData;
        } else {
          IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
          return crnsummarylinkData;
        }
      }
    }
    on Exception catch (err) {
      IRUDMConstants().showSnack(err.toString(), context);
    }
    return crnsummarylinkData;
  }

  // More Than Thirty Days Data
  Future<List<CrnsumrylinkData>> crnSummarymorethirtyData(String? rly, String? consignee, String? subconsignee, String? fromdate, String? todate, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    crnsummarylinkData.clear();
    try {
      var result_UDMCrnsummarylinkData = await Network().postDataWithPro('https://ireps.gov.in/EPSApi/UDM/Warranty/GetData','Greater_than_30_Days' , "$rly~$consignee~$subconsignee~$todate",prefs.getString('token'));
      var UDMCrnsummarylinkData_body = json.decode(result_UDMCrnsummarylinkData.body);
      if(UDMCrnsummarylinkData_body['status'] != 'OK') {
        return crnsummarylinkData;
      } else {
        var crnsmlinkData = UDMCrnsummarylinkData_body['data'];
        if(crnsmlinkData != null) {
          crnsummarylinkData = crnsmlinkData.map<CrnsumrylinkData>((val) => CrnsumrylinkData.fromJson(val)).toList();
          //crnsummarylinkData.sort((a, b) => a.posr!.compareTo(b.posr!));
          return crnsummarylinkData;
        } else {
          IRUDMConstants().showSnack('Something Unexpected happened! Please try again.', context);
          return crnsummarylinkData;
        }
      }
    }
    on Exception catch (err) {
      IRUDMConstants().showSnack(err.toString(), context);
    }
    return crnsummarylinkData;
  }

  // --- CRN Summary Searching Data ----
  Future<List<CrnSmryData>> fetchSearchCrnsummaryData(List<CrnSmryData> data, String query) async{
    if(query.isNotEmpty){
      crnsummaryData = data.where((element) => element.railname.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
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
      return crnsummaryData;
    }
    else{
      return data;
    }
  }

  // --- CRN Summary link Searching Data ----
  Future<List<CrnsumrylinkData>> fetchSearchCrnsummarylinkData(List<CrnsumrylinkData> data, String query) async{
    if(query.isNotEmpty){
      crnsummarylinkData = data.where((element) => element.reinspflag.toString().trim().toLowerCase().contains(query.toString().trim().toLowerCase())
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
      return crnsummarylinkData;
    }
    else{
      return data;
    }
  }
}